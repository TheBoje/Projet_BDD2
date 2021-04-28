-- ######################################################
-- #         CreateBase.sql - Créé les tables           #
-- #                                                    #
-- # Par Vincent Commin, Louis Leenart & Alexis Louail  #
-- ######################################################

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

    CONSTRAINT fk_document_editor FOREIGN KEY (EditorID) REFERENCES Editor(ID),
    CONSTRAINT fk_document_documentType FOREIGN KEY (DocumentTypeID) REFERENCES DocumentType(ID)
);

CREATE TABLE Book
(
    DocumentID  INT PRIMARY KEY NOT NULL,
    nbPages     INT,

    CONSTRAINT fk_book_document FOREIGN KEY (DocumentID) REFERENCES Document(ID)
);

CREATE TABLE DVD
(
    DocumentID  INT PRIMARY KEY NOT NULL,
    duration    INT,

    CONSTRAINT fk_dvd_document FOREIGN KEY (DocumentID) REFERENCES Document(ID)
);

CREATE TABLE CD
(
    DocumentID  INT PRIMARY KEY NOT NULL,
    duration    INT,
    nbSubtitles INT,

    CONSTRAINT fk_cd_document FOREIGN KEY (DocumentID) REFERENCES Document(ID)
);

CREATE TABLE Video
(
    DocumentID      INT PRIMARY KEY NOT NULL,
    duration        INT,
    recordingFormat VARCHAR(10),

    CONSTRAINT fk_video_document FOREIGN KEY (DocumentID) REFERENCES Document(ID)
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
    CONSTRAINT fk_document_keywords_document FOREIGN KEY (DocumentID) REFERENCES Document(ID),
    CONSTRAINT fk_document_keywords_keywords FOREIGN KEY (KeywordID) REFERENCES Keywords(ID)
);

-- AUTEUR.S DE DOCUMENTS
CREATE TABLE Document_Author
(
    DocumentID  INT NOT NULL,
    AuthorID    INT NOT NULL,

    PRIMARY KEY (DocumentID, AuthorID),
    CONSTRAINT fk_document_author_document FOREIGN KEY (DocumentID) REFERENCES Document(ID),
    CONSTRAINT fk_document_author_author   FOREIGN KEY (AuthorID) REFERENCES Author(ID)
);

-- EMPRUNTEURS ET NOMBRES D'EMPRUNTS
CREATE TABLE BorrowerType
(
    ID          INT PRIMARY KEY NOT NULL,
    borrower    VARCHAR(20)
);

CREATE TABLE BorrowerType_DocumentType
(
    BorrowerTypeID      INT NOT NULL,
    DocumentTypeID      INT NOT NULL,
    durationBorrowMax   INT,
    nbBorrowMax         INT,

    PRIMARY KEY (BorrowerTypeID, DocumentTypeID),
    CONSTRAINT fk_borrowertype_documenttype_borrowertype FOREIGN KEY (BorrowerTypeID) REFERENCES BorrowerType(ID),
    CONSTRAINT fk_borrowertype_documenttype_documenttype FOREIGN KEY (DocumentTypeID) REFERENCES DocumentType(ID)
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

    CONSTRAINT fk_borrower_borrowertype FOREIGN KEY (BorrowerTypeID) REFERENCES BorrowerType(ID)
);

CREATE TABLE Document_Borrower
(
    DocumentID  INT NOT NULL,
    BorrowerID  INT NOT NULL,
    dateStart   DATE,
    dateReturn  DATE,

    PRIMARY KEY (DocumentID, BorrowerID),
    CONSTRAINT fk_document_borrower_document FOREIGN KEY (DocumentID) REFERENCES Document(ID),
    CONSTRAINT fk_document_borrower_borrower FOREIGN KEY (BorrowerID) REFERENCES Borrower(ID)
);

COMMIT;