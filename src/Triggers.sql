-- test si un document est pas deja emprunter
DROP TRIGGER TRIGGER2;
CREATE OR REPLACE TRIGGER TRIGGER2 
BEFORE INSERT ON DOCUMENT_BORROWER 
BEGIN

CREATE LOCAL TEMPORARY VIEW tempo AS 
SELECT D.Quantity
FROM Document D
JOIN Document_Borrower DB  ON DB.DocumentID = D.ID
WHERE D.ID = NEW.DOCUEMENTID

if (COUNT(SELECT DB.DocumentID
FROM Document_Borrower DB
join Document D on DB.DocumentID = D.ID
Where (DB.DocumentID=NEW.DocumentID  and (DB.dateReturn IS NULL) and D.QUANTITY > 0))> tempo.quantity)
THEN raise_application_error('-20001', 'All Document Already Borrowed') ;
END IF;
END;
/

-- Vérification que l'emprunteur ne dépasse pas son nombre d'emprunt max
DROP TRIGGER TRIGGER1;
CREATE OR REPLACE TRIGGER TRIGGER1
    BEFORE INSERT 
    ON Document_Borrower 
    FOR EACH ROW
DECLARE
    max_borrow      INT;
    current_borrow  INT;
BEGIN
    SELECT BT.nbBorrowMax, B.nbBorrow
    INTO max_borrow, current_borrow
    FROM BorrowerType BT, Borrower B
    WHERE :NEW.BorrowerID = B.ID 
      AND B.BorrowerTypeID = BT.ID;

    IF (current_borrow + 1 > max_borrow)
    THEN RAISE_APPLICATION_ERROR('-20001', 'Document already borrowed');
    ELSE
        UPDATE Borrower B
        SET current_borrow = current_borrow + 1 
        WHERE :NEW.BorrowerID = B.ID;
    END IF;
END;
/


--test si le nombre d'emprunt pour cet categorie de document 
DROP TRIGGER TRIGGER3;
CREATE OR REPLACE TRIGGER TRIGGER3
BEFORE INSERT ON DOCUMENT_BORROWER 
BEGIN

CREATE OR REPLACE LOCAL TEMPORARY VIEW tempiddoc1 AS 
SELECT D.DOCUMENTTYPEID
FROM Document D
JOIN Document_Borrower DB  ON DB.DocumentID = D.ID
WHERE D.ID = NEW.DOCUEMENTID

CREATE OR REPLACE LOCAL TEMPORARY VIEW tempiddoc2 AS 
SELECT DT.ID 
FROM DocumentType DT
JOIN tempiddoc1 ON tempiddoc1.DOCUMENTTYPEID = D.ID

CREATE OR REPLACE LOCAL TEMPORARY VIEW tempidborrow1 AS 
SELECT B.BORROWERTYPEID
FROM Borrower B
JOIN Document_Borrower DB  ON DB.DocumentID = B.ID
WHERE B.ID = NEW.DOCUEMENTID


CREATE OR REPLACE LOCAL TEMPORARY VIEW tempidborrow2 AS 
SELECT BT.BORROWERTYPEID
FROM BorrowerType BT
JOIN tempidborrow1  ON BT.ID = tempidborrow1.ID

CREATE OR REPLACE LOCAL TEMPORARY VIEW tempidborrow3 AS 
SELECT BT.BORROWERTYPEID,BT_DT.nbBorrowMax
FROM BorrowerType_DocumentTyep BT_DT
JOIN tempidborrow2  ON BT_DT.ID = tempidborrow2.BorrowerID

CREATE OR REPLACE LOCAL TEMPORARY VIEW temp AS 
SELECT tempidborrow3.nbBorrowMax
FROM tempidborrow3
JOIN tempiddoc2  ON tempiddoc2.ID = tempidborrow3.BORROWERTYPEID

CREATE OR REPLACE LOCAL TEMPORARY VIEW NB_DOC_TYPE AS 
SELECT DB.DocumentID,DB.BorrowerID
FROM Document_Borrower DB
Where ((DB.DocumentID=NEW.DocumentID and DB.BorrowerID = NEW.BorrowerID) and(DB.dateReturn IS NULL))


if(temp.nbBorrowMax>=COUNT(NB_DOC_TYPE))
then raise_application_error('-20001', 'Document borrow limit reached !') ;
end if;
END;
/

--verifications si l'emprunteur n'est pas en retard
DROP TRIGGER TRIGGER4;
CREATE OR REPLACE TRIGGER TRIGGER4
BEFORE INSERT ON DOCUMENT_BORROWER 
BEGIN

if EXIST (SELECT DB.DocumentID, DB.BorrowerID
FROM Document_Borrower DB
Where ( DB.BorrowerID = NEW.BorrowerID and (DB.dateReturn > sysdate )))
then  raise_application_error('-20001', 'Document(s) en retard !') ;
end if;
END;
/

--verification du type d'un document (book)
DROP TRIGGER TRIGGER5;
CREATE OR REPLACE TRIGGER TRIGGER5 
BEFORE INSERT ON DOCUMENT
BEGIN

if EXIST (
SELECT DT.DocumentID,DT.BorrowerID
FROM NEW
join DocumentType DT on DT.ID= NEW.DocumentTypeID
Where (DT.name = 'book')
)
then insert into  Book ( DocumentID , nbPages ) values (New.ID, 0);
end if;
END;
/