CREATE TABLE Autorzy(
	ID			INT PRIMARY KEY,
	Imie		VARCHAR(30) NOT NULL,
	Nazwisko	VARCHAR(50) NOT NULL,
)

CREATE TABLE Ksiazki (
	ISBN	CHAR(13) PRIMARY KEY,
	Tytul	VARCHAR(50) NOT NULL,
	Cena	SMALLMONEY NOT NULL,
	Opis	VARCHAR(1000),
	Wydawca VARCHAR(50) NOT NULL
)

CREATE TABLE Napisal (
	IDAutora	INT REFERENCES Autorzy NOT NULL,
	ISBNKsiazki	CHAR(13) REFERENCES Ksiazki NOT NULL,

	PRIMARY KEY (IDAutora, ISBNKsiazki)
)

CREATE TABLE Promocje (
	ID				INT	PRIMARY KEY,
	Nazwa			VARCHAR(50) NOT NULL,
	DataRozpoczecia	DATE NOT NULL,
	DataZakonczenia	DATE NOT NULL,
	Obnizka			INT NOT NULL,

	CHECK(Obnizka > 0 AND Obnizka < 100)
)

CREATE TABLE Przecenione (
	IDPromocji	INT REFERENCES Promocje NOT NULL,
	ISBNKsiazki	CHAR(13) REFERENCES Ksiazki NOT NULL,

	PRIMARY KEY (IDPromocji, ISBNKsiazki)
)

CREATE TABLE Uzytkownicy (
	ID			INT PRIMARY KEY,
	Email		VARCHAR(50) NOT NULL UNIQUE,
	PassHash	CHAR(64) NOT NULL
)

CREATE TABLE DaneDostawy (
	ID					INT PRIMARY KEY,
	ImieOdbiorcy		VARCHAR(30) NOT NULL,
	NazwiskoOdbiorcy	VARCHAR(50) NOT NULL,
	AdresDostawy		VARCHAR(100) NOT NULL,
	NrTelefonu			CHAR(9) NOT NULL,
	IDUzytkownika		INT REFERENCES Uzytkownicy NOT NULL
)

CREATE TABLE Zamowienia (
	NrZamowienia		INT PRIMARY KEY,
	DataZlozenia		DATE NOT NULL,
	Wartosc				SMALLMONEY NOT NULL,
	SposobDostawy		INT REFERENCES DaneDostawy NOT NULL,
	IDUzytkownika		INT REFERENCES Uzytkownicy NOT NULL,
	DataWyslania		DATE,
	DataZrealizowania	DATE
)
CREATE TABLE PozycjeZamowienia (
	NrZamowienia	INT REFERENCES Zamowienia NOT NULL,
	ISBNKsiazki		CHAR(13) REFERENCES Ksiazki NOT NULL,
	Ilosc			INT NOT NULL

	PRIMARY KEY	(NrZamowienia, ISBNKsiazki),
	CHECK(Ilosc > 0)
)

CREATE TABLE WirtualnePolki (
	IDUzytkownika	INT REFERENCES Uzytkownicy NOT NULL,
	Nazwa			VARCHAR(50) NOT NULL,

	PRIMARY KEY (IDUzytkownika, Nazwa)
)

CREATE TABLE OdlozoneNaPolke (
	ISBNKsiazki		CHAR(13) REFERENCES Ksiazki NOT NULL,
	IDUzytkownika	INT REFERENCES Uzytkownicy NOT NULL,
	NazwaPolki		VARCHAR(50) NOT NULL,

	PRIMARY KEY(ISBNKsiazki, IDUzytkownika, NazwaPolki),
	FOREIGN KEY(IDUzytkownika, NazwaPolki) REFERENCES WirtualnePolki
)

CREATE TABLE Recenzje (
	IDUzytkownika	INT REFERENCES Uzytkownicy NOT NULL,
	ISBNKsiazki		CHAR(13) REFERENCES Ksiazki NOT NULL,
	Nota			INT NOT NULL,
	Tresc			VARCHAR(1000),

	PRIMARY KEY(IDUzytkownika, ISBNKsiazki),
	CHECK(Nota > 0 AND Nota <=5)
)
