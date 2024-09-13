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

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging
 
-- IT 12,000 employeers in one time. 
-- maximum laid off percentage is 1% which means 100. 




