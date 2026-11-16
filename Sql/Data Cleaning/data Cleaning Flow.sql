-- Data Cleaning 

SELECT * 
FROM world_layoffs.layoffs;

-- 1 . Remove the Duplicates 
-- 2. Standradize the data : it a remove spaces and spellings 
-- 3. Null Values Or Blank Values 
-- 4. Remove the any Colums and Rows 

CREATE TABLE layoffs_staging 
LIKE layoffs;

SELECT*
FROM layoffs_staging;

INSERT layoffs_staging 
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = "Casper";

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num >1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `total_laid_off` text,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` int DEFAULT NULL,
  `country` text,
  `date_added` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

-- Standardizing data 

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company); 

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY location;

select country, trim(country)
from layoffs_staging2;

select distinct country
from layoffs_staging2
order by country;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off = '' AND percentage_laid_off = '';

DELETE
FROM layoffs_staging2
WHERE total_laid_off = '' AND percentage_laid_off = '';

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;
