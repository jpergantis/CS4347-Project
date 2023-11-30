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
	EmailAddress VARCHAR(255) NOT NULL,
	Age INTEGER CHECK(Age < 65),
	FirstName VARCHAR(255) NOT NULL,
	LastName VARCHAR(255) NOT NULL,
	AddressLine1 VARCHAR(255) NOT NULL,
	AddressLine2 VARCHAR(255), -- Not all addresses have a line 2
	ZipCode CHAR(5) NOT NULL,
	City VARCHAR(255) NOT NULL,
	StateCode CHAR(2) NOT NULL -- 2 character state code e.g. TX, FL, CA for consistency

	-- Keys and constraints
	PRIMARY KEY (PersonId)
);

CREATE TABLE PhoneNumber (
	-- Attributes
	PhoneNumber CHAR(10) NOT NULL,
	PersonId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (PhoneNumber),
	FOREIGN KEY (PersonId) REFERENCES Person(PersonId)
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
	PRIMARY KEY (EmployeeId, CustomerId)
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
	EndDate DATE -- Allowed null for employees still working in that department with no specified end date

	-- Keys and constraints
	FOREIGN KEY (PersonId) REFERENCES Employee(PersonId), 
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
);


-- Applicant tables need some work. Since an applicant could be an employee or a potential employee, how to handle?
CREATE TABLE Applicant (
	-- Attributes
	ApplicantId INTEGER NOT NULL,
	JobId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (ApplicantId),
	FOREIGN KEY (JobId) REFERENCES JobPosition(JobId)
);

CREATE TABLE ExternalApplicant (
	-- Attributes
	PotentialEmployeeId INTEGER NOT NULL,
	ApplicantId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (PotentialEmployeeId, ApplicantId),
	FOREIGN KEY (PotentialEmployeeId) REFERENCES PotentialEmployee(PersonId),
	FOREIGN KEY (ApplicantId) REFERENCES Applicant(ApplicantId)
);

CREATE TABLE InternalApplicant (
	-- Attributes
	EmployeeId INTEGER NOT NULL,
	ApplicantId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (EmployeeId, ApplicantId),
	FOREIGN KEY (EmployeeId) REFERENCES Employee(PersonId),
	FOREIGN KEY (ApplicantId) REFERENCES Applicant(ApplicantId)
);

CREATE TABLE Interview (
	-- Attributes
	InterviewId INTEGER NOT NULL,
	JobId INTEGER NOT NULL,
	ApplicantId INTEGER NOT NULL,
	InterviewDateTime DATETIME NOT NULL,
	Grade INTEGER -- Allowed to be null as an interview could be scheduled but not yet completed

	-- Keys and constraints
	PRIMARY KEY (InterviewId),
	FOREIGN KEY (JobId) REFERENCES JobPosition(JobId),
	FOREIGN KEY (ApplicantId) REFERENCES Applicant(ApplicantId)
);

CREATE TABLE Interviewer (
	-- Attributes
	InterviewId INTEGER NOT NULL,
	EmployeeId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (InterviewId, EmployeeId),
	FOREIGN KEY (InterviewId) REFERENCES Interview(InterviewId),
	FOREIGN KEY (EmployeeId) REFERENCES Employee(PersonId)

)

CREATE TABLE MarketingSite (
	-- Attributes
	SiteId INTEGER NOT NULL,
	SiteName VARCHAR(255) NOT NULL,
	SiteLocation VARCHAR(255) NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SiteId)
);

CREATE TABLE EmployeeSiteMembership (
	-- Attributes
	SiteId INTEGER NOT NULL,
	EmployeeId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SiteId, EmployeeId),
	FOREIGN KEY (SiteId) REFERENCES MarketingSite(SiteId),
	FOREIGN KEY (EmployeeId) REFERENCES Employee(PersonId)
);

CREATE TABLE Vendor (
	-- Attributes
	VendorId INTEGER NOT NULL,
	VendorName VARCHAR(255) NOT NULL,
	AddressLine1 VARCHAR(255) NOT NULL,
	AddressLine2 VARCHAR(255),
	ZipCode CHAR(5) NOT NULL,
	City VARCHAR(255) NOT NULL,
	StateCode CHAR(2) NOT NULL, -- 2 character state code e.g. TX, FL, CA for consistency
	AccountNumber INTEGER NOT NULL,
	CreditRating INTEGER NOT NULL,
	PurchasingWebsite VARCHAR(MAX) NOT NULL

	-- Keys and constraints
	PRIMARY KEY (VendorId),
	CONSTRAINT CreditRatingRange CHECK(CreditRating >= 300 and CreditRating <= 850) -- Valid ranges for credit ratings
);

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
	ProductStyle VARCHAR(255) NOT NULL,
	SiteId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (ProductId)
	FOREIGN KEY (SiteId) REFERENCES MarketingSite(SiteId)
);

