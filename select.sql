/*Widok zawierający zestawienie autorów i napisanych przez nich książek, dostępnych w sklepie*/
CREATE VIEW AutorzyIKsiazki
	AS SELECT Imie, Nazwisko, Tytul
		FROM Autorzy, Ksiazki, Napisal
		WHERE Napisal.IDAutora = Autorzy.Id AND Napisal.ISBNKsiazki = Ksiazki.ISBN

/*Zapytanie o wszystkie książki dostępny w sklepie*/
SELECT *
	FROM AutorzyIKsiazki
	ORDER BY Tytul

DROP VIEW AutorzyIKsiazki

/*Lista wszystkich dostępnych książek, z uwzględnieniem promocji*/
SELECT Tytul, Cena
	FROM Ksiazki
	WHERE NOT EXISTS (
		SELECT *
			FROM Przecenione
			WHERE Ksiazki.ISBN = Przecenione.ISBNKsiazki
	)
	UNION
	SELECT Tytul, ROUND(Ksiazki.Cena - Ksiazki.Cena*Obnizka/100, 2) AS Cena
		FROM Ksiazki, Promocje, Przecenione
		WHERE Ksiazki.ISBN = Przecenione.ISBNKsiazki AND Promocje.ID = Przecenione.IDPromocji
		ORDER BY Cena DESC

/*Pobranie średniej ocen danego tytułu (jeżeli był oceniony)*/
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
