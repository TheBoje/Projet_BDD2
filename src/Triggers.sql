-- test si un document est pas deja emprunter
CREATE OR REPLACE TRIGGER TRIGGER2 
BEFORE INSERT ON DOCUMENT_BORROWER 
BEGIN

if EXISTS(SELECT D.title, DB.dateStart
FROM Document D
JOIN Document_Borrower DB  ON DB.DocumentID = D.ID
WHERE D.QUANTITY >0 and D.ID =NEW.DOCUEMENTID)
then raise_application_error('-20001', 'Document Already Borrowed') ;
end if;
END;

--test si le nombre d'emprunt pour cet categorie de document 

CREATE OR REPLACE TRIGGER Trigger3  
BEFORE INSERT ON DOCUMENT_BORROWER 
BEGIN

CREATE OR REPLACE LOCAL TEMPORARY VIEW tempiddoc1 AS 
SELECT D.DOCUMENTTYPEID
FROM Document D
JOIN Document_Borrower DB  ON DB.DocumentID = D.ID
WHERE D.ID =NEW.DOCUEMENTID

CREATE OR REPLACE LOCAL TEMPORARY VIEW tempiddoc2 AS 
SELECT DT.ID 
FROM DocumentType DT
JOIN tempiddoc1 ON tempiddoc1.DOCUMENTTYPEID = D.ID

CREATE OR REPLACE LOCAL TEMPORARY VIEW tempidborrow1 AS 
SELECT B.BORROWERTYPEID
FROM Borrower B
JOIN Document_Borrower DB  ON DB.DocumentID = B.ID
WHERE  B.ID =NEW.DOCUEMENTID


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

--verifications si l'emprunteur n'est pas en retard

CREATE OR REPLACE TRIGGER TRIGGER4 
BEFORE INSERT ON DOCUMENT_BORROWER 
BEGIN

if EXIST (SELECT DB.DocumentID,DB.BorrowerID
FROM Document_Borrower DB
Where ( DB.BorrowerID = NEW.BorrowerID and (DB.dateReturn> sysdate )))
then  raise_application_error('-20001', 'Document(s) en retard !') ;
end if;
END;


--verification du type d'un document (book)

CREATE OR REPLACE TRIGGER TRIGGER5 
BEFORE INSERT ON DOCUMENT
BEGIN

if EXIST (
SELECT DB.DocumentID,DB.BorrowerID
FROM NEW
join BorrowerType BT on BT.ID= NEW.DocumentTypeID
Where (BT.name = 'book')
)
then  raise_application_error('-20001', 'Document(s) en retard !') ;
end if;
END;
