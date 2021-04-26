# Projet de base de données

Ce projet est à réaliser avant le 3 mai 2021, dans le cadre de l'Unité d'Enseignement "Bases de Données 2". Ce projet porte sur la création et l'utilisation d'une base de données multimédia, et est à réaliser en trinôme.

Composition de notre groupe : Vincent Commin, Louis Leenart & Alexis Louail.

# 1. Conception de la base de données multimédia

&nbsp;Voici le schéma entité association que nous avons réalisé pour le projet :

![MCD temporaire](/images/mcd.png) 

## Problème rencontré

&nbsp;Durant la réalisation du schéma, nous nous sommes confronté à un problème majeur qui été la gestion des documents. En effet la médiathèque propose plusieurs types de documents (dans un premier temps : vidéos, CD, DVD, livres). Ces différents documents ont la plupart de leurs champs en communs mais certains en ont en plus. 

&nbsp;Nous avons, dans un premiers temps, pensé à de l'héritage de table (comme pour de l'héritage en Programmation Orienté Objet). Cette technique n'était pas concluante car il aurait alors fallut mettre tous les champs de la table `Document` dans toutes les autres tables. Et donc, s'il nous faudrait rajouter un type de document, cela serait fastidieux. 
&nbsp;La deuxième solution qui nous est venue est d'attribuer une clé primaire unique qui se serait partagée entre tous les types de documents. Ainsi pour faire les requêtes il nous faut joindre tous les types de documents à chaque fois.  

# 2. Création de la base de données multimédia

TODO : Réaliser la base via Visual paradigm a partir du MCD

# 3. Gestion des transactions

&nbsp;Pour le moment nous avons penser à utiliser les verrous pour gèrer les différentes transactions simultanées. Bien sûr, nous appliquerons l'algorithme de prévention des verrous mortels.

# 4. Vérification de la cohérence de la base

