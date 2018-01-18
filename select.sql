/*Widok zawierający zestawienie autorów i napisanych przez nich książek, dostępnych w sklepie*/
CREATE VIEW AutorzyIKsiazki
	AS SELECT Imie, Nazwisko, Tytul
		FROM Autorzy, Ksiazki, Napisal
		WHERE Napisal.IDAutora = Autorzy.Id AND Napisal.ISBNKsiazki = Ksiazki.ISBN

/*Wszystkie książki dostępne w sklepie*/
SELECT *
	FROM AutorzyIKsiazki
	ORDER BY Tytul

DROP VIEW AutorzyIKsiazki

/*Lista cen wszystkich dostępnych książek, z uwzględnieniem promocji*/
SELECT Tytul, Cena
	FROM Ksiazki
	WHERE NOT EXISTS (
		SELECT *
			FROM Przecenione, Promocje
			WHERE Ksiazki.ISBN = Przecenione.ISBNKsiazki AND
				Przecenione.IDPromocji = Promocje.ID AND
				Promocje.DataRozpoczecia < CAST(GETDATE() AS DATE) AND
				Promocje.DataZakonczenia > CAST(GETDATE() AS DATE)
	)
	UNION
	SELECT Tytul, ROUND(Ksiazki.Cena - Ksiazki.Cena*Obnizka/100, 2) AS Cena
		FROM Ksiazki, Promocje, Przecenione
		WHERE Ksiazki.ISBN = Przecenione.ISBNKsiazki AND 
			Promocje.ID = Przecenione.IDPromocji AND
			Promocje.DataRozpoczecia < CAST(GETDATE() AS DATE) AND
			Promocje.DataZakonczenia > CAST(GETDATE() AS DATE) 
		ORDER BY Cena DESC

/*Wszystkie obecnie trwajace promocje*/
SELECT Nazwa, DataRozpoczecia, DataZakonczenia, COUNT(ISBNKsiazki) AS IloscPrzecenionych
	FROM Promocje, Przecenione
	WHERE Promocje.ID = Przecenione.IDPromocji AND 
		Promocje.DataRozpoczecia < CAST(GETDATE() AS DATE) AND
		Promocje.DataZakonczenia > CAST(GETDATE() AS DATE)
	GROUP BY Nazwa, DataRozpoczecia, DataZakonczenia

/*Średniej ocen danego tytułu (jeżeli był oceniony)*/
SELECT Tytul, ROUND(AVG(CAST(Nota AS FLOAT)), 2) AS SredniaOcen
	FROM Ksiazki, Recenzje
	WHERE Ksiazki.ISBN = Recenzje.ISBNKsiazki
	GROUP BY Tytul

/*Najchętniej kupowane ksiązki*/
SELECT TOP(3) Tytul, SUM(Ilosc) as IloscSprzedanych
	FROM Ksiazki, PozycjeZamowienia
	WHERE Ksiazki.ISBN = PozycjeZamowienia.ISBNKsiazki
	GROUP BY Tytul
	ORDER BY IloscSprzedanych DESC

/*Wyswietlenie ilosci kupionych ksiazek prze danego uzytkownika*/
SELECT Email, SUM(Ilosc) as IloscKupionychKsiazek
	FROM Uzytkownicy, PozycjeZamowienia
	WHERE PozycjeZamowienia.NrZamowienia IN (
		SELECT NrZamowienia
		FROM Zamowienia
		WHERE Uzytkownicy.ID = Zamowienia.IDUzytkownika
	)
	GROUP BY Email
	ORDER BY IloscKupionychKsiazek ASC

/*Historie zamowien poszczegolnych uzytkownikow*/
SELECT Email, DataZlozenia, Tytul, Ilosc
	FROM Uzytkownicy, Zamowienia, PozycjeZamowienia, Ksiazki
	WHERE Zamowienia.IDUzytkownika = Uzytkownicy.ID AND 
		Zamowienia.NrZamowienia = PozycjeZamowienia.NrZamowienia AND
		PozycjeZamowienia.ISBNKsiazki = Ksiazki.ISBN

/*Wyswietlenie wirtualnych półek (dla poszczegółnych użytkowników) oraz ich zawartości*/
SELECT Email, Nazwa as NazwaPolki, Tytul
	FROM Uzytkownicy, WirtualnePolki, Ksiazki
	WHERE EXISTS (
		SELECT *
			FROM OdlozoneNaPolke
			WHERE OdlozoneNaPolke.IDUzytkownika = Uzytkownicy.Id
					AND WirtualnePolki.Nazwa = OdlozoneNaPolke.NazwaPolki
					AND WirtualnePolki.IDUzytkownika = Uzytkownicy.ID
					AND Ksiazki.ISBN = OdlozoneNaPolke.ISBNKsiazki
		)
	ORDER BY Email