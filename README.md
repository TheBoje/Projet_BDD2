# Projet de base de données

Ce projet est à réaliser avant le 3 mai 2021, dans le cadre de l'Unité
d'Enseignement "Bases de Données 2". Ce projet porte sur la création et
l'utilisation d'une base de données multimédia, et est à réaliser en trinôme.

# 1. Conception de la base de données multimédia

&nbsp;Voici le schéma entité association que nous avons réalisé pour le projet :

![MCD temporaire](/images/mcd.png) 

## Problème rencontré

&nbsp;Durant la réalisation du schéma, nous nous sommes confronté à un problème
majeur qui été la gestion des documents. En effet la médiathèque propose
plusieurs types de documents (dans un premier temps : vidéos, CD, DVD, livres).
Ces différents documents ont la plupart de leurs champs en communs mais certains
en ont en plus. 

&nbsp;Nous avons, dans un premiers temps, pensé à de l'héritage de table (comme
pour de l'héritage en Programmation Orienté Objet). Cette technique n'était pas
concluante car il aurait alors fallut mettre tous les champs de la table
`Document` dans toutes les autres tables. Et donc, s'il nous faudrait rajouter
un type de document, cela serait fastidieux.

&nbsp;La deuxième solution qui nous est venue est d'attribuer une clé primaire
unique qui se serait partagée entre tous les types de documents. Ainsi pour
faire les requêtes il nous faut joindre tous les types de documents à chaque fois. 


# 2. Création de la base de données multimédia

TODO : Réaliser la base via Visual paradigm a partir du MCD

# 3. Gestion des transactions

&nbsp;Pour le moment nous avons penser à utiliser les verrous pour gèrer les
différentes transactions simultanées. Bien sûr, nous appliquerons l'algorithme
de prévention des verrous mortels.

# 4. Vérification de la cohérence de la base


# 5. Remplissage de la base de données multimédia


# 6. Interrogation de la base de données multimédia


# 7. Optimisation des requêtes
