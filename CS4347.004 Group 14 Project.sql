-- Project developed on MS SQL Server 2022 Developer Edition + SQL Server Management Studio 18
-- SQL Server 2022 Developer Edition available at https://www.microsoft.com/en-us/sql-server/sql-server-downloads
-- SQL Server Management Studio 18 available at https://learn.microsoft.com/en-us/sql/ssms/release-notes-ssms?view=sql-server-ver16#previous-ssms-releases



-- Drop all connections and the existing database for a fresh copy each run of the file
USE tempdb;
GO

DECLARE @SQL nvarchar(1000);
IF EXISTS (SELECT 1 FROM sys.databases WHERE [name] = N'CS4347Group14')
	BEGIN
		SET @SQL = N'USE [CS4347Group14];

					 ALTER DATABASE CS4347Group14 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
					 USE [tempdb];

					 DROP DATABASE CS4347Group14;';
		EXEC (@SQL);
	END;



-- Create database

CREATE DATABASE CS4347Group14;
GO

USE CS4347GROUP14;



-- Create tables

CREATE TABLE Department (
	DepartmentId INTEGER, 
	DepartmentName VARCHAR(255)

	PRIMARY KEY (DepartmentId)
);

CREATE TABLE Person (
	-- Attributes
	PersonId INTEGER NOT NULL,
	Age INTEGER,
	FirstName VARCHAR(255) NOT NULL,
	LastName VARCHAR(255) NOT NULL,
	AddressLine1 VARCHAR(255) NOT NULL,
	AddressLine2 VARCHAR(255) NOT NULL,
	ZipCode CHAR(5) NOT NULL,
	City VARCHAR(255) NOT NULL,
	StateCode CHAR(2) NOT NULL --2 character state code e.g. TX, FL, CA for consistency

	-- Keys and constraints
	PRIMARY KEY (PersonId)
);

CREATE TABLE Employee (
	-- Attributes
	PersonId INTEGER NOT NULL,
	Title VARCHAR(255) NOT NULL,
	CompanyRank VARCHAR(255) NOT NULL,
	ManagerId INTEGER

	-- Keys and constraints
	PRIMARY KEY (PersonId),
	FOREIGN KEY (PersonId) REFERENCES Person(PersonId),
	FOREIGN KEY (ManagerId) REFERENCES Employee(PersonId)
);

CREATE TABLE EmployeePaycheck (
	-- Attributes
	EmployeeId INTEGER NOT NULL,
	TransactionNumber INTEGER NOT NULL,
	PayDate DATE NOT NULL,
	Amount DECIMAL NOT NULL
	
	-- Keys and constraints
	PRIMARY KEY (EmployeeId, TransactionNumber),
	CONSTRAINT PaymentGreaterThanZero CHECK(Amount > 0)
)

CREATE TABLE Customer (
	-- Attributes
	PersonId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (PersonId),
	FOREIGN KEY (PersonId) REFERENCES Person(PersonId)
);

-- Junction object to allow customers to have multiple preferred salespeople
CREATE TABLE PreferredSalespeople (
	-- Attributes
	EmployeeId INTEGER NOT NULL,
	CustomerId INTEGER NOT NULL

	-- Keys and constraints
	FOREIGN KEY (EmployeeId) REFERENCES Employee(PersonId),
	FOREIGN KEY (CustomerId) REFERENCES Customer(PersonId)

)

CREATE TABLE PotentialEmployee (
	-- Attributes
	PersonId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (PersonId)
	FOREIGN KEY (PersonId) REFERENCES Person(PersonId)
);

CREATE TABLE DepartmentMembership (
	-- Attributes
	PersonId INTEGER NOT NULL,
	DepartmentId INTEGER NOT NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL

	-- Keys and constraints
	FOREIGN KEY (PersonId) REFERENCES Person(PersonId), 
	FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId)
);

CREATE TABLE JobPosition (
	-- Attributes
	JobId INTEGER NOT NULL,
	PostedDate DATE NOT NULL,
	JobDescription VARCHAR(MAX) NOT NULL,
	DepartmentId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (JobId),
	FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId)
)


-- Applicant tables need some work. Since an applicant could be an employee or a potential employee, how to handle?
CREATE TABLE Applicant (
	-- Attributes
	ApplicantId INTEGER NOT NULL,
	JobId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (ApplicantId),
	FOREIGN KEY (JobId) REFERENCES JobPosition(JobId)
)

CREATE TABLE ExternalApplicant (
	-- Attributes
	PotentialEmployeeId INTEGER NOT NULL,
	ApplicantId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (PotentialEmployeeId, ApplicantId),
	FOREIGN KEY (PotentialEmployeeId) REFERENCES PotentialEmployee(PersonId),
	FOREIGN KEY (ApplicantId) REFERENCES Applicant(ApplicantId)
)

