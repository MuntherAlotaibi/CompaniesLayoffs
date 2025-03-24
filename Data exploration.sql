select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select *
from layoffs_staging2;

select company, sum(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select substring(`date` ,1,7) as `month` , sum(total_laid_off)
from layoffs_staging2
where substring(`date` ,1,7) is not null
group by `month`
order by 1 asc
;

with Rolling_Total as
 (
select substring(`date` ,1,7) as `month` , sum(total_laid_off) as Total_Off
from layoffs_staging2
where substring(`date` ,1,7) is not null
group by `month`
order by 1 asc
)
select `month` , Total_Off
, sum(Total_Off) over(order by `month`) as rolling_total
from Rolling_Total;

select company, sum(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company, year( `date`) , sum(total_laid_off)
from layoffs_staging2
group by company, year( `date`)
order by 3 desc;

with comany_year (company, years , total_laid_off)  as
(
select company, year( `date`) , sum(total_laid_off)
from layoffs_staging2
group by company, year( `date`)
), company_year_rank as
(select * ,dense_rank() over (partition by years order by total_laid_off desc) as ranking
from comany_year
where years is not null)
select * 
from company_year_rank
where ranking <=5
;


