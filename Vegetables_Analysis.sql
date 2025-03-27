--------------------------Market & Pricing Analysis----------------------

SELECT name, price_per_kg
FROM [dbo].[vegetables]

--1.Which vegetables have the highest and lowest average market prices?
--  Find the top 5 most and least expensive vegetables based on their price per unit or weight.

--TOP 5 most expensive
SELECT TOP(5) name, AVG(price_per_kg) AS Average_Price
FROM [dbo].[vegetables]
GROUP BY name
ORDER BY Average_Price DESC

--Top 5 leas expensive
SELECT TOP(5) name, AVG(price_per_kg) AS Average_Price
FROM [dbo].[vegetables]
GROUP BY name
ORDER BY Average_Price

--2.How do vegetable prices vary by season?
--  Analyze the average price of vegetables across different seasons to identify trends.

SELECT Season, AVG(price_per_kg) AS AvgPrice
FROM [dbo].[vegetables]
GROUP BY season
ORDER BY AvgPrice DESC;


--3.What is the price difference between seasonal and year-round available vegetables?
-- Compare the average prices of vegetables available seasonally versus those available year-round.

SELECT Availability, AVG(price_per_kg) AS AvgPrice, COUNT(*) AS Number_of_Vegetables
FROM [dbo].[vegetables]
WHERE Availability IN ('Seasonal','Year-round')
GROUP BY Availability

-----------------------------------Availability & Shelf Life Analysis------------------

--4.Which vegetables have the longest and shortest shelf life?
--  Identify vegetables with the longest and shortest average shelf life and their storage requirements.

--Shortest avg life
SELECT name, Storage_requirements, AVG(Shelf_Life_days) AS Avg_Life
FROM [dbo].[vegetables]
GROUP BY Name, Storage_requirements
HAVING AVG(Shelf_Life_days) = (
    SELECT MIN(Avg_Life) 
    FROM (
        SELECT AVG(Shelf_Life_days) AS Avg_Life
        FROM [dbo].[vegetables]
        GROUP BY Name, Storage_requirements
    ) AS SubQuery
)
ORDER BY Avg_Life;



--longest avg life
SELECT name, Storage_requirements, AVG(Shelf_Life_days) AS Avg_Life
FROM [dbo].[vegetables]
GROUP BY Name, Storage_requirements
HAVING AVG(Shelf_Life_days) = (
    SELECT MAX(Avg_Life) 
    FROM (
        SELECT AVG(Shelf_Life_days) AS Avg_Life
        FROM [dbo].[vegetables]
        GROUP BY Name, Storage_requirements
    ) AS SubQuery
)
ORDER BY Avg_Life DESC;

--5.Which vegetables are most commonly available year-round?
-- Find vegetables that have high availability across all seasons.

SELECT 
    Name, 
    Category, 
    Availability, 
    COUNT(*) AS Availability_Count
FROM [dbo].[vegetables]
WHERE Availability = 'Year-round'
GROUP BY Name, Category, Availability
ORDER BY Availability_Count DESC;

----------------------------------Regional & Agricultural Trends----------------------

--6.What are the most common vegetables grown in each region?
-- Find which vegetables are most frequently grown in different geographic locations.


SELECT 
    Origin AS Region,  
    Name AS Vegetable,  
    COUNT(*) AS Count
FROM Vegetables
GROUP BY Origin, Name
ORDER BY Count DESC;


--7.How do growing conditions affect vegetable availability?
-- Examine how soil type, water requirements, and sunlight impact vegetable availability across regions.

SELECT 
    v.Name AS Vegetable_Name,
    v.Category,
    v.Season,
    v.Availability,
    v.Growing_Conditions,
    COUNT(*) OVER (PARTITION BY v.Growing_Conditions) AS Count_By_Growing_Condition
FROM 
    Vegetables v
ORDER BY 
    Count_By_Growing_Condition DESC, v.Availability DESC;

------------------------------------------Varietal & Category Analysis--------------------------

--8.which vegetable categories (e.g., Root, Leafy, Tubers) have the highest diversity in terms of varieties?
--   Find out which vegetable categories have the most variety and analyze their distribution.


SELECT category, common_varieties, COUNT(*) as Highest_Diversity_Varieties
FROM vegetables
group by category, common_varieties
order by Highest_Diversity_Varieties DESC