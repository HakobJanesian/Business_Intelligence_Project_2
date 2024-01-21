
-- Part1
USE master;
GO
DROP DATABASE IF EXISTS   Orders_RELATION_DB
GO
CREATE DATABASE Orders_RELATION_DB;

GO
USE Orders_RELATION_DB;
GO

DROP TABLE IF EXISTS  [dbo].[OrderDetails]
GO
DROP TABLE IF EXISTS  [dbo].[Orders]
GO
DROP TABLE IF EXISTS  [dbo].[Products]
GO
DROP TABLE IF EXISTS  [dbo].[Shippers]
GO
DROP TABLE IF EXISTS  [dbo].[Customers]
GO
DROP TABLE IF EXISTS  [dbo].[Suppliers]
GO
DROP TABLE IF EXISTS  [dbo].[Categories]
GO
DROP TABLE IF EXISTS  [dbo].[EmployeeTerritories]
GO
DROP TABLE IF EXISTS  [dbo].[Employees]
GO
DROP TABLE IF EXISTS  [dbo].[Territories]
GO
DROP TABLE IF EXISTS   [dbo].[Region]
GO


CREATE TABLE  [dbo].[Region](
	RegionID int PRIMARY KEY,
	RegionDescription nchar(50) NOT NULL 
);



CREATE TABLE  [dbo].[Territories](
	TerritoryID nvarchar(20) PRIMARY KEY,
	TerritoryDescription nchar(50) NOT NULL,
	RegionID int  NOT NULL,
	FOREIGN KEY(RegionID) references Region(RegionID)
);




CREATE TABLE  [dbo].[Employees](
	EmployeeID int PRIMARY KEY,
	LastName nvarchar(20) NOT NULL,
	FirstName nvarchar(10)  NOT NULL,
	Title nvarchar(30) NULL,
	TitleOfCourtesy nvarchar(25) NULL, 
	BirthDate datetime NULL,
	HireDate datetime NULL,
	Address nvarchar(60) NULL,
	City nvarchar(15) NULL,
	Region nvarchar(15) NULL,
	PostalCode nvarchar(10) NULL,
	Country nvarchar(15) NULL,
	HomePhone nvarchar(24) NULL,
	Extension nvarchar(4) NULL,
	Photo image NULL,
	Notes varchar(MAX) NULL,
	ReportsTo int NULL,
	PhotoPath nvarchar(255) NULL,
	FOREIGN KEY(ReportsTo) references Employees(EmployeeID)
);



CREATE TABLE  [dbo].[EmployeeTerritories](
	EmployeeID int NOT NULL,
	TerritoryID nvarchar(20) NOT NULL,
	FOREIGN KEY(EmployeeID) references Employees(EmployeeID),
	FOREIGN KEY(TerritoryID) references Territories(TerritoryID),
	PRIMARY KEY(EmployeeID, TerritoryID)
);



CREATE TABLE  [dbo].[Categories](
	CategoryID int PRIMARY KEY,
	CategorName nvarchar(15) NOT NULL,
	Description varchar(MAX) NULL,
	Picture image NULL
);


CREATE TABLE  [dbo].[Suppliers](
	SupplierID int PRIMARY KEY,
	CompanyName nvarchar(40) NOT NULL,
	ContactName nvarchar(30) NULL,
	ContactTitle nvarchar(30) NULL,
	Address nvarchar(60) NULL,
	City nvarchar(15) NULL,
	Region nvarchar(15) NULL,
	PostalCode nvarchar(10) NULL,
	Country nvarchar(15) NULL,
	Phone nvarchar(24) NULL,
	Fax nvarchar(24) NULL,
	HomePage varchar(MAX) NULL
);





CREATE TABLE  [dbo].[Customers](
	CustomerID nchar(5) PRIMARY KEY,
	CompanyName nvarchar(40) NOT NULL,
	ContactName nvarchar(30) NULL,
	ContactTitle nvarchar(30) NULL,
	Address nvarchar(60) NULL,
	City nvarchar(15) NULL,
	Region nvarchar(15) NULL,
	PostalCode nvarchar(10) NULL,
	Country nvarchar(15) NULL,
	Phone nvarchar(24) NULL,
	Fax nvarchar(24) NULL
);




