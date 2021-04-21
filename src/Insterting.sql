-- Ajout types d'emprunteurs
Insert into PROJET.BORROWERTYPE (BORROWER,NBBORROWMAX) values ('Personnel','10');
Insert into PROJET.BORROWERTYPE (BORROWER,NBBORROWMAX) values ('Professionnel','5');
Insert into PROJET.BORROWERTYPE (BORROWER,NBBORROWMAX) values ('Public','3');

-- Ajout type de document
Insert into PROJET.DOCUMENTTYPE (NAME) values ('Book');
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
INSERT ALL
INTO Author (name, firstname, birthdate) VALUES ('Commin', 'Vincent', TO_DATE('02/06/2000', 'DD/MM/YYYY'))
INTO Author (name, firstname, birthdate) VALUES ('Louail', 'Alexis', TO_DATE('28/08/1999', 'DD/MM/YYYY'))
INTO Author (name, firstname, birthdate) VALUES ('Leenart', 'Louis', TO_DATE('19/03/2000', 'DD/MM/YYYY'))
SELECT 1 FROM DUAL;

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
SELECT 1 FROM DUAL;