CREATE DATABASE [choinki]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'choinki', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\choinki.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'choinki_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\choinki_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [choinki] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [choinki] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [choinki] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [choinki] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [choinki] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [choinki] SET ARITHABORT OFF 
GO
ALTER DATABASE [choinki] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [choinki] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [choinki] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [choinki] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [choinki] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [choinki] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [choinki] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [choinki] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [choinki] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [choinki] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [choinki] SET  DISABLE_BROKER 
GO
ALTER DATABASE [choinki] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [choinki] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [choinki] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [choinki] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [choinki] SET  READ_WRITE 
GO
ALTER DATABASE [choinki] SET RECOVERY FULL 
GO
ALTER DATABASE [choinki] SET  MULTI_USER 
GO
ALTER DATABASE [choinki] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [choinki] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [choinki] SET DELAYED_DURABILITY = DISABLED 
GO
USE [choinki]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = On;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = Primary;
GO
USE [choinki]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [choinki] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO

ALTER DATABASE [choinki] SET RECURSIVE_TRIGGERS OFF WITH NO_WAIT
GO
EXEC sp_configure 'nested triggers', 1;
RECONFIGURE;
go
drop table if exists Magazyn
drop table if exists Stoisko1
drop table if exists Stoisko2
drop table if exists Stoisko3
drop table if exists SprzedazDetal
drop table if exists SprzedazHurt
drop table if exists ChoinkaCenaHistoria
drop table if exists Choinka
drop table if exists Gatunek

--stworzenie bazy
CREATE TABLE Gatunek (
    GatunekID INT PRIMARY KEY IDENTITY(1,1),
    NazwaGatunku VARCHAR(255) NOT NULL
);
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = 'Tabela zawieraj¹ca informacje o gatunkach choinek.', 
    @level0type = N'SCHEMA', @level0name = dbo, 
    @level1type = N'TABLE',  @level1name = 'Gatunek';

CREATE TABLE Choinka (
    ChoinkaID INT PRIMARY KEY IDENTITY(1,1),
    GatunekID INT,
    Wielkosc INT,
    CenaHurtowa DECIMAL(10,2),
    CenaDetaliczna DECIMAL(10,2),
    FOREIGN KEY (GatunekID) REFERENCES Gatunek(GatunekID)
);
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = 'Tabela przechowuj¹ca informacje o dostêpnych choinkach, ich gatunkach, wielkoœciach i cenach.', 
    @level0type = N'SCHEMA', @level0name = dbo, 
    @level1type = N'TABLE',  @level1name = 'Choinka';

CREATE TABLE Magazyn (
    MagazynID INT PRIMARY KEY IDENTITY(1,1),
    Adres VARCHAR(255) NOT NULL,
    ChoinkaID INT,
    Ilosc INT,
    FOREIGN KEY (ChoinkaID) REFERENCES Choinka(ChoinkaID)
);
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = 'Tabela przechowuj¹ca informacje o magazynach oraz przechowywanych w nich choinkach.', 
    @level0type = N'SCHEMA', @level0name = dbo, 
    @level1type = N'TABLE',  @level1name = 'Magazyn';


CREATE TABLE SprzedazDetal (
    SprzedazDetalID INT PRIMARY KEY IDENTITY(1,1),
    ChoinkaID INT,
    Ilosc INT,
    DataSprzedazy DATE,
    FOREIGN KEY (ChoinkaID) REFERENCES Choinka(ChoinkaID)
);
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = 'Tabela rejestruj¹ca informacje o sprzeda¿y detalicznej choinek.', 
    @level0type = N'SCHEMA', @level0name = dbo, 
    @level1type = N'TABLE',  @level1name = 'SprzedazDetal';


CREATE TABLE SprzedazHurt (
    SprzedazHurtID INT PRIMARY KEY IDENTITY(1,1),
    ChoinkaID INT,
    Ilosc INT,
    DataSprzedazy DATE,
    FOREIGN KEY (ChoinkaID) REFERENCES Choinka(ChoinkaID)
);
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = 'Tabela rejestruj¹ca informacje o sprzeda¿y hurtowej choinek.', 
    @level0type = N'SCHEMA', @level0name = dbo, 
    @level1type = N'TABLE',  @level1name = 'SprzedazHurt';

CREATE TABLE Stoisko1 (
    Stoisko1ID INT PRIMARY KEY IDENTITY(1,1),
    TypSprzedazy VARCHAR(255),
    DataSprzedazy DATE,
    Ilosc INT,
    ChoinkaID INT,
    FOREIGN KEY (ChoinkaID) REFERENCES Choinka(ChoinkaID)
);
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = 'Tabela przechowuj¹ca informacje o sprzeda¿y z pierwszego stoiska.', 
    @level0type = N'SCHEMA', @level0name = dbo, 
    @level1type = N'TABLE',  @level1name = 'Stoisko1';

CREATE TABLE Stoisko2 (
    Stoisko2ID INT PRIMARY KEY IDENTITY(1,1),
    TypSprzedazy VARCHAR(255),
    DataSprzedazy DATE,
    Ilosc INT,
    ChoinkaID INT,
    FOREIGN KEY (ChoinkaID) REFERENCES Choinka(ChoinkaID)
);
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = 'Tabela przechowuj¹ca informacje o sprzeda¿y z drugiego stoiska.', 
    @level0type = N'SCHEMA', @level0name = dbo, 
    @level1type = N'TABLE',  @level1name = 'Stoisko2';

