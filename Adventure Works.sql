# Total Revenue
select concat(round((sum(salesamount*OrderQuantity)/1000000),2),' M') as Total_Revenue 
from adventureworks.fact_internet_sales;

# Total Profit
select concat(round((sum(salesamount*OrderQuantity)-sum(ProductStandardCost*OrderQuantity))/1000000,2),' M') as Total_Profit 
from adventureworks.fact_internet_sales;

# Total Orders
select concat(round(count(OrderQuantity)/1000,2),' K') as Total_orders
from adventureworks.fact_internet_sales;

# Total Customers
select Concat(round(count(distinct(CustomerKey))/1000,2)," K") Total_Customers 
from adventureworks.fact_internet_sales;

# Previous Year revenue
select concat(round((sum(salesamount*OrderQuantity)/1000000),2),' M') AS Prev_year_Revenue 
from adventureworks.fact_internet_sales
where year(date(OrderDateKey))=2012;

# Month Wise Total revenue
SELECT month(date(OrderDatekey)) AS Monthno,monthname(date(OrderDatekey)) AS Month,
concat(round((sum(salesamount*OrderQuantity)/1000000),1),' M') AS TotalRevenue,
concat(round((sum(salesamount*OrderQuantity)-sum(ProductStandardCost*OrderQuantity))/1000000,1),' M') as Total_Profit 
FROM adventureworks.fact_internet_sales	
GROUP BY MONTH,Monthno
ORDER BY Monthno ;

# Year Wise sales 
SELECT Year(date(OrderDatekey)) AS Year,
concat(round((sum(salesamount*OrderQuantity)/1000000),2),' M') AS TotalSales
FROM adventureworks.fact_internet_sales	
GROUP BY year
ORDER BY year;
 
# Subcategory Wise Orders
select EnglishProductSubcategoryName as Subcategories,concat(round(count(OrderQuantity)/1000,1),' K') as Total_orders from adventureworks.fact_internet_sales fs 
inner join dimproduct dp on fs.ProductKey=dp.ProductKey
inner join dimproductsubcategory Ds on Ds.ProductSubcategoryKey=dp.ProductSubcategoryKey
group by EnglishProductSubcategoryName;

# Category Wise Sales
select EnglishProductcategoryName as Categories,concat(round((sum(salesamount*OrderQuantity)/1000000),2),' M') AS TotalSales from adventureworks.fact_internet_sales fs 
inner join dimproduct dp on fs.ProductKey=dp.ProductKey
inner join dimproductsubcategory Ds on Ds.ProductSubcategoryKey=dp.ProductSubcategoryKey
inner join dimproductcategory dpc on dpc.ProductCategoryKey=ds.ProductCategoryKey
group by EnglishProductcategoryName;
 
 
# Country Wise sales
select SalesTerritoryCountry,concat(round((sum(salesamount*OrderQuantity)/1000000),2),' M') AS TotalSales 
from adventureworks.fact_internet_sales Fs inner join dimsalesterritory Ds on Fs.SalesTerritoryKey=Ds.SalesTerritoryKey
group by SalesTerritoryCountry;

# QuarterWise TotalRevenue
SELECT Quarter(date(OrderDatekey)) AS Quarter,
concat(round((sum(salesamount*OrderQuantity)/1000000),2),' M') AS TotalSales
FROM adventureworks.fact_internet_sales	
GROUP BY Quarter
ORDER BY Quarter ;

# CategoryWise Total orders
select EnglishProductcategoryName as Categories,concat(round(count(OrderQuantity)/1000,1),' K') as Total_orders 
from adventureworks.fact_internet_sales fs 
inner join dimproduct dp on fs.ProductKey=dp.ProductKey
inner join dimproductsubcategory Ds on Ds.ProductSubcategoryKey=dp.ProductSubcategoryKey
inner join dimproductcategory dpc on dpc.ProductCategoryKey=ds.ProductCategoryKey
group by EnglishProductcategoryName;

