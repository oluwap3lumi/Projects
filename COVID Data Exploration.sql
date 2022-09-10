Select *
FROM PortfolioProjects..CovidDeaths
Where continent is not null
ORDER BY 3,4

--Select *
--FROM PortfolioProjects..CovidVaccinations
--ORDER BY 3,4

--SELECT DATA TO BE USED FROM FIRST TABLE
Select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjects..CovidDeaths
order by 1,2

--COMPARING TOTAL CASES vs TOTAL DEATHS
--shows the percentage likehood of dying if you contract COVID in our country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProjects..CovidDeaths
Where location like '%africa%'
Where continent is not null
order by 1,2


--comparing total cases vs Population
--shows what percentage of population got covid
Select Location, date, total_cases, population, (total_cases/population)*100 as PercentageInfected
from PortfolioProjects..CovidDeaths
Where location like '%africa%'
Where continent is not null
order by 1,2


--Countries with highest infected rate compared to population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
from PortfolioProjects..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location, population
order by PercentagePopulationInfected desc


--Showing Countries with the highest death count per population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
Where continent is not null
--Where location like '%states%'
Group by location
order by TotalDeathCount desc


--CHECKING DEATH COUNT PER CONTINENT// CONTINET WITH HIGHEST DEATH COUNT
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProjects..CovidDeaths
Where continent is null
--Where location like '%states%'
Group by location
order by TotalDeathCount desc



--GLOBAL NUMBERS 

Select date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as Total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases) *100 as DeathPercentage
from PortfolioProjects..CovidDeaths
--Where location like '%africa%'
Where continent is not null
Group by date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as Total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases) *100 as DeathPercentage
from PortfolioProjects..CovidDeaths
--Where location like '%africa%'
Where continent is not null
order by 1,2


--LOOKING AT TOTAL POPULATION vs VACCINATION
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location, dea.date) as RollingPeopleVacinnated
From PortfolioProjects..CovidVaccinations vac
 join PortfolioProjects..CovidDeaths dea
 ON dea.location = vac.location
 and dea.date = vac.date
 WHERE dea.continent is not null
 Order by 2,3



 --USING CTE FOR FURTHER CALCULATIONS
 WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
 as
 (
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location, dea.date) as RollingPeopleVacinnated
From PortfolioProjects..CovidVaccinations vac
 join PortfolioProjects..CovidDeaths dea
 ON dea.location = vac.location
 and dea.date = vac.date
 WHERE dea.continent is not null
 --Order by 2,3
 )

 Select *, (RollingPeopleVaccinated/Population)*100
 From PopvsVac





 --TEMP TABLE
Drop Table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

 Insert into #PercentagePopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location, dea.date) as RollingPeopleVacinnated
From PortfolioProjects..CovidVaccinations vac
 join PortfolioProjects..CovidDeaths dea
 ON dea.location = vac.location
 and dea.date = vac.date
-- WHERE dea.continent is not null
 --Order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentagePopulationVaccinated


--CREATING VIEWS TO STORE FOR LATER VISULAIZATIONS

CREATE View PercentagePopulationVaccinated as
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location, dea.date) as RollingPeopleVacinnated
From PortfolioProjects..CovidVaccinations vac
 join PortfolioProjects..CovidDeaths dea
 ON dea.location = vac.location
 and dea.date = vac.date
WHERE dea.continent is not null
 --Order by 2,3