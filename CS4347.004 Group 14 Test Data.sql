-- Test data

USE CS4347Group14;
GO

INSERT INTO Department (DepartmentId, DepartmentName) VALUES 
(1, 'Sales'),
(2, 'Customer Service'),
(3, 'Admin'),
(4, 'Marketing');

INSERT INTO JobPosition (JobId, PostedDate, JobDescription, DepartmentId) VALUES 
(11111, '11/29/2023', 'Sales Rep', 1),
(2, '11/29/2023', 'Service Rep', 2),
(3, '11/29/2023', 'Admin Assistant', 3),
(4, '1/10/2011', 'Marketing Assistant', 4),
(5, '1/15/2011', 'Marketing Manager', 4),
(6, '2/1/2011', 'Marketing Director', 4),
(7, '1/15/2011', 'Sales Director', 1),
(12345, '1/1/2023', 'Sales Manager', 1);

INSERT INTO Person (PersonId, Age, FirstName, LastName, AddressLine1, AddressLine2, ZipCode, City, StateCode, EmailAddress) VALUES
(1, 25, 'Hellen', 'Cole', '123 Main St', 'Apt 456', '75013', 'Allen', 'TX', 'hellencole@gmail.com'),
(2, 45, 'Steve', 'Jobs', '111 Park Blvd', NULL, '75013', 'Allen', 'TX', 'stevejobs@apple.com'),
(3, 40, 'Bill', 'Gates', '222 West Ave', NULL, '75013', 'Allen', 'TX', 'billgates@microsoft.com'),
(4, 55, 'Bob', 'Ross', '333 Art St', NULL, '75025', 'Plano', 'TX', 'bobross@joyofpainting.com'),
(5, 50, 'Joe', 'Biden', '1600 Pennsylvania Blvd', NULL, '20500', 'Washington', 'DC', 'joebiden@potus.gov'),
(6, 35, 'Corey', 'Taylor', '444 Iowa Ave', NULL, '12345', 'Des Moines', 'IA', 'coreytalor@slipknot.com');

INSERT INTO Employee (PersonId, Title, CompanyRank, ManagerId) VALUES
(3, 'CEO', 'President', NULL),
(2, 'VP Sales', 'Vice President', 3),
(4, 'Art Manager', 'Manager', 2),
(6, 'Singer', 'Employee', 2);

INSERT INTO DepartmentMembership (PersonId, DepartmentId, StartDate, EndDate) VALUES
(3, 1, '1/1/2011', '1/1/2012'),
(3, 3, '1/2/2012', NULL),
(2, 1, '1/1/2011', '2/1/2012'),
(2, 2, '2/2/2012', '3/1/2012'),
(2, 3, '3/2/2012', '4/1/2012'),
(2, 4, '4/2/2012', '5/1/2012'),
(2, 1, '5/2/2012', NULL),
(4, 2, '5/1/2012', '6/1/2012'),
(4, 3, '6/2/2012', NULL),
(6, 4, '6/2/2012', NULL);

INSERT INTO PotentialEmployee (PersonId) VALUES
(1),
(5);

INSERT INTO Applicant (ApplicantId, JobId) VALUES
(1, 11111),
(2, 11111),
(3, 3),
(4, 3),
(5, 6),
(6, 12345),
(7, 12345);

INSERT INTO InternalApplicant (ApplicantId, EmployeeId) VALUES
(6, 4),
(7, 6);

INSERT INTO ExternalApplicant (PotentialEmployeeId, ApplicantId) VALUES 
(1, 1),
(5, 5);

INSERT INTO Interview (InterviewId, JobId, ApplicantId, InterviewDateTime, Grade) VALUES
(1, 11111, 1, '2023-11-29 11:00:00', 85),
(2, 3, 2, '2023-11-29 14:00:00', 90),
(3, 11111, 1, '2023-11-29 15:00:00', 100),
(4, 6, 5, '2023-11-01 12:00:00', 75),
(5, 6, 5, '2023-11-01 12:00:00', 85),
(6, 6, 5, '2023-11-01 12:00:00', 80),
(7, 6, 5, '2023-11-01 12:00:00', 90),
(8, 6, 5, '2023-11-01 12:00:00', 85),
(9, 6, 5, '2023-11-01 12:00:00', 90);

INSERT INTO Interviewer (InterviewId, EmployeeId) VALUES
(1, 2),
(1, 3),
(2, 3),
(3, 4);

