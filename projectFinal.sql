-- Imiê i nazwisko (numer indeksu): Mateusz Jendernal (261012), Kamil Górny (261021)
-- Temat bazdy danych: Aplikacja do zamawiania us³ug transportu samochodowego (Uber itp.)

-- 0A) TWORZENIE TABEL

CREATE TABLE Adres (
	idAdres INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	miejscowosc VARCHAR(30) NOT NULL,
	ulica VARCHAR(50) NOT NULL,
	nr_domu VARCHAR(10) NOT NULL,
	nr_mieszkania INTEGER,
	kod CHAR(11) NOT NULL
);

CREATE TABLE Znizka (
	idZnizka INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	nazwa VARCHAR(30) NOT NULL,
	procentRabatu INT NOT NULL CHECK(procentRabatu<=100)
);

CREATE TABLE Ocena (
	idOcena INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	ocenaKierowcy DECIMAL(3,2) NOT NULL DEFAULT 0.00 CHECK(ocenaKierowcy<=5.00),
	podwyzkaProcent INT NOT NULL CHECK(podwyzkaProcent<=100)
);

CREATE TABLE Klient (
	idKlient INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Adres3 INTEGER REFERENCES Adres(idAdres),
	Adres2 INTEGER REFERENCES Adres(idAdres),
	Adres1 INTEGER REFERENCES Adres(idAdres),
	idZnizka INTEGER REFERENCES Znizka(idZnizka),
	imie VARCHAR(30) NOT NULL,
	nazwisko VARCHAR(30) NOT NULL,
	dataUrodzenia DATE NOT NULL
); 

CREATE TABLE Kierowca (
	idKierowca INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	idOcena INTEGER NOT NULL REFERENCES  Ocena(idOcena),
	adresTymcz INTEGER REFERENCES Adres(idAdres),
	adresStaly INTEGER NOT NULL REFERENCES Adres(idAdres),
	adresKorespondencji INTEGER NOT NULL REFERENCES Adres(idAdres),
	imie VARCHAR(30) NOT NULL,
	nazwisko VARCHAR(30) NOT NULL,
	czyDostepny BIT NOT NULL
);

CREATE TABLE Rodzaj_samochodu (
	idRodzaj_samochodu INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	marka VARCHAR(30) NOT NULL,
	model VARCHAR(30) NOT NULL,
	iloscMiejsc INT NOT NULL,
	cenaZaKm DECIMAL(4,2) NOT NULL,
);

CREATE TABLE Egzemplarz (
	idKierowca INTEGER NOT NULL REFERENCES Kierowca(idKierowca),
	idRodzaj_samochodu INTEGER NOT NULL REFERENCES Rodzaj_samochodu(idRodzaj_samochodu),
	unikalnyNr INTEGER NOT NULL UNIQUE CHECK(unikalnyNr<1000),
	kolor VARCHAR(30) NOT NULL,
	ocenaSamoch DECIMAL(3,2) NOT NULL DEFAULT 0.00 CHECK(ocenaSamoch<=5.00),
	PRIMARY KEY (idKierowca,idRodzaj_samochodu)
);

CREATE TABLE Oplata (
	idOplata INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	formaPlatnosci VARCHAR(30) NOT NULL,
	oplataDodatk DECIMAL(3,2) NOT NULL
);

CREATE TABLE Taryfa (
	idTaryfa INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	nazwa VARCHAR(30) NOT NULL,
	wysokoscTaryfy DECIMAL(4,2) NOT NULL
);

CREATE TABLE Kurs (
	idKurs INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	idOplata INTEGER NOT NULL REFERENCES Oplata(idOplata),
	idTaryfa INTEGER NOT NULL REFERENCES Taryfa(idTaryfa),
	idKierowca INTEGER NOT NULL REFERENCES Kierowca(idKierowca),
	idKlient INTEGER NOT NULL REFERENCES Klient(idKlient),
	lokalizacjaKonc INTEGER NOT NULL REFERENCES Adres(idAdres),
	lokalizacjaPocz INTEGER NOT NULL REFERENCES Adres(idAdres),
	dataKursu DATE NOT NULL,
	godzinaPocz TIME(0)NOT NULL,
	godzinaKonc TIME(0) NOT NULL,
	ocenaPrzejazdu DECIMAL(3,2) NOT NULL,
	komentarzPrzejazdu VARCHAR(200),
	lacznaOplata DECIMAL(19,2) NOT NULL
);

