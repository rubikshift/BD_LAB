SELECT Imie, Nazwisko, Tytul
	FROM Autorzy, Ksiazki, Napisal
	WHERE Napisal.IDAutora = Autorzy.Id AND Napisal.ISBNKsiazki = Ksiazki.ISBN
	ORDER BY Tytul


SELECT Tytul, Nazwa, ROUND(Cena*Obnizka/100, 2) AS Wartosc
	FROM Ksiazki, Promocje, Przecenione
	WHERE Ksiazki.ISBN = Przecenione.ISBNKsiazki AND Promocje.ID = Przecenione.IDPromocji
	ORDER BY Wartosc DESC

SELECT Tytul, ROUND(AVG(CAST(Nota AS FLOAT)), 2) AS SredniaOcen
	FROM Ksiazki, Recenzje
	WHERE Ksiazki.ISBN = Recenzje.ISBNKsiazki
	GROUP BY Tytul
