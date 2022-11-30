--select * from portfolioproject..coviddeath
-- Select Data that we are going to be starting with
select location
from portfolioproject..coviddeath
WHERE location like 'up%'


--Total cases vs Total Death
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From portfolioproject..coviddeath
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From portfolioproject..coviddeath
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

select date,location,population,total_deaths,total_cases,
(total_deaths/total_cases)*100 AS per_death
from portfolioproject..coviddeath
WHERE continent is not NULL
AND location like 'India'
order by 1,2

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolioproject..coviddeath
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


--Total_cases VS population(percentage of population infected with Covid)
select date,location,population,total_cases,(total_cases/population)*100 AS Percent_cases
from portfolioproject..coviddeath
WHERE continent is not NULL
--AND location like 'India'
order by 1,2

--Countries with highest infection rate as compared to population
select location,population,MAX(total_cases) as maxcases,MAX((total_cases/population))*100 AS Percent_cases
from portfolioproject..coviddeath
--WHERE continent is not NULL
--AND location like 'India'
GROUP BY location,population
order by Percent_cases desc

--Countries with highest death count
select location,population,max(CAST(total_deaths as int)) as highest_death--,total_cases
from portfolioproject..coviddeath
WHERE continent is not NULL
GROUP BY location,population
order by highest_death desc

--Continents with highest death count as per population

select continent,max(CAST(total_deaths as int)) AS highest_death
from portfolioproject..coviddeath
WHERE continent is not NULL
GROUP BY continent
order by highest_death desc


--Global numbers
select SUM(new_cases) AS total_cases,SUM(CAST(new_deaths as int)) as total_death,SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as percent_death
from portfolioproject..coviddeath
WHERE continent is not null
order by 1,2

--Total deaths vs total vaccination
--percentage of population that have recieved atleast one covid vaccin
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
, SUM(Cast(vacc.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From portfolioproject..coviddeath dea
Join portfolioproject..covidvacc vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
where dea.continent is not null 
order by 2,3



--Use CTE

with popvsvac(continent,loction,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
, SUM(Cast(vacc.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From portfolioproject..coviddeath dea
Join portfolioproject..covidvacc vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
where dea.continent is not null 
)
select *,(RollingPeopleVaccinated/population)*100
from popvsvac

--Temporary table
DROP table if exists #perpopvacc
create table #perpopvacc(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #perpopvacc
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
, SUM(Cast(vacc.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From portfolioproject..coviddeath dea
Join portfolioproject..covidvacc vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
where dea.continent is not null 
select *,(RollingPeopleVaccinated/population)*100
from #perpopvacc


--VIEW


Create View perpopvacc as
Select dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
, SUM(Cast(vacc.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From portfolioproject..coviddeath dea
Join portfolioproject..covidvacc vacc
	On dea.location = vacc.location
	and dea.date = vacc.date
where dea.continent is not null 

select locatio