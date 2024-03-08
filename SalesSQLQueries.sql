CREATE DATABASE Sales_DA;

USE Sales_DA;
-- Performing ETL 
	-- E- Extract
		-- imported the csv file in the form table sales_data 
		-- Verifying  - first few rows
		SELECT * FROM sales_data LIMIT 5;

	-- Exploration for Transformation
		-- number of rows
		SELECT COUNT(*) AS TotalRows FROM sales_data;  
			-- 185950 Rows 
            
		-- number of columns 
		SELECT COUNT(*)
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'sales_data';
			--  11 columns
            
		DESCRIBE sales_data;
		-- insights : All the datatypes are correct.
        
		-- T - Transform 
			-- Renaming the columns the 
			ALTER TABLE Sales_Data
			RENAME COLUMN MyUnknownColumn TO S_NO,
			RENAME COLUMN `Order ID` TO Order_ID,
			RENAME COLUMN `Quantity Ordered` TO Quantity_Ordered,
			RENAME COLUMN `Price Each` TO Price_Each,
			RENAME COLUMN `Order Date` TO Order_Date,
			RENAME COLUMN `Purchase Address` TO Purchase_Address; 
            
            -- spliting Order date into date and time 
				-- Add new columns for Date and TimeStamp
				ALTER TABLE Sales_Data
				ADD COLUMN OrderDate DATE,
				ADD COLUMN OrderTime TIME;
                
                SET SQL_SAFE_UPDATES = 0; -- safe mode off 

				-- Update the new columns with values from the OrderDate column
				UPDATE Sales_Data
				SET OrderDate = DATE(Order_Date),
					OrderTime = TIME(Order_Date);
                    
				SELECT * FROM sales_data LIMIT 5; 

				SET SQL_SAFE_UPDATES = 1;  -- safe mode on
                
                
            -- L - Load 
			/* Will load this data to powerbi so as to do Visualised Analysis using Interactive Dashboard*/
            
-- Data Analysis ( Analyzing  Sales )   
	-- Best-selling products
	SELECT Product, SUM(Quantity_Ordered) AS TotalQuantitySold
	FROM Sales_Data
	GROUP BY Product
	ORDER BY TotalQuantitySold DESC
	LIMIT 5;
    /* Insights : Product Maximumly Ordered - AAA Batteries (4-pack) */

	-- Total sales for each city          
	SELECT City, ROUND(SUM(Sales),2) AS TotalSales
	FROM Sales_Data
	GROUP BY City
    ORDER BY TotalSales DESC;   
	/* Insights : • total number of products -5
				  • PRoduct Maximumly sold : AAA Batteries (4-pack) */
    
	-- Revenue metrics
	SELECT ROUND(SUM(Sales), 2) AS TotalRevenue,
       ROUND(AVG(Price_Each), 2) AS AveragePrice,
       Floor(AVG(Quantity_Ordered))AS AverageQuantity_Ordered
	FROM Sales_data;
    /* Insights : • Total revenue was 34.49 million.
				  • Average Quantity : 184.40
                  • Average Order Quantity : 1  */
    
	-- Sales trend over time
	SELECT MONTH, ROUND(SUM(Sales),2) AS TotalSales
	FROM Sales_Data
	GROUP BY MONTH
	ORDER BY TotalSales DESC;
	/* Insights : • Maximum sales was in December
				  • Minimum sales was in January
                  • Average Order Quantity : 1  */
