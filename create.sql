CREATE TABLE Autorzy(
	ID			INT PRIMARY KEY,
	Imie		VARCHAR(30) NOT NULL,
	Nazwisko	VARCHAR(50) NOT NULL,
)

CREATE TABLE Ksiazki (
	ISBN	CHAR(13) PRIMARY KEY,
	Tytul	VARCHAR(50) NOT NULL,
	Cena	SMALLMONEY NOT NULL,
	Opis	VARCHAR,
	Wydawca VARCHAR(50) NOT NULL
)

CREATE TABLE Napisal (
	IDAutora	INT REFERENCES Autorzy NOT NULL,
	ISBNKsiazki	CHAR(13) REFERENCES Ksiazki,

	PRIMARY KEY (IDAutora, ISBNKsiazki)
)

CREATE TABLE Promocje (
	ID				INT	PRIMARY KEY,
	Nazwa			VARCHAR(50),
	DataRozpoczecia	DATE,
	DataZakonczenia	DATE,
	Obnizka			INT
)

CREATE TABLE Przecenione (
	IDPromocji	INT REFERENCES Promocje,
	ISBNKsiazki	CHAR(13) REFERENCES Ksiazki,

	PRIMARY KEY (IDPromocji, ISBNKsiazki)
)

CREATE TABLE Uzytkownicy (
	ID			INT PRIMARY KEY,
	Email		VARCHAR(50),
	PassHash	CHAR(256)
)

CREATE TABLE DaneDostawy (
	ID					INT PRIMARY KEY,
	ImieOdbiorcy		VARCHAR(30),
	NazwiskoOdbiorcy	VARCHAR(50),
	AdresDostawy		VARCHAR(100),
	NrTelefonu			CHAR(9),
	IDUzytkownika		INT REFERENCES Uzytkownicy
)

CREATE TABLE Zamowienia (
	NrZamowienia		INT PRIMARY KEY,
	DataZlozenia		DATE,
	Wartosc				SMALLMONEY,
	SposobDostawy		INT REFERENCES DaneDostawy,
	DataWyslania		DATE,
	DataZrealizowania	DATE
)
CREATE TABLE PozycjeZamowienia (
	NrZamowienia	INT REFERENCES Zamowienia,
	ISBNKsiazki		CHAR(13) REFERENCES Ksiazki,

	PRIMARY KEY	(NrZamowienia, ISBNKsiazki)
)

CREATE TABLE WirtualnePolki (
	IDUzytkownika	INT REFERENCES Uzytkownicy,
	Nazwa			VARCHAR(50),

	PRIMARY KEY (IDUzytkownika, Nazwa)
)