CREATE TABLE Sale (
	-- Attributes
	SaleId INTEGER NOT NULL, -- This was not specified in the requirements but is necessary to have a unique primary key, as the same product could be sold at the same date/time to different customers
	ProductId INTEGER NOT NULL,
	SaleDateTime DATETIME NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SaleId)
	FOREIGN KEY (ProductId) REFERENCES Product(ProductId)
);

CREATE TABLE SalesPersonSaleMembership (
	-- Attributes
	SaleId INTEGER NOT NULL,
	EmployeeId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SaleId, EmployeeId),
	FOREIGN KEY (SaleId) REFERENCES Sale(SaleId),
	FOREIGN KEY (EmployeeId) REFERENCES Employee(PersonId)
);

CREATE TABLE CustomerSaleMembership (
	-- Attributes
	SaleId INTEGER NOT NULL,
	CustomerId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SaleId, CustomerId),
	FOREIGN KEY (SaleId) REFERENCES Sale(SaleId),
	FOREIGN KEY (CustomerId) REFERENCES Customer(PersonId)
);

CREATE TABLE SiteSaleMembership (
	-- Attributes
	SaleId INTEGER NOT NULL,
	SiteId INTEGER NOT NULL

	-- Keys and constraints
	PRIMARY KEY (SaleId, SiteId),
	FOREIGN KEY (SaleId) REFERENCES Sale(SaleId),
	FOREIGN KEY (SiteId) REFERENCES MarketingSite(SiteId)
);

CREATE TABLE Part (
	-- Attributes
	PartId INTEGER NOT NULL,
	PartName VARCHAR(255) NOT NULL,
	PartWeight DECIMAL NOT NULL

	-- Keys and constraints
	PRIMARY KEY (PartId),
);

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
);

CREATE TABLE PartVendorMembership (
	-- Attributes
	PartId INTEGER NOT NULL,
	VendorId INTEGER NOT NULL,
	PartPrice DECIMAL NOT NULL

	-- Keys and constraints
	PRIMARY KEY (PartId, VendorId),
	FOREIGN KEY (PartId) REFERENCES Part(PartId),
	FOREIGN KEY (VendorId) REFERENCES Vendor(VendorId)
)

GO

-- Create views

-- View 1
CREATE VIEW [View1] AS
	SELECT
	e.PersonId AS 'Employee Id',
	p.FirstName AS 'Employee First Name',
	p.LastName AS 'Employee Last Name',
	AVG(ep.Amount) AS 'Employee Average Salary'
	FROM Employee e
	INNER JOIN Person p ON e.PersonId = p.PersonId
	INNER JOIN EmployeePaycheck ep ON ep.EmployeeId = e.PersonId
	GROUP BY 
	e.PersonId, 
	p.FirstName, 
	p.LastName
GO

CREATE VIEW [View2] AS
	SELECT
	ap.ApplicantId AS 'Applicant Id',
	jp.JobId AS 'Job Id',
	SUM(CASE WHEN ISNULL(i.Grade, 0) >= 70 THEN 1 ELSE 0 END) AS '# of Interviews Passed'
	FROM JobPosition jp
	INNER JOIN Applicant ap ON ap.JobId = jp.JobId
	LEFT JOIN Interview i ON i.JobId = jp.JobId AND i.ApplicantId = ap.ApplicantId
	GROUP BY 
	ap.ApplicantId,
	jp.JobId
GO

CREATE VIEW [View3] AS
	SELECT
	p.ProductId AS 'Product Id',
	COUNT(s.SaleId) AS '# Sold'
	FROM Product p
	INNER JOIN Sale s ON s.ProductId = p.ProductId
	GROUP BY 
	p.ProductId
GO

CREATE VIEW [View4] AS
	SELECT
	p.ProductId AS 'Product Id',
	SUM (minPrices.MinPrice * ppm.Quantity) AS 'Purchase Price'
	FROM Product p
	INNER JOIN PartProductMembership ppm ON ppm.ProductId = p.ProductId
	INNER JOIN Part pt ON ppm.PartId = pt.PartId
	INNER JOIN PartVendorMembership pvm ON pvm.PartId = pt.PartId
	INNER JOIN 	(
		SELECT
		pvm2.PartId,
		MIN(pvm2.PartPrice) AS 'MinPrice'
		FROM PartVendorMembership pvm2
		GROUP BY pvm2.PartId
	) minPrices ON minPrices.PartId = pt.PartId  -- Assuming we get the part from the cheapest vendor
	GROUP BY
	p.ProductId

