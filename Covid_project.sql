--SELECT TOP (2000) *
 -- FROM [master].[dbo].[covid_Vaccination]
  --order by 3,4;
  SELECT TOP (2000) *
  FROM [master].[dbo].[covid_Deaths]
  where continent is not null
  order by 3,4;
--Select the data 
use master;
Select [location],[date],[population],[total_deaths],[total_cases]
from [covid_Deaths]
where continent is not null
order by location,[date];
--Checking total deaths vs total case
-- percentage population effected with covid
select [location],[date],[total_cases],[total_deaths], round(([total_deaths] *1.0 /[total_cases])*100,2) as Death_percentage,
population,round((total_cases*1.0/population)*100,2) as percent_population
from [dbo].[covid_Deaths]
where continent is not null
order by location,date;
--countries with highest infection rate
select location,population,max(total_cases) as Highestinfectioncount,max((total_cases*1.0)/population)*100 percentpopulationinfected from [dbo].[covid_Deaths]
where continent is not null
group by location,population
order by percentpopulationinfected desc;

--countries with highest death rate 

select location,population,max(total_deaths) Highest_death,max((total_deaths*1.0)/population)*100 percentpopulationdied from [dbo].[covid_Deaths]
where continent is not null
group by location,population
order by Highest_death desc;

-- total death by continent

select continent,max(total_deaths) as Highestdeath from [dbo].[covid_Deaths]
where continent is not NULL
group by continent
order by Highestdeath desc;

---
select date,sum(total_cases) casesbydate,sum(total_deaths) deathsbyydate from [dbo].[covid_Deaths]
where continent is not NULL
group by date
order by date desc;

--looking at population vs vaccinations
select d.location,d.date,d.population,v.new_vaccinations,sum(v.new_vaccinations) over(partition by d.location order by d.location,d.date)  as run_total from
 [dbo].[covid_Deaths] d join [dbo].[covid_Vaccination] v 
on d.location = v.location and d.date = v.date
where d.continent is not null
order by location,date;