INSERT INTO MarketingSite (SiteId, SiteName, SiteLocation) VALUES
(1, 'Headquarters', 'Dallas, TX'),
(2, 'Satellite Office 1', 'New York, NY'),
(3, 'Satellite Office 2', 'San Francisco, CA'),
(4, 'Satellite Office 3', 'Miami, FL');

INSERT INTO Vendor (VendorId, VendorName, AddressLine1, AddressLine2, ZipCode, City, StateCode, AccountNumber, CreditRating, PurchasingWebsite) VALUES
(1, 'Hair Products Inc', '42 Wallaby Way', NULL, '01021', 'Seattle', 'WA', 100, 750, 'hairproductsinc.com'),
(2, 'Superhair', '12 Cookie Ave', NULL, '48952', 'Portland', 'OR', 200, 650, 'superhair.com'),
(3, 'Chair Stuff', '18 Industrial Ave', 'Suite 400', '88431', 'Denver', 'CO', 300, 810, 'chairsupplies.com'),
(4, 'Nice Plastics', '4242 Mermaid Dr', 'Suite 999', '38416', 'Las Vegas', 'NV', 400, 840, 'wedoplastic.com');

INSERT INTO Part (PartId, PartName, PartWeight) VALUES
(1, 'Cup', 3),
(2, 'Cup', 6),
(3, 'Cup', 3),
(4, 'Cup', 2);

INSERT INTO PartVendorMembership (PartId, VendorId, PartPrice) VALUES
(1, 1, 4.00),
(2, 1, 9.00),
(2, 3, 3.00),
(3, 2, 6.00),
(4, 4, 5.00),
(4, 1, 3.00)


INSERT INTO Product (ProductId, ProductType, ProductLength, ProductWidth, ProductDepth, ListPrice, ProductWeight, ProductStyle, SiteId) VALUES
(1, 'Hairdryer', 2, 2, 1, 250.00, 7, 'Pink', 1),
(2, 'Hairbrush', 1, 1, 1, 125.00, 1, 'Blue', 1),
(3, 'Shampoo', 1, 1, 1, 25.00, 2, 'Clear', 3),
(4, 'Conditioner', 1, 1, 1, 30.00, 2, 'White', 4),
(5, 'Mousse', 1, 1, 1, 75.00, 2, 'White', 4),
(6, 'Salon Chair', 6, 3, 3, 450.00, 100, 'Pink', 1);

INSERT INTO Sale (SaleId, ProductId, SaleDateTime) VALUES
(1, 1, '2011-01-01 12:00:00'),
(2, 1, '2011-01-02 12:00:00'),
(3, 2, '2011-01-03 12:00:00'),
(4, 2, '2011-01-04 12:00:00'),
(5, 4, '2011-02-05 12:00:00'),
(6, 5, '2011-02-06 12:00:00'),
(7, 3, '2011-02-07 12:00:00'),
(8, 1, '2011-03-08 12:00:00'),
(9, 2, '2011-04-09 12:00:00'),
(10, 3, '2011-01-10 12:00:00'),
(11, 5, '2011-01-11 12:00:00'),
(12, 1, '2011-02-12 12:00:00'),
(13, 6, '2011-03-12 12:00:00'),
(14, 6, '2011-06-15 12:00:00');

INSERT INTO SiteSaleMembership (SaleId, SiteId) VALUES
(1, 1),
(2, 1),
(3, 3),
(4, 2),
(5, 2),
(6, 2),
(7, 4),
(8, 3),
(9, 4),
(10, 1),
(11, 3),
(12, 1);

INSERT INTO SalesPersonSaleMembership (SaleId, EmployeeId) VALUES
(1, 2),
(1, 3),
(2, 2),
(3, 3),
(4, 2),
(4, 3),
(5, 2),
(5, 6),
(6, 2),
(7, 4),
(7, 2),
(7, 3),
(8, 2),
(8, 3),
(9, 4),
(10, 6),
(11, 3),
(12, 3),
(13, 2),
(14, 3);

INSERT INTO EmployeePaycheck (EmployeeId, TransactionNumber, PayDate, Amount) VALUES
(3, 1, '1/1/2011', 5000.00),
(3, 2, '2/1/2011', 6000.00),
(3, 3, '3/1/2011', 4000.00),
(2, 1, '1/1/2011', 2000.00),
(2, 2, '2/1/2011', 2000.00),
(2, 3, '3/1/2011', 2000.00),
(4, 1, '1/1/2011', 3000.00),
(4, 2, '2/1/2011', 3000.00),
(4, 3, '3/1/2011', 8000.00),
(6, 1, '1/1/2011', 8000.00),
(6, 2, '2/1/2011', 8000.00),
(6, 3, '3/1/2011', 8000.00)