/* CREATE DATABASE CarSalesOkBoomerDW; */

--Names: 
-- Teh Huan Xi Kester (P1922897)
-- Alwinderjit Singh Basant (P1935996)
-- Jason Lou (P1837902)
-- Wong En Ting Kelyn (P1935800)
-- Team: Team OkBoomer
-- Class: DIT/FT/2B/21

Use CarSalesOkBoomerDW;

DROP TABLE IF EXISTS SalesFacts, EmployeesDIM, OfficesDIM, ProductsDIM, CustomersDIM, TimeDIM, OfficesStaging, CustomersStaging;

CREATE TABLE TimeDIM (	
		[TimeKey] INT primary key, 
		[Date] DATETIME,
		[FullDateUK] CHAR(10), -- Date in dd-MM-yyyy format
		[FullDateUSA] CHAR(10),-- Date in MM-dd-yyyy format
		[DayOfMonth] VARCHAR(2), -- Field will hold day number of Month
		[DaySuffix] VARCHAR(4), -- Apply suffix as 1st, 2nd ,3rd etc
		[DayName] VARCHAR(9), -- Contains name of the day, Sunday, Monday 
		[DayOfWeekUSA] CHAR(1),-- First Day Sunday=1 and Saturday=7
		[DayOfWeekUK] CHAR(1),-- First Day Monday=1 and Sunday=7
		[DayOfYear] VARCHAR(3),
		[WeekOfMonth] VARCHAR(1),-- Week Number of Month 
		[WeekOfQuarter] VARCHAR(2), --Week Number of the Quarter
		[WeekOfYear] VARCHAR(2),--Week Number of the Year
		[Month] VARCHAR(2), --Number of the Month 1 to 12
		[MonthName] VARCHAR(9),--January, February etc
		[MonthOfQuarter] VARCHAR(2),-- Month Number belongs to Quarter
		[Quarter] CHAR(1),
		[QuarterName] VARCHAR(9),--First,Second..
		[Year] CHAR(4),-- Year value of Date stored in Row
		[YearName] CHAR(7), --CY 2012,CY 2013
		[MonthYear] CHAR(10), --Jan-2013,Feb-2013
		[MMYYYY] CHAR(6),
		[FirstDayOfMonth] DATE,
		[LastDayOfMonth] DATE,
		[FirstDayOfQuarter] DATE,
		[LastDayOfQuarter] DATE,
		[FirstDayOfYear] DATE,
		[LastDayOfYear] DATE,
		[IsHolidayUSA] BIT,-- Flag 1=National Holiday, 0-No National Holiday
		[IsWeekday] BIT,-- 0=Week End ,1=Week Day
		[HolidayUSA] VARCHAR(50),--Name of Holiday in US
		[IsHolidayUK] BIT Null,
		[HolidayUK] VARCHAR(50) Null --Name of Holiday in UK
);

CREATE TABLE OfficesDIM (
OfficesSK INT IDENTITY(1,1) PRIMARY KEY,
officeCode VARCHAR(10) NOT NULL, 
city VARCHAR(50) NOT NULL,
addressLine1 VARCHAR(50) NOT NULL,
addressLine2 VARCHAR(50),
state VARCHAR(50), /* Null by default */
country VARCHAR(50) NOT NULL,
territory VARCHAR(10) 
);

CREATE TABLE EmployeesDIM (
EmployeeSK INT IDENTITY(1,1) PRIMARY KEY,
employeeNumber INT NOT NULL, 
lastName VARCHAR(50) NOT NULL,
firstName VARCHAR(50) NOT NULL,
email VARCHAR(100) NOT NULL,
reportsTo INT, 
jobTitle VARCHAR(50) NOT NULL
UNIQUE (employeeNumber, email) /* Leave it for now */
);

CREATE TABLE ProductsDIM (
ProductSK INT IDENTITY(1,1) PRIMARY KEY,
productCode VARCHAR(15) NOT NULL, 
productName VARCHAR(70) NOT NULL,
productLine VARCHAR(50) NOT NULL,
productScale VARCHAR(10) NOT NULL,
productVendor VARCHAR(50) NOT NULL,
productDescription TEXT NOT NULL,
quantityInStock INT NOT NULL, 
buyPrice FLOAT NOT NULL, 
MSRP FLOAT NOT NULL
);

CREATE TABLE CustomersDIM (
CustomerSK INT IDENTITY(1,1) PRIMARY KEY,
customerNumber INT NOT NULL,
customerName VARCHAR(50) NOT NULL,
contactLastName VARCHAR(50) NOT NULL,
contactFirstName VARCHAR(50) NOT NULL,
addressLine1 VARCHAR(50) NOT NULL,
addressLine2 VARCHAR(50),
city VARCHAR(50) NOT NULL,
state VARCHAR(50),
country VARCHAR(50) NOT NULL,
creditLimit FLOAT NOT NULL
);

CREATE TABLE SalesFacts (
OrderSK INT IDENTITY(1, 1),
OfficesSK INT NOT NULL,
ProductSK INT NOT NULL,
CustomerSK INT NOT NULL,
EmployeeSK INT NOT NULL,
orderNumber INT NOT NULL,
quantityOrdered INT NOT NULL,
priceEach FLOAT NOT NULL,
orderLineNumber INT NOT NULL,
orderStatus VARCHAR(15) NOT NULL,
orderDate INT FOREIGN KEY REFERENCES TimeDIM(TimeKey) NOT NULL,
shippedDate INT FOREIGN KEY REFERENCES TimeDIM(TimeKey),
requiredDate INT FOREIGN KEY REFERENCES TimeDIM(TimeKey),
officeCode VARCHAR(10) NOT NULL,
FOREIGN KEY (OfficesSK) REFERENCES OfficesDIM(OfficesSK),
FOREIGN KEY (ProductSK) REFERENCES ProductsDIM(ProductSK),
FOREIGN KEY (CustomerSK) REFERENCES CustomersDIM(CustomerSK),
FOREIGN KEY (EmployeeSK) REFERENCES EmployeesDIM(EmployeeSK),
PRIMARY KEY (OrderSK,OfficesSK, ProductSK, CustomerSK, EmployeeSK)
);