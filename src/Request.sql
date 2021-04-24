-- 1 Liste par ordre alphabétique des titres de documents dont le thème comprend le motinformatique ou mathématiques
-- Ici on pourrait mettre un index par hachage sur le mainTheme étant donne une égalisation stricte
SELECT title 
FROM Document 
WHERE 
    mainTheme = 'Informatique' OR 
    mainTheme = 'Math�matiques'
ORDER BY title;

-- 2 Liste (titre et thème) des documents empruntés par Dupont entre le 15/11/2018 et le 15/11/2019
-- Ici nous pourrions utiliser un Arbre-b sur la date étant donné les inégalités
SELECT D.title, DB.dateStart
FROM Document D
JOIN Document_Borrower DB   ON DB.DocumentID = D.ID
JOIN Borrower B             ON B.ID = DB.BorrowerID
WHERE 
    B.name = 'Dupont' AND
    TO_DATE(DB.dateStart, 'DD/MM/YY') >= TO_DATE('15/11/18', 'DD/MM/YY') AND
    TO_DATE(DB.dateStart, 'DD/MM/YY') <= TO_DATE('15/11/19', 'DD/MM/YY')
;

-- 3 Pour chaque emprunteur, donner la liste des titres des documents qu'il a emprunt�s avec le nom des auteurs pour chaque document.
-- Ici on a pas besoin d'index, la question pourra se poser sur la méthode de calcul de jointure utilisée.
SELECT B.name, D.title, A.name
FROM Borrower B
JOIN Document_Borrower DB   ON DB.BorrowerID = B.ID
JOIN Document D             ON D.ID = DB.DocumentID
JOIN Document_Author DA     ON DA.DocumentID = D.ID
JOIN Author A               ON A.ID = DA.AuthorID
ORDER BY B.name
;

-- 4 Noms des auteurs ayant écrit un livre édité chez Dunod
-- Ici nous pouvons utiliser le hachage sur le nom de  l'éditeur et sur le nom du type de document. Mais ici aussi, vu le nombre de jointures
-- on peut se concentrer sur le calcul de la jointure.
-- On peut aussi utiliser un index bitmap car DT.name est un domaine restreint (ici 4 valeurs seulement)
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

-- 5 Quantité totale des exemplaires édités chez Eyrolles ?
-- Ici on peut utiliser un hachage sur le nom de l'éditeur grâce à une égalité stricte
SELECT SUM(quantite)
FROM Document D
JOIN Editor E   ON E.ID = D.EditorID
WHERE E."name" = 'Eyrolles';

-- 6 Pour chaque éditeur, nombre de documents présents à la bibliothèque
-- Ici nous n'avons pas besoin d'index
SELECT E."name", COUNT(D.title) AS "Nb docs"
FROM Document D
JOIN Editor E ON E.ID = D.EditorID
GROUP BY E."name";

-- 7 Pour chaque document, nombre de fois où il a été emprunté
-- On n'a pas besoin d'utiliser d'index ici.
SELECT D.title, COUNT(DB.DocumentID) AS "Nb borrowing"
FROM Document D
JOIN Document_Borrower DB ON DB.DocumentID = D.ID
GROUP BY D.title;

-- 8 Liste des éditeurs ayant édité plus de deux documents d'informatique ou de mathématiques
-- On peut ici utiliser un hachage sur le mainTheme.
SELECT "nameEditor"
FROM
    (
        SELECT E."name" AS "nameEditor", COUNT(D.title) AS "nbInfoMaths"
        FROM Document D
        JOIN Editor E ON E.ID = D.EditorID
        WHERE D.mainTheme = 'Informatique' OR D.mainTheme = 'Mathématiques'
        GROUP BY E."name"
    )
WHERE "nbInfoMaths" >= 2;

-- 9 Noms des emprunteurs habitant la même adresse que Dupont
-- Ici on peut mettre un index de hachage sur le nom de l'emprunteur
SELECT B2.name, B2.firstname
FROM Borrower B1
JOIN Borrower B2 ON B1.adress = B2.adress
WHERE B1.name = 'Dupont'
GROUP BY B2.name, B2.firstname
;