CREATE TABLE  [dbo].[Shippers](
	ShipperID int PRIMARY KEY,
	CompanyName nvarchar(40) NOT NULL,
	Phone nvarchar(24) NULL,
);




CREATE TABLE  [dbo].[Products](
	ProductID int PRIMARY KEY,
	ProductName nvarchar(40) NOT NULL,
	SupplierID int NULL,
	CategoryID int NULL,
	QuantityPer nvarchar(20) NULL,
	UnitsInStock smallint NULL,
	UnitOnOrder smallint NULL,
	RecorderLevel smallint NULL,
	Discontinued bit NOT NULL,
	FOREIGN KEY(CategoryID) references Categories(CategoryID),
	FOREIGN KEY(SupplierID) references Suppliers(SupplierID)
);


CREATE TABLE  [dbo].[Orders](
	OrderID int PRIMARY KEY,
	CustomerID nchar(5) NULL,
	EmployeeID int NULL,
	OrderDate datetime NULL,
	RequiredDate datetime NULL,
	ShippedDate datetime NULL,
	ShipVia int NULL,
	Freight money NULL,
	ShipName nvarchar(40) NULL,
	ShipAddress nvarchar(60) NULL,
	ShipCity nvarchar(15) NULL,
	ShipRegion nvarchar(15) NULL,
	ShipPostalCode nvarchar(10) NULL,
	ShipCountry nvarchar(15) NULL,
	FOREIGN KEY(CustomerID) references Customers(CustomerID),
	FOREIGN KEY(EmployeeID) references Employees(EmployeeID),
	FOREIGN KEY(ShipVia) references Shippers(ShipperID)
);



CREATE TABLE  [dbo].[OrderDetails](
	OrderID int NOT NULL,
	ProductID int NOT NULL,
	UnitPrice money NOT NULL,
	Quantity smallint NOT NULL,
	Discoumt real NOT NULL,
	FOREIGN KEY(OrderID) references Orders(OrderID),
	FOREIGN KEY(ProductID) references Products(ProductID),
	PRIMARY KEY(OrderID,ProductID)
);

-- Part2 

USE master;
GO
DROP DATABASE IF EXISTS   Orders_DIMENSIONAL_DW
GO
CREATE DATABASE Orders_DIMENSIONAL_DW;
GO

USE Orders_DIMENSIONAL_DW;
GO

DROP TABLE IF EXISTS  [dbo].[FactOrders]
GO
DROP TABLE IF EXISTS  [dbo].[DimProducts]
GO
DROP PROCEDURE IF EXISTS [dbo].[DimProducts_ETL];  
GO  
DROP TABLE IF EXISTS  [dbo].[DimSuppliers]
GO
DROP PROCEDURE IF EXISTS [dbo].[DimSuppliers_ETL];  
GO  
DROP TABLE IF EXISTS  [dbo].[DimCategories]
GO
DROP PROCEDURE IF EXISTS [dbo].[DimCategories_ETL];  
GO
DROP TABLE IF EXISTS  [dbo].[Date]
GO
DROP TABLE IF EXISTS  [dbo].[DimCustomers]
GO
DROP PROCEDURE IF EXISTS [dbo].[DimCustomers_ETL];  
GO
DROP TABLE IF EXISTS  [dbo].[DimShippers]
GO
DROP PROCEDURE IF EXISTS [dbo].[DimShippers_ETL];  
GO
DROP TABLE IF EXISTS  [dbo].[DimEmployee]
GO
DROP PROCEDURE IF EXISTS [dbo].[DimEmployee_ETL];  
GO