CREATE TABLE Historia (
	idHistoria INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
	idKurs INTEGER NOT NULL REFERENCES Kurs(idKurs),
	idKierowca INTEGER NOT NULL REFERENCES Kierowca(idKierowca),
	idKlient INTEGER NOT NULL REFERENCES Klient(idKlient),
	opis VARCHAR (500),
);

-- 0B) WYPELNIANIE TABEL DANYMI

INSERT INTO Adres(miejscowosc, ulica, nr_domu, nr_mieszkania, kod) VALUES('Koszalin','krawiecka', 12, 4,'60-323');

INSERT INTO Adres(miejscowosc, ulica, nr_domu, nr_mieszkania, kod) VALUES('Kraków','stanis³awska', 10, 5,'80-549');

INSERT INTO Adres(miejscowosc, ulica, nr_domu, nr_mieszkania, kod) VALUES('Bytom','piekarniana', 5, 5,'93-543');

INSERT INTO Adres(miejscowosc, ulica, nr_domu, nr_mieszkania, kod) VALUES('Bydgoszcz','d¹browszczaków', 23, 8,'43-432');

INSERT INTO Adres(miejscowosc, ulica, nr_domu, nr_mieszkania, kod) VALUES('Mor¹g','krynicka', 44, 9,'87-654');


INSERT INTO Znizka(nazwa, procentRabatu) VALUES('Studencka', 51);

INSERT INTO Znizka(nazwa, procentRabatu) VALUES('Seniorska' , 51);

INSERT INTO Znizka(nazwa, procentRabatu) VALUES('Szkolna', 23 );

INSERT INTO Znizka(nazwa, procentRabatu) VALUES('Dla polityków',100);

INSERT INTO Znizka(nazwa, procentRabatu) VALUES('Dla weteranów', 100);


INSERT INTO Ocena(ocenaKierowcy, podwyzkaProcent) VALUES(5.0 , 30);

INSERT INTO Ocena(ocenaKierowcy, podwyzkaProcent) VALUES(4.5 , 25);

INSERT INTO Ocena(ocenaKierowcy, podwyzkaProcent) VALUES(4.0 , 20);

INSERT INTO Ocena(ocenaKierowcy, podwyzkaProcent) VALUES( 3.5, 15);

INSERT INTO Ocena(ocenaKierowcy, podwyzkaProcent) VALUES(3.0 , 0);


INSERT INTO Klient(Adres3, Adres2, Adres1, idZnizka, imie, nazwisko, dataUrodzenia) VALUES(1,3, NULL, 2, 'Kamil','£ukaszczyk', '2003-10-11');

INSERT INTO Klient(Adres3, Adres2, Adres1, idZnizka, imie, nazwisko, dataUrodzenia) VALUES(2,1, 2, 3, 'Pawel','D¹browszczak', '1990-12-03');

INSERT INTO Klient(Adres3, Adres2, Adres1, idZnizka, imie, nazwisko, dataUrodzenia) VALUES(4,4,3,1, 'Tomasz', 'Prawda', '1963-05-03');

INSERT INTO Klient(Adres3, Adres2, Adres1, idZnizka, imie, nazwisko, dataUrodzenia) VALUES(1, 2, 2, NULL, 'Karol', 'Niezgoda', '1999-05-12');

INSERT INTO Klient(Adres3, Adres2, Adres1, idZnizka, imie, nazwisko, dataUrodzenia) VALUES(3,1,2, NULL, 'Stefan','Paprotka', '1997-02-01');


INSERT INTO Kierowca(idOcena, adresTymcz, adresStaly, adresKorespondencji, imie, nazwisko, czyDostepny) VALUES(1,2,3,4,'Wojtek', 'Marchewa',0);

INSERT INTO Kierowca(idOcena, adresTymcz, adresStaly, adresKorespondencji, imie, nazwisko, czyDostepny) VALUES(4,3,2,1,'Mateusz', 'Dymba³a',1);

INSERT INTO Kierowca(idOcena, adresTymcz, adresStaly, adresKorespondencji, imie, nazwisko, czyDostepny) VALUES(2,3,1,4,'Dominik', 'Kapustnik',1);

