-- Some Exploration into the data

select max(total_laid_off), max(percentage_laid_off) from layoff_staging2; -- Highest number of laid off workers

select * from layoff_staging2 -- Companies that completely went down
where percentage_laid_off = 1

order by total_laid_off desc;


select company, sum(total_laid_off) from layoff_staging2 -- Companies with the most layoffs, Amazon, Google, Meta leading
group by company
order by 2 desc;

select min(date), max(date) from layoff_staging2; -- Data range for the data, March 2020 to March 2023

select industry, sum(total_laid_off) from layoff_staging2 -- Layoff per industry, Consumer and Retail were most affected
group by industry
order by 2 desc;

select country, sum(total_laid_off) from layoff_staging2 -- Countries with the most layoffs, USA topped by far
group by country
order by 2 desc;

select Year(`date`), sum(total_laid_off) from layoff_staging2 -- Year with the most layoffs
group by Year(`date`)
order by 2 desc;

select stage, sum(total_laid_off) from layoff_staging2 -- Layoffs grouped by stage
group by stage
order by 2 desc;

with rolling_total as -- Rolling total of laid off employees by month
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as monthly_layoff from layoff_staging2 
where substring(`date`,1,7) is not null
group by `month`
order by `month`
)
select `month`, sum(monthly_layoff) over(order by `month`)
from rolling_total;

-- The total number of people laid off each year (ranked by company)
with Ranking as (
select company, year(`date`)as Layoff_year, sum(total_laid_off) as Yearlylaidoff, dense_rank()over(partition by year(`date`) order by sum(total_laid_off)desc) as `rank` from layoff_staging2 
where year(`date`) is not null
group by company,Layoff_year
)
select * from ranking
where `rank`<=5;