CREATE TABLE Stoisko3 (
    Stoisko3ID INT PRIMARY KEY IDENTITY(1,1),
    TypSprzedazy VARCHAR(255),
    DataSprzedazy DATE,
    Ilosc INT,
    ChoinkaID INT,
    FOREIGN KEY (ChoinkaID) REFERENCES Choinka(ChoinkaID)
);
EXEC sp_addextendedproperty 
    @name = N'MS_Description', 
    @value = 'Tabela przechowuj¹ca informacje o sprzeda¿y z trzeciego stoiska.', 
    @level0type = N'SCHEMA', @level0name = dbo, 
    @level1type = N'TABLE',  @level1name = 'Stoisko3';

	CREATE TABLE ChoinkaCenaHistoria (
    CenaHistoriaID INT PRIMARY KEY IDENTITY(1,1),
    ChoinkaID INT,
    StaraCenaHurtowa DECIMAL(10,2),
    NowaCenaHurtowa DECIMAL(10,2),
    StaraCenaDetaliczna DECIMAL(10,2),
    NowaCenaDetaliczna DECIMAL(10,2),
    DataZmiany DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ChoinkaID) REFERENCES Choinka(ChoinkaID)
);

--dodanie modifieddate oraz rowguid do kazdej tabeli
ALTER TABLE Magazyn
ADD
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();

ALTER TABLE Gatunek
ADD
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();

ALTER TABLE Choinka
ADD
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();

ALTER TABLE SprzedazDetal
ADD
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();

ALTER TABLE SprzedazHurt
ADD
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();

ALTER TABLE Stoisko1
ADD
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();

ALTER TABLE Stoisko2
ADD
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();

ALTER TABLE Stoisko3
ADD
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    rowguid UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID();


ALTER TABLE SprzedazDetal
ADD Stoisko INT,
    CalkowitaWartoscZamowienia float;

ALTER TABLE SprzedazHurt
ADD Stoisko INT,
   CalkowitaWartoscZamowienia float;

ALTER TABLE Stoisko1
ADD 
   CalkowitaWartoscZamowienia float;

ALTER TABLE Stoisko2
ADD 
   CalkowitaWartoscZamowienia float;


ALTER TABLE Stoisko3
ADD 
    CalkowitaWartoscZamowienia float;

go

--wyzwalacze

CREATE TRIGGER trg_UpdateGatunekModifiedDate
ON Gatunek
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Gatunek
    SET ModifiedDate = GETDATE()
    FROM Inserted
    WHERE Gatunek.GatunekID = Inserted.GatunekID;
END;
go

CREATE TRIGGER trg_UpdateMagazynModifiedDate
ON Magazyn
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Magazyn
    SET ModifiedDate = GETDATE()
    FROM Inserted
    WHERE Magazyn.MagazynID = Inserted.MagazynID;
END;
go
CREATE or alter TRIGGER trg_UpdateChoinkaModifiedDate
ON Choinka
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Choinka
    SET ModifiedDate = GETDATE()
    FROM Inserted
    WHERE Choinka.ChoinkaID = Inserted.ChoinkaID;
END;
go
CREATE TRIGGER trg_UpdateSprzedazDetalModifiedDate
ON SprzedazDetal
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SprzedazDetal
    SET ModifiedDate = GETDATE()
    FROM Inserted
    WHERE SprzedazDetal.SprzedazDetalID = Inserted.SprzedazDetalID;
END;
go
CREATE TRIGGER trg_UpdateSprzedazHurtModifiedDate
ON SprzedazHurt
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE SprzedazHurt
    SET ModifiedDate = GETDATE()
    FROM Inserted
    WHERE SprzedazHurt.SprzedazHurtID = Inserted.SprzedazHurtID;
END;
go
CREATE TRIGGER trg_UpdateStoisko1ModifiedDate
ON Stoisko1
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Stoisko1
    SET ModifiedDate = GETDATE()
    FROM Inserted
    WHERE Stoisko1.Stoisko1ID = Inserted.Stoisko1ID;
END;
go
CREATE TRIGGER trg_UpdateStoisko2ModifiedDate
ON Stoisko2
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Stoisko2
    SET ModifiedDate = GETDATE()
    FROM Inserted
    WHERE Stoisko2.Stoisko2ID = Inserted.Stoisko2ID;
END;
go
CREATE TRIGGER trg_UpdateStoisko3ModifiedDate
ON Stoisko3
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Stoisko3
    SET ModifiedDate = GETDATE()
    FROM Inserted
    WHERE Stoisko3.Stoisko3ID = Inserted.Stoisko3ID;
END;
go
CREATE TRIGGER trg_UpdateMagazynAfterDetalSale
ON SprzedazDetal
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @choinkaID int, @ilosc int;

    SELECT @choinkaID = ChoinkaID, @ilosc = Ilosc FROM Inserted;

    UPDATE Magazyn
    SET Ilosc = Ilosc - @ilosc
    WHERE ChoinkaID = @choinkaID;
END;
go
CREATE or alter TRIGGER trg_UpdateMagazynAfterHurtSale
ON SprzedazHurt
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @choinkaID int, @ilosc int;

    SELECT @choinkaID = ChoinkaID, @ilosc = Ilosc FROM Inserted;

    UPDATE Magazyn
    SET Ilosc = Ilosc - @ilosc
    WHERE ChoinkaID = @choinkaID;
