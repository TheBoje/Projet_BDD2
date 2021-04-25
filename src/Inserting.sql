-- Ajout types d'emprunteurs
Insert into PROJET.BORROWERTYPE (ID, BORROWER, NBBORROWMAX) values ('1','Personnel','10');
Insert into PROJET.BORROWERTYPE (ID, BORROWER, NBBORROWMAX) values ('2','Professionnel','5');
Insert into PROJET.BORROWERTYPE (ID, BORROWER, NBBORROWMAX) values ('3','Public','3');
Commit;
-- Ajout type de document
Insert into PROJET.DOCUMENTTYPE (NAME) values ('Livre');
Insert into PROJET.DOCUMENTTYPE (NAME) values ('DVD');
Insert into PROJET.DOCUMENTTYPE (NAME) values ('CD');
Insert into PROJET.DOCUMENTTYPE (NAME) values ('Video');

-- Ajout temps emprunt en fonction de l'emprunteur
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('1','1','9');
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('1','2','4');
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('1','3','5');
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('1','4','3');
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('2','1','11');
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('2','2','3');
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('2','3','4');
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('2','4','2');
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('3','1','3');
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('3','2','2');
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('3','3','3');
Insert into PROJET.BORROWERTYPE_DOCUMENTTYPE (BORROWERTYPEID,DOCUMENTTYPEID,DURATIONBORROWMAX) values ('3','4','1');

-- Ajout d'auteurs
Insert into PROJET.AUTHOR (NAME,FIRSTNAME,BIRTHDATE) values ('Commin','Vincent',to_date('02/06/00','DD/MM/RR'));
Insert into PROJET.AUTHOR (NAME,FIRSTNAME,BIRTHDATE) values ('Louail','Alexis',to_date('28/08/99','DD/MM/RR'));
Insert into PROJET.AUTHOR (NAME,FIRSTNAME,BIRTHDATE) values ('Leenart','Louis',to_date('19/03/00','DD/MM/RR'));
Insert into PROJET.AUTHOR (NAME,FIRSTNAME,BIRTHDATE) values ('Tolkien','J.R.R',to_date('03/01/92','DD/MM/RR'));
Insert into PROJET.AUTHOR (NAME,FIRSTNAME,BIRTHDATE) values ('Orwell','George',to_date('25/06/03','DD/MM/RR'));
Insert into PROJET.AUTHOR (NAME,FIRSTNAME,BIRTHDATE) values ('Lindenmayer','Aristid',to_date('17/11/25','DD/MM/RR'));
Insert into PROJET.AUTHOR (NAME,FIRSTNAME,BIRTHDATE) values ('Prusinkiewicz','Premyslaw',null);


-- Ajout des éditeurs nécessaires
INSERT ALL
INTO Editor ("name", adress, phoneNumber) VALUES ('Eyrolles', '4 rue qui existe', '0637656565')
INTO Editor ("name", adress, phoneNumber) VALUES ('Dunod', '44 avenue des Sables Ombrages', '0636999999')
SELECT 1 FROM DUAL;

-- Ajout des emprunteurs
INSERT ALL
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Garvey', 'Preston', 'Sanctuary Hills', '0788888888', 1)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Cave', 'Johnson', '7 rue du Labo', '0785488888', 2)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Sombrage', 'Ulfric', '9 place Vendaume', '0788836788', 3)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Stark', 'Tony', 'Stark tower New York', '0648736788', 1)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('McFly', 'Marty', '5 place 1955', '0388836788', 2)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Mathieson', 'Carry', 'Langley, USA', '0785896788', 3)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Bruitage', 'Jean-Michel', 'Dans sa Nissan primera', '0748836788', 1)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Lennon', 'Bob', '28 rue du Pyrobarbare', '0654836788', 2)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Lennon', 'John', '9 place Imaginaire', '0788836788', 3)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Auditore', 'Ezio', 'Florence', '0458336788', 1)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('La chasseuse', 'Aela', 'Jorvaskr, Blancherive', '0788836788', 2)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Wick', 'John', 'USA ?', '0788836788', 3)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('de Payns', 'Hugues', 'JERUSALEM', '0784566788', 1)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('10', 'Ben', 'Dans son omnitrix', '0788836788', 2)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Vador', 'Dark', 'Etoile Noir', '0788836788', 3)
INTO Borrower (name, firstname, adress, phoneNumber, BorrowerTypeID) VALUES ('Dupont', 'Monsieur', 'quelque part', '4589624785', 3)
SELECT 1 FROM DUAL;