GO

-- Queries

-- Query 1
SELECT
p.PersonId,
p.FirstName,
p.LastName
FROM Interviewer ivr
INNER JOIN Employee e ON ivr.EmployeeId = e.PersonId
INNER JOIN Person p ON e.PersonId = p.PersonId
INNER JOIN Interview i ON ivr.InterviewId = i.InterviewId
INNER JOIN Applicant ap ON i.ApplicantId = ap.ApplicantId
LEFT JOIN InternalApplicant iap ON iap.ApplicantId = ap.ApplicantId
LEFT JOIN Employee empap ON iap.EmployeeId = empap.PersonId
LEFT JOIN Person empapp ON empap.PersonId = empapp.PersonId
LEFT JOIN ExternalApplicant eap ON eap.ApplicantId = ap.ApplicantId
LEFT JOIN PotentialEmployee peap ON eap.PotentialEmployeeId = peap.PersonId
LEFT JOIN Person peapp ON peap.PersonId = peapp.PersonId
WHERE
(
	(empapp.FirstName = 'Hellen'
	AND empapp.LastName = 'Cole')
	OR 
	(
	(peapp.FirstName = 'Hellen'
	AND peapp.LastName = 'Cole')
	)
)
AND i.JobId = 11111;

-- Query 2
SELECT
jp.JobId
FROM JobPosition jp
INNER JOIN Department d ON jp.DepartmentId = d.DepartmentId
WHERE 
d.DepartmentName = 'Marketing'
AND jp.PostedDate >= '1/1/2011'
AND jp.PostedDate <= '1/31/2011';

-- Query 3
SELECT
p.PersonId,
p.FirstName,
p.LastName
FROM Person p
INNER JOIN Employee e ON e.PersonId = p.PersonId
WHERE
NOT EXISTS (
	SELECT
	ManagerId
	FROM Employee 
	WHERE ManagerId = e.PersonId
);

-- Query 4
SELECT
ms.SiteId,
ms.SiteLocation
FROM MarketingSite ms
WHERE 
ms.SiteId NOT IN (
	SELECT 
	ssm.SiteId
	FROM Sale s
	INNER JOIN SiteSaleMembership ssm ON ssm.SaleId = s.SaleId
	WHERE 
	s.SaleDateTime >= '1/1/2011' 
	AND s.SaleDateTime <= '1/31/2011'
);

-- Query 5
SELECT
jp.JobId,
jp.JobDescription
FROM JobPosition jp
WHERE 
(	
	SELECT
	COUNT(*)
	FROM Interview i
	WHERE 
	i.JobId = jp.JobId
	AND Grade >= 70
) < 5;

-- Query 6
SELECT DISTINCT
p.PersonId,
p.FirstName,
p.LastName
FROM Sale s
INNER JOIN SalesPersonSaleMembership spsm ON spsm.SaleId = s.SaleId
INNER JOIN Employee e ON spsm.EmployeeId = e.PersonId
INNER JOIN Person p ON e.PersonId = p.PersonId
INNER JOIN Product pr ON s.ProductId = pr.ProductId
WHERE 
CONCAT(spsm.EmployeeId, pr.ProductId) IN (
	SELECT DISTINCT
	CONCAT(spsm.EmployeeId, p2.ProductId)
	FROM SalesPersonSaleMembership spsm2
	INNER JOIN Sale s2 ON s2.SaleId = spsm2.SaleId
	INNER JOIN Product p2 ON s2.ProductId = p2.ProductId
	WHERE p2.ListPrice > 200
	GROUP BY
	CONCAT(spsm.EmployeeId, p2.ProductId)
)

-- Query 7
SELECT
d.DepartmentId,
d.DepartmentName
FROM Department d
WHERE 
d.DepartmentId NOT IN (
	SELECT 
	jp.DepartmentId
	FROM JobPosition jp
	WHERE 
	jp.PostedDate >= '1/1/2011'
	AND jp.PostedDate <= '2/1/2011'
);

-- Query 8
SELECT
p.PersonId,
p.FirstName,
p.LastName,
d.DepartmentName
FROM Employee e
INNER JOIN Person p ON e.PersonId = p.PersonId
INNER JOIN InternalApplicant ia ON ia.EmployeeId = e.PersonId
INNER JOIN Applicant a ON ia.ApplicantId = a.ApplicantId
INNER JOIN JobPosition jp ON a.JobId = jp.JobId
INNER JOIN DepartmentMembership dm ON dm.PersonId = e.PersonId
INNER JOIN Department d ON d.DepartmentId = dm.DepartmentId
WHERE
jp.JobId = 12345
AND dm.StartDate <= GETDATE()
AND (
	dm.EndDate IS NULL 
	OR dm.EndDate > GETDATE()
);