# Top 5 Products By Orders
select EnglishProductName as Products,concat(round(sum(OrderQuantity)/1000,1),' K') as Total_orders 
from adventureworks.fact_internet_sales fs 
inner join dimproduct dp on fs.ProductKey=dp.ProductKey
group by EnglishProductName
order by Total_orders desc
limit 5;

# TotalOrders by Education
select EnglishEducation,concat(round(sum(OrderQuantity)/1000,2),' K') as Total_orders 
from adventureworks.fact_internet_sales fs 
inner join dimcustomer Dc on fs.CustomerKey=Dc.CustomerKey
group by EnglishEducation
order by round(count(OrderQuantity)/1000,2) desc;

# TotalOrders by Occupation
select EnglishOccupation as Occupation,concat(round(sum(OrderQuantity)/1000,2),' K') as Total_orders 
from adventureworks.fact_internet_sales fs 
inner join dimcustomer Dc on fs.CustomerKey=Dc.CustomerKey
group by EnglishOccupation
order by round(count(OrderQuantity)/1000,2) desc;

# TotalOrders by Gender
select Gender ,concat(round(sum(OrderQuantity)/1000,2),' K') as Total_orders 
from adventureworks.fact_internet_sales fs 
inner join dimcustomer Dc on fs.CustomerKey=Dc.CustomerKey
group by Gender
order by round(sum(OrderQuantity)/1000,2) desc;


# TotalOrders by Age
select timestampdiff(Year,dob,curdate()) as Age,concat((sum(OrderQuantity)),' K') as Total_orders 
from adventureworks.fact_internet_sales fs 
inner join dimcustomer Dc on fs.CustomerKey=Dc.CustomerKey
group by Age 
order by round (sum(OrderQuantity)/1000,2) desc;

# Overall report
SELECT
fact_internet_sales.SalesOrderNumber,
fact_internet_sales.OrderDate,
fact_internet_sales.OrderQuantity,
sum(fact_internet_sales.TotalProductCost) AS TotalProductCost,
sum(fact_internet_sales.SalesAmount) AS TotalSalesAmount,
sum(fact_internet_sales.SalesAmount) - sum(fact_internet_sales.TotalProductCost) AS GrossMargin,
(sum(fact_internet_sales.SalesAmount) - sum(fact_internet_sales.TotalProductCost)) / sum(fact_internet_sales.SalesAmount) AS GrossMarginPct,
DimProduct.EnglishProductName AS ProductName,
DimProductCategory.EnglishProductCategoryName AS ProductCategory,
DimProductSubcategory.EnglishProductSubcategoryName AS ProductSubcategory,
DimSalesTerritory.SalesTerritoryRegion AS SalesTerritoryRegion,
DimSalesTerritory.SalesTerritoryCountry AS SalesTerritoryCountry
FROM fact_internet_sales
INNER JOIN DimProduct ON fact_internet_sales.ProductKey = DimProduct.ProductKey
INNER JOIN DimProductSubcategory ON DimProductSubcategory.ProductSubcategoryKey = DimProduct.ProductSubcategoryKey
INNER JOIN DimProductCategory ON DimProductCategory.ProductCategoryKey = DimProductSubcategory.ProductCategoryKey
INNER JOIN DimSalesTerritory ON fact_internet_sales.SalesTerritoryKey = DimSalesTerritory.SalesTerritoryKey
GROUP BY 
fact_internet_sales.SalesOrderNumber, 
fact_internet_sales.OrderDate,
fact_internet_sales.OrderQuantity,
DimProduct.EnglishProductName,
DimProductCategory.EnglishProductCategoryName,
DimProductSubcategory.EnglishProductSubcategoryName,
DimSalesTerritory.SalesTerritoryRegion,
DimSalesTerritory.SalesTerritoryCountry
ORDER BY SalesOrderNumber DESC;
