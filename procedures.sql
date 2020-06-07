--delete from klient;
--select * from klient;
DROP PROCEDURE set_Klient;
CREATE PROCEDURE set_Klient AS
DECLARE @counter INT = 101;
WHILE @counter <= 200
	BEGIN
	INSERT INTO klient (numer_klienta, nazwa_klienta)
		 VALUES(@counter, 'Andrzej Testowy_KLIENT_' + CAST(@counter as varchar(10)))

	SET @counter = @counter + 1;
END;
EXEC set_Klient;
select  COUNT(*) from klient k2 ;

SELECT * FROM pracownik;
--DELETE from pracownik;
--DROP PROCEDURE set_Pracownik;
CREATE PROCEDURE set_Pracownik AS
DECLARE @counter INT = 1;
WHILE @counter <= 100
	BEGIN
	DECLARE @sex varchar(1) = dbo.getSex(RAND() * 10);
	INSERT INTO pracownik (id_pracownika, imie, nazwisko, p³ec, adres, data_rozpoczêcia_pracy)
		 VALUES(@counter, 'Andrzej', 'Pracownik_' + CAST(@counter as varchar(10)), @sex, 'Wspanailego Andrzeja '+ CAST(@counter as varchar(10)), dbo.createRandomDate(RAND()));
	SET @counter = @counter + 1;
END
EXEC set_Pracownik;
select * from pracownik;
DELETE from pracownik;
 
DROP PROCEDURE set_Umowa;
CREATE PROCEDURE set_Umowa AS
DECLARE @counter INT = 1;
DECLARE @numberOfIterate int = (select count(id_pracownika) from pracownik);
WHILE @counter <= @numberOfIterate
	BEGIN
	DECLARE @skl VARCHAR(50);
	SET @skl = (SELECT TOP 1 nip_firmy from sklep order by NEWID())

	DECLARE @data_rozp date;
	SET @data_rozp = (SELECT TOP 1 data_rozpoczêcia_pracy from pracownik where id_pracownika = @counter);
	DECLARE @data_zak date = DATEADD(year, 5, @data_rozp);
	
	DECLARE @umowa varchar(20) = dbo.generateAgriment(RAND()* 3);
	print @umowa;

	INSERT INTO umowa (numer_umowy, tresc_umowy, rodzaj_umowy, data_rozpoczêcia, data_zakonczenia, pracownik_id_pracownika, sklep_nip_firmy)
		 VALUES(@counter, 'content umowy. Losowy tekst.', @umowa, @data_rozp, @data_zak, @counter, @skl);
	SET @counter = @counter + 1;
END
EXEC set_Umowa;
select * from umowa;
delete from umowa;


DROP PROCEDURE set_Annex;
CREATE PROCEDURE set_Annex AS
SELECT 
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage;  
GO
BEGIN TRY  
DECLARE @counter INT = 1;
WHILE @counter <= 15
	BEGIN

	DECLARE @umowaID int = (SELECT TOP 1 numer_umowy from umowa order by NEWID());
	DECLARE @data_rozp date = (SELECT data_rozpoczêcia from umowa WHERE numer_umowy = @umowaID);

	DECLARE @data_wej date = DATEADD(year, RAND() *4, @data_rozp);
	SET @data_wej = DATEADD(month, RAND() * 10, @data_wej);
	SET @data_wej = DATEADD(day, RAND() * 20, @data_wej);

	INSERT INTO aneks_do_umowy (numer_aneksu, umowa_numer_umowy, data_wejscia_w_zycie, opis_zmiany_stanowiska)
		 VALUES(@counter, @umowaID, @data_wej, 'Curabitur volutpat ante eget mauris convallis.')
	SET @counter = @counter + 1;
END
END TRY  
BEGIN CATCH  
    EXECUTE set_Annex;  
END CATCH;  
EXEC set_Annex;
select * from aneks_do_umowy;


--DROP PROCEDURE set_sklep;
CREATE PROCEDURE set_sklep AS
DECLARE @counter INT = 1;
WHILE @counter <= 1
BEGIN
	DECLARE @nip int = RAND() * 1000000;
	DECLARE @num int = RAND() * 200;
	INSERT INTO sklep (nip_firmy, adres, dane_wlasciciela, opinie_klientow)
		 VALUES( @nip, 'WARSZAWA 00-001 ANRZEJA STRUGA ' + CAST((@counter * 12) as varchar(10)), 'ANDRZEJ WLASCICIEL ' + CAST(@num as varchar(10)), 'POLECAM! SREDNIE..')
	SET @counter = @counter + 1;
END
EXEC set_sklep;
select * from sklep;
DELETE from sklep;


--DROP PROCEDURE set_towar;
CREATE PROCEDURE set_towar AS
DECLARE @counter INT = 1;
WHILE @counter <= 1000
	BEGIN
	DECLARE @randomString  varchar(15) = CONVERT(varchar(255), NEWID())
	DECLARE @desc varchar(5) = CONVERT(varchar(255), NEWID())
	DECLARE @getCategory varchar(20) = dbo.getCategory(RAND() * 8);
	DECLARE @mgz varchar(20) = dbo.getStorage(RAND() * 99, RAND() * 99, RAND() * 9, CONVERT(varchar(255), NEWID()));

	INSERT INTO towar (id_towaru, nazwa, opis, kategoria, cena, lokalizacja_w_magazynie)
		 VALUES(@counter,@randomString, @desc, @getCategory, RAND() * 1000, @mgz)
	SET @counter = @counter + 1;
END
EXEC set_towar;
select * from towar;

--DROP PROCEDURE set_paragon_Faktorura;
CREATE PROCEDURE set_paragon_Faktorura AS
DECLARE @counter INT = 1;
WHILE @counter <= 10
	BEGIN
	INSERT INTO paragon_faktura (numer_paragonu_faktury, dane_sklepu, suma_do_zaplaty, pracownik_id_pracownika, data_sprzedazy, klient_numer_klienta)
		 VALUES(@counter, '----------', RAND() * 1000 , RAND() * 100, DATEADD(day, (ABS(CHECKSUM(NEWID())) % 65530), 0),  RAND() * 100)
	SET @counter = @counter + 1;
END
EXEC set_paragon_Faktorura;


--DROP PROCEDURE set_szczegoly_transakcji;
CREATE PROCEDURE set_szczegoly_transakcji AS
DECLARE @counter INT = 1;
WHILE @counter <= 10
	BEGIN
	DECLARE @towarID int = (SELECT TOP 1 id_towaru from towar order by NEWID());
	DECLARE @quantity int = RAND() * 50;
	INSERT INTO szczegoly_transakcji (towar_id_towaru, ilosc_towaru, numer_paragonu_faktury)
		 VALUES(@towarID, RAND() * 50, @counter)
	SET @counter = @counter + 1;
END
EXEC set_szczegoly_transakcji;

select * from szczegoly_transakcji;




select * from aneks_do_umowy;
select * from klient;
select * from paragon_faktura;
select * from pracownik;
select * from sklep;
select * from szczegoly_transakcji;
select * from towar;
select * from umowa;