CREATE TABLE [dbo].[DimEmployee](
	EmployeeID int NOT NULL,
	LastName nvarchar(20) NOT NULL,
	FirstName nvarchar(10)  NOT NULL,
	Title nvarchar(30) NULL,
	TitleOfCourtesy nvarchar(25) NULL,
	BirthDate datetime NULL,
	HireDate datetime NULL,
	Address nvarchar(60) NULL,
	City nvarchar(15) NULL,
	Region nvarchar(15) NULL,
	PostalCode nvarchar(10) NULL,
	Country nvarchar(15) NULL,
	HomePhone nvarchar(24) NULL,
	Extension nvarchar(4) NULL,
	Photo image NULL,
	Notes varchar(MAX) NULL,
	ReportsTo int NULL,
	PhotoPath nvarchar(255) NULL,
	ValidFrom INT NULL,
	ValidTo INT NULL,
	IsCurrent BIT NULL
)	 ON [PRIMARY]
GO
CREATE PROCEDURE  [dbo].[DimEmployee_ETL]
AS
BEGIN TRY
DECLARE @Yesterday INT = (YEAR(DATEADD(dd,-1,GETDATE())) * 10000) + (MONTH(DATEADD(dd,-1,GETDATE())) * 100) + DAY(DATEADD(dd,-1,GETDATE()))
DECLARE @Today INT = (YEAR(GETDATE()) * 10000) + (MONTH(GETDATE()) * 100) + DAY(GETDATE())
-- Outer insert - the updated records are added to the SCD2 table
INSERT INTO dbo.DimEmployee (EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo, PhotoPath,  ValidFrom, IsCurrent)
SELECT EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo, PhotoPath, @Today, 1
FROM
(
-- Merge statement
MERGE INTO dbo.DimEmployee AS DST
USING [Orders_RELATION_DB].[dbo].[Employees] AS SRC
ON (SRC.EmployeeID = DST.SurrKey)
-- New records inserted
WHEN NOT MATCHED THEN 
INSERT (EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Photo, Notes, ReportsTo, PhotoPath, ValidFrom, IsCurrent)
VALUES (SRC.EmployeeID, SRC.LastName, SRC.FirstName, SRC.Title, SRC.TitleOfCourtesy, SRC.BirthDate, SRC.HireDate, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.HomePhone, SRC.Extension, SRC.Photo, SRC.Notes, SRC.ReportsTo, SRC.PhotoPath, @Today, 1)
-- Existing records updated if data changes
WHEN MATCHED 
AND IsCurrent = 1
AND (
 ISNULL(DST.LastName,'') <> ISNULL(SRC.LastName,'') 
 OR ISNULL(DST.FirstName,'') <> ISNULL(SRC.FirstName,'') 
 OR ISNULL(DST.Title,'') <> ISNULL(SRC.Title,'')
 OR ISNULL(DST.TitleOfCourtesy,'') <> ISNULL(SRC.TitleOfCourtesy,'')
 OR ISNULL(DST.BirthDate,'') <> ISNULL(SRC.BirthDate,'')
 OR ISNULL(DST.HireDate,'') <> ISNULL(SRC.HireDate,'')
 OR ISNULL(DST.Address,'') <> ISNULL(SRC.Address,'')
 OR ISNULL(DST.City,'') <> ISNULL(SRC.City,'')
 OR ISNULL(DST.Region,'') <> ISNULL(SRC.Region,'')
 OR ISNULL(DST.PostalCode,'') <> ISNULL(SRC.PostalCode,'')
 OR ISNULL(DST.Country,'') <> ISNULL(SRC.Country,'')
 OR ISNULL(DST.HomePhone,'') <> ISNULL(SRC.HomePhone,'')
 OR ISNULL(DST.Extension,'') <> ISNULL(SRC.Extension,'')
 OR ISNULL(DST.Notes,'') <> ISNULL(SRC.Notes,'')
 OR ISNULL(DST.ReportsTo,'') <> ISNULL(SRC.ReportsTo,'')
 OR ISNULL(DST.PhotoPath,'') <> ISNULL(SRC.PhotoPath,'')
 )
-- Update statement for a changed dimension record, to flag as no longer active
THEN UPDATE 
SET DST.IsCurrent = 0, DST.ValidTo = @Yesterday
OUTPUT SRC.EmployeeID, SRC.LastName, SRC.FirstName, SRC.Title, SRC.TitleOfCourtesy, SRC.BirthDate, SRC.HireDate, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.HomePhone, SRC.Extension, SRC.Photo, SRC.Notes, SRC.ReportsTo, SRC.PhotoPath, $Action AS MergeAction
) AS MRG
WHERE MRG.MergeAction = 'UPDATE'
;
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM [dbo].[DimEmployee];
GO
EXEC  [dbo].[DimEmployee_ETL];
GO
SELECT * FROM [dbo].[DimEmployee];
GO