-- 10 Liste des éditeurs n'ayant pas édité de documents d'informatique
-- Ici on peut mettre un index de hachage sur le mainTheme du Document grâce à l'égalite stricte
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
-- Ici nous n'avons pas besoin d'index
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
-- Ici nous n'avons pas besoin d'index
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
-- Ici nous pouvons mettre un index Arbre-b sur le nombre de mois.
SELECT B.name, B.firstname
FROM Borrower B
JOIN BorrowerType BT        ON BT.ID = B.BorrowerTypeID
JOIN Document_Borrower DB   ON DB.BorrowerID = B.ID
JOIN Document D             ON D.ID = DB.DocumentID
JOIN DocumentType DT        ON DT.ID = D.DocumentTypeID
WHERE
    BT.Borrower = 'Professionnel' AND
    DT.name = 'DVD'               AND
    MONTHS_BETWEEN(DB.dateStart, SYSDATE) <= 6
;

-- 14 Liste des documents dont le nombre 
-- d'exemplaires est supérieur au nombre moyen d'exemplaires
-- Ici nous pouvons mettre un index Arbre-b sur la quantité
SELECT title
FROM Document,
    (
        SELECT AVG(quantity) AS "avg"
        FROM Document
    )
WHERE quantity > "avg";


-- 15  Noms des auteurs ayant écrit des documents d'informatique 
-- et de mathématiques
-- Ici nous pouvons mettre un index de hachage sur mainTheme via les égalités strictes
SELECT name
FROM Author
WHERE
ID IN
    (
        SELECT AuthorID
        FROM Document_Author DA
        JOIN Document D ON D.ID = DA.DocumentID
        WHERE D.mainTheme = 'Mathématiques'
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
-- Ici on peut se concentrer sur le calcul de la jointure plutôt que sur un index
SELECT DISTINCT "EditorName", MAX("nbBorrow")
FROM
    (
        SELECT E."name" AS "EditorName", COUNT(dateStart) AS "nbBorrow"
        FROM Document_Borrower DB
        JOIN Document D ON D.ID = DB.DocumentID
        JOIN Editor E   ON E.ID = D.EditorID
        GROUP BY E."name"
    )
GROUP BY "EditorName"
;

-- On créer des vus pour rendre le tout un peu plus lisibles
-- ###### VUES #####

-- Vue contenant les mots clés de SQL pour les nuls
-- Ici on peut utiliser un index de hachage via l'égalité stricte
CREATE OR REPLACE VIEW sql_pour_les_nuls_keywords AS
SELECT KeywordID, DocumentID
FROM Document_Keywords DK
JOIN Document D ON D.ID = DK.DocumentID
WHERE D.title = 'SQL pour les nuls';

-- ###### FIN VUES ######

-- 17 Liste des documents n'ayant aucun 
-- mot-clef en commun avec le document dont le titre est "SQL pour les nuls".
SELECT title
FROM Document
WHERE
ID NOT IN
    (
        SELECT ID FROM docs_with_at_least_one_keyword_with_sql_pour_les_nuls  
    )
GROUP BY title;

-- 18 Liste des documents ayant au moins un mot-clef
-- en commun avec le document dont le titre est"SQL pour les nuls"
Select D.Title
From Document_Keywords A 
Inner Join sql_pour_les_nuls_keywords B 
    On A.KeywordID = B.KeywordID
    And A.DocumentID <> B.DocumentID
Inner Join Document D on D.ID = A.DocumentID
GROUP BY D.title;


-- 19 Liste des documents ayant au moins 
-- les mêmes mot-clef que le document dont le titre est "SQL pour les nuls".
-- En faire des vues
-- Cette requête permet d'avoir tous les mots clés qui ne sont pas les mots clés de SQL pour les nuls

SELECT KeywordID, D1.ID DOC_ID, D1.Title
FROM Document_Keywords DK1
     JOIN Document D1
        on DK1.DocumentID = D1.ID
WHERE exists
   (select 1
    from Document D2
    join Document_Keywords DK2
        on D2.ID = DK2.DocumentID
    where  D2.title = 'SQL pour les nuls'
     and DK1.KeywordID=DK2.KeywordID
     and D1.ID!= D2.ID
     );


-- 20 Liste des documents ayant exactement les mêmes mot-clef que le document
-- dont le titre est "SQL pour les nuls"
