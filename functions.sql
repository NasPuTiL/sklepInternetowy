select * from pracownik;
--DROP FUNCTION getSex;
CREATE FUNCTION getSex(@rand int)
RETURNS varchar(1) AS
BEGIN
	DECLARE @sex CHAR = '-';
	IF (@rand) > 5
		SET @sex = 'M';
	ELSE
		SET @sex = 'K';
	RETURN @sex;
END

--CREATE FUNCTION createRandomDate()
CREATE FUNCTION createRandomDate(@randVal int)
RETURNS date AS
BEGIN
	DECLARE @year int = @randVal * (2020 - 2006 + 1)+ 2006;
	DECLARE @month int = @randVal * (11 - 1 + 1)+ 1;
	DECLARE @day int = @randVal * (28 - 1 + 1)+ 1;
	DECLARE @dt varchar(15);
		if(@day < 10)
			if(@month < 10)
				SET @dt = CONCAT(@year, '0', @month, '0',@day)
			else
				SET @dt = CONCAT(@year, @month, '0',@day)
		else
			if(@month < 10)
				SET @dt = CONCAT(@year, '0', @month, @day)
			else
				SET @dt = CONCAT(@year, @month, @day)
	DECLARE @date date = DATEADD(month, 1, @dt)
	return @date;
END

drop function generateAgriment;
CREATE FUNCTION generateAgriment(@randVal int)
RETURNS varchar(20) AS
BEGIN
	if(@randVal = 0)
		return 'czas nieokreœlony';
	else if(@randVal = 1)
		return 'czas okreœlony';
	else
		return 'okres próbny';
return '';
END
dbo.generateAgriment();


drop function getCategory;
CREATE FUNCTION getCategory(@ctry int)
RETURNS varchar(20) AS
BEGIN
	if(@ctry = 0)	
		return 'ELEKTRONIKA';
	if(@ctry = 1)	
		return 'MODA';
	if(@ctry = 2)	
		return 'DOM I OGROD';
	if(@ctry = 3)	
		return 'SUPERMARKET';
	if(@ctry = 4)	
		return 'DZIECKO';
	if(@ctry = 5)	
		return 'URODA';
	if(@ctry = 6)	
		return 'ZDROWIE';
	if(@ctry = 7)	
		return 'KULTURA';
	if(@ctry = 8)	
		return 'SPORT';
	return '-';
END

DROP FUNCTION getStorage;
CREATE FUNCTION getStorage(@idp int, @idd int,@p int, @pSufix varchar(1))
RETURNS varchar(20) AS
BEGIN
	return CONCAT(@idp, '-', @idd, '-',@p, @pSufix);
END