CREATE TABLE [dbo].[DimShippers] (
	ShipperID int NOT NULL IDENTITY(1,1),
	SurrKey int NOT NULL,
	CompanyName nvarchar(40) NOT NULL,
	Phone nvarchar(24) NULL
	);
GO
CREATE PROCEDURE  [dbo].[DimShippers_ETL]
AS
BEGIN TRY
MERGE [dbo].[DimShippers] AS DST
USING [Orders_RELATION_DB].[dbo].[Shippers] AS SRC
ON (SRC.ShipperID = DST.SurrKey)
WHEN NOT MATCHED THEN
INSERT (SurrKey, CompanyName, Phone)
VALUES (SRC.ShipperID, SRC.CompanyName, SRC.Phone)
WHEN MATCHED 
AND (
 ISNULL(DST.CompanyName,'') <> ISNULL(SRC.CompanyName,'') 
 OR ISNULL(DST.Phone,'') <> ISNULL(SRC.Phone,'') 
 )
THEN UPDATE 
SET 
 DST.CompanyName = SRC.CompanyName 
 ,DST.Phone = SRC.Phone 
;
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM DimShippers;
GO
EXEC [dbo].[DimShippers_ETL];
GO
SELECT * FROM DimShippers;
GO



CREATE TABLE [dbo].[DimCustomers] (
	ID int NOT NULL IDENTITY(1,1),
	SurrKey int NOT NULL,
	CompanyName nvarchar(40) NOT NULL,
	ContactName nvarchar(30) NULL,
	ContactTitle nvarchar(30) NULL,
	Address nvarchar(60) NULL,
	City nvarchar(15) NULL,
	Region nvarchar(15) NULL,
	PostalCode nvarchar(10) NULL,
	Country nvarchar(15) NULL,
	Phone nvarchar(24) NULL,
	Fax nvarchar(24) NULL,
    Address_Prev1 nvarchar(60) NULL,
    Address_Prev1_ValidTo nvarchar(60) NULL,
	);
GO

CREATE PROCEDURE  [dbo].[DimCustomers_ETL]
AS
BEGIN TRY
DECLARE @Yesterday2 VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2)
MERGE dbo.DimCustomers AS DST
USING [Orders_RELATION_DB].[dbo].[Customers] AS SRC
ON (SRC.CustomerID = DST.SurrKey)
WHEN NOT MATCHED THEN
INSERT (SurrKey, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax)
VALUES (SRC.CustomerID, SRC.CompanyName, SRC.ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax)
WHEN MATCHED 
AND (DST.Address <> SRC.Address
 OR DST.CompanyName <> SRC.CompanyName
 OR DST.ContactName <> SRC.ContactName
 OR DST.ContactTitle <> SRC.ContactTitle
 OR DST.City <> SRC.City
 OR DST.Region <> SRC.Region
 OR DST.PostalCode <> SRC.PostalCode
 OR DST.Country <> SRC.Country
 OR DST.Phone <> SRC.Phone
 OR DST.Fax <> SRC.Fax)
THEN UPDATE 
SET DST.Address = SRC.Address
 ,DST.CompanyName = SRC.CompanyName
 ,DST.ContactName = SRC.ContactName
 ,DST.ContactTitle = SRC.ContactTitle
 ,DST.City = SRC.City
 ,DST.Region = SRC.Region
 ,DST.PostalCode = SRC.PostalCode
 ,DST.Country = SRC.Country
 ,DST.Phone = SRC.Phone
 ,DST.Fax = SRC.Fax
 ,DST.Address_Prev1 = DST.Address
 ,DST.Address_Prev1_ValidTo = @Yesterday2