INSERT INTO Kierowca(idOcena, adresTymcz, adresStaly, adresKorespondencji, imie, nazwisko, czyDostepny) VALUES(1,3,3,2,'Darek', 'Kulak',0);

INSERT INTO Kierowca(idOcena, adresTymcz, adresStaly, adresKorespondencji, imie, nazwisko, czyDostepny) VALUES(3,4,1,2,'Miko³aj', 'Orze³',1);

INSERT INTO Kierowca(idOcena, adresTymcz, adresStaly, adresKorespondencji, imie, nazwisko, czyDostepny) VALUES(5,1,3,2,'Mateusz', 'Kowalski',0);


INSERT INTO Rodzaj_samochodu(marka, model, iloscMiejsc, cenaZaKm) VALUES('toyota', 'corolla',5, 2.30);

INSERT INTO Rodzaj_samochodu(marka, model, iloscMiejsc, cenaZaKm) VALUES('volkswagen', 'beetle',5, 1.50);

INSERT INTO Rodzaj_samochodu(marka, model, iloscMiejsc, cenaZaKm) VALUES('ford', 'f-series',5, 1.80);

INSERT INTO Rodzaj_samochodu(marka, model, iloscMiejsc, cenaZaKm) VALUES('honda', 'acord',5, 3.20);

INSERT INTO Rodzaj_samochodu(marka, model, iloscMiejsc, cenaZaKm) VALUES('honda', 'civic',5, 5.50);


INSERT INTO Egzemplarz(idKierowca,idRodzaj_samochodu,unikalnyNr, kolor, ocenaSamoch) VALUES(2,5,512,'niebieski',3.79);

INSERT INTO Egzemplarz(idKierowca,idRodzaj_samochodu,unikalnyNr, kolor, ocenaSamoch) VALUES(3,1,356,'czerwony',4.89);

INSERT INTO Egzemplarz(idKierowca,idRodzaj_samochodu,unikalnyNr, kolor, ocenaSamoch) VALUES(1,2,198,'zolty',3.66);

INSERT INTO Egzemplarz(idKierowca,idRodzaj_samochodu,unikalnyNr, kolor, ocenaSamoch) VALUES(5,3,25,'niebieski',4.55);

INSERT INTO Egzemplarz(idKierowca,idRodzaj_samochodu,unikalnyNr, kolor, ocenaSamoch) VALUES(4,4,199,'czarny',4.65);


INSERT INTO Oplata(formaPlatnosci,oplataDodatk) VALUES('Karta debetowa',0.00);

INSERT INTO Oplata(formaPlatnosci,oplataDodatk) VALUES('Karta kredytowa',0.00);

INSERT INTO Oplata(formaPlatnosci,oplataDodatk) VALUES('PayPal',0.00);

INSERT INTO Oplata(formaPlatnosci,oplataDodatk) VALUES('Gotowka',5.00);

INSERT INTO Oplata(formaPlatnosci,oplataDodatk) VALUES('PaySafeCard',2.50);


INSERT INTO Taryfa(nazwa,wysokoscTaryfy) VALUES('nocna',3.50);

INSERT INTO Taryfa(nazwa,wysokoscTaryfy) VALUES('weekendowa',5.50);

INSERT INTO Taryfa(nazwa,wysokoscTaryfy) VALUES('zwykla',0.00);

INSERT INTO Taryfa(nazwa,wysokoscTaryfy) VALUES('dodatkowy bagaz',8.20);

INSERT INTO Taryfa(nazwa,wysokoscTaryfy) VALUES('zwierze domowe',10.50);


INSERT INTO Kurs(idOplata,idTaryfa,idKierowca,idKlient,lokalizacjaKonc,lokalizacjaPocz,dataKursu,godzinaPocz,godzinaKonc,ocenaPrzejazdu,komentarzPrzejazdu,lacznaOplata)
VALUES(2,3,4,1,4,5,'2019-02-14','16:24:35','16:39:35',5.00,'Wszystko ok',13.50);

INSERT INTO Kurs(idOplata,idTaryfa,idKierowca,idKlient,lokalizacjaKonc,lokalizacjaPocz,dataKursu,godzinaPocz,godzinaKonc,ocenaPrzejazdu,komentarzPrzejazdu,lacznaOplata)
VALUES(4,1,2,3,5,4,'2019-04-11','12:54:15','13:13:39',3.50,'Malo rozmowny kierowca',20.10);