CREATE TABLE InternalApplicant (
	-- Attributes
	EmployeeId INTEGER NOT NULL,
	ApplicantId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (EmployeeId, ApplicantId),
	FOREIGN KEY (EmployeeId) REFERENCES Employee(PersonId),
	FOREIGN KEY (ApplicantId) REFERENCES Applicant(ApplicantId)
)

CREATE TABLE Interview (
	-- Attributes
	JobId INTEGER NOT NULL,
	ApplicantId INTEGER NOT NULL,
	InterviewDateTime DATETIME NOT NULL,
	Grade INTEGER -- Allowed to be null as an interview could be scheduled but not yet completed

	-- Keys and constraints
	PRIMARY KEY (JobId, ApplicantId, InterviewDateTime),
	FOREIGN KEY (JobId) REFERENCES JobPosition(JobId),
	FOREIGN KEY (ApplicantId) REFERENCES Applicant(ApplicantId)
)

CREATE TABLE MarketingSite (
	-- Attributes
	SiteId INTEGER NOT NULL,
	SiteName VARCHAR(255) NOT NULL,
	SiteLocation VARCHAR(255) NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SiteId)
)

CREATE TABLE EmployeeSiteMembership (
	-- Attributes
	SiteId INTEGER NOT NULL,
	EmployeeId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SiteId, EmployeeId),
	FOREIGN KEY (SiteId) REFERENCES MarketingSite(SiteId),
	FOREIGN KEY (EmployeeId) REFERENCES Employee(PersonId)
)

CREATE TABLE Sale (
	-- Attributes
	SaleId INTEGER NOT NULL, -- This was not specified in the requirements but is necessary to have a unique primary key, as the same product could be sold at the same date/time to different customers
	ProductId INTEGER NOT NULL,
	SaleDateTime DATETIME NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SaleId)
)

CREATE TABLE SalesPersonSaleMembership (
	-- Attributes
	SaleId INTEGER NOT NULL,
	EmployeeId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SaleId, EmployeeId),
	FOREIGN KEY (SaleId) REFERENCES Sale(SaleId),
	FOREIGN KEY (EmployeeId) REFERENCES Employee(PersonId)
)

CREATE TABLE CustomerSaleMembership (
	-- Attributes
	SaleId INTEGER NOT NULL,
	CustomerId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SaleId, CustomerId),
	FOREIGN KEY (SaleId) REFERENCES Sale(SaleId),
	FOREIGN KEY (CustomerId) REFERENCES Customer(PersonId)
)

CREATE TABLE SiteSaleMembership (
	-- Attributes
	SaleId INTEGER NOT NULL,
	SiteId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SaleId, SiteId),
	FOREIGN KEY (SaleId) REFERENCES Sale(SaleId),
	FOREIGN KEY (SiteId) REFERENCES MarketingSite(SiteId)
)

CREATE TABLE Vendor (
	-- Attributes
	VendorId INTEGER NOT NULL,
	VendorName INTEGER NOT NULL,
	AddressLine1 VARCHAR(255) NOT NULL,
	AddressLine2 VARCHAR(255) NOT NULL,
	ZipCode CHAR(5) NOT NULL,
	City VARCHAR(255) NOT NULL,
	StateCode CHAR(2) NOT NULL, --2 character state code e.g. TX, FL, CA for consistency
	AccountNumber INTEGER NOT NULL,
	CreditRating INTEGER NOT NULL,
	PurchasingWebsite VARCHAR(MAX) NOT NULL

	-- Keys and constraints
	PRIMARY KEY (VendorId),
	CONSTRAINT CreditRatingRange CHECK(CreditRating >= 300 and CreditRating <= 850) -- Valid ranges for credit ratings
)

CREATE TABLE Product (
	-- Attributes
	ProductId INTEGER NOT NULL,
	ProductType VARCHAR(255) NOT NULL,
	-- The following 3 attributes indicate the product size as dimensions in arbitrary units of measurement
	ProductLength DECIMAL NOT NULL,
	ProductWidth DECIMAL NOT NULL,
	ProductDepth DECIMAL NOT NULL,
	ListPrice DECIMAL NOT NULL,
	ProductWeight DECIMAL NOT NULL,
	ProductStyle VARCHAR(255) NOT NULL

	-- Keys and constraints
	PRIMARY KEY (ProductId)
)

CREATE TABLE Part (
	-- Attributes
	PartId INTEGER NOT NULL,
	PartPrice INTEGER NOT NULL,
	VendorId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (PartId),
	FOREIGN KEY (VendorId) REFERENCES Vendor(VendorId)
)

CREATE TABLE PartProductMembership (
	-- Attributes
	PartId INTEGER NOT NULL,
	ProductId INTEGER NOT NULL,
	Quantity INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (PartId, ProductId),
	FOREIGN KEY (PartId) REFERENCES Part(PartId),
	FOREIGN KEY (ProductId) REFERENCES Product(ProductId),
	CONSTRAINT PartQuantityPerProduct CHECK(Quantity > 0)
)