END;
go
CREATE TRIGGER trg_PreventDeleteOnGatunekIfChoinkaExists
ON Gatunek
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Choinka INNER JOIN Deleted ON Choinka.GatunekID = Deleted.GatunekID)
    BEGIN
        RAISERROR ('Nie mo¿na usun¹æ gatunku, poniewa¿ istniej¹ choinki przypisane do tego gatunku.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Gatunek WHERE GatunekID IN (SELECT GatunekID FROM Deleted);
    END
END;
go
CREATE TRIGGER trg_ChoinkaCenaHistoria
ON Choinka
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(CenaHurtowa) OR UPDATE(CenaDetaliczna)
    BEGIN
        INSERT INTO ChoinkaCenaHistoria (ChoinkaID, StaraCenaHurtowa, NowaCenaHurtowa, StaraCenaDetaliczna, NowaCenaDetaliczna, DataZmiany)
        SELECT i.ChoinkaID, d.CenaHurtowa, i.CenaHurtowa, d.CenaDetaliczna, i.CenaDetaliczna, GETDATE()
        FROM Inserted i
        JOIN Deleted d ON i.ChoinkaID = d.ChoinkaID;
    END
END;
go
CREATE or ALTER TRIGGER trg_AdjustPricesOnUpdate
ON Choinka
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(CenaHurtowa)
    BEGIN
        UPDATE c
        SET c.CenaDetaliczna = i.CenaHurtowa * 1.2 -- Zwiêkszenie o 20%
        FROM Choinka c
        JOIN Inserted i ON c.ChoinkaID = i.ChoinkaID
        WHERE NOT EXISTS(SELECT 1 FROM Deleted d WHERE d.CenaHurtowa = i.CenaHurtowa AND d.ChoinkaID = i.ChoinkaID);
    END

    IF UPDATE(CenaDetaliczna)
    BEGIN
        UPDATE c
        SET c.CenaHurtowa = i.CenaDetaliczna * 0.8 -- Ustawienie ceny na 80% ceny detalicznej
        FROM Choinka c
        JOIN Inserted i ON c.ChoinkaID = i.ChoinkaID
        WHERE NOT EXISTS(SELECT 1 FROM Deleted d WHERE d.CenaDetaliczna = i.CenaDetaliczna AND d.ChoinkaID = i.ChoinkaID);
    END
END;
GO

CREATE TRIGGER trg_PreventDeleteChoinkaIfSold
ON Choinka
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM SprzedazDetal WHERE ChoinkaID IN (SELECT ChoinkaID FROM Deleted))
    OR EXISTS (SELECT 1 FROM SprzedazHurt WHERE ChoinkaID IN (SELECT ChoinkaID FROM Deleted))
    BEGIN
        RAISERROR ('Nie mo¿na usun¹æ choinki, poniewa¿ istniej¹ powi¹zane z ni¹ transakcje sprzeda¿y.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Choinka WHERE ChoinkaID IN (SELECT ChoinkaID FROM Deleted);
    END
END;
go
CREATE TRIGGER AktualizujWartoscZamowieniaStoisko1
ON Stoisko1
AFTER INSERT
AS
BEGIN
    UPDATE Stoisko1
    SET CalkowitaWartoscZamowienia = inserted.Ilosc * (SELECT CenaDetaliczna FROM Choinka WHERE ChoinkaID = inserted.ChoinkaID)
    FROM inserted
    WHERE Stoisko1.Stoisko1ID = inserted.Stoisko1ID
    AND Stoisko1.CalkowitaWartoscZamowienia IS NULL;
END;
go
CREATE TRIGGER AktualizujWartoscZamowieniaStoisko2
ON Stoisko2
AFTER INSERT
AS
BEGIN
    UPDATE Stoisko2
    SET CalkowitaWartoscZamowienia = inserted.Ilosc * (SELECT CenaDetaliczna FROM Choinka WHERE ChoinkaID = inserted.ChoinkaID)
    FROM inserted
    WHERE Stoisko2.Stoisko2ID = inserted.Stoisko2ID
    AND Stoisko2.CalkowitaWartoscZamowienia IS NULL;
END;
go
CREATE TRIGGER AktualizujWartoscZamowieniaStoisko3
ON Stoisko3
AFTER INSERT
AS
BEGIN
    UPDATE Stoisko3
    SET CalkowitaWartoscZamowienia = inserted.Ilosc * (SELECT CenaDetaliczna FROM Choinka WHERE ChoinkaID = inserted.ChoinkaID)
    FROM inserted
    WHERE Stoisko3.Stoisko3ID = inserted.Stoisko3ID
    AND Stoisko3.CalkowitaWartoscZamowienia IS NULL;
END;
go
CREATE TRIGGER DodajSprzedazZStoiska1
ON Stoisko1
AFTER INSERT
AS
BEGIN
    DECLARE @typSprzedazy VARCHAR(255), @choinkaID INT, @ilosc INT, @dataSprzedazy DATE, @stoiskoID INT;

    SELECT @typSprzedazy = TypSprzedazy, @choinkaID = ChoinkaID, @ilosc = Ilosc, @dataSprzedazy = DataSprzedazy, @stoiskoID = Stoisko1ID
    FROM inserted;

    IF @typSprzedazy = 'Detal'
    BEGIN
        INSERT INTO SprzedazDetal (ChoinkaID, Ilosc, DataSprzedazy, Stoisko)
        VALUES (@choinkaID, @ilosc, @dataSprzedazy, 1);
    END
    ELSE IF @typSprzedazy = 'Hurt'
    BEGIN
        INSERT INTO SprzedazHurt (ChoinkaID, Ilosc, DataSprzedazy, Stoisko)
        VALUES (@choinkaID, @ilosc, @dataSprzedazy, 1);
    END
END;
go
CREATE TRIGGER DodajSprzedazZStoiska2
ON Stoisko2
AFTER INSERT
AS
BEGIN
    DECLARE @typSprzedazy VARCHAR(255), @choinkaID INT, @ilosc INT, @dataSprzedazy DATE, @stoiskoID INT;

    SELECT @typSprzedazy = TypSprzedazy, @choinkaID = ChoinkaID, @ilosc = Ilosc, @dataSprzedazy = DataSprzedazy, @stoiskoID = Stoisko2ID
    FROM inserted;

    IF @typSprzedazy = 'Detal'
    BEGIN
        INSERT INTO SprzedazDetal (ChoinkaID, Ilosc, DataSprzedazy, Stoisko)
        VALUES (@choinkaID, @ilosc, @dataSprzedazy, 2);
    END
    ELSE IF @typSprzedazy = 'Hurt'
    BEGIN
        INSERT INTO SprzedazHurt (ChoinkaID, Ilosc, DataSprzedazy, Stoisko)
        VALUES (@choinkaID, @ilosc, @dataSprzedazy, 2);
    END
END;
go
CREATE TRIGGER DodajSprzedazZStoiska3
ON Stoisko3
AFTER INSERT
AS
BEGIN
    DECLARE @typSprzedazy VARCHAR(255), @choinkaID INT, @ilosc INT, @dataSprzedazy DATE, @stoiskoID INT;

    SELECT @typSprzedazy = TypSprzedazy, @choinkaID = ChoinkaID, @ilosc = Ilosc, @dataSprzedazy = DataSprzedazy, @stoiskoID = Stoisko3ID
    FROM inserted;

    IF @typSprzedazy = 'Detal'
    BEGIN
        INSERT INTO SprzedazDetal (ChoinkaID, Ilosc, DataSprzedazy, Stoisko)
        VALUES (@choinkaID, @ilosc, @dataSprzedazy, 3);
    END
    ELSE IF @typSprzedazy = 'Hurt'
    BEGIN
        INSERT INTO SprzedazHurt (ChoinkaID, Ilosc, DataSprzedazy, Stoisko)
        VALUES (@choinkaID, @ilosc, @dataSprzedazy, 3);
    END
END;
go
CREATE TRIGGER AktualizujCalkowitaWartoscZamowieniaDetal
ON SprzedazDetal
AFTER INSERT
AS
BEGIN
    UPDATE SprzedazDetal
    SET CalkowitaWartoscZamowienia = c.CenaDetaliczna * inserted.Ilosc
    FROM inserted
    INNER JOIN Choinka c ON inserted.ChoinkaID = c.ChoinkaID
    WHERE SprzedazDetal.SprzedazDetalID = inserted.SprzedazDetalID;
END;
go
CREATE  TRIGGER AktualizujCalkowitaWartoscZamowieniaHurt
ON SprzedazHurt
AFTER INSERT
AS
BEGIN
    UPDATE SprzedazHurt
    SET CalkowitaWartoscZamowienia = c.CenaHurtowa * inserted.Ilosc
    FROM inserted
    INNER JOIN Choinka c ON inserted.ChoinkaID = c.ChoinkaID
    WHERE SprzedazHurt.SprzedazHurtID = inserted.SprzedazHurtID;
END;
go
--constraints
ALTER TABLE Choinka--sprawdzanie wielkosci choinki 
ADD CONSTRAINT CHK_Choinka_Wielkosc CHECK (Wielkosc > 0 AND Wielkosc <= 300);
ALTER TABLE Choinka--cena wieksza niz 0
ADD CONSTRAINT CHK_Choinka_CenaHurtowa CHECK (CenaHurtowa > 0);

ALTER TABLE Choinka--cena wieksza niz 0
ADD CONSTRAINT CHK_Choinka_CenaDetaliczna CHECK (CenaDetaliczna > 0);
ALTER TABLE SprzedazDetal--ilosc wieksza niz 0
ADD CONSTRAINT CHK_SprzedazDetal_Ilosc CHECK (Ilosc > 0);

ALTER TABLE SprzedazHurt--ilosc wieksza niz 0
ADD CONSTRAINT CHK_SprzedazHurt_Ilosc CHECK (Ilosc > 0);
ALTER TABLE Magazyn--ilosc wieksza badz rowna  0
ADD CONSTRAINT CHK_Magazyn_Ilosc CHECK (Ilosc >= 0);
ALTER TABLE Stoisko1 --ilosc wieksza niz 0
ADD CONSTRAINT CHK_Stoisko1_Ilosc CHECK (Ilosc > 0);

ALTER TABLE Stoisko2 --ilosc wieksza niz 0
ADD CONSTRAINT CHK_Stoisko2_Ilosc CHECK (Ilosc > 0);

ALTER TABLE Stoisko3 --ilosc wieksza niz 0
ADD CONSTRAINT CHK_Stoisko3_Ilosc CHECK (Ilosc > 0);
ALTER TABLE Stoisko1 --typ sprzedazy
ADD CONSTRAINT CHK_Stoisko1_TypSprzedazy CHECK (TypSprzedazy IN ('detal', 'hurt'));

ALTER TABLE Stoisko2 --typ sprzedazy
ADD CONSTRAINT CHK_Stoisko2_TypSprzedazy CHECK (TypSprzedazy IN ('detal', 'hurt'));

ALTER TABLE Stoisko3 --typ sprzedazy
ADD CONSTRAINT CHK_Stoisko3_TypSprzedazy CHECK (TypSprzedazy IN ('detal', 'hurt'));
ALTER TABLE Gatunek--nie pusta nazwa gatunku
ADD CONSTRAINT CHK_Gatunek_NazwaGatunku_NotEmpty CHECK (NazwaGatunku != '');
ALTER TABLE Choinka--cena hurtowa mniejsza niz detaliczna
ADD CONSTRAINT CHK_Choinka_Ceny CHECK (CenaDetaliczna > CenaHurtowa);
ALTER TABLE SprzedazDetal-- niemozliwosc sprzedazy w przyszlosci
ADD CONSTRAINT CHK_SprzedazDetal_DataSprzedazy CHECK (DataSprzedazy <= GETDATE());

ALTER TABLE SprzedazHurt-- niemozliwosc sprzedazy w przyszlosci
ADD CONSTRAINT CHK_SprzedazHurt_DataSprzedazy CHECK (DataSprzedazy <= GETDATE());

ALTER TABLE Stoisko1-- niemozliwosc sprzedazy w przyszlosci
ADD CONSTRAINT CHK_Stoisko1_DataSprzedazy CHECK (DataSprzedazy <= GETDATE());

ALTER TABLE Stoisko2-- niemozliwosc sprzedazy w przyszlosci
ADD CONSTRAINT CHK_Stoisko2_DataSprzedazy CHECK (DataSprzedazy <= GETDATE());

ALTER TABLE Stoisko3-- niemozliwosc sprzedazy w przyszlosci
ADD CONSTRAINT CHK_Stoisko3_DataSprzedazy CHECK (DataSprzedazy <= GETDATE());

ALTER TABLE SprzedazDetal--kaskadowe usuwanie id
ADD CONSTRAINT FK_SprzedazDetal_ChoinkaID
FOREIGN KEY (ChoinkaID) REFERENCES Choinka(ChoinkaID)
ON DELETE CASCADE
ON UPDATE CASCADE;
go

--widoki
CREATE VIEW vw_TotalSalesPerTree AS
SELECT
    c.ChoinkaID,
    g.NazwaGatunku,
    SUM(CASE WHEN sd.ChoinkaID IS NOT NULL THEN sd.Ilosc ELSE 0 END) AS TotalRetail,
    SUM(CASE WHEN sh.ChoinkaID IS NOT NULL THEN sh.Ilosc ELSE 0 END) AS TotalWholesale
FROM
    Choinka c
    LEFT JOIN Gatunek g ON c.GatunekID = g.GatunekID
    LEFT JOIN SprzedazDetal sd ON c.ChoinkaID = sd.ChoinkaID
    LEFT JOIN SprzedazHurt sh ON c.ChoinkaID = sh.ChoinkaID
GROUP BY
    c.ChoinkaID, g.NazwaGatunku;
go
	CREATE VIEW vw_TreeAvailability AS
SELECT
    m.MagazynID,
    m.Adres,
    g.NazwaGatunku,
    c.Wielkosc,
    m.Ilosc AS DostepnaIlosc
FROM
    Magazyn m
    INNER JOIN Choinka c ON m.ChoinkaID = c.ChoinkaID
    INNER JOIN Gatunek g ON c.GatunekID = g.GatunekID;
	go
	CREATE VIEW vw_TreePricing AS
SELECT
    g.NazwaGatunku,
    c.Wielkosc,
    c.CenaHurtowa,
    c.CenaDetaliczna
FROM
    Choinka c
    INNER JOIN Gatunek g ON c.GatunekID = g.GatunekID;
go

CREATE VIEW vw_SalesSummaryByDay AS
SELECT
    DataSprzedazy,
    'Detal' AS TypSprzedazy,
    SUM(Ilosc) AS SumaSprzedazy
FROM
    SprzedazDetal
GROUP BY
    DataSprzedazy
UNION ALL
SELECT
    DataSprzedazy,
    'Hurt' AS TypSprzedazy,
    SUM(Ilosc)
FROM
    SprzedazHurt
GROUP BY
    DataSprzedazy;
go
CREATE VIEW vw_StallDetails AS
SELECT
   
    TypSprzedazy,
    DataSprzedazy,
    Ilosc,
    c.GatunekID,
    g.NazwaGatunku
FROM
    Stoisko1 s1
    JOIN Choinka c ON s1.ChoinkaID = c.ChoinkaID
    JOIN Gatunek g ON c.GatunekID = g.GatunekID
UNION ALL
SELECT
  
    TypSprzedazy,
    DataSprzedazy,
    Ilosc,
    c.GatunekID,
    g.NazwaGatunku
FROM
    Stoisko2
    JOIN Choinka c ON Stoisko2.ChoinkaID = c.ChoinkaID
    JOIN Gatunek g ON c.GatunekID = g.GatunekID
UNION ALL
SELECT
 
    TypSprzedazy,
    DataSprzedazy,
    Ilosc,
    c.GatunekID,
    g.NazwaGatunku
FROM
    Stoisko3
    JOIN Choinka c ON Stoisko3.ChoinkaID = c.ChoinkaID
    JOIN Gatunek g ON c.GatunekID = g.GatunekID;
go
CREATE VIEW vw_TreePricesBySpeciesAndSize AS
SELECT
    g.NazwaGatunku,
    c.Wielkosc,
    AVG(c.CenaDetaliczna) AS SredniaCenaDetaliczna,
    AVG(c.CenaHurtowa) AS SredniaCenaHurtowa
FROM
    Choinka c
    JOIN Gatunek g ON c.GatunekID = g.GatunekID
GROUP BY
    g.NazwaGatunku, c.Wielkosc;
go
CREATE VIEW vw_SalesHistory AS
SELECT
    'Detal' AS TypSprzedazy,
    ChoinkaID,
    SUM(Ilosc) AS SprzedanaIlosc,
    MAX(DataSprzedazy) AS OstatniaSprzedaz
FROM
    SprzedazDetal
GROUP BY
    ChoinkaID
UNION ALL
SELECT
    'Hurt' AS TypSprzedazy,
    ChoinkaID,
    SUM(Ilosc),
    MAX(DataSprzedazy)
FROM
    SprzedazHurt
GROUP BY
    ChoinkaID;
go
--procedury
CREATE  PROCEDURE sp_AddNewTreeToWarehouse
    @ChoinkaID INT,
    @Ilosc INT,
    @Adres VARCHAR(255)
AS
BEGIN
    -- Sprawdzenie, czy wpis ju¿ istnieje
    IF EXISTS (SELECT 1 FROM Magazyn WHERE ChoinkaID = @ChoinkaID AND Adres = @Adres)
    BEGIN
        -- Aktualizacja istniej¹cego wpisu
        UPDATE Magazyn
        SET Ilosc = Ilosc + @Ilosc
        WHERE ChoinkaID = @ChoinkaID AND Adres = @Adres;
    END
    ELSE
    BEGIN
        -- Dodanie nowego wpisu, jeœli nie istnieje
        INSERT INTO Magazyn (ChoinkaID, Adres, Ilosc)
        VALUES (@ChoinkaID, @Adres, @Ilosc);
    END
END;
GO
CREATE PROCEDURE sp_UpdateRetailPrice
    @ChoinkaID INT,
    @CenaDetaliczna DECIMAL(10,2)
AS
BEGIN
    UPDATE Choinka
    SET CenaDetaliczna = @CenaDetaliczna
    WHERE ChoinkaID = @ChoinkaID
END
go
CREATE PROCEDURE sp_RegisterRetailSale
    @ChoinkaID INT,
    @Ilosc INT,
    @DataSprzedazy DATE
AS
BEGIN
    INSERT INTO SprzedazDetal (ChoinkaID, Ilosc, DataSprzedazy)
    VALUES (@ChoinkaID, @Ilosc, @DataSprzedazy)
END
go
CREATE PROCEDURE sp_ShowAvailableTreesInWarehouse
AS
BEGIN
    SELECT m.MagazynID, m.Adres, c.ChoinkaID, g.NazwaGatunku, c.Wielkosc, m.Ilosc
    FROM Magazyn m
    JOIN Choinka c ON m.ChoinkaID = c.ChoinkaID
    JOIN Gatunek g ON c.GatunekID = g.GatunekID
END
go
CREATE or alter PROCEDURE AddSaleToStoisko
    
    @ChoinkaID INT,
    @Ilosc INT,
    @TypSprzedazy VARCHAR(255), -- 'Hurt' lub 'Detal'
	@StoiskoNazwa VARCHAR(255),
    @DataSprzedazy DATE
	
AS
BEGIN
    
    DECLARE @TableName NVARCHAR(100);
    
    -- Pobranie nazwy stoiska
 
    
    -- Ustalenie nazwy tabeli na podstawie nazwy stoiska
    SET @TableName = CASE 
                        WHEN @StoiskoNazwa = 'Stoisko1' THEN 'Stoisko1'
                        WHEN @StoiskoNazwa = 'Stoisko2' THEN 'Stoisko2'
                        WHEN @StoiskoNazwa = 'Stoisko3' THEN 'Stoisko3'
                     END;

    -- Dodanie sprzeda¿y do odpowiedniej tabeli stoiska
    IF @TableName IS NOT NULL
    BEGIN
        DECLARE @SQL NVARCHAR(MAX);
        SET @SQL = 'INSERT INTO ' + QUOTENAME(@TableName) + ' ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES ( @TypSprzedazy, @DataSprzedazy, @Ilosc, @ChoinkaID)';
        EXEC sp_executesql @SQL, N' @TypSprzedazy VARCHAR(255), @DataSprzedazy DATE, @Ilosc INT, @ChoinkaID INT', @TypSprzedazy, @DataSprzedazy, @Ilosc, @ChoinkaID;
    END
    ELSE
    BEGIN
        RAISERROR ('Nie znaleziono stoiska o podanym ID.', 16, 1);
    END
END;
go

CREATE PROCEDURE sp_UpdateHurtPrice
    @ChoinkaID INT,
    @CenaHurtowa DECIMAL(10,2)
AS
BEGIN
    UPDATE Choinka
    SET CenaHurtowa = @CenaHurtowa
    WHERE ChoinkaID = @ChoinkaID
END
go
CREATE PROCEDURE sp_AddNewTreeSpecies
    @NazwaGatunku VARCHAR(255)
AS
BEGIN
    INSERT INTO Gatunek (NazwaGatunku)
    VALUES (@NazwaGatunku)
END
go
CREATE PROCEDURE sp_SalesReport
    @FromDate DATE,
    @ToDate DATE
AS
BEGIN
    SELECT
        c.ChoinkaID,
        g.NazwaGatunku,
        c.Wielkosc,
        SUM(sd.Ilosc) AS TotalUnitsSold,
        SUM(sd.Ilosc * c.CenaDetaliczna) AS TotalRevenue
    FROM
        SprzedazDetal sd
        JOIN Choinka c ON sd.ChoinkaID = c.ChoinkaID
        JOIN Gatunek g ON c.GatunekID = g.GatunekID
    WHERE
        sd.DataSprzedazy BETWEEN @FromDate AND @ToDate
    GROUP BY
        c.ChoinkaID, g.NazwaGatunku, c.Wielkosc
END
go
CREATE PROCEDURE sp_ListTreesBelowThreshold
    @Threshold INT
AS
BEGIN
    SELECT c.ChoinkaID, g.NazwaGatunku, c.Wielkosc, m.Ilosc
    FROM Magazyn m
    JOIN Choinka c ON m.ChoinkaID = c.ChoinkaID
    JOIN Gatunek g ON c.GatunekID = g.GatunekID
    WHERE m.Ilosc < @Threshold
END
go
CREATE PROCEDURE sp_UpdateTreeSize
    @ChoinkaID INT,
    @NewSize INT
AS
BEGIN
    UPDATE Choinka
    SET Wielkosc = @NewSize
    WHERE ChoinkaID = @ChoinkaID
END
go
CREATE PROCEDURE sp_RemoveTreeFromWarehouse
    @ChoinkaID INT
AS
BEGIN
    DELETE FROM Magazyn
    WHERE ChoinkaID = @ChoinkaID
END
go
CREATE PROCEDURE sp_ReviewSalesInPeriod
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SELECT 
        sd.DataSprzedazy, 
        g.NazwaGatunku, 
        c.Wielkosc, 
        SUM(sd.Ilosc) AS TotalSold, 
        SUM(sd.Ilosc * c.CenaDetaliczna) AS Revenue
    FROM SprzedazDetal sd
    JOIN Choinka c ON sd.ChoinkaID = c.ChoinkaID
    JOIN Gatunek g ON c.GatunekID = g.GatunekID
    WHERE sd.DataSprzedazy BETWEEN @StartDate AND @EndDate
    GROUP BY sd.DataSprzedazy, g.NazwaGatunku, c.Wielkosc
    ORDER BY sd.DataSprzedazy
END
go
CREATE PROCEDURE sp_RegisterHurtSale
    @ChoinkaID INT,
    @Ilosc INT,
    @DataSprzedazy DATE
AS
BEGIN
    INSERT INTO SprzedazHurt (ChoinkaID, Ilosc, DataSprzedazy)
    VALUES (@ChoinkaID, @Ilosc, @DataSprzedazy)
END
go
--funkcje
CREATE FUNCTION fn_AverageWholesalePriceBySpeciesDetal
(
    @GatunekID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN (
        SELECT AVG(CenaDetaliczna)
        FROM Choinka
        WHERE GatunekID = @GatunekID
    );
END;
go
CREATE FUNCTION fn_AverageWholesalePriceBySpeciesHurt
(
    @GatunekID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN (
        SELECT AVG(CenaHurtowa)
        FROM Choinka
        WHERE GatunekID = @GatunekID
    );
END;
go
CREATE FUNCTION fn_CountTreesInWarehouseBySpecies
(
    @GatunekID INT
)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT SUM(Ilosc)
        FROM Magazyn m
        JOIN Choinka c ON m.ChoinkaID = c.ChoinkaID
        WHERE c.GatunekID = @GatunekID
    );
END;
go
CREATE FUNCTION fn_IsTreeAvailableInWarehouse
(
    @ChoinkaID INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT;
    IF EXISTS (SELECT 1 FROM Magazyn WHERE ChoinkaID = @ChoinkaID AND Ilosc > 0)
        SET @result = 1;
    ELSE
        SET @result = 0;
    RETURN @result;
END;
go
CREATE FUNCTION fn_PriceDifferenceForTree
(
    @ChoinkaID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN (
        SELECT ABS(CenaDetaliczna - CenaHurtowa)
        FROM Choinka
        WHERE ChoinkaID = @ChoinkaID
    );
END;
go
CREATE  FUNCTION fn_TotalTreesSoldInPeriod
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT SUM(Ilosc) FROM (
            SELECT Ilosc FROM SprzedazDetal WHERE DataSprzedazy BETWEEN @StartDate AND @EndDate
            UNION ALL
            SELECT Ilosc FROM SprzedazHurt WHERE DataSprzedazy BETWEEN @StartDate AND @EndDate
        ) AS SumaIlosci
    );
END;
go
--role

GO
CREATE LOGIN [Admin] WITH PASSWORD=N'qwerty', DEFAULT_DATABASE=[choinki], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [Admin]
GO
USE [choinki]
CREATE USER Admin FOR LOGIN Admin;

GO
CREATE LOGIN [Pracownik] WITH PASSWORD=N'qwerty' MUST_CHANGE, DEFAULT_DATABASE=[choinki], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO
use choinki
CREATE USER [Pracownik] FOR LOGIN [Pracownik];
go
GRANT execute on dbo.sp_RegisterRetailSale TO Pracownik;
GRANT execute on dbo.sp_RegisterHurtSale TO Pracownik;
GRANT execute on dbo.sp_ShowAvailableTreesInWarehouse TO Pracownik;
GRANT execute on dbo.AddSaleToStoisko TO Pracownik;
go
-- przykladowe dane
INSERT INTO Gatunek ( NazwaGatunku) VALUES ( 'Jod³a');
INSERT INTO Gatunek ( NazwaGatunku) VALUES ( 'Œwierk Srebrny');
INSERT INTO Gatunek ( NazwaGatunku) VALUES ( 'Œwierk Pospolity');
go
INSERT INTO Choinka ( GatunekID, Wielkosc, CenaHurtowa, CenaDetaliczna) VALUES
( 1, 100, 50.00, 100.00),
( 1, 150, 75.00, 150.00),
( 2, 100, 55.00, 110.00),
( 2, 150, 80.00, 160.00),
( 3, 100, 60.00, 120.00),
( 3, 150, 85.00, 170.00),
( 1, 120, 62.00, 124.00),
( 2, 120, 67.00, 134.00),
( 3, 140, 78.00, 156.00),
( 1, 130, 70.00, 140.00);
go
INSERT INTO Magazyn ( Adres, ChoinkaID, Ilosc) VALUES
( 'ul. Leœna 1', 1, 200),
( 'ul. Leœna 1', 2, 150),
( 'ul. Leœna 1', 3, 300),
( 'ul. Leœna 1', 4, 250),
( 'ul. Leœna 1', 5, 200),
( 'ul. Leœna 1', 6, 150),
( 'ul. Leœna 1', 7, 300),
( 'ul. Leœna 1', 8, 250),
( 'ul. Leœna 1', 9, 200),
( 'ul. Leœna 1', 10, 150);
go
INSERT INTO SprzedazDetal ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 1, 2, '2023-12-01')
INSERT INTO SprzedazDetal ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 2, 1, '2023-12-02')
INSERT INTO SprzedazDetal ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 3, 3, '2023-12-03')
INSERT INTO SprzedazDetal ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 4, 2, '2023-12-04')
INSERT INTO SprzedazDetal ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 5, 1, '2023-12-05')
INSERT INTO SprzedazDetal ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 6, 2, '2023-12-06')
INSERT INTO SprzedazDetal ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 7, 3, '2023-12-07')
INSERT INTO SprzedazDetal ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 8, 2, '2023-12-08')
INSERT INTO SprzedazDetal ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 9, 1, '2023-12-09')
INSERT INTO SprzedazDetal ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 10, 2, '2023-12-10')
go
INSERT INTO SprzedazHurt ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 1, 5, '2023-11-01')
INSERT INTO SprzedazHurt ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 2, 10, '2023-11-02')
INSERT INTO SprzedazHurt ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 3, 15, '2023-11-03')
INSERT INTO SprzedazHurt ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 4, 5, '2023-11-04')
INSERT INTO SprzedazHurt ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 5, 10, '2023-11-05')
INSERT INTO SprzedazHurt ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 6, 15, '2023-11-06')
INSERT INTO SprzedazHurt ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 7, 5, '2023-11-07')
INSERT INTO SprzedazHurt ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 8, 10, '2023-11-08')
INSERT INTO SprzedazHurt ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 9, 15, '2023-11-09')
INSERT INTO SprzedazHurt ( ChoinkaID, Ilosc, DataSprzedazy) VALUES
( 10, 5, '2023-11-10')
go
INSERT INTO Stoisko1 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-01', 2, 1)
INSERT INTO Stoisko1 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-11-15', 5, 2)
INSERT INTO Stoisko1 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-03', 1, 3)
INSERT INTO Stoisko1 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-11-20', 7, 4)
INSERT INTO Stoisko1 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-05', 2, 5)
INSERT INTO Stoisko1 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-07', 1, 6)
INSERT INTO Stoisko1 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-11-25', 4, 7)
INSERT INTO Stoisko1 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-09', 3, 8)
INSERT INTO Stoisko1 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-11-30', 6, 9)
INSERT INTO Stoisko1 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-11', 1, 10)
INSERT INTO Stoisko2 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-02', 3, 1)
INSERT INTO Stoisko2 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-11-16', 8, 2)
INSERT INTO Stoisko2 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-04', 1, 3)
INSERT INTO Stoisko2 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-11-21', 9, 4)
INSERT INTO Stoisko2 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-06', 2, 5)
INSERT INTO Stoisko2 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-08', 1, 6)
INSERT INTO Stoisko2 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-11-26', 5, 7)
INSERT INTO Stoisko2 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-10', 2, 8)
INSERT INTO Stoisko2 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-12-01', 7, 9)
INSERT INTO Stoisko2 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-12', 2, 10)
go
INSERT INTO Stoisko3 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-03', 4, 1)
INSERT INTO Stoisko3 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-11-17', 10, 2)
INSERT INTO Stoisko3 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-05', 1, 3)
INSERT INTO Stoisko3 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-11-22', 8, 4)
INSERT INTO Stoisko3 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-07', 3, 5)
INSERT INTO Stoisko3 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-09', 2, 6)
INSERT INTO Stoisko3 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-11-27', 6, 7)
INSERT INTO Stoisko3 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-11', 2, 8)
INSERT INTO Stoisko3 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Hurt', '2023-12-02', 9, 9)
INSERT INTO Stoisko3 ( TypSprzedazy, DataSprzedazy, Ilosc, ChoinkaID) VALUES
( 'Detal', '2023-12-13', 3, 10)
go

