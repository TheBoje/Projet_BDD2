-- AUTEUR ET EDITEUR
CREATE TABLE Author
(
    ID          INT PRIMARY KEY NOT NULL,
    name        VARCHAR(63),
    firstname   VARCHAR(63),
    birthdate   DATE
);

COMMIT;

 -- vérifier que les caractères entrés sont bien des nombres
CREATE TABLE Editor
(
    ID          INT PRIMARY KEY NOT NULL,
    name        VARCHAR(63),
    adress      VARCHAR(255),
    phoneNumber VARCHAR(10)
);

COMMIT;

-- TYPE DE DOCUMENTS ET DOCUMENT
CREATE TABLE DocumentType
(
    ID      INT PRIMARY KEY NOT NULL,
    name    VARCHAR(20)
);

CREATE TABLE Document
(
    ID              INT PRIMARY KEY NOT NULL,
    title           VARCHAR(255),
    mainTheme       VARCHAR(255),
    quantity        INT,
    department      INT,
    EditorID        INT,
    DocumentTypeID  INT,

    FOREIGN KEY (EditorID) REFERENCES Editor(ID),
    FOREIGN KEY (DocumentTypeID) REFERENCES DocumentType(ID)
);

CREATE TABLE Book
(
    DocumentID  INT PRIMARY KEY NOT NULL,
    nbPages     INT,

    FOREIGN KEY (DocumentID) REFERENCES Document(ID)
);

CREATE TABLE DVD
(
    DocumentID  INT PRIMARY KEY NOT NULL,
    duration    INT,

    FOREIGN KEY (DocumentID) REFERENCES Document(ID)
);

CREATE TABLE CD
(
    DocumentID  INT PRIMARY KEY NOT NULL,
    duration    INT,
    nbSubtitles INT,

    FOREIGN KEY (DocumentID) REFERENCES Document(ID)
);

CREATE TABLE Video
(
    DocumentID      INT PRIMARY KEY NOT NULL,
    duration        INT,
    recordingFormat VARCHAR(10),

    FOREIGN KEY (DocumentID) REFERENCES Document(ID)
);

-- MOTS CLES
CREATE TABLE Keywords
(
    ID      INT PRIMARY KEY NOT NULL,
    Word    VARCHAR(255)
);

CREATE TABLE Document_Keywords
(
    DocumentID  INT NOT NULL,
    KeywordID   INT NOT NULL,

    PRIMARY KEY (DocumentID, KeywordID),
    FOREIGN KEY (DocumentID) REFERENCES Document(ID),
    FOREIGN KEY (KeywordID) REFERENCES Keywords(ID)
);

-- AUTEUR.S DE DOCUMENTS
CREATE TABLE Document_Author
(
    DocumentID  INT NOT NULL,
    AuthorID    INT NOT NULL,

    PRIMARY KEY (DocumentID, AuthorID),
    FOREIGN KEY (DocumentID) REFERENCES Document(ID),
    FOREIGN KEY (AuthorID) REFERENCES Author(ID)
);

-- EMPRUNTEURS ET NOMBRES D'EMPRUNTS
CREATE TABLE BorrowerType
(
    ID          INT PRIMARY KEY NOT NULL,
    borrower    VARCHAR(20),
    nbBorrowMax INT
);

CREATE TABLE BorrowerType_DocumentType
(
    BorrowerTypeID      INT NOT NULL,
    DocumentTypeID      INT NOT NULL,
    durationBorrowMax   INT,

    PRIMARY KEY (BorrowerTypeID, DocumentTypeID),
    FOREIGN KEY (BorrowerTypeID) REFERENCES BorrowerType(ID),
    FOREIGN KEY (DocumentTypeID) REFERENCES DocumentType(ID)
);

CREATE TABLE Borrower
(
    ID              INT PRIMARY KEY NOT NULL,
    name            VARCHAR(63),
    firstname       VARCHAR(63),
    adress          VARCHAR(255),
    phoneNumber     VARCHAR(10),
    nbBorrow        INT,
    BorrowerTypeID  INT,

    FOREIGN KEY (BorrowerTypeID) REFERENCES BorrowerType(ID)
);

CREATE TABLE Document_Borrower
(
    DocumentID  INT NOT NULL,
    BorrowerID  INT NOT NULL,
    dateStart   DATE,
    dateReturn  DATE,

    PRIMARY KEY (DocumentID, BorrowerID),
    FOREIGN KEY (DocumentID) REFERENCES Document(ID),
    FOREIGN KEY (BorrowerID) REFERENCES Borrower(ID)
);

COMMIT;