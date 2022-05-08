select*
from ['Covid death$']
where continent is not null

--select *
--from ['Covid vaccination$']


--select DAta tha we are ging to use
select location,date, population, total_cases, new_cases, total_deaths
from ['Covid death$']
where continent is not null
order by 1,2

--total cases vs total death
select location,date,  total_cases, total_deaths, (total_deaths/total_cases)*100 as [death percent]
from ['Covid death$']
where location like 'india'
and  continent is not null
order by 1,2


--total cases vs population
select location, Date, total_cases,population,(total_cases /population)*100 as [cases in percent]
from ['Covid death$']
where location like 'india'
order by 1,2

--countries having highest infection rate compare to population
select location,population,date,MAX(total_cases) as [highest infected count],MAX( (total_cases/population))*100 as [percent population infected]
from ['Covid death$']
--where continent is not null
group by location, population,date
order by 5 desc


 --highest death count per population
 select location,max(cast(total_deaths as int )) as [highest death count]
 from ['Covid death$']
 where continent is  null
 and location not in ('world','European Union''International')
 group by location
 order by [highest death count] desc

 --lets break thinks down by continent
 select continent,max(cast(total_deaths as int )) as [highest death count]
 from ['Covid death$']
 where continent is not null
 group by continent
 order by [highest death count] desc

 --global numbers

select   sum(new_cases) as [total cases] , SUM(cast(new_deaths as int)) as [total deaths], SUM(cast(new_deaths as int))/ sum(new_cases)*100  as [  death percentage]
from ['Covid death$']
where continent is not null
--group by date
order by 1,2
 
--total population vs vaccination
select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as [rolling population vaccinated]
from ['Covid vaccination$'] vac
join ['Covid death$'] dea
   on dea.location=vac.location
   and dea.date=vac.date
where dea.continent is not null
order by 2,3


--USE CTE
with popvsvac (continent,location, date,population,new_vaccinations,[rolling population vaccinated])
as
(
select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as [rolling population vaccinated]
from ['Covid vaccination$'] vac
join ['Covid death$'] dea
   on dea.location=vac.location
   and dea.date=vac.date
where dea.continent is not null
)
select*,([rolling population vaccinated]/population)*100
from popvsvac


create view popvsvac as
select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations, 
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as [rolling population vaccinated]
from ['Covid vaccination$'] vac
join ['Covid death$'] dea
   on dea.location=vac.location
   and dea.date=vac.date
where dea.continent is not null

--4
Select Location, Population,date, MAX(total_cases) as[ Highest Infection Count],  Max((total_cases/population))*100 as[ Percent Population Infected]
From ['Covid death$']
--Where location like '%states%'
Group by Location, Population, date
order by [ Percent Population Infected]  desc

