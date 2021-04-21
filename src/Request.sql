-- 1 Liste par ordre alphabétique des titres de documents dont le thème comprend le motinformatique ou mathématiques
SELECT title 
FROM Document 
WHERE 
    mainTheme = 'informatique' OR 
    mainTheme = 'mathématiques'
ORDER BY title;

-- 2 Liste (titre et thème) des documents empruntés par Dupont entre le 15/11/2018 et le 15/11/2019
SELECT Document.title 
FROM Document AS D
JOIN Document_Borrower DB   ON DB.DocumentID = D.ID
JOIN Borrower B             ON B.ID = DB.BorrowerID
WHERE 
    B.name = 'Dupont' AND
    DB.dateStart > '2018-11-15' AND
    DB.dateStart < '2019-11-15'
;

-- 3 Pour chaque emprunteur, donner la liste des titres des documents qu'il a empruntés avec le nom des auteurs pour chaque document.
SELECT B.name, D.title, A.name
FROM Borrower AS B
JOIN Document_Borrower DB   ON DB.BorrowerID = B.ID
JOIN Document D             ON D.ID = DB.DocumentID
JOIN Document_Author DA     ON DA.DocumentID = D.ID
JOIN Author A               ON A.ID = DA.AuthorID
;

-- 3 Noms des auteurs ayant écrit un livre édité chez Dunod
SELECT *
FROM Document AS D
JOIN Editor E           ON E.ID = D.EditorID
JOIN Document_Author DA ON DA.DocumentID = D.ID
JOIN Author A           ON A.ID = DA.AuthorID
JOIN DocumentType DT    ON DT.ID = D.DocumentTypeID
WHERE
    Editor.name = "Dunod" AND
    DT.name = "Book"
;