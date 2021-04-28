-- ######################################################
-- #       Triggers.sql - Ajoute les triggers           #
-- #      WIP - Voir README pour le pseudo-code         #
-- # Par Vincent Commin, Louis Leenart & Alexis Louail  #
-- ######################################################

-- Vérification que le nombre d'emprunts maximum de l'emprunteur n'est pas dépassé
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
    THEN RAISE_APPLICATION_ERROR(-20001, 'Nombre d emprunts total est atteint, vous ne pouvez pas emprunter plus de documents.');
    ELSE 
        UPDATE BORROWER B
        SET NBBORROW = NBBORROW + 1
        WHERE :NEW.BORROWERID = B.ID;
    END IF;
END;
/

-- test si un document est pas deja emprunté 
CREATE OR REPLACE TRIGGER trigger_quantity
BEFORE INSERT ON DOCUMENT_BORROWER 
for each row
DECLARE 
Quantity_max_doc   INT;
doc_borrow int;
BEGIN
    SELECT D.Quantity into Quantity_max_doc
        FROM Document D
        WHERE D.ID = :NEW.DOCUEMENTID;

    SELECT count(DB.DocumentID) into doc_borrow
        FROM Document_Borrower DB
        join Document D on DB.DocumentID = D.ID
        Where (DB.DocumentID=:NEW.DocumentID  and (DB.dateReturn IS NULL) and D.QUANTITY > 0);

    if (doc_borrow> Quantity_max_doc)
        THEN raise_application_error('-20001', 'All Document Already Borrowed') ;
    END IF;
END;
/


--verifications si l'emprunteur n'est pas en retard
create or replace NONEDITIONABLE TRIGGER trigger_return_late
BEFORE INSERT ON DOCUMENT_BORROWER 
for each row
DECLARE 
is_late integer;
BEGIN
    SELECT count(*) into is_late
        FROM Document_Borrower DB
        Where ( DB.BorrowerID = :NEW.BorrowerID and (DB.dateReturn > sysdate ));
    if is_late>0
        then  raise_application_error('-20001', 'Document(s) en retard !') ;
    end if;
END;
/

--verification du type d'un document (book)
CREATE OR REPLACE TRIGGER trigger_type
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