-- Query 9
SELECT TOP 1
p.ProductType
FROM Product p
INNER JOIN Sale s ON s.ProductId = p.ProductId
GROUP BY p.ProductType
ORDER BY COUNT(s.SaleId) DESC;

-- Query 10
SELECT TOP 1
p.ProductType
FROM Product p
INNER JOIN View4 v ON v.[Product Id] = p.ProductId
GROUP BY p.ProductType
ORDER BY MAX(p.ListPrice - v.[Purchase Price]);

-- Query 11
SELECT
p.FirstName,
p.LastName,
p.PersonId
FROM Person p
INNER JOIN Employee e ON e.PersonId = p.PersonId
WHERE e.PersonId IN (
	SELECT 
	ee.PersonId
	FROM Employee ee
	INNER JOIN DepartmentMembership dm ON dm.PersonId = ee.PersonId
	GROUP BY
	ee.PersonId
	HAVING 
	COUNT(DISTINCT dm.DepartmentId) = (
		SELECT 
		COUNT(*)
		FROM Department
	)
)

-- Query 12

SELECT
ISNULL(ep.FirstName, pep.FirstName) AS 'FirstName',
ISNULL(ep.LastName, pep.LastName) AS 'LastName',
ISNULL(ep.EmailAddress, pep.EmailAddress) AS 'EmailAddress'
FROM View2 v2
INNER JOIN Applicant a ON a.ApplicantId = v2.[Applicant Id]
LEFT JOIN InternalApplicant ia ON ia.ApplicantId = a.ApplicantId
LEFT JOIN Employee e ON e.PersonId = ia.EmployeeId
LEFT JOIN Person ep ON ep.PersonId = e.PersonId
LEFT JOIN ExternalApplicant ea ON ea.ApplicantId = a.ApplicantId
LEFT JOIN PotentialEmployee pe ON pe.PersonId = ea.PotentialEmployeeId
LEFT JOIN Person pep ON pep.PersonId = pe.PersonId
WHERE v2.[# of Interviews Passed] >= 5;

-- Query 13

-- Using a table variable to combine names from PotentialEmployee and Employee for easier access
DECLARE @CombinedApplicants TABLE (
	ApplicantId INTEGER,
	FirstName VARCHAR(255),
	LastName VARCHAR(255),
	EmailAddress VARCHAR(255)
)

INSERT INTO @CombinedApplicants (ApplicantId, FirstName, LastName, EmailAddress) 
	SELECT 
	a.ApplicantId,
	ISNULL(ep.FirstName, pep.FirstName),
	ISNULL(ep.LastName, pep.LastName),
	ISNULL(ep.EmailAddress, pep.EmailAddress)
	FROM View2 v2
	INNER JOIN Applicant a ON a.ApplicantId = v2.[Applicant Id]
	LEFT JOIN InternalApplicant ia ON ia.ApplicantId = a.ApplicantId
	LEFT JOIN Employee e ON e.PersonId = ia.EmployeeId
	LEFT JOIN Person ep ON ep.PersonId = e.PersonId
	LEFT JOIN ExternalApplicant ea ON ea.ApplicantId = a.ApplicantId
	LEFT JOIN PotentialEmployee pe ON pe.PersonId = ea.PotentialEmployeeId
	LEFT JOIN Person pep ON pep.PersonId = pe.PersonId;

SELECT
ca.FirstName,
ca.LastName,
ca.EmailAddress
FROM View2 v2
INNER JOIN @CombinedApplicants ca ON ca.ApplicantId = v2.[Applicant Id]
GROUP BY
ca.FirstName,
ca.LastName,
ca.EmailAddress
HAVING 
MIN(v2.[# of Interviews Passed]) >= 5;

-- Query 14
SELECT
p.FirstName,
p.LastName,
p.PersonId
FROM Person p
INNER JOIN Employee e ON e.PersonId = p.PersonId
WHERE
e.PersonId IN (
	SELECT TOP 1 
	ep.EmployeeId
	FROM EmployeePaycheck ep
	GROUP BY ep.EmployeeId
	ORDER BY AVG(ep.Amount) DESC
)


-- Query 15
SELECT TOP 1
v.VendorId,
v.VendorName
FROM Vendor v
INNER JOIN PartVendorMembership pvm ON pvm.VendorId = v.VendorId
INNER JOIN Part p ON pvm.PartId = p.PartId
WHERE 
p.PartName = 'Cup'
AND p.PartWeight < 4
ORDER BY 
pvm.PartPrice DESC