INSERT INTO Kurs(idOplata,idTaryfa,idKierowca,idKlient,lokalizacjaKonc,lokalizacjaPocz,dataKursu,godzinaPocz,godzinaKonc,ocenaPrzejazdu,komentarzPrzejazdu,lacznaOplata)
VALUES(1,5,4,2,2,1,'2019-10-25','20:28:15','20:39:31',4.50,NULL,15.90);

INSERT INTO Kurs(idOplata,idTaryfa,idKierowca,idKlient,lokalizacjaKonc,lokalizacjaPocz,dataKursu,godzinaPocz,godzinaKonc,ocenaPrzejazdu,komentarzPrzejazdu,lacznaOplata)
VALUES(5,1,1,4,3,5,'2019-12-14','09:28:31','10:02:20',2.50,'Kierowca pomylil droge',25.50);

INSERT INTO Kurs(idOplata,idTaryfa,idKierowca,idKlient,lokalizacjaKonc,lokalizacjaPocz,dataKursu,godzinaPocz,godzinaKonc,ocenaPrzejazdu,komentarzPrzejazdu,lacznaOplata)
VALUES(2,1,2,5,3,1,'2019-12-24','21:23:30','21:30:24',5.00,'Szybki transport',13.00);


INSERT INTO Historia(idKurs,idKierowca,idKlient,opis) VALUES(2,2,3,'Neutralny');

INSERT INTO Historia(idKurs,idKierowca,idKlient,opis) VALUES(1,4,1,'Pozytywny');

INSERT INTO Historia(idKurs,idKierowca,idKlient,opis) VALUES(3,1,4,'Pozytywny');

INSERT INTO Historia(idKurs,idKierowca,idKlient,opis) VALUES(5,2,5,'Pozytywny');

INSERT INTO Historia(idKurs,idKierowca,idKlient,opis) VALUES(4,1,4,'Zwrot');

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1A) Tworzymy widok (z³aczenia, having)

-- utworzenie widoku u¿ytkowników, którzy zap³acili za ostatni kurs mniej ni¿ 20 z³.
-- wyœwietlenie pe³noletnich u¿ytkowników u¿ywaj¹c widoku

IF OBJECT_ID('mniejNiz20') IS NOT NULL
    DROP VIEW mniejNiz20
GO

CREATE VIEW mniejNiz20 AS
SELECT k.idKlient,k.imie, k.nazwisko, k.dataUrodzenia, ku.lacznaOplata, COALESCE(ku.komentarzPrzejazdu,'brak komentarza') AS 'komentarzPrzejazdu', ke.imie AS 'imieKierowcy', ke.nazwisko AS 'nazwiskoKierowcy',a.miejscowosc AS 'lokPocz', ad.miejscowosc AS 'lokKonc'
FROM Klient k JOIN Kurs ku ON k.idKlient=ku.idKlient
JOIN Kierowca ke ON ku.idKierowca=ke.idKierowca 
JOIN Adres a ON a.idAdres=ku.lokalizacjaPocz JOIN Adres ad ON ad.idAdres=ku.lokalizacjaKonc
GROUP BY k.idKlient,k.nazwisko, k.imie, k.dataUrodzenia, ku.lacznaOplata, ku.komentarzPrzejazdu, ke.imie, ke.nazwisko, a.miejscowosc, ad.miejscowosc
HAVING ku.lacznaOplata<20.00;
GO 

-- 1B) Sprawdzenie, ¿e widok dzia³a


SELECT * from mniejNiz20 WHERE dataUrodzenia<=(SELECT DATEADD(YEAR,-18,GETDATE()));  


-- 2A) Tworzymy funkcjê 1 (IF EXISTS ELSE)

-- utworzenie funkcji wypisuj¹cej rodzaj zni¿ki przypisanej do danego klienta
-- do funkcji podajemy imiê i nazwisko u¿ytkownika
-- gdy do u¿ytkownika nie jest przypisana ¿adna zni¿ka funkcja wypisze: "brak zni¿ki"


IF (OBJECT_ID('jakaPrzyslugujeZnizka') IS NOT NULL) DROP FUNCTION jakaPrzyslugujeZnizka;
GO