;
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM [dbo].[DimCustomers];
GO
EXEC [dbo].[DimCustomers_ETL];
GO
SELECT * FROM [dbo].[DimCustomers];
GO



CREATE TABLE [dbo].[Date](
	DateKey int PRIMARY KEY,
	Date datetime NOT NULL,
	Day int  NOT NULL,
	Month int NOT NULL,
	MonthName nvarchar(10) NOT NULL,
	WeekOfYear int NOT NULL,
	WeekOfMounth int NOT NULL,
	DayOfMounth int NOT NULL,
	DayOfYear int NOT NULL
);



CREATE TABLE [dbo].[DimCategories](
	ID int NOT NULL IDENTITY(1,1),
	SurrKey int NOT NULL,
	CategorName nvarchar(15) NOT NULL,
	Description varchar(MAX) NULL,
	Picture image NULL,
	ValidFrom INT NULL,
	ValidTo INT NULL,
	IsCurrent BIT NULL
)	 ON [PRIMARY]
GO
CREATE PROCEDURE  [dbo].[DimCategories_ETL]
AS
BEGIN TRY
DECLARE @Yesterday INT = (YEAR(DATEADD(dd,-1,GETDATE())) * 10000) + (MONTH(DATEADD(dd,-1,GETDATE())) * 100) + DAY(DATEADD(dd,-1,GETDATE()))
DECLARE @Today INT = (YEAR(GETDATE()) * 10000) + (MONTH(GETDATE()) * 100) + DAY(GETDATE())
-- Outer insert - the updated records are added to the SCD2 table
INSERT INTO dbo.DimCategories(SurrKey, CategorName, Description, Picture, ValidFrom, IsCurrent)
SELECT CategoryID, CategorName, Description, Picture, @Today, 1
FROM
(
-- Merge statement
MERGE INTO dbo.DimCategories AS DST
USING [Orders_RELATION_DB].[dbo].[Categories] AS SRC
ON (SRC.CategoryID = DST.SurrKey)
-- New records inserted
WHEN NOT MATCHED THEN 
INSERT (SurrKey, CategorName, Description, Picture, ValidFrom, IsCurrent)
VALUES (SRC.CategoryID, SRC.CategorName, SRC.Description, SRC.Picture, @Today, 1)
-- Existing records updated if data changes
WHEN MATCHED 
AND IsCurrent = 1
AND (
 ISNULL(DST.CategorName,'') <> ISNULL(SRC.CategorName,'') 
 OR ISNULL(DST.Description,'') <> ISNULL(SRC.Description,'')
 )
-- Update statement for a changed dimension record, to flag as no longer active
THEN UPDATE 
SET DST.IsCurrent = 0, DST.ValidTo = @Yesterday
OUTPUT SRC.CategoryID, SRC.CategorName, SRC.Description, SRC.Picture, $Action AS MergeAction
) AS MRG
WHERE MRG.MergeAction = 'UPDATE'
;
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM [dbo].[DimCategories];
GO
EXEC  [dbo].[DimCategories_ETL];
GO
SELECT * FROM [dbo].[DimCategories];
GO




