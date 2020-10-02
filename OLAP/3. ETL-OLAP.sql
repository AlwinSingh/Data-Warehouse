--Names: 
-- Teh Huan Xi Kester (P1922897)
-- Alwinderjit Singh Basant (P1935996)
-- Jason Lou (P1837902)
-- Wong En Ting Kelyn (P1935800)
-- Team: Team OkBoomer
-- Class: DIT/FT/2B/21

/* Inconsistency rectify*/

Use CarSalesOkBoomerDW;
DROP TABLE IF EXISTS OfficesStaging, CustomersStaging;

CREATE TABLE OfficesStaging (
officeCode VARCHAR(10) PRIMARY KEY, 
city VARCHAR(50) NOT NULL,
addressLine1 VARCHAR(50) NOT NULL,
addressLine2 VARCHAR(50),
state VARCHAR(50), 
country VARCHAR(50) NOT NULL,
territory VARCHAR(10) 
);

/* Offices Validation */
INSERT INTO CarSalesOkBoomerDW..OfficesStaging(officeCode, city, addressLine1, addressLine2, state, country, territory)
SELECT 
	officeCode, city, addressLine1, addressLine2, state, country, territory 
FROM 
	CarSalesOkBoomer..Offices

/* Update Statements */
update OfficesStaging set state = null where state = '';
update OfficesStaging set country = 'Japan' where territory = 'Japan';
update OfficesStaging set territory = 'JP' where territory = 'Japan';
update OfficesStaging set country = 'United States of America' where country = 'USA';
update OfficesStaging set country = 'United Kingdom' where country = 'UK';

INSERT INTO CarSalesOkBoomerDW..OfficesDIM(officeCode, city, addressLine1, addressLine2, state, country, territory)
SELECT 
	officeCode, city, addressLine1, addressLine2, state, country, territory 
FROM 
	CarSalesOkBoomerDW..OfficesStaging;

DROP TABLE IF EXISTS OfficesStaging;

/* Products Validation */
/* No validation required */
INSERT INTO CarSalesOkBoomerDW..ProductsDIM(productCode, productName, productLine, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP)
SELECT 
	productCode, productName, productLine, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP
FROM 
	CarSalesOkBoomer..Products

/* Employee Validation */
/* No validation required */
INSERT INTO CarSalesOkBoomerDW..EmployeesDIM(employeeNumber, lastName, firstName, email, reportsTo, jobTitle)
SELECT 
	employeeNumber, lastName, firstName, email, reportsTo, jobTitle
FROM 
	CarSalesOkBoomer..Employees

/* Customers Validation */
CREATE TABLE CustomersStaging (
customerNumber INT PRIMARY KEY,
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

INSERT INTO CarSalesOkBoomerDW..CustomersStaging(customerNumber, customerName, contactLastName, contactFirstName, addressLine1, addressLine2, city, state, country, creditLimit)
SELECT 
	customerNumber, customerName, contactLastName, contactFirstName, addressLine1, addressLine2, city, state, country, creditLimit
FROM 
	CarSalesOkBoomer..Customers

/* Update Statements */
-- Before we found the code page ACP.
-- update CustomersStaging set city = 'Köln' where city = 'K÷ln';
-- update CustomersStaging set city = 'Aarhus' where city = '+rhus';
-- update CustomersStaging set city = 'Montreal' where city = 'MontrTal';
-- update CustomersStaging set city = 'Geneva' where city = 'GenFve';
-- update CustomersStaging set city = 'München' where city = 'Mnnchen';
-- update CustomersStaging set city = 'Münster' where city = 'Mnnster';
-- update CustomersStaging set city = 'Bräcke' where city = 'BrScke';
-- update CustomersStaging set state = 'Quebec' where state = 'QuTbec';
update CustomersStaging set country = 'United States of America' where country = 'USA';
update CustomersStaging set country = 'United Kingdom' where country = 'UK';

INSERT INTO CarSalesOkBoomerDW..CustomersDIM(customerNumber, customerName, contactLastName, contactFirstName, addressLine1, addressLine2, city, state, country, creditLimit)
SELECT 
	customerNumber, customerName, contactLastName, contactFirstName, addressLine1, addressLine2, city, state, country, creditLimit
FROM 
	CarSalesOkBoomerDW..CustomersStaging

DROP TABLE IF EXISTS CustomersStaging;

/* SalesFacts Validation */
/* No validation required*/
INSERT INTO CarSalesOkBoomerDW..SalesFacts(OfficesSK, ProductSK, CustomerSK, EmployeeSK, orderNumber, quantityOrdered, 
priceEach, orderLineNumber, orderStatus, 
orderDate, shippedDate, requiredDate, officeCode

)
SELECT
	OfficesDIM.officesSK, productsDIM.ProductSK, CustomersDIM.CustomerSK, EmployeesDIM.EmployeeSK, orderdetails.orderNumber,
	orderdetails.quantityOrdered, 
	orderdetails.priceEach,
	orderdetails.orderLineNumber, 
	orders.status,

	replace(CONVERT(DATE,orders.orderDate),'-',''), replace(CONVERT(DATE,orders.shippedDate),'-',''), replace(CONVERT(DATE,orders.requiredDate),'-',''),
	OfficesDIM.OfficesSK
	
	FROM CarSalesOkBoomer..orderdetails

	INNER JOIN CarSalesOkBoomerDW..ProductsDIM ON CarSalesOkBoomerDW..ProductsDIM.productCode = orderdetails.productCode
	INNER JOIN CarSalesOkBoomer..orders ON CarSalesOkBoomer..orders.orderNumber = orderdetails.orderNumber
	INNER JOIN CarSalesOkBoomerDW..CustomersDIM ON CarSalesOkBoomerDW..CustomersDIM.customerNumber = orders.customerNumber
	INNER JOIN CarSalesOkBoomer..Customers ON CarSalesOkBoomerDW..CustomersDIM.customerNumber = CarSalesOkBoomer..Customers.customerNumber
	INNER JOIN CarSalesOkBoomer..Employees ON CarSalesOkBoomer..Employees.employeeNumber = Customers.salesRepEmployeeNumber
	INNER JOIN CarSalesOkBoomerDW..EmployeesDIM ON CarSalesOkBoomerDW..EmployeesDIM.employeeNumber = Customers.salesRepEmployeeNumber
	INNER JOIN CarSalesOkBoomerDW..OfficesDIM ON CarSalesOkBoomerDW..OfficesDIM.officeCode = CarSalesOkBoomer..Employees.officeCode

