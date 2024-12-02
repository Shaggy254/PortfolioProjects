-- Cleaning the Data

Select * from layoffs;

-- 1. Remove duplicates
-- 2. Standardise data
-- 3. Null values and blank values
-- 4. Remove unnecessary colums

-- Create a staging table
create table layoff_staging
like layoffs; -- creating a our staging table

insert into layoff_staging
select * from layoffs; -- copy data from original table to staging table

select * from layoff_staging;

-- Remove duplicates - using row_number () since no unique identifier

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
Insert into layoff_staging2
select *, row_number()over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
from layoff_staging;
select * from layoff_staging2
where row_num>1;
Delete
from layoff_staging2
where row_num>1;
select * from layoff_staging2
where row_num>1;
-- Duplicates removed with another table and the row_number function()

-- Standardizing Data
-- 1. Trimmming
select * from layoff_staging2;

update layoff_staging2
set company =trim(company);

-- 2. Further standardization
select distinct industry
from layoff_staging2;

update layoff_staging2
set industry = 'Crypto'
where industry like 'crypto%';

select * from layoff_staging2
where industry like 'crypto%';

select distinct country
from layoff_staging2
order by 1;

update layoff_staging2
set country = 'United States'
where country like 'United States%';

select date
from layoff_staging2
;

-- Date column from type text to type date
select `date`,
str_to_date(`date`,'%m/%d/%Y')as newdate
from layoff_staging2;

Update layoff_staging2
set `date`= str_to_date(`date`,'%m/%d/%Y');

select *
from layoff_staging2;

Alter table layoff_staging2
modify column `date` date;

-- Filling in missing values
select * from layoff_staging2
where industry= '';


update layoff_staging2
set industry = 'Travel'
where company = 'Airbnb';

select *
from layoff_staging2
where company = 'Juul';

update layoff_staging2
set industry = 'Consumer'
where company = 'Juul';

select *
from layoff_staging2
where company = 'Carvana';

update layoff_staging2
set industry = 'Transportation'
where company = 'Carvana';

-- Removing unnecessary rows and columns
select * from layoff_staging2
where total_laid_off is null and percentage_laid_off is null;

Delete from layoff_staging2
where total_laid_off is null and percentage_laid_off is null;

ALter table layoff_staging2
drop column row_num;