&nbsp;Pour la cohérence de la base de donnée nous nous somme centrée autour de plusieurs points : 
1. Verification lors de l'emprunt si les exemplaires ne sont pas tous déjà empruntés (c'est-à-dire qu'au moins 1 exemplaire est disponible).
2. Le nombre d'emprunt maximal d'une personne (valeur dépendant de la catégorie de l'emprunteur et du document) ne doit pas être dépassé avec l'emprunt d'un nouveau document.
3. Si un emprunteur est en retard pour la remise d'au moins 1 document, alors il ne peut pas en emprunter d'autres avant de le(s) avoir rendu(s).
4. A chaque ajout de document, il est nécessaire de déterminer le type auquel il appartient, pour l'ajouter dans la table correspondante.
5. A l'ajout et au rendu d'un document, mise à jour du nombre de document empruntés par l'emprunteur.

Suite à des problèmes de gestion du temps, et des difficultées à appliquer correctement la syntaxe de SQL, nous n'avons pas terminé la mise en place des différents triggers. Cependant, voici la méthode que nous aurions appliqué pour chacun des cas.

1. Verification lors de l'emprunt si les exemplaires ne sont pas tous déjà empruntés (c'est-à-dire qu'au moins 1 exemplaire est disponible) :
```
A chaque ajout sur Document_borrower
    ->  Join entre Document et Document_borrower
        Where id du document = l'id du document que l'on souhaite emprunter,
              avec retour indéfini (donc null) 
              avec quantité du document > 0

    ->  Ensuite On compte le nombre de document total du Join précédent
        Si nombre de document empruntés < nombre total de document
        Alors L'emprunt est validé
        Sinon L'emprunt est refusé
```

2. Le nombre d'emprunt maximal d'une personne (valeur dépendant de la catégorie de l'emprunteur et du document) ne doit pas être dépassé avec l'emprunt d'un nouveau document.

```
A chaque ajout sur Document_borrower
    -> Join entre Borrower, BorrowerType, Document_Borrower, Document, DocumentType et BorrowerType_DocumentType
        Récupération de nbBorrow et nbBorrowMax du document/emprunteur en question
    
    ->  Si nbBorrow + 1 <= nbBorrowMax
        Alors L'emprunt est validé
        Sinon L'emprunt est refusé
```
On note que ce trigger fais appel à de nombreuses jointures pour pouvoir récupérer les bonnes données. De ce fait, si les tables sont menées à grandir, l'ordre des jointures doit être examiné afin de réduire le temps de calcul.

3. Si un emprunteur est en retard pour la remise d'au moins 1 document, alors il ne peut pas en emprunter d'autres avant de le(s) avoir rendu(s).

```
A chaque ajout sur Document_Borrower
    ->  Join entre Borrower, BorrowerType, Document_Borrower, Document, DocumentType et BorrowerType_DocumentType
        Récupération de durationBorrowMax et dateStart
    ->  Pour chacun des documents empruntés
            Initialisation de compteur
            Si dateStart + durationBorrowMax est après la date du jour
            Alors compteur += 1
    
    ->  Si compteur = 0
        Alors L'emprunt est validé
        Sinon L'emprunt est refusé     

```

4. A chaque ajout de document, il est nécessaire de déterminer le type auquel il appartient, pour l'ajouter dans la table correspondante.

```
A chaque ajout sur Document
    -> 
```

il faut tout d'abord faire un join entre la table DoCument type et l'insertion  sur leur id avec un where ou docuementtype.name testeras un type de document.
nous n'aurront plus que a faire ensuite un test Exist sur ce join et si ce test est vrai alors on feras une insertion sur la talbe qui seras tester avec l'id de l'insertion faite sur docuement.





# 5. Remplissage de la base de données multimédia
&nbsp;Le remplissage de notre base de données est assuré par le fichier `src/Inserting.sql`, dans lequel on ajoute :
- Les types d'emprunteur `Personnel`, `Professionnel` et `Public`
- Les types de document `Livre`, `DVD`, `CD` et `Video`
- Des auteurs
- Des éditeurs
- Des emprunteurs
- Des documents
- Des emprunts

# 6. Interrogation de la base de données multimédia
&nbsp;L'interrogation de la base de données multimédia est assuré par les requetes contenues dans le fichier `src/Request.sql`. Les requêtes sont les suivantes :

## 1) Liste par ordre alphabétique des titres de documents dont le thème comprend le mot informatique ou mathématiques
```sql
SELECT title 
FROM Document 
WHERE 
    mainTheme = 'Informatique' OR 
    mainTheme = 'Mathématiques'
ORDER BY title;
```

## 2) Liste (titre et thème) des documents empruntés par Dupont entre le 15/11/2018 et le 15/11/2019
```sql
SELECT D.title, DB.dateStart
FROM Document D
JOIN Document_Borrower DB   ON DB.DocumentID = D.ID
JOIN Borrower B             ON B.ID = DB.BorrowerID
WHERE 
    B.name = 'Dupont' AND
    TO_DATE(DB.dateStart, 'DD/MM/YY') >= TO_DATE('15/11/18', 'DD/MM/YY') AND
    TO_DATE(DB.dateStart, 'DD/MM/YY') <= TO_DATE('15/11/19', 'DD/MM/YY');
```

## 3) Pour chaque emprunteur, donner la liste des titres des documents qu'il a empruntés avec le nom des auteurs pour chaque document
```sql
SELECT B.name, D.title, A.name
FROM Borrower B
JOIN Document_Borrower DB   ON DB.BorrowerID = B.ID
JOIN Document D             ON D.ID = DB.DocumentID
JOIN Document_Author DA     ON DA.DocumentID = D.ID
JOIN Author A               ON A.ID = DA.AuthorID
ORDER BY B.name;
```

## 4) Noms des auteurs ayant écrit un livre édité chez Dunod
```sql
SELECT D.title, E."name"
FROM Document D
JOIN Editor E           ON E.ID = D.EditorID
JOIN Document_Author DA ON DA.DocumentID = D.ID
JOIN Author A           ON A.ID = DA.AuthorID
JOIN DocumentType DT    ON DT.ID = D.DocumentTypeID
WHERE
    E."name" = 'Dunod' AND
    DT.name = 'Book';
```

## 5) Quantité totale des exemplaires édités chez Eyrolles
```sql
SELECT SUM(quantite)
FROM Document D
JOIN Editor E   ON E.ID = D.EditorID
WHERE E."name" = 'Eyrolles';
```

## 6) Pour chaque éditeur, nombre de documents présents à la bibliothèque
```sql
SELECT E."name", COUNT(D.title) AS "Nb docs"
FROM Document D
JOIN Editor E ON E.ID = D.EditorID
GROUP BY E."name";
```

## 7) Pour chaque document, nombre de fois où il a été emprunté
```sql
SELECT D.title, COUNT(DB.DocumentID) AS "Nb borrowing"
FROM Document D
JOIN Document_Borrower DB ON DB.DocumentID = D.ID
GROUP BY D.title;
```

## 8) Liste des éditeurs ayant édité plus de deux documents d'informatique ou de mathématiques
```sql
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
```

## 9) Noms des emprunteurs habitant la même adresse que Dupont
```sql
SELECT B2.name, B2.firstname
FROM Borrower B1, Borrower B2
WHERE
    B1.name = 'Dupont' AND
    B1.adress = B2.adress
GROUP BY B2.name, B2.firstname;
```

## 10) Liste des éditeurs n'ayant pas édité de documents d'informatique
```sql
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
    );
```

## 11) Noms des personnes n'ayant jamais emprunté de documents
```sql
SELECT name, firstname
FROM Borrower
WHERE
ID NOT IN
    (
        SELECT BorrowerID
        FROM Document_Borrower
        GROUP BY BorrowerID
    );
```

## 12) Liste des documents n'ayant jamais été empruntés
```sql
SELECT title
FROM Document
WHERE
ID NOT IN
    (
        SELECT DocumentID
        FROM Document_Borrower
        GROUP BY DocumentID
    );
```

## 13) Liste des emprunteurs (nom, prénom) appartenant à la catégorie des professionnels ayant emprunté au moins une fois un DVD au cours des 6 derniers mois
```sql
SELECT B.name, B.firstname
FROM Borrower B
JOIN BorrowerType BT        ON BT.ID = B.BorrowerTypeID
JOIN Document_Borrower DB   ON DB.BorrowerID = B.ID
JOIN Document D             ON D.ID = DB.DocumentID
JOIN DocumentType DT        ON DT.ID = D.DocumentTypeID
WHERE
    BT.Borrower = 'Professionnel' AND
    DT.name = 'DVD'               AND
    MONTHS_BETWEEN(DB.dateStart, SYSDATE) <= 6;
```

## 14) Liste des documents dont le nombre d'exemplaires est supérieur au nombre moyen d'exemplaires
```sql
SELECT title
FROM Document,
    (
        SELECT AVG(quantity) AS "avg"
        FROM Document
    )
WHERE quantity > "avg";
```

## 15) Noms des auteurs ayant écrit des documents d'informatique et de mathématiques (ceux qui ont écrit les deux)
```sql
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
    );
```

## 16) Éditeur dont le nombre de documents empruntés est le plus grand
```sql
SELECT DISTINCT "EditorName", MAX("nbBorrow")
FROM
    (
        SELECT E."name" AS "EditorName", COUNT(dateStart) AS "nbBorrow"
        FROM Document_Borrower DB
        JOIN Document D ON D.ID = DB.DocumentID
        JOIN Editor E   ON E.ID = D.EditorID
        GROUP BY E."name"
    )
GROUP BY "EditorName";
```

## 17) Liste des documents n'ayant aucun mot cléf en commun avec le document dont le titre est "SQL pour les nuls"
Pour rendre les requetes plus lisibles, nous mettons en place des vues qui sont les suivantes:
```sql
-- Vue contenant les mots clés de SQL pour les nuls
CREATE OR REPLACE VIEW sql_pour_les_nuls_keywords AS
SELECT KeywordID, DocumentID
FROM Document_Keywords DK
JOIN Document D ON D.ID = DK.DocumentID
WHERE D.title = 'SQL pour les nuls';

-- Vue contenant les id des documents ayant au moins un mot clé en commun avec SQL pour les nuls
CREATE OR REPLACE VIEW docs_with_at_least_one_keyword_with_sql_pour_les_nuls AS
SELECT D.ID, D.title
FROM Document D
JOIN Document_Keywords DK ON DK.DocumentID = D.ID
WHERE
DK.KeywordID IN 
    (
        SELECT KeywordID FROM sql_pour_les_nuls_keywords
    );
```

```sql
SELECT title
FROM Document
WHERE
ID NOT IN
    (
        SELECT ID FROM docs_with_at_least_one_keyword_with_sql_pour_les_nuls  
    )
GROUP BY title;
```

## 18) Liste des documents ayant au moins un mot-clef en commun avec le document dont le titre est "SQL pour les nuls"
```sql
SELECT title 
FROM docs_with_at_least_one_keyword_with_sql_pour_les_nuls
GROUP BY title;
```

## 19) Liste des documents ayant au moins les mêmes mot-clef que le document dont le titre est "SQL pour les nuls"
```sql
TODO
```

## 20) Liste des documents ayant exactement les mêmes mot-clef que le document dont le titre est "SQL pour les nuls"
```sql
TODO
```

# 7. Optimisation des requêtes
## 1) Liste par ordre alphabétique des titres de documents dont le thème comprend le mot informatique ou mathématiques
Ici on pourrait mettre un index par hachage sur le `Document.mainTheme` étant donné une égalisation stricte.
## 2) Liste (titre et thème) des documents empruntés par Dupont entre le 15/11/2018 et le 15/11/2019
Ici nous pourrions utiliser un Arbre-b sur la date `Document_Borrower.dateStart` étant donné les inégalités.
## 3) Pour chaque emprunteur, donner la liste des titres des documents qu'il a empruntés avec le nom des auteurs pour chaque document
Ici on a pas besoin d'index, la question pourra se poser sur la méthode de calcul de jointure utilisée.
## 4) Noms des auteurs ayant écrit un livre édité chez Dunod
Ici nous pouvons utiliser le hachage sur le nom de  l'éditeur et sur le nom du type de document. Mais ici aussi, vu le nombre de jointures. On peut se concentrer sur le calcul de la jointure. On peut aussi utiliser un index bitmap car `DocumentType.name` est un domaine restreint (ici 4 valeurs seulement).
## 5) Quantité totale des exemplaires édités chez Eyrolles
Ici on peut utiliser un hachage sur le nom de l'éditeur `Editor.name` grâce à une égalité stricte.
## 6) Pour chaque éditeur, nombre de documents présents à la bibliothèque
Ici nous n'avons pas besoin d'index.
## 7) Pour chaque document, nombre de fois où il a été emprunté
Ici nous n'avons pas besoin d'index.
## 8) Liste des éditeurs ayant édité plus de deux documents d'informatique ou de mathématiques
On peut ici utiliser un hachage sur `Document.mainTheme`.
## 9) Noms des emprunteurs habitant la même adresse que Dupont
Ici on peut mettre un index de hachage sur `Borrower.firstname`.
## 10) Liste des éditeurs n'ayant pas édité de documents d'informatique
Ici on peut mettre un index de hachage sur `Document.mainTheme` grâce à l'égalite stricte.
## 11) Noms des personnes n'ayant jamais emprunté de documents
Ici nous n'avons pas besoin d'index.
## 12) Liste des documents n'ayant jamais été empruntés
Ici nous n'avons pas besoin d'index.
## 13) Liste des emprunteurs (nom, prénom) appartenant à la catégorie des professionnels ayant emprunté au moins une fois un DVD au cours des 6 derniers mois
Ici nous pouvons mettre un index Arbre-b sur `Document_Borrower.dateStart`.
## 14) Liste des documents dont le nombre d'exemplaires est supérieur au nombre moyen d'exemplaires
Ici nous pouvons mettre un index Arbre-b sur `Document.quantity`.
## 15) Noms des auteurs ayant écrit des documents d'informatique et de mathématiques (ceux qui ont écrit les deux)
Ici nous pouvons mettre un index de hachage sur `Document.mainTheme` via les égalités strictes.
## 16) Éditeur dont le nombre de documents empruntés est le plus grand
Ici on peut se concentrer sur le calcul de la jointure plutôt que sur un index.
## 17) Liste des documents n'ayant aucun mot cléf en commun avec le document dont le titre est "SQL pour les nuls"
### Vue sql_pour_les_nuls_keywords
Ici on peut utiliser un index de hachage via l'égalité stricte.
## 18) Liste des documents ayant au moins un mot-clef en commun avec le document dont le titre est "SQL pour les nuls"
TODO
## 19) Liste des documents ayant au moins les mêmes mot-clef que le document dont le titre est "SQL pour les nuls"
TODO
## 20) Liste des documents ayant exactement les mêmes mot-clef que le document dont le titre est "SQL pour les nuls"
TODO