CREATE TABLE [dbo].[DimSuppliers](
	ID int NOT NULL IDENTITY(1,1),
	SurrKey int NOT NULL,
	CompanyName nvarchar(40) NOT NULL,
	ContactName nvarchar(30) NULL,
	ContactTitle nvarchar(30) NULL,
	Address nvarchar(60) NULL,
	City nvarchar(15) NULL,
	Region nvarchar(15) NULL,
	PostalCode nvarchar(10) NULL,
	Country nvarchar(15) NULL,
	Phone nvarchar(24) NULL,
	Fax nvarchar(24) NULL,
	HomePage varchar(MAX) NULL,
	ValidFrom INT NULL,
	ValidTo INT NULL,
	IsCurrent BIT NULL
)	 ON [PRIMARY]
GO
CREATE PROCEDURE  [dbo].[DimSuppliers_ETL]
AS
BEGIN TRY
DECLARE @Yesterday INT = (YEAR(DATEADD(dd,-1,GETDATE())) * 10000) + (MONTH(DATEADD(dd,-1,GETDATE())) * 100) + DAY(DATEADD(dd,-1,GETDATE()))
DECLARE @Today INT = (YEAR(GETDATE()) * 10000) + (MONTH(GETDATE()) * 100) + DAY(GETDATE())
-- Outer insert - the updated records are added to the SCD2 table
INSERT INTO dbo.DimSuppliers(SurrKey, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, HomePage, ValidFrom, IsCurrent)
SELECT SupplierID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, HomePage, @Today, 1
FROM
(
-- Merge statement
MERGE INTO dbo.DimSuppliers AS DST
USING [Orders_RELATION_DB].[dbo].[Suppliers] AS SRC
ON (SRC.SupplierID = DST.SurrKey)
-- New records inserted
WHEN NOT MATCHED THEN 
INSERT (SurrKey, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, HomePage, ValidFrom, IsCurrent)
VALUES (SRC.SupplierID, SRC.CompanyName, SRC.ContactName, SRC.ContactTitle, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.Phone, SRC.Fax, HomePage, @Today, 1)
-- Existing records updated if data changes
WHEN MATCHED 
AND IsCurrent = 1
AND (
 ISNULL(DST.CompanyName,'') <> ISNULL(SRC.CompanyName,'') 
 OR ISNULL(DST.ContactName,'') <> ISNULL(SRC.ContactName,'') 
 OR ISNULL(DST.ContactTitle,'') <> ISNULL(SRC.ContactTitle,'')
 OR ISNULL(DST.Address,'') <> ISNULL(SRC.Address,'')
 OR ISNULL(DST.City,'') <> ISNULL(SRC.City,'')
 OR ISNULL(DST.Region,'') <> ISNULL(SRC.Region,'')
 OR ISNULL(DST.PostalCode,'') <> ISNULL(SRC.PostalCode,'')
 OR ISNULL(DST.Country,'') <> ISNULL(SRC.Country,'')
 OR ISNULL(DST.Phone,'') <> ISNULL(SRC.Phone,'')
 OR ISNULL(DST.Fax,'') <> ISNULL(SRC.Fax,'')
 OR ISNULL(DST.HomePage,'') <> ISNULL(SRC.HomePage,'')
 )
-- Update statement for a changed dimension record, to flag as no longer active
THEN UPDATE 
SET DST.IsCurrent = 0, DST.ValidTo = @Yesterday
OUTPUT SRC.SupplierID, SRC.CompanyName, SRC.ContactName, SRC.ContactTitle, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.Phone, SRC.Fax, SRC.HomePage, $Action AS MergeAction
) AS MRG
WHERE MRG.MergeAction = 'UPDATE'
;
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM [dbo].[DimSuppliers];
GO
EXEC  [dbo].[DimSuppliers_ETL];
GO
SELECT * FROM [dbo].[DimSuppliers];
GO




