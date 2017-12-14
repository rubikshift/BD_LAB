CREATE TABLE Autorzy(
	ID			INT,
	Imie		VARCHAR(30) NOT NULL,
	Nazwisko	VARCHAR(50) NOT NULL,

	PRIMARY KEY(ID)
)

CREATE TABLE Ksiazki (
	ISBN	CHAR(13),
	Tytul	VARCHAR(50) NOT NULL,
	Cena	SMALLMONEY NOT NULL,
	Opis	VARCHAR(1000),
	Wydawca VARCHAR(50) NOT NULL,

	PRIMARY KEY (ISBN)
)

CREATE TABLE Napisal (
	IDAutora	INT NOT NULL,
	ISBNKsiazki	CHAR(13) NOT NULL,

	PRIMARY KEY (IDAutora, ISBNKsiazki),
	FOREIGN KEY(IDAutora) REFERENCES Autorzy,
	FOREIGN KEY(ISBNKsiazki) REFERENCES Ksiazki,
)

CREATE TABLE Promocje (
	ID				INT,
	Nazwa			VARCHAR(50) NOT NULL,
	DataRozpoczecia	DATE NOT NULL,
	DataZakonczenia	DATE NOT NULL,
	Obnizka			INT NOT NULL,

	PRIMARY KEY (ID),

	CHECK(Obnizka > 0 AND Obnizka < 100)
)

CREATE TABLE Przecenione (
	IDPromocji	INT NOT NULL,
	ISBNKsiazki	CHAR(13) NOT NULL,

	PRIMARY KEY (IDPromocji, ISBNKsiazki),
	FOREIGN KEY(IDPromocji) REFERENCES Promocje,
	FOREIGN KEY(ISBNKsiazki) REFERENCES Ksiazki,
)

CREATE TABLE Uzytkownicy (
	ID			INT,
	Email		VARCHAR(50) NOT NULL UNIQUE,
	PassHash	CHAR(64) NOT NULL,

	PRIMARY KEY (ID)
)

CREATE TABLE DaneDostawy (
	ID					INT,
	ImieOdbiorcy		VARCHAR(30) NOT NULL,
	NazwiskoOdbiorcy	VARCHAR(50) NOT NULL,
	AdresDostawy		VARCHAR(100) NOT NULL,
	NrTelefonu			CHAR(9) NOT NULL,
	IDUzytkownika		INT NOT NULL

	PRIMARY KEY(ID),
	FOREIGN KEY(IDUzytkownika) REFERENCES Uzytkownicy,
)

CREATE TABLE Zamowienia (
	NrZamowienia		INT,
	DataZlozenia		DATE NOT NULL,
	Wartosc				SMALLMONEY NOT NULL,
	SposobDostawy		INT NOT NULL,
	IDUzytkownika		INT NOT NULL,
	DataWyslania		DATE,
	DataZrealizowania	DATE,

	PRIMARY KEY(NrZamowienia),
	FOREIGN KEY(SposobDostawy) REFERENCES DaneDostawy,
	FOREIGN KEY(IDUzytkownika) REFERENCES Uzytkownicy,
)
CREATE TABLE PozycjeZamowienia (
	NrZamowienia	INT NOT NULL,
	ISBNKsiazki		CHAR(13) NOT NULL,
	Ilosc			INT NOT NULL,

	PRIMARY KEY	(NrZamowienia, ISBNKsiazki),
	FOREIGN KEY(NrZamowienia) REFERENCES Zamowienia,
	FOREIGN KEY(ISBNKsiazki) REFERENCES Ksiazki,

	CHECK(Ilosc > 0)
)

CREATE TABLE WirtualnePolki (
	IDUzytkownika	INT NOT NULL,
	Nazwa			VARCHAR(50) NOT NULL,

	PRIMARY KEY (IDUzytkownika, Nazwa),
	FOREIGN KEY(IDUzytkownika) REFERENCES Uzytkownicy,

)

CREATE TABLE OdlozoneNaPolke (
	ISBNKsiazki		CHAR(13) NOT NULL,
	IDUzytkownika	INT NOT NULL,
	NazwaPolki		VARCHAR(50) NOT NULL,

	PRIMARY KEY(ISBNKsiazki, IDUzytkownika, NazwaPolki),
	FOREIGN KEY(IDUzytkownika, NazwaPolki) REFERENCES WirtualnePolki,
	FOREIGN KEY(ISBNKsiazki) REFERENCES Ksiazki
)

CREATE TABLE Recenzje (
	IDUzytkownika	INT NOT NULL,
	ISBNKsiazki		CHAR(13) NOT NULL,
	Nota			INT NOT NULL,
	Tresc			VARCHAR(1000),

	PRIMARY KEY(IDUzytkownika, ISBNKsiazki),
	FOREIGN KEY(IDUzytkownika) REFERENCES Uzytkownicy,
	FOREIGN KEY(ISBNKsiazki) REFERENCES Ksiazki,

	CHECK(Nota > 0 AND Nota <=5)
)
