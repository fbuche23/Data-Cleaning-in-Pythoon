
--I created a database named F1 to access the file
use F1
-- I use select * to see how the data looks like, see if the nulls 
select * 
from GrandPrix_drivers;
-- I wanted to see the number of drivers who are Italian and drove from Ferrari from 1950 and 2000

select distinct count(Driver) as 'Italian-Drivers'
from GrandPrix_drivers
where Nationality = 'ITA' and
	year between '1950' and '2000'
	and Car = 'Ferrari';
	-- It looks like 40 drivers are from Italy who drove for Ferrari

-- Now, let's see how many car brands scored more than 100 points in F1

select distinct (Car)
from GrandPrix_drivers
where PTS >= 100;
	-- It looks like 106 cars have scored more or equal to 100 points. 

-- What about more than 200?

select distinct (Car)
from GrandPrix_drivers
where PTS >= 200;
	-- 53 cars have scored more than 200 points, but lets see the driver too
select distinct (Car), Driver
from GrandPrix_drivers
where PTS >= 200;

-- Now 300 points. 
select distinct (Car), Driver
from GrandPrix_drivers
where PTS >= 300;

-- Now let's see the teams and drivers that scored more than 375 points with their year. 
select distinct Car, Driver, Year, sum(PTS) as Points
from GrandPrix_drivers
where PTS >= 375
group by Car, Driver, PTS, year
order by Points desc;

-- It looks like Red Bull is the team that scored the most points in F1 acroos all years, 454. 
-- One might say this is the best team in F1 history since they won mostly all races,
-- but more races have been added across years while the sport has been growing.  
--We can say, however, that the most dominant teams have been Red Bull and Mercedes

select distinct Car, Year, sum(PTS) as Points, Driver, Nationality
from GrandPrix_drivers
where PTS >= 375
group by Car, PTS, year, Driver, Nationality;

-- Let's see how many points has the most dominant Drivers scored. 
select sum(pts) as HAM_Total_Points
FROM GrandPrix_drivers
Where Driver like '%Lewis Hamilton%'
-- 4405.5 for Lewis Hamilton

select sum(pts) as VER_Total_Points
FROM GrandPrix_drivers
Where Driver like '%Versta%'
-- 2028.5 for Max Verstappen

select sum(pts) as VETTEL_Total_Points
FROM GrandPrix_drivers
Where Driver like '%Vettel%'
-- 3098 for Sebastian Vettel
select sum(pts) as Ros_Total_Points
FROM GrandPrix_drivers
Where Driver like '%Rosberg%'
--1754 for Nico Rosberg

	-- By points scored, Lewis Hamilton is the Greatest Driver in F1 history. 

-- Let's see the points he scored by year
Select Distinct year, car,driver,
FIRST_VALUE(PTS) 
  OVER (PARTITION BY Year ORDER BY PTS DESC) AS Points
FROM GrandPrix_drivers
where Driver like '%Lewis Hamilton%'
-- For another future analysis we could use a different database where there's a Driver ID and Join them to see the best lap times
-- that way we can see the fastest driver in F1 or the one that has the best average time.