CREATE FUNCTION jakaPrzyslugujeZnizka(@imie AS VARCHAR(80), @nazwisko AS VARCHAR(80)) 
RETURNS VARCHAR(80)
AS
BEGIN
	DECLARE @nazwa VARCHAR(80)
	
	IF EXISTS(SELECT idKlient FROM Klient WHERE imie=@imie AND nazwisko=@nazwisko) BEGIN
		IF EXISTS (SELECT idZnizka FROM Klient WHERE imie=@imie AND nazwisko=@nazwisko) 
		BEGIN SET @nazwa=(SELECT z.nazwa FROM Znizka z LEFT JOIN Klient k ON k.idZnizka=z.idZnizka WHERE k.imie=@imie AND k.nazwisko=@nazwisko) END
		SET @nazwa=COALESCE(@nazwa,'brak zni¿ki') 
		END
	ELSE SET @nazwa='nie ma takiej osoby w bazie danych'
	
	RETURN @nazwa
END;
GO

-- 2B) Sprawdzamy, ¿e funkcja 1. dzia³a

SELECT dbo.jakaPrzyslugujeZnizka('Karol','Niezgoda') AS nazwaZnizki


-- 3A) Tworzymy funkcjê 2

-- utworzenie funkcji powiadamiaj¹cej o aktywnych samochodach o ocenie wiêkszej od podanej przez u¿ytkownika
-- funkcja informuje tak¿e o kierowcy prowadz¹cym dany pojazd
-- w przypadku braku aktywnych samochodach mieszcz¹cych siê w kryteriach funkcja wypisze: "brak aktywnych pojazdów"

 
 IF (OBJECT_ID('dostepnoscSamochodu') IS NOT NULL) DROP FUNCTION dostepnoscSamochodu;
GO

CREATE FUNCTION dostepnoscSamochodu(@ocena DECIMAL(3,2))
RETURNS TABLE AS 

	RETURN (SELECT rs.marka,rs.model,e.kolor,e.ocenaSamoch,rs.cenaZaKm,k.imie AS 'imieKierowcy',k.nazwisko AS 'nazwiskoKierowcy' FROM Rodzaj_samochodu rs JOIN Egzemplarz e ON rs.idRodzaj_samochodu=e.idRodzaj_samochodu
	JOIN Kierowca k ON k.idKierowca=e.idKierowca WHERE e.ocenaSamoch>=@ocena AND k.czyDostepny=1) 

GO

-- 3B) Sprawdzenie, ¿e funkcja 2. dzia³a

SELECT * FROM dbo.dostepnoscSamochodu(4.5)

-- 4A) Tworzymy procedurê 1 (WHILE, IF-ELSE)

-- procedura zwiêksza (lub zmniejsza po podaniu liczby ujemnej) procent podwy¿ki za ocenê kierowcy
-- po zmianie podwy¿ka nie mo¿e przekraczaæ 100 i nie mo¿e byæ ni¿sza ni¿ 0

IF EXISTS(SELECT * FROM sys.objects WHERE type='P' AND name='zmianaPodwyzki') DROP PROC zmianaPodwyzki;
GO

CREATE PROC zmianaPodwyzki @wzrost INT 
AS
BEGIN
DECLARE @x INT
SET @x=0
WHILE (@x<(SELECT COUNT(idOcena) FROM Ocena))
BEGIN
	SET @x+=1
	  IF((SELECT podwyzkaProcent FROM Ocena WHERE idOcena=@x)+@wzrost<=100) BEGIN
		UPDATE Ocena
		SET podwyzkaProcent+=@wzrost WHERE idOcena=@x
		PRINT 'Zmieniono procent podwy¿ki'
	  END
	  ELSE PRINT 'Nie zmieniono procentu podwy¿ki (limit 100%)' 
END 

END;
GO

-- 4B) Sprawdzenie, ¿e procedura 1. dzia³a

EXEC zmianaPodwyzki 5;

-- 5A) Tworzymy procedurê 2

-- procedura pozwala kierowcy na aktualizacje jednego z 3 adresów (tymczasowy, sta³y, korespondencji)
-- w pierwszej kolejnoœci podajemy cyfrê odpowiadaj¹c¹ danemu adresowi: 
--   - tymczasowy - 1
--   - sta³y - 2
--   - korespondencji - 3
-- druga podawana dana to ID kierowcy

IF EXISTS(SELECT * FROM sys.objects WHERE type='P' AND name='aktuAd') DROP PROC aktuAd;
GO

