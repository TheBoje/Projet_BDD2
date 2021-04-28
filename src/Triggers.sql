-- ######################################################
-- #       Triggers.sql - Ajoute les triggers           #
-- #      WIP - Voir README pour le pseudo-code         #
-- # Par Vincent Commin, Louis Leenart & Alexis Louail  #
-- ######################################################

CREATE OR REPLACE TRIGGER TRIGGER_MAX_BORROW_COUNT
    BEFORE INSERT OR UPDATE ON DOCUMENT_BORROWER
    FOR EACH ROW
DECLARE local_nb_borrow   INT;
        local_max_borrow  INT;
BEGIN
    SELECT B.nbBorrow, BT_DT.nbBorrowMax
    INTO local_nb_borrow, local_max_borrow
    FROM    BORROWER B, 
            DOCUMENT D, 
            BORROWERTYPE BT, 
            DOCUMENTTYPE DT, 
            BORROWERTYPE_DOCUMENTTYPE BT_DT
    WHERE   D.ID = :NEW.DOCUMENTID          AND
            B.ID = :NEW.BORROWERID          AND
            D.DOCUMENTTYPEID = DT.ID        AND
            DT.ID = BT_DT.DOCUMENTTYPEID    AND
            BT.ID = BT_DT.BORROWERTYPEID    AND
            BT.ID = B.BORROWERTYPEID ;

    IF (local_nb_borrow + 1 > local_max_borrow)
    THEN RAISE_APPLICATION_ERROR(-20001, "Nombre d'emprunts total est atteint, vous ne pouvez pas emprunter plus de documents.");
    ELSE 
        UPDATE BORROWER B
        SET NBBORROW = NBBORROW + 1
        WHERE :NEW.BORROWERID = B.ID;
    END IF;
END;
/

-- test si un document est pas deja emprunté
DROP TRIGGER TRIGGER2;
CREATE OR REPLACE TRIGGER TRIGGER2 
BEFORE INSERT ON DOCUMENT_BORROWER 
DECLARE 
Quantity_max_doc   INT;
doc_borrow Document_Borrower.DocumentID%type;


BEGIN
 
SELECT D.Quantity
into Quantity_max_doc
FROM Document D
JOIN Document_Borrower DB  ON DB.DocumentID = D.ID
WHERE D.ID = :NEW.DOCUEMENTID

SELECT DB.DocumentID
into doc_borrow
FROM Document_Borrower DB
join Document D on DB.DocumentID = D.ID
Where (DB.DocumentID=:NEW.DocumentID  and (DB.dateReturn IS NULL) and D.QUANTITY > 0)
if (COUNT(doc_borrow)> Quantity_max_doc)
THEN raise_application_error('-20001', 'All Document Already Borrowed') ;
END IF;
END;
/

--test si le nombre d'emprunt pour cet categorie de document 
DROP TRIGGER TRIGGER3;
CREATE OR REPLACE TRIGGER TRIGGER3
BEFORE INSERT ON DOCUMENT_BORROWER 
DECLARE
doc_type Document.DOCUMENTTYPEID%type;
tempiddoc2 DocumentType.ID%type;

tempidborrow1 Borrower.BORROWERTYPEID%type;
tempidborrow2 BorrowerType.BORROWERTYPEID%type;
tempidborrow3 BorrowerType_DocumentType%type;

temp BorrowerType_DocumentType.nbBorrowMax%type;
NB_DOC_TYPE 

BEGIN


SELECT D.DOCUMENTTYPEID
into tempiddoc1
FROM Document D
WHERE D.ID = NEW.DOCUEMENTID;


SELECT DT.ID 
into tempiddoc2
FROM DocumentType DT
where D.ID = tempiddoc1;


SELECT B.BORROWERTYPEID
into tempidborrow1
FROM Borrower B
WHERE B.ID = NEW.DOCUEMENTID;

SELECT BT.BorrowerID
into tempidborrow2
FROM BorrowerType BT
where BT.ID = tempidborrow1
JOIN tempidborrow1  ON .ID


SELECT *
into tempidborrow3
FROM BorrowerType_DocumentType BT_DT
where BT_DT.ID = tempidborrow2


SELECT tempidborrow3.nbBorrowMax
into temp
FROM tempidborrow3
where tempidborrow3.BORROWERTYPEID = tempiddoc2

CREATE OR REPLACE LOCAL TEMPORARY VIEW  AS 
SELECT DB.DocumentID,DB.BorrowerID
into 
FROM Document_Borrower DB
Where ((DB.DocumentID=NEW.DocumentID and DB.BorrowerID = NEW.BorrowerID) and(DB.dateReturn IS NULL))


if(temp.nbBorrowMax>=COUNT(NB_DOC_TYPE))
then raise_application_error('-20001', 'Document borrow limit reached !') ;
end if;
END;
/

--verifications si l'emprunteur n'est pas en retard
CREATE OR REPLACE TRIGGER TRIGGER4
BEFORE INSERT ON DOCUMENT_BORROWER 
DECLARE 
is_late integer;
BEGIN

SELECT count(*)
into
is_late
FROM Document_Borrower DB
Where ( DB.BorrowerID = :NEW.BorrowerID and (DB.dateReturn > sysdate ))

if is_late>0
then  raise_application_error('-20001', 'Document(s) en retard !') ;
end if;
END;
/

--verification du type d'un document (book)
--verification du type d'un document (book)
CREATE OR REPLACE TRIGGER TRIGGER5 
AFTER INSERT ON DOCUMENT
FOR EACH ROW
DECLARE 
   doc_type DocumentType.name%type;
BEGIN
  SELECT DT.name into doc_type
    FROM DocumentType DT 
   WHERE DT.ID = :NEW.DocumentTypeID;
   if doc_type='book' then 
     insert into  Book ( DocumentID , nbPages ) values (:New.ID, 0);
   else
        raise_application_error('-20001', 'Le document n''est pas un livre');
   end if;
END;
/
-- test
insert into documenttype values (1, 'book');
insert into documenttype values (2, 'books');
-- positif
insert into document (id, documenttypeid) values (1, 1);
select * from book where documentid = 1;
-- negatif
insert into document (id, documenttypeid) values (2, 2);
select * from document where id = 2;
/