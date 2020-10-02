/* Create Database CarSalesOkBoomer; */

--Names: 
-- Teh Huan Xi Kester (P1922897)
-- Alwinderjit Singh Basant (P1935996)
-- Jason Lou (P1837902)
-- Wong En Ting Kelyn (P1935800)
-- Team: Team OkBoomer
-- Class: DIT/FT/2B/21

Use CarSalesOkBoomer;

DROP TABLE IF EXISTS orderdetails, orders, payments, customersstaging, customers, employees, offices, products, productlines;

CREATE TABLE offices (
officeCode VARCHAR(10) PRIMARY KEY, 
city VARCHAR(50) NOT NULL,
phone VARCHAR(50) NOT NULL,
addressLine1 VARCHAR(50) NOT NULL,
addressLine2 VARCHAR(50),
state VARCHAR(50), 
country VARCHAR(50) NOT NULL,
postalCode VARCHAR(15) NOT NULL,
territory VARCHAR(10) 
);

CREATE TABLE employees (
employeeNumber INT PRIMARY KEY, 
lastName VARCHAR(50) NOT NULL,
firstName VARCHAR(50) NOT NULL,
extension VARCHAR(10) NOT NULL,
email VARCHAR(100) NOT NULL,
officeCode VARCHAR(10) FOREIGN KEY REFERENCES Offices(officeCode) NOT NULL,
reportsTo INT , 
jobTitle VARCHAR(50) NOT NULL,
UNIQUE (employeeNumber, email) 
);

CREATE TABLE customersstaging (
customerNumber INT PRIMARY KEY,
customerName VARCHAR(50) NOT NULL,
contactLastName VARCHAR(50) NOT NULL,
contactFirstName VARCHAR(50) NOT NULL,
phone VARCHAR(50) NOT NULL,
addressLine1 VARCHAR(50) NOT NULL,
addressLine2 VARCHAR(50),
city VARCHAR(50) NOT NULL,
state VARCHAR(50),
postalCode VARCHAR(15),
country VARCHAR(50) NOT NULL,
salesRepEmployeeNumber VARCHAR(50),
creditLimit FLOAT NOT NULL
);

CREATE TABLE customers (
customerNumber INT PRIMARY KEY,
customerName VARCHAR(50) NOT NULL,
contactLastName VARCHAR(50) NOT NULL,
contactFirstName VARCHAR(50) NOT NULL,
phone VARCHAR(50) NOT NULL,
addressLine1 NVARCHAR(50) NOT NULL,
addressLine2 NVARCHAR(50),
city VARCHAR(50) NOT NULL,
state VARCHAR(50), 
postalCode VARCHAR(15), 
country VARCHAR(50) NOT NULL,
salesRepEmployeeNumber INT FOREIGN KEY REFERENCES employees(employeeNumber), 
creditLimit FLOAT NOT NULL 
);

CREATE TABLE payments (
customerNumber INT FOREIGN KEY REFERENCES Customers(customerNumber) NOT NULL, 
checkNumber VARCHAR(50) PRIMARY KEY, 
paymentDate DATETIME NOT NULL,
amount FLOAT NOT NULL 
);

CREATE TABLE orders (
orderNumber INT PRIMARY KEY, 
orderDate DATETIME NOT NULL, 
requiredDate DATETIME NOT NULL,
shippedDate DATETIME,
status VARCHAR(15) NOT NULL,
comments TEXT, 
customerNumber INT FOREIGN KEY REFERENCES Customers(customerNumber) NOT NULL
);

CREATE TABLE productLines (
productLine VARCHAR(50) PRIMARY KEY, 
textDescription TEXT NOT NULL,
htmlDescription TEXT, 
image IMAGE
);

CREATE TABLE products (
productCode VARCHAR(15) PRIMARY KEY, 
productName VARCHAR(70) NOT NULL,
productLine VARCHAR(50) FOREIGN KEY REFERENCES ProductLines(productLine) NOT NULL,
productScale VARCHAR(10) NOT NULL,
productVendor VARCHAR(50) NOT NULL,
productDescription TEXT NOT NULL,
quantityInStock INT NOT NULL, 
buyPrice FLOAT NOT NULL, 
MSRP FLOAT NOT NULL
);

CREATE TABLE orderdetails (
orderNumber INT FOREIGN KEY REFERENCES Orders(orderNumber), 
productCode VARCHAR(15) FOREIGN KEY REFERENCES Products(productCode), 
quantityOrdered INT NOT NULL,
priceEach FLOAT NOT NULL, 
orderLineNumber SMALLINT NOT NULL
);