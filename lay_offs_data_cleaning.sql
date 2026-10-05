-- Data Cleaning 

select * 
from layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data 
-- 3. Null values or Blank values
-- 4. Remove any column


CREATE TABLE layoff_staging
LIKE layoffs;


SELECT *
FROM layoff_staging;

insert layoff_staging
select *
from layoffs;


SELECT *,
Row_Number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoff_staging;


-- Removing Duplicates

with duplicate_cte as 
(
SELECT *,
Row_Number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoff_staging
)
select * 
from duplicate_cte 
where row_num > 1;


select * 
from layoff_staging 
where company = 'Casper';


with duplicate_cte as 
(
SELECT *,
Row_Number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoff_staging
)
DELETE 
from duplicate_cte 
where row_num > 1;



CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoff_staging2
where row_num >1;

insert into layoff_staging2
SELECT *,
Row_Number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoff_staging;

DELETE  
from layoff_staging2
where row_num > 1;

select * 
from layoff_staging2
where row_num >1;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM layoff_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 1;

select * 
from layoff_staging2;


-- Standardizing data 

select company ,trim(company)
from layoff_staging2;

SET SQL_SAFE_UPDATES = 0;

update layoff_staging2
set company = trim(company);

SET SQL_SAFE_UPDATES = 1;

select * from layoff_staging2;

select distinct(industry)
from layoff_staging2
order by 1;

select *
from layoff_staging2
where industry like 'Crypto%';


SET SQL_SAFE_UPDATES = 0;

update layoff_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct(country)
from layoff_staging2;

select *
from layoff_staging2
where country like 'United States%'
order by 1;


update layoff_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';


-- changing date data type

select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
from layoff_staging2;


update layoff_staging2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

select * 
from layoff_staging2;


alter table layoff_staging2
modify column `date` date;

-- Managing Null or blank values

select * 
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;

update layoff_staging2
set industry = null 
where industry = '';


select * 
from layoff_staging2
where industry is null 
or industry = '';

select * 
from layoff_staging2
where company = 'Airbnb';


select t1.industry , t2.industry 
from layoff_staging2 as t1 
join layoff_staging2 as t2 
	on t1.company = t2.company
	and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;


update layoff_staging2 t1 
join layoff_staging2 t2 
on t1.company = t2.company 
set t1.industry = t2.industry 
where t1.industry is null 
and t2.industry is not null;



select * 
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete 
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- Drop any column 

alter table layoff_staging2
drop column row_num;

select * 
from layoff_staging2;