CREATE PROC aktuAd @jakiAd INT, @idK INT, @miej VARCHAR(50), @ul VARCHAR(50), @nrD VARCHAR(50), @nrM INT, @kod VARCHAR(50)
AS
BEGIN 
DECLARE @x INT
SET @x= (SELECT COUNT(idAdres) FROM Adres) +1
INSERT INTO Adres VALUES(@miej,@ul,@nrD,@nrM,@kod)
IF @jakiAd=1 
UPDATE Kierowca SET adresTymcz=@x WHERE idKierowca=@idK
IF @jakiAd=2 
UPDATE Kierowca SET adresStaly=@x WHERE idKierowca=@idK
IF @jakiAd=3 
UPDATE Kierowca SET adresKorespondencji=@x WHERE idKierowca=@idK

SELECT CASE 
WHEN @jakiAd=1 THEN 'Zmieniono adres tymczasowy.'
WHEN @jakiAd=2 THEN 'Zmieniono adres sta³y.'
WHEN @jakiAd=3 THEN 'Zmieniono adres korespondencji.'
ELSE 'Podano z³¹ liczbê!'
END

END;
GO

-- 5B) Sprawdzenie, ¿e procedura 2. dzia³a

EXEC aktuAd 2,3,'Warszawa','D³uga','52A',2,'00-013';
GO
-- 6A) Tworzymy wyzwalacz 1

-- po wprowadzniu danych nowego kursu aktualna ocena kierowcy i jego podwy¿ka zostanie zaktualizowana na bazie oceny przejazdu 
-- przy wprowadzaniu nowego kursu idKierowcy podawane jest jako 3 w kolejnosci, a ocenaPrzejazdu jako 10

IF OBJECT_ID('trg_AktuOcena') IS NOT NULL DROP TRIGGER trg_AktuOcena;
GO

CREATE TRIGGER trg_AktuOcena ON Kurs FOR INSERT
AS 
BEGIN
DECLARE @oc DECIMAL(3,2)
DECLARE @id INT
SET @id = (SELECT idKierowca FROM inserted)
SET @oc = (SELECT ocenaPrzejazdu FROM inserted)
IF (@oc = (SELECT ocenaKierowcy FROM Ocena WHERE idOcena=1)) UPDATE Kierowca SET idOcena=1 WHERE idKierowca=@id  --kiedy ocena=5.0
IF (@oc = (SELECT ocenaKierowcy FROM Ocena WHERE idOcena=2)) UPDATE Kierowca SET idOcena=2 WHERE idKierowca=@id  --kiedy ocena=4.5
IF (@oc = (SELECT ocenaKierowcy FROM Ocena WHERE idOcena=3)) UPDATE Kierowca SET idOcena=3 WHERE idKierowca=@id  --kiedy ocena=4.0
IF (@oc = (SELECT ocenaKierowcy FROM Ocena WHERE idOcena=4)) UPDATE Kierowca SET idOcena=4 WHERE idKierowca=@id  --kiedy ocena=3.5
IF (@oc <= (SELECT ocenaKierowcy FROM Ocena WHERE idOcena=5)) UPDATE Kierowca SET idOcena=5 WHERE idKierowca=@id  --brak podwyzki za ocene mniejsza niz 3.5
END
GO

-- 6B) Sprawdzenie, ¿e wyzwalacz 1. dzia³a

INSERT INTO Kurs VALUES (3,1,1,5,1,3,GETDATE(),'13:56','14:10',4.00,'W porz¹dku',15.35);
SELECT k.idKierowca,k.imie,k.nazwisko,o.idOcena,o.ocenaKierowcy,o.podwyzkaProcent FROM Kierowca k JOIN Ocena o ON k.idOcena=o.idOcena;
GO

-- 7A) Tworzymy wyzwalacz 2

-- po dodaniu nowego kursu u¿ytkownikowi przedstawia siê podsumowanie przejazdu w formie pisemnej

IF OBJECT_ID('trg_podsumowanie') IS NOT NULL DROP TRIGGER trg_podsumowanie;
GO

