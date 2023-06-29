
Select *
From PortfolioProject.dbo.Deaths
where continent is not null
Order by 1,2

--Select *
--From PortfolioProject..Vaccinnation
--Order by 3,4

--Extracting Data to work with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.dbo.Deaths
where continent is not null
Order by 1, 2

--We want to look at Total cases vs Total death
--This is to show the likelihood of dying if you contracted COVID in your country

Select Location, date, total_cases, total_deaths, cast(total_deaths as numeric)/ cast(total_cases as numeric) *100 as DeathPercent
From PortfolioProject..Deaths
Where location like '%Nigeria%'
and continent is not null
Order by 1,2

--Lets look at Total cases vs Population
--Showing the percentation of population got covid

Select Location, date, population, total_cases,  cast(total_cases as numeric)/ cast(population as numeric) *100 as TotalInfectionPercent
From PortfolioProject..Deaths
where continent is not null
Order by 1,2

--Looking at countries with highest infection rate compare to their population

Select Location, population, MAX(total_cases) as HghestInfectionCount,  MAX(cast(total_cases as numeric)/ cast(population as numeric)) *100 as HighestInfectionPercent
From PortfolioProject..Deaths
where continent is not null
Group by location, population
Order by HighestInfectionPercent desc

--Showing the countries with Highest COVID death per popuation

Select Location,  MAX(cast(total_deaths as numeric)) as TotalDeathCount
From PortfolioProject..Deaths
where continent is not null
Group by location
Order by TotalDeathCount desc


--LETS LOOK AT IT BY CONTINENT

--Showing the continents with highest death count per population

Select continent,  MAX(cast(total_deaths as numeric)) as TotalDeathCount
From PortfolioProject..Deaths
where continent is not null
Group by continent
Order by TotalDeathCount desc

--GLOBAL NUMBER

Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as numeric)) as Total_deaths, SUM(cast(new_deaths as numeric))/SUM(new_cases) *100 as DeathPercent
From PortfolioProject..Deaths
where continent is not null
--Group by date
Order by 1,2


--LOOKING AT TOTAL POPULATION VS TOTAL VACINNATIONS

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as numeric)) Over (Partition by dea.location order by dea.location, dea.date) as RollingVacinnated
From PortfolioProject..Deaths  dea
join PortfolioProject..Vaccinnation  vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
Order by 2, 3

--USE CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingVacinnated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as numeric)) Over (Partition by dea.location order by dea.location, dea.date) as RollingVacinnated
From PortfolioProject..Deaths  dea
join PortfolioProject..Vaccinnation  vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--Order by 2, 3
)
select *,(RollingVacinnated/population) * 100 as PercentVaccinated
from PopvsVac




---TEMP TABLE
DROP Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated

(
Continent nVarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVacinnated numeric
)
Insert Into PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as numeric)) Over (Partition by dea.location order by dea.location, dea.date) as RollingVacinnated
From PortfolioProject..Deaths  dea
join PortfolioProject..Vaccinnation  vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--Order by 2, 3

Select *,(RollingVacinnated/population) * 100 as PercentVaccinated
from PercentPopulationVaccinated


--Creating view to store data for later visualization

Create View PercentPopulationVaccinatedview as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(cast(vac.new_vaccinations as numeric)) Over (Partition by dea.location order by dea.location, dea.date) as RollingVacinnated
From PortfolioProject..Deaths  dea
join PortfolioProject..Vaccinnation  vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--Order by 2, 3


select *
from PercentPopulationVaccinatedview

