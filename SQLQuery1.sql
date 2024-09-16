-- EXPLOROTARY DATA ANALYSIS
USE world_layoffs

SELECT * 
FROM layoffs_staging

-- highest layoff

-- change varchar values into int values in laid off column
SELECT total_laid_off, CAST(total_laid_off AS INT) AS ConvertedInt
FROM layoffs_staging;

UPDATE layoffs_staging
SET total_laid_off = CAST(total_laid_off AS INT); 

-- change data type of the total_laid_off to INT
ALTER TABLE layoffs_staging
ALTER COLUMN total_laid_off INT;

-- check the highest amount of laid off happen 

SELECT MAX(total_laid_off) AS max_total_laid_off, MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoffs_staging
 
-- IT 12,000 employeers in one time. 
-- maximum laid off percentage is 1% which means 100. 

-- let's group by the companies to check how much each company has go for a lay off 

SELECT company, SUM(total_laid_off) as total_layoff
FROM layoffs_staging
GROUP BY company
ORDER BY 2 DESC;-- 2 means the second column here which is sum of total laid off

-- as we can see the most famouse companies has gone for heigher lay off specially Amazone. they have layoff 18150 employees. 

SELECT MAX(date) as maximum, MIN(date) as minimum
FROM layoffs_staging;

-- what industries went for a highest layoffs
SELECT industry, SUM(total_laid_off) as sum_layoff
FROM layoffs_staging
GROUP BY industry
ORDER BY 2 DESC;
-- we can see that consumer industry has gone for 45182 lay off which can notice as the highest. 

-- laidoff country wise 
SELECT country, SUM(total_laid_off) as sum_layoff
FROM layoffs_staging
GROUP BY country
ORDER BY 2 DESC;

-- US has taken over highest number of lay off which makes sense. US and India has very high effect from covid- 19

-- laidoff year wise 
SELECT YEAR(date) as 'year', SUM(total_laid_off) as sum_layoff
FROM layoffs_staging
GROUP BY YEAR(date)
ORDER BY 2 DESC;

-- highest layoff has happened on year 2022.

-- different stages of company
SELECT stage, SUM(total_laid_off) as sum_layoff
FROM layoffs_staging
GROUP BY stage
ORDER BY 2 DESC;

--rolling call by year and month
SELECT FORMAT(date,'yyyy-MM') AS year_month, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY FORMAT(date,'yyyy-MM')
ORDER BY 2 DESC;



/*

ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW: This ensures that the rolling sum works correctly for each 
row from the beginning to the current row, which is a standard approach for calculating rolling totals.
*/


	WITH rolling_total AS
(
    SELECT 
        FORMAT([date],'yyyy-MM') AS year_month, 
        SUM(total_laid_off) AS layoff_sum
    FROM 
        layoffs_staging
	WHERE FORMAT([date],'yyyy-MM') IS NOT NULL
    GROUP BY 
        FORMAT([date],'yyyy-MM')
)
SELECT 
    year_month, layoff_sum,
    SUM(layoff_sum) OVER(ORDER BY year_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rolling_total
FROM 
    rolling_total
ORDER BY 
    year_month;

-- lets look how much each company has layoff employees in each year 

SELECT company, YEAR(date) as year, SUM(total_laid_off) as sum_layoff
FROM layoffs_staging
GROUP BY company, YEAR(date)
ORDER BY 1 ASC;


WITH company_year (company, year, layoff_sum)AS
(SELECT company, YEAR(date), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company, YEAR(date)),
company_ranking AS
(SELECT *, DENSE_RANK()OVER(PARTITION BY year ORDER BY layoff_sum DESC) AS ranking
FROM company_year
WHERE year IS NOT NULL)
SELECT * 
FROM company_ranking
WHERE ranking <= 5;




select * 
from layoffs_staging