-- Insertion de documents
Insert into PROJET.DOCUMENT (TITLE,MAINTHEME,QUANTITY,DEPARTMENT,EDITORID,DOCUMENTTYPEID) values ('1984','Science-Fiction','3','4','1','1');
Insert into PROJET.DOCUMENT (TITLE,MAINTHEME,QUANTITY,DEPARTMENT,EDITORID,DOCUMENTTYPEID) values ('La génération procédurale','Informatique','4','1','2','1');
Insert into PROJET.DOCUMENT (TITLE,MAINTHEME,QUANTITY,DEPARTMENT,EDITORID,DOCUMENTTYPEID) values ('Le Silmarillon','Fantaisie','1','2','1','1');
Insert into PROJET.DOCUMENT (TITLE,MAINTHEME,QUANTITY,DEPARTMENT,EDITORID,DOCUMENTTYPEID) values ('Le Seigneur des Anneaux','Fantaisie','2','2','1','1');
Insert into PROJET.DOCUMENT (TITLE,MAINTHEME,QUANTITY,DEPARTMENT,EDITORID,DOCUMENTTYPEID) values ('Algorithmic Beauty of Plants','Informatique','4','3','2','1');
Insert into PROJET.DOCUMENT (TITLE,MAINTHEME,QUANTITY,DEPARTMENT,EDITORID,DOCUMENTTYPEID) values ('Toy Story 1','Dessin-Animé','0','5','2','2');
Insert into PROJET.DOCUMENT (TITLE,MAINTHEME,QUANTITY,DEPARTMENT,EDITORID,DOCUMENTTYPEID) values ('Apocalypse 2nd Guerre  Mondial','Documentaire','2','5','2','2');
Insert into PROJET.DOCUMENT (TITLE,MAINTHEME,QUANTITY,DEPARTMENT,EDITORID,DOCUMENTTYPEID) values ('Adibou The Movie','Educatif','4','6','2','3');
Insert into PROJET.DOCUMENT (TITLE,MAINTHEME,QUANTITY,DEPARTMENT,EDITORID,DOCUMENTTYPEID) values ('The test project','Mathématiques','0','4','1','4');

-- Insertion livres
Insert into PROJET.BOOK (DOCUMENTID,NBPAGES) values ('1','328');
Insert into PROJET.BOOK (DOCUMENTID,NBPAGES) values ('2','10');
Insert into PROJET.BOOK (DOCUMENTID,NBPAGES) values ('3','523');
Insert into PROJET.BOOK (DOCUMENTID,NBPAGES) values ('4','768');
Insert into PROJET.BOOK (DOCUMENTID,NBPAGES) values ('5','240');

-- Insertion DVD
Insert into PROJET.DVD (DOCUMENTID,DURATION) values ('6','81');
Insert into PROJET.DVD (DOCUMENTID,DURATION) values ('7','90');

-- Insertion CD
Insert into PROJET.CD (DOCUMENTID,DURATION,NBSUBTITLES) values ('8','24','3');

-- Insertion video
Insert into PROJET.VIDEO (DOCUMENTID,DURATION,RECORDINGFORMAT) values ('9','65','mp4');

-- Insertion d'auteurs de documents
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('1','5');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('2','1');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('2','3');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('3','4');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('4','4');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('5','6');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('5','7');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('6','2');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('7','1');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('8','3');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('9','1');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('9','2');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('9','3');
Insert into PROJET.DOCUMENT_AUTHOR (DOCUMENTID,AUTHORID) values ('9','4');

-- Insertion emprunt
Insert into PROJET.DOCUMENT_BORROWER (DOCUMENTID,BORROWERID,DATESTART,DATERETURN) values ('5','16',to_date('15/11/18','DD/MM/RR'),to_date('15/11/19','DD/MM/RR'));
Insert into PROJET.DOCUMENT_BORROWER (DOCUMENTID,BORROWERID,DATESTART,DATERETURN) values ('7','16',to_date('14/11/18','DD/MM/RR'),null);
Insert into PROJET.DOCUMENT_BORROWER (DOCUMENTID,BORROWERID,DATESTART,DATERETURN) values ('2','16',to_date('16/11/19','DD/MM/RR'),null);
Insert into PROJET.DOCUMENT_BORROWER (DOCUMENTID,BORROWERID,DATESTART,DATERETURN) values ('8','5',to_date('16/04/20','DD/MM/RR'),to_date('17/04/20','DD/MM/RR'));
Insert into PROJET.DOCUMENT_BORROWER (DOCUMENTID,BORROWERID,DATESTART,DATERETURN) values ('6','2',to_date('22/04/19','DD/MM/RR'),to_date('22/04/20','DD/MM/RR'));
Insert into PROJET.DOCUMENT_BORROWER (DOCUMENTID,BORROWERID,DATESTART,DATERETURN) values ('3','1',to_date('18/02/15','DD/MM/RR'),null);
Insert into PROJET.DOCUMENT_BORROWER (DOCUMENTID,BORROWERID,DATESTART,DATERETURN) values ('9','6',to_date('03/07/19','DD/MM/RR'),null);
Insert into PROJET.DOCUMENT_BORROWER (DOCUMENTID,BORROWERID,DATESTART,DATERETURN) values ('7','7',to_date('02/02/22','DD/MM/RR'),null);