CREATE TRIGGER trg_podsumowanie ON Kurs FOR INSERT
AS
BEGIN
--DECLARE @czasLaczny TIME
DECLARE @gP VARCHAR(50)
DECLARE @idKlien INT
DECLARE @idK INT
DECLARE @imieK VARCHAR(30)
DECLARE @nazwK VARCHAR(50) 
DECLARE @lokP INT
DECLARE @lokK INT
DECLARE @miejscP VARCHAR(80)
DECLARE @miejscK VARCHAR(80)
DECLARE @ulP VARCHAR(80)
DECLARE @ulK VARCHAR(80) 
DECLARE @nrDP VARCHAR(10)
DECLARE @nrDK VARCHAR(10)
DECLARE @date VARCHAR(50)
DECLARE @oc VARCHAR(10)
DECLARE @suma VARCHAR(10)
DECLARE @pods VARCHAR(500)
DECLARE @kom VARCHAR(300)
DECLARE @idKur INT

--SET @czasLaczny = TIMEDIFF((SELECT godzinaKonc FROM inserted),(SELECT godzinaPocz FROM inserted))
SET @gP = CONVERT(VARCHAR,(SELECT godzinaPocz FROM inserted))
SET @date = CONVERT(VARCHAR,(SELECT dataKursu FROM inserted))
SET @idK = (SELECT idKierowca FROM inserted)

SET @lokP = (SELECT lokalizacjaPocz FROM inserted)
SET @miejscP = (SELECT miejscowosc FROM Adres WHERE idAdres=@lokP)
SET @ulP = (SELECT ulica FROM Adres WHERE idAdres=@lokP)
SET @nrDP = (SELECT nr_domu FROM Adres WHERE idAdres=@lokP)

SET @lokK = (SELECT lokalizacjaKonc FROM inserted)
SET @miejscK = (SELECT miejscowosc FROM Adres WHERE idAdres=@lokK)
SET @ulK = (SELECT ulica FROM Adres WHERE idAdres=@lokK)
SET @nrDK = (SELECT nr_domu FROM Adres WHERE idAdres=@lokK)

SET @imieK = (SELECT imie FROM Kierowca WHERE idKierowca=@idK)
SET @nazwK = (SELECT nazwisko FROM Kierowca WHERE idKierowca=@idK)

SET @kom = (SELECT komentarzPrzejazdu FROM inserted)
SET @oc = (SELECT ocenaPrzejazdu FROM inserted)
SET @suma = (SELECT lacznaOplata FROM inserted)

SET @pods = 'Przejazd z '+@miejscP+' ul. '+@ulP+' '+@nrDP+' do '+@miejscK+' ul. '+@ulK+' '+@nrDK+' dnia '+@date+' o godzinie '+@gP+' . Samochód prowadzi³ '+@imieK+' '+@nazwK+' . Przejazd kosztowa³: '+@suma+' z³. Twoja ocena przejazdu: '+@oc+' . Twój komentarz do przejazdu: '+@kom


SET @idKur = (SELECT COUNT(idKurs) FROM Kurs)
SET @idKlien = (SELECT idKlient FROM inserted)

INSERT INTO Historia VALUES(@idKur,@idK,@idKlien,@pods)

END; 
GO 

-- 7B) Sprawdzenie, ¿e wyzwalacz 2. dzia³a

INSERT INTO Kurs VALUES (2,4,1,3,4,3,GETDATE(),'15:56','16:10',5.00,'Wszystko OK. Szybki kierowca. Polecam!',18.65);
INSERT INTO Kurs VALUES (1,2,4,2,1,5,GETDATE(),'18:46','19:09',4.00,'W porz¹dku',25.15);

SELECT * FROM Historia;


-- 8A) Tworzymy wyzwalacz 3

-- po usuniêciu kierowcy wyœwietli siê wiadomoœæ z jego id, imieniem i nazwiskiem

IF OBJECT_ID('trg_del_kierowca') IS NOT NULL DROP TRIGGER trg_del_kierowca; 
GO

CREATE TRIGGER trg_del_kierowca ON Kierowca FOR DELETE
AS
BEGIN
DECLARE
kur_del_kierowca CURSOR
FOR SELECT imie, nazwisko, idKierowca FROM deleted;
OPEN kur_del_kierowca
DECLARE @imie VARCHAR(30), @nazwisko VARCHAR(30), @id INT
FETCH NEXT FROM kur_del_kierowca INTO @imie, @nazwisko, @id
WHILE @@FETCH_STATUS = 0
BEGIN
PRINT 'Usuniêto kierowcê: ' + @imie + ' ' + @nazwisko + ' o ID = ' + CONVERT(VARCHAR(5),@id)
FETCH NEXT FROM kur_del_kierowca INTO @imie, @nazwisko,@id
END
CLOSE kur_del_kierowca
DEALLOCATE kur_del_kierowca
END
GO

