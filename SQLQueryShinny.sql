use zomato2;

--Question 1 SQL query
select name, city, Votes from zomato_rest
where name LIKE '%in%' and votes between 0 and 2000;

--Question 2 SQL query
select Longitude, latitude from zomato_rest
where Longitude is not NULL and Latitude is not NULL;