CREATE TABLE [dbo].[DimProducts](
	ID int NOT NULL IDENTITY(1,1),
	SurrKey int NOT NULL,
	ProductName nvarchar(40) NOT NULL,
	QuantityPer nvarchar(20) NULL,
	UnitsInStock smallint NULL,
	UnitOnOrder smallint NULL,
	RecorderLevel smallint NULL,
	Discontinued bit NOT NULL,
	ValidFrom INT NULL,
	ValidTo INT NULL,
	IsCurrent BIT NULL
)	 ON [PRIMARY]
GO
CREATE PROCEDURE  [dbo].[DimProducts_ETL]
AS
BEGIN TRY
DECLARE @Yesterday INT = (YEAR(DATEADD(dd,-1,GETDATE())) * 10000) + (MONTH(DATEADD(dd,-1,GETDATE())) * 100) + DAY(DATEADD(dd,-1,GETDATE()))
DECLARE @Today INT = (YEAR(GETDATE()) * 10000) + (MONTH(GETDATE()) * 100) + DAY(GETDATE())
-- Outer insert - the updated records are added to the SCD2 table
INSERT INTO dbo.DimProducts(SurrKey, ProductName, QuantityPer, UnitsInStock, UnitOnOrder, RecorderLevel, Discontinued, ValidFrom, IsCurrent)
SELECT ProductID, ProductName, QuantityPer, UnitsInStock, UnitOnOrder, RecorderLevel, Discontinued, @Today, 1
FROM
(
-- Merge statement
MERGE INTO [dbo].[DimProducts] AS DST
USING [Orders_RELATION_DB].[dbo].[Products] AS SRC
ON (SRC.ProductID = DST.SurrKey)
-- New records inserted
WHEN NOT MATCHED THEN 
INSERT (SurrKey, ProductName, QuantityPer, UnitsInStock, UnitOnOrder, RecorderLevel, Discontinued, ValidFrom, IsCurrent)
VALUES (SRC.ProductID, SRC.ProductName, SRC.QuantityPer, SRC.UnitsInStock, SRC.UnitOnOrder, SRC.RecorderLevel, SRC.Discontinued, @Today, 1)
-- Existing records updated if data changes
WHEN MATCHED 
AND IsCurrent = 1
AND (
 ISNULL(DST.ProductName,'') <> ISNULL(SRC.ProductName,'') 
 OR ISNULL(DST.QuantityPer,'') <> ISNULL(SRC.QuantityPer,'')
 OR ISNULL(DST.UnitsInStock,'') <> ISNULL(SRC.UnitsInStock,'')
 OR ISNULL(DST.UnitOnOrder,'') <> ISNULL(SRC.UnitOnOrder,'')
 OR ISNULL(DST.RecorderLevel,'') <> ISNULL(SRC.RecorderLevel,'')
 OR ISNULL(DST.Discontinued,'') <> ISNULL(SRC.Discontinued,'')
 )
-- Update statement for a changed dimension record, to flag as no longer active
THEN UPDATE 
SET DST.IsCurrent = 0, DST.ValidTo = @Yesterday
OUTPUT SRC.ProductID, SRC.ProductName, SRC.QuantityPer, SRC.UnitsInStock, SRC.UnitOnOrder, SRC.RecorderLevel, SRC.Discontinued, $Action AS MergeAction
) AS MRG
WHERE MRG.MergeAction = 'UPDATE'
;
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM [dbo].[DimProducts];
GO
EXEC  [dbo].[DimProducts_ETL];
GO
SELECT * FROM [dbo].[DimProducts];
GO



CREATE TABLE [dbo].[FactOrders](
	Order_SK int NOT NULL,
	OrderID int NOT NULL,
	CustomerKey int NOT NULL,
	EmployeeKey int NOT NULL,
	OrderDateKey int NOT NULL,
	RequiredDate int NOT NULL, -----------HERE
	ShippedDate int NOT NULL, -----------HERE
	ShipperKey int NOT NULL,
	Freight money NULL,
	ShipName nvarchar(40) NULL,
	ShipAddress nvarchar(60) NULL,
	ShipCity nvarchar(15) NULL,
	ShipRegion nvarchar(15) NULL,
	ShipPostalCode nvarchar(10) NULL,
	ShipCountry nvarchar(15) NULL,
	ProductKey int NOT NULL,
	UnitPrice money NOT NULL,
	Quantity smallint NOT NULL,
	Discount real NOT NULL,
	FOREIGN KEY(EmployeeKey) references DimEmployee(EmployeeKey),
	FOREIGN KEY(ShipperKey) references DimShippers(ShipperKey),
	FOREIGN KEY(CustomerKey) references DimCustomers(CustomerKey),
	FOREIGN KEY(RequiredDate) references Date(DateKey),
	FOREIGN KEY(ShippedDate) references Date(DateKey),
	FOREIGN KEY(OrderDateKey) references Date(DateKey),	
	FOREIGN KEY(ProductKey) references DimProducts(ProductKey),
);
