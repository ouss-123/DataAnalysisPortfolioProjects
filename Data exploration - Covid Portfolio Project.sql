
select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4



--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

select location, date, total_cases, new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- checking Total Cases vs Total Deaths
-- shows the likelihood of dying from Covid in your country
select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%' and continent is not null
order by 1,2

-- checking the Total Cases vs Population
-- shows what percentage of population got covid
select location, date,population, total_cases,(total_cases/population)*100 as InfectedPercentage
from PortfolioProject..CovidDeaths
where location like '%states%' and continent is not null
order by 1,2


--looking at Countrries with Highest Infection Rate compared to Population
select location,population, max(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as InfectedPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by location,population
order by InfectedPercentage desc


--showing Countries with Highest Death Count per Population
select location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT


--Showing Continents with Highest Death Count per Population
select continent,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS
select  sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as GlobalDeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2



-- Looking at Total Population vs Vaccinations

select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
sum(convert(int,d.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated,
from PortfolioProject..CovidDeaths as d
join PortfolioProject..CovidVaccinations as v
	on d.location = v.location and d.date = v.date
where d.continent is not null
order by 2,3


--USE CTE

with PopvsVac (continent,location, date, population,new_vaccinations, RollingPeopleVaccinated) as 
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
sum(convert(int,d.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths as d
join PortfolioProject..CovidVaccinations as v
	on d.location = v.location and d.date = v.date
where d.continent is not null
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac

-- TEMP TABLE
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
sum(convert(int,d.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths as d
join PortfolioProject..CovidVaccinations as v
	on d.location = v.location and d.date = v.date
where d.continent is not null

select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating View for later visualizations

create view PercentPopulationVaccinated as 
select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
sum(convert(int,d.new_vaccinations)) over (partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths as d
join PortfolioProject..CovidVaccinations as v
	on d.location = v.location and d.date = v.date
where d.continent is not null

select * 
from PercentPopulationVaccinated