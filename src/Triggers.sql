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
-- tests - à faire avec tables vides
-- insert into documenttype(ID, name) values (1, 'book');
-- insert into document (id, documenttypeid,quantity) values (1, 1, 3);
-- insert into BorrowerType values(1,1);
-- insert into Borrower(ID,BorrowerTypeID) values(1,1);
-- insert into BorrowerType_DocumentType (BorrowerTypeID,DocumentTypeID,nbBorrowMax) values (1,1,2);    

-- positif
-- insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (1,1,1);
-- select * from document_Borrower where documentid = 1 and BorrowerID = 1;
-- insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (2,1,1);
-- negatif
-- insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (3,1,1);
-- select * from document_Borrower where documentid = 1 and BorrowerID = 1;
-- /

-- test si un document est pas deja emprunté 
CREATE OR REPLACE TRIGGER TRIGGER_QUANTITY
    BEFORE INSERT ON DOCUMENT_BORROWER 
    FOR EACH ROW
DECLARE 
    quantity_max_doc    INT;
    doc_borrow          INT;
BEGIN
    SELECT D.QUANTITY INTO quantity_max_doc
        FROM DOCUMENT D
        WHERE D.ID = :NEW.DOCUMENTID;

    SELECT COUNT(DB.DocumentID) 
        INTO doc_borrow
        FROM Document_Borrower DB
        JOIN Document D ON DB.DocumentID = D.ID
        WHERE   DB.DocumentID=:NEW.DocumentID  AND
                DB.dateReturn IS NULL AND
                D.QUANTITY > 0;

        IF (doc_borrow >= quantity_max_doc)
        THEN RAISE_APPLICATION_ERROR('-20001', 'All Document Already Borrowed') ;
    END IF;
END;
/
-- test
-- insert into documenttype values (1, 'book');
-- insert into document (id, documenttypeid,quantity) values (1, 1, 2);
-- insert into Borrower(ID) values(1);

-- positif
-- insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (1,1,1);
-- select * from document_Borrower where documentid = 1 and BorrowerID = 1;
-- insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (2,1,1);
-- negatif
-- insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID )values (3,1,1);
-- select * from document_Borrower where documentid = 1 and BorrowerID = 1;
-- /


--verifications si l'emprunteur n'est pas en retard
CREATE OR REPLACE NONEDITIONABLE TRIGGER TRIGGER_LATE_RETURN
    BEFORE INSERT ON DOCUMENT_BORROWER 
    FOR EACH ROW
DECLARE 
    is_late INT;
BEGIN
    SELECT count(*) 
        INTO is_late
        FROM DOCUMENT_BORROWER DB
        WHERE   DB.BorrowerID = :NEW.BorrowerID AND
                DB.dateReturn < sysdate;

    IF (is_late > 0)
    THEN RAISE_APPLICATION_ERROR('-20001', 'Document(s) en retard !');
    END IF;
END;
/
-- test
-- insert into documenttype values (1, 'book');
-- insert into document (id, documenttypeid,quantity) values (1, 1, 3);
-- insert into Borrower(ID) values(1);

-- positif
-- insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID,dateReturn )values (1,1,1,to_date('20/08/2022','DD/MM/RR'));
-- select * from document_Borrower where documentid = 1 and BorrowerID = 1;
-- negatif
-- insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID ,dateReturn)values (2,1,1,to_date('20/08/2020','DD/MM/RR'));
-- insert into document_Borrower ( Borrowid,DocumentID ,BorrowerID,dateReturn )values (3,1,1,to_date('20/08/2022','DD/MM/RR'));
-- select * from document_Borrower where documentid = 1 and BorrowerID = 1;
-- /


--verification du type d'un document 
CREATE OR REPLACE TRIGGER TRIGGER_TYPE
    AFTER INSERT ON DOCUMENT
    FOR EACH ROW
DECLARE 
    doc_type DocumentType.name%type;
BEGIN
    SELECT DT.name into doc_type
        FROM DocumentType DT 
    WHERE DT.ID = :NEW.DocumentTypeID;

    IF doc_type = 'Book' 
    THEN INSERT INTO  Book (DocumentID, nbPages) VALUES (:NEW.ID, 0);
    ELSIF doc_type = 'CD' 
    THEN INSERT INTO CD (DocumentID) VALUES (:NEW.ID);
    ELSIF doc_type = 'DVD' 
    THEN INSERT INTO DVD (DocumentID) VALUES (:NEW.ID);
    ELSIF doc_type = 'Video' 
    THEN INSERT INTO video (DocumentID) VALUES (:NEW.ID);
    ELSE RAISE_APPLICATION_ERROR('-20001', 'Le document n''est pas d''un type reconnu');
    END IF;
END;
/
-- test
-- insert into documenttype values (1, 'Book');
-- insert into documenttype values (2, 'DVD');
-- insert into documenttype values (3, 'CD');
-- insert into documenttype values (4, 'Video');
-- insert into documenttype values (5, 'books');
-- positif
-- insert into document (id, documenttypeid) values (1, 1);
-- select * from book where documentid = 1;
-- insert into document (id, documenttypeid) values (2, 2);
-- insert into document (id, documenttypeid) values (3, 3);
-- insert into document (id, documenttypeid) values (4, 4);
-- select * from document;
-- negatif
-- insert into document (id, documenttypeid) values (5, 5);
-- select * from document where id = 5;
-- /