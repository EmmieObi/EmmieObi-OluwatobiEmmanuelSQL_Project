--1. List all the orders placed by each employee,including employee name,order ID, and order date.
-- This will require that i join the Employee,SalesOrderHeader, and Person tables to get the employee 
--details with their orders
SELECT 
    e.BusinessEntityID,
    p.FirstName,
    p.LastName,
    soh.SalesOrderID,
    soh.OrderDate
FROM 
    Sales.SalesOrderHeader soh
JOIN 
    HumanResources.Employee e ON soh.SalesPersonID = e.BusinessEntityID
JOIN 
    Person.Person p ON e.BusinessEntityID = p.BusinessEntityID;


--2. What are the total sales amounts for each product in each sales territory
--This requires joining the SalesOrderDetail,SalesOderHeader,Product,and SalesTerritory tables to aggregate sales data by
--product and territory.
SELECT 
    p.Name AS ProductName,
    st.Name AS TerritoryName,
    SUM(sod.LineTotal) AS TotalSales
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
JOIN 
    Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
GROUP BY 
    p.Name, st.Name;


--3. For each customer, list the names along with the details of products they have purchased,including product name,
--order date, and quantity.
--This will require joining the customer,SalesOrderHeader,SalesOrderDetail,Product and Person tables.

SELECT 
    c.CustomerID,
    p.FirstName,
    p.LastName,
    prod.Name AS ProductName,
    soh.OrderDate,
    sod.OrderQty
FROM 
    Sales.Customer c
JOIN 
    Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN 
    Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN 
    Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product prod ON sod.ProductID = prod.ProductID;
	SELECT * FROM HumanResources.EmployeeDepartmentHistory

--4. The head of HR wants to know all employed staffs in the company,provide a list of employees, include their department name and
--job title.
--This requires joining the Employee,Department,EmployeeDepartmentHistory and Job title tables.

SELECT 
    e.BusinessEntityID,
    p.FirstName,
    p.LastName,
    d.Name AS DepartmentName,
    e.JobTitle
FROM 
    HumanResources.Employee e
JOIN 
    Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN 
    HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN 
    HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE 
    edh.EndDate IS NULL;


--5. Which products have generated the highest total sales revenue.
--this involves joining the SalesOrderDetail and product tables

SELECT 
    p.Name AS ProductName,
    SUM(sod.LineTotal) AS TotalSales
FROM 
    Sales.SalesOrderDetail sod
JOIN 
    Production.Product p ON sod.ProductID = p.ProductID
GROUP BY 
    p.Name
ORDER BY 
    TotalSales DESC;

--6. Which customer placed orders in the last 10 years, and what were the details of these orders.
--this requires joining the customer,SalesOrderHeader,SalesOrderDetail,Product, and Person tables

SELECT 
    c.CustomerID,
    pe.FirstName,
    pe.LastName,
    soh.SalesOrderID,
    soh.OrderDate,
    prod.Name AS ProductName,
    sod.OrderQty,
    sod.LineTotal
FROM 
    Sales.Customer c
JOIN 
    Person.Person pe ON c.PersonID = pe.BusinessEntityID
JOIN 
    Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN 
    Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product prod ON sod.ProductID = prod.ProductID
WHERE 
    soh.OrderDate >= DATEADD(year, -10, GETDATE());


--7. Provide a list of all products and their suppliers,including products that do not have a supplier

SELECT 
    p.ProductID,
    p.Name AS ProductName,
    pv.BusinessEntityID AS SupplierID,
    v.Name AS SupplierName
FROM 
    Production.Product p
LEFT JOIN 
    Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
LEFT JOIN 
    Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID;

--8.Provide a list of only products that have an associated supplier
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    pv.BusinessEntityID AS SupplierID,
    v.Name AS SupplierName
FROM 
    Production.Product p
JOIN 
    Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN 
    Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID;

--9. What is the current inventory level for each product from the highest to the least.

SELECT PRODUCTID,LOCATIONID,QUANTITY
FROM PRODUCTION.ProductInventory
ORDER BY Quantity DESC


--10. How many sales orders have been placed

select count(*) as totalsalesorders from Sales.SalesOrderHeader


--11. Find all customers and the number of orders they have placed. The output should also entail customerID,firstname and
--lastname 

SELECT c.CustomerID, p.FirstName, p.LastName, COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Person p ON c.CustomerID = P.BusinessEntityID 
GROUP BY c.CustomerID, p.FirstName, p.LastName;

--12. Retrieve the details of employees who have worked on production related job titles 

select e.BusinessEntityID,p.FirstName,p.LastName,e.JobTitle 
from HumanResources.Employee e
Join Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
Where e.JobTitle like '%production%'

--13. List all products along with their Inventory quantities

SELECT p.ProductID,p.Name AS ProductName,ISNULL(ppi.Quantity, 0) AS InventoryQuantity
FROM Production.Product p
LEFT JOIN Production.ProductInventory ppi ON P.ProductID = ppi.ProductID

--14. Find the top 5 customers by total purchase amount  

SELECT TOP 5 c.CustomerID, p.FirstName, p.LastName, SUM(soh.TotalDue) AS TotalPurchaseAmount
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Person p ON c.CustomerID = p.BusinessEntityID
GROUP BY c.CustomerID, p.FirstName, p.LastName
ORDER BY TotalPurchaseAmount DESC;

--15. List the names of products that have more than one review

SELECT p.Name
FROM Production.Product p
WHERE p.ProductID IN (select ProductID
                      from Production.ProductReview
                      Group by ProductID
                      Having COUNT(ProductReviewID) > 1);