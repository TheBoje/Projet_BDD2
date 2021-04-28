-- ######################################################
-- #       Triggers.sql - Ajoute les triggers           #
-- #      WIP - Voir README pour le pseudo-code         #
-- # Par Vincent Commin, Louis Leenart & Alexis Louail  #
-- ######################################################

-- Vérification que le nombre d'emprunts maximum de l'emprunteur n'est pas dépassé
CREATE OR REPLACE TRIGGER TRIGGER_MAX_BORROW_COUNT
    BEFORE INSERT OR UPDATE ON DOCUMENT_BORROWER
    FOR EACH ROW
DECLARE 
        Doc_type Document.DocumentTypeID%type;
        
        local_nb_borrow   INT;
        local_max_borrow  INT;
BEGIN

    select D.DocumentTypeID into Doc_type
        From Document D
        Where D.ID =:NEW.DocumentID;

    select count(*) into local_nb_borrow
     From DOCUMENT_BORROWER DB
        join Document D on D.ID = DB.DocumentID
        where D.DocumentTypeID = Doc_type ;


    SELECT BT_DT.nbBorrowMax
    INTO  local_max_borrow
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
-- test
insert into documenttype values (1, 'book');
insert into document (id, documenttypeid,quantity) values (1, 1, 3);
insert into BorrowerType values(1,1);
insert into Borrower(ID,BorrowerTypeID) values(1,1);
insert into BorrowerType_DocumentType (BorrowerTypeID,DocumentTypeID,nbBorrowMax) values (1,1,2);    

-- positif
insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (1,1,1);
select * from document_Borrower where documentid = 1 and BorrowerID = 1;
insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (2,1,1);
-- negatif
insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (3,1,1);
select * from document_Borrower where documentid = 1 and BorrowerID = 1;
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
        WHERE D.ID = :NEW.DOCUMENTID;

    SELECT count(DB.DocumentID) into doc_borrow
        FROM Document_Borrower DB
        join Document D on DB.DocumentID = D.ID
        Where (DB.DocumentID=:NEW.DocumentID  and (DB.dateReturn IS NULL) and D.QUANTITY > 0);

    if (doc_borrow>= Quantity_max_doc)
        THEN raise_application_error('-20001', 'All Document Already Borrowed') ;
    END IF;
END;
/
-- test
insert into documenttype values (1, 'book');
insert into document (id, documenttypeid,quantity) values (1, 1, 2);
insert into Borrower(ID) values(1);

-- positif
insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (1,1,1);
select * from document_Borrower where documentid = 1 and BorrowerID = 1;
insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (2,1,1);
-- negatif
insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (3,1,1);
select * from document_Borrower where documentid = 1 and BorrowerID = 1;
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
        Where ( DB.BorrowerID = :NEW.BorrowerID and (DB.dateReturn < sysdate ));
    if is_late>0
        then  raise_application_error('-20001', 'Document(s) en retard !') ;
    end if;
END;
/
-- test
insert into documenttype values (1, 'book');
insert into document (id, documenttypeid,quantity) values (1, 1, 3);
insert into Borrower(ID) values(1);

-- positif
insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID,dateReturn )values (1,1,1,to_date('20/08/2022','DD/MM/RR'));
select * from document_Borrower where documentid = 1 and BorrowerID = 1;
-- negatif
insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID ,dateReturn)values (2,1,1,to_date('20/08/2020','DD/MM/RR'));
insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID,dateReturn )values (3,1,1,to_date('20/08/2022','DD/MM/RR'));
select * from document_Borrower where documentid = 1 and BorrowerID = 1;
/


--verification du type d'un document 
CREATE OR REPLACE TRIGGER trigger_type
AFTER INSERT ON DOCUMENT
FOR EACH ROW
DECLARE 
   doc_type DocumentType.name%type;
BEGIN
  SELECT DT.name into doc_type
    FROM DocumentType DT 
   WHERE DT.ID = :NEW.DocumentTypeID;
   if doc_type='Book' then 
     insert into  Book ( DocumentID , nbPages ) values (:New.ID, 0);
   elsif doc_type='CD' then 
     insert into  CD ( DocumentID ) values (:New.ID);
    elsif doc_type='DVD' then 
     insert into  DVD ( DocumentID) values (:New.ID);
    elsif doc_type='Video' then 
     insert into  video ( DocumentID  ) values (:New.ID);
    else
        raise_application_error('-20001', 'Le document n''est pas d''un type reconnu');
   end if;
END;
/
-- test
insert into documenttype values (1, 'Book');
insert into documenttype values (2, 'DVD');
insert into documenttype values (3, 'CD');
insert into documenttype values (4, 'Video');
insert into documenttype values (5, 'books');
-- positif
insert into document (id, documenttypeid) values (1, 1);
select * from book where documentid = 1;
insert into document (id, documenttypeid) values (2, 2);
insert into document (id, documenttypeid) values (3, 3);
insert into document (id, documenttypeid) values (4, 4);
select * from document;
-- negatif
insert into document (id, documenttypeid) values (5, 5);
select * from document where id = 5;
/