-- 8B) Sprawdzenie, ¿e wyzwalacz 3. dzia³a

SELECT * FROM Kierowca;
DELETE FROM Kierowca WHERE idKierowca=6;
SELECT * FROM Kierowca;


-- 9A) Tworzymy wyzwalacz 4

-- wyzwalacz sprawdza komentarz klienta do przejazdu w  poszukiwaniu niecenzuralnych wyrazów
-- jeœli taki napotka - cenzuruje go
-- jeœli nie - nie zmienia treœci komentarza


IF OBJECT_ID('trg_cenzura') IS NOT NULL DROP TRIGGER trg_cenzura; 
GO

CREATE TRIGGER trg_cenzura ON Kurs INSTEAD OF INSERT
AS
BEGIN

DECLARE @cenz VARCHAR(300)

DECLARE @idOplata INT
DECLARE @idTaryfa INT
DECLARE @idKierowca INT
DECLARE @idKlient INT
DECLARE @lokPocz INT
DECLARE @lokKonc INT
DECLARE @data DATE
DECLARE @gP TIME(0)
DECLARE @gK TIME(0)
DECLARE @ocena DECIMAL(3,2)
DECLARE @kom VARCHAR (300)
DECLARE @oplata DECIMAL(19,2)

SELECT @idOplata = idOplata FROM inserted
SELECT @idTaryfa = idTaryfa FROM inserted
SELECT @idKierowca = idKierowca FROM inserted
SELECT @idKlient = idKlient FROM inserted
SELECT @lokPocz = lokalizacjaPocz FROM inserted
SELECT @lokKonc = lokalizacjaKonc FROM inserted
SELECT @data = dataKursu FROM inserted
SELECT @gP = godzinaPocz FROM inserted
SELECT @gK = godzinaKonc FROM inserted
SELECT @ocena = ocenaPrzejazdu FROM inserted
SELECT @kom = komentarzPrzejazdu FROM inserted
SELECT @oplata = lacznaOplata FROM inserted

IF EXISTS(SELECT komentarzPrzejazdu FROM inserted WHERE komentarzPrzejazdu LIKE '%G³upi%') BEGIN
SELECT @cenz = REPLACE(@kom,'³up','*****') 
INSERT INTO Kurs VALUES(@idOplata,@idTaryfa,@idKierowca,@idKlient,@lokKonc,@lokPocz,@data,@gP,@gK,@ocena,@cenz,@oplata)
END
ELSE INSERT INTO Kurs VALUES(@idOplata,@idTaryfa,@idKierowca,@idKlient,@lokKonc,@lokPocz,@data,@gP,@gK,@ocena,@kom,@oplata)

END 
GO

-- 9B) Sprawdzenie, ¿e wyzwalacz 4. dzia³a

INSERT INTO Kurs VALUES (1,3,3,2,1,5,GETDATE(),'21:56','22:10',2.00,'G³upi kierowca.',14.65);
INSERT INTO Kurs VALUES (2,4,2,1,5,2,GETDATE(),'23:56','00:16',3.50,'Dziwny zapach w samochodzie.',19.65);
SELECT * FROM Kurs;
SELECT * FROM Historia;

-- 10A) Tworzymy tabelê przestawn¹

-- zestawia w tabeli nazwiska klientów, ID kierowców oraz pieni¹dze wydane na danego kierowcê przez klienta
-- pivot pozwala zobaczyæ ³¹czn¹ kwotê jak¹ klient przeznaczy³ na danego kierowcê
-- pozwoli to klientowi na ³atwiejszy wybór miêdzy kierowcami na jego przysz³e przejazdy

IF OBJECT_ID('wydatki') IS NOT NULL DROP TABLE wydatki
SELECT ku.idKierowca,k.idKlient, k.nazwisko AS 'NazwiskoKlienta', ku.lacznaOplata INTO wydatki FROM Kurs ku JOIN Klient k ON k.idKlient=ku.idKlient ORDER BY k.idKlient; 

SELECT * FROM wydatki

SELECT * FROM wydatki PIVOT
(
SUM(lacznaOplata)
FOR idKierowca
IN ([1],[2],[3],[4],[5])
)PIV;   