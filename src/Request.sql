-- 1 Liste par ordre alphabétique des titres de documents dont le thème comprend le motinformatique ou mathématiques
SELECT title 
FROM Document 
WHERE 
    mainTheme = 'Informatique' OR 
    mainTheme = 'Math�matiques'
ORDER BY title;

-- 2 Liste (titre et thème) des documents empruntés par Dupont entre le 15/11/2018 et le 15/11/2019
SELECT D.title, DB.dateStart
FROM Document D
JOIN Document_Borrower DB   ON DB.DocumentID = D.ID
JOIN Borrower B             ON B.ID = DB.BorrowerID
WHERE 
    B.name = 'Dupont' AND
    TO_DATE(DB.dateStart, 'DD/MM/YY') >= TO_DATE('15/11/18', 'DD/MM/YY') AND
    TO_DATE(DB.dateStart, 'DD/MM/YY') <= TO_DATE('15/11/19', 'DD/MM/YY')
;

-- 3 Pour chaque emprunteur, donner la liste des titres des documents qu'il a empruntés avec le nom des auteurs pour chaque document.
SELECT B.name, D.title, A.name
FROM Borrower B
JOIN Document_Borrower DB   ON DB.BorrowerID = B.ID
JOIN Document D             ON D.ID = DB.DocumentID
JOIN Document_Author DA     ON DA.DocumentID = D.ID
JOIN Author A               ON A.ID = DA.AuthorID
ORDER BY B.name
;

-- 4 Noms des auteurs ayant écrit un livre édité chez Dunod
SELECT D.title, E."name"
FROM Document D
JOIN Editor E           ON E.ID = D.EditorID
JOIN Document_Author DA ON DA.DocumentID = D.ID
JOIN Author A           ON A.ID = DA.AuthorID
JOIN DocumentType DT    ON DT.ID = D.DocumentTypeID
WHERE
    E."name" = 'Dunod' AND
    DT.name = 'Book'
;

-- 5 Quantité totale des exemplaires édités chez Eyrolles /!\ exemplaires ?
SELECT SUM(quantite)
FROM Document D
JOIN Editor E   ON E.ID = D.EditorID
WHERE E."name" = 'Eyrolles';

-- 6 Pour chaque éditeur, nombre de documents présents à la bibliothèque
SELECT E."name", COUNT(D.title) AS "Nb docs"
FROM Document D
JOIN Editor E ON E.ID = D.EditorID
GROUP BY E."name";

-- 7 Pour chaque document, nombre de fois où il a été emprunté
SELECT D.title, COUNT(DB.DocumentID) AS "Nb borrowing"
FROM Document D
JOIN Document_Borrower DB ON DB.DocumentID = D.ID
GROUP BY D.title;

-- 8 Liste des éditeurs ayant édité plus de deux documents d'informatique ou de mathématiques
SELECT "nameEditor"
FROM
    (
        SELECT E."name" AS "nameEditor", COUNT(D.title) AS "nbInfoMaths"
        FROM Document D
        JOIN Editor E ON E.ID = D.EditorID
        WHERE D.mainTheme = 'Informatique' OR D.mainTheme = 'Math�matiques'
        GROUP BY E."name"
    )
WHERE "nbInfoMaths" >= 2;

-- 9 Noms des emprunteurs habitant la même adresse que Dupont
SELECT B2.name, B2.firstname
FROM Borrower B1, Borrower B2
WHERE
    B1.name = 'Dupont' AND
    B1.adress = B2.adress
GROUP BY B2.name, B2.firstname
;

-- 10 Liste des éditeurs n'ayant pas édité de documents d'informatique
SELECT E."name"
FROM Editor E
WHERE 
E.ID NOT IN
    (
        SELECT E.ID
        FROM Document D
        JOIN Editor E ON E.ID = D.EditorID
        WHERE mainTheme = 'Informatique'
        GROUP BY E.ID
    )
;

-- 11 Noms des personnes n'ayant jamais emprunté de documents
SELECT name, firstname
FROM Borrower
WHERE
ID NOT IN
    (
        SELECT BorrowerID
        FROM Document_Borrower
        GROUP BY BorrowerID
    )
;

-- 12  Liste des documents n'ayant jamais été empruntés
SELECT title
FROM Document
WHERE
ID NOT IN
    (
        SELECT DocumentID
        FROM Document_Borrower
        GROUP BY DocumentID
    )
;

-- 13  Donnez la liste des emprunteurs (nom, prénom) 
-- appartenant à la catégorie desprofessionnels ayant emprunté 
-- au moins une fois un dvd au cours des 6 derniers mois
SELECT B.name, B.firstname
FROM Borrower B
JOIN BorrowerType BT        ON BT.ID = B.BorrowerTypeID
JOIN Document_Borrower DB   ON DB.BorrowerID = B.ID
JOIN Document D             ON D.ID = DB.DocumentID
JOIN DocumentType DT        ON DT.ID = D.DocumentTypeID
WHERE
    BT.Borrower = 'Professionnel' AND
    DT.name = 'DVD' AND
    MONTHS_BETWEEN(DB.dateStart, SYSDATE) <= 6
;

-- 14 Liste des documents dont le nombre 
-- d'exemplaires est supérieur au nombre moyen d'exemplaires
SELECT title
FROM Document,
    (
        SELECT AVG(quantity) AS "avg"
        FROM Document
    )
WHERE quantity > "avg";


-- 15  Noms des auteurs ayant écrit des documents d'informatique 
-- et de mathématiques
SELECT name
FROM Author
WHERE
ID IN
    (
        SELECT AuthorID
        FROM Document_Author DA
        JOIN Document D ON D.ID = DA.DocumentID
        WHERE D.mainTheme = 'Math�matiques'
    ) AND
ID IN
    (
        SELECT AuthorID
        FROM Document_Author DA
        JOIN Document D ON D.ID = DA.DocumentID
        WHERE D.mainTheme = 'Informatique'
    )
;

-- 16 Éditeur dont le nombre de documents empruntés est le plus grand
--, E."name" je ne sais pas pourquoi il ne veut pas marcher ici
SELECT DISTINCT "EditorName", MAX("nbBorrow") -- TODO S�lectionner uniquement le max
FROM
    (
        SELECT E."name" AS "EditorName", COUNT(dateStart) AS "nbBorrow"
        FROM Document_Borrower DB
        JOIN Document D ON D.ID = DB.DocumentID
        JOIN Editor E ON E.ID = D.EditorID
        GROUP BY E."name"
    )
GROUP BY "EditorName"
;

--  Liste des documents n'ayant aucun 
-- mot-clef en commun avec le document dont le titre est "SQL pour les nuls".