--Netflix Project
drop table if exists netflix;
create table netflix
(
show_id varchar(6),	
type_s varchar(10),	
title varchar(150),	
director varchar(208),	
casts varchar(1000),	
country varchar(150),	
date_added varchar(50),	
release_year int,
rating varchar(10),	
duration varchar(15),	
listed_in varchar(100),	
descriptions varchar(250)
);
select * from netflix;

select count(*) as Total_count
from netflix;

select distinct type_s as type
from netflix;

-- 10 Business Problems
--1. Count the number of Movies vs Tv shows

select type_s, count(*) as Total_count
from netflix
group by type_s;

--2. Find the most comman rating  for movies and Tv shows
select type_s,rating from(
select type_s, rating, count(*),
rank() over(partition by type_s order by count(*)desc) as ranking
from netflix
group by 1,2)
as T1
where ranking = 1;

--3. List all movies released in sepcific year(eg, 2021)
select * from netflix
where type_s = 'Movie' and release_year = 2021;

--4. Find the top 5 countries with the most contant on the netflix
select 
distinct unnest(string_to_array(country,',')) as N_Country,
count(show_id) as Total_count
from netflix
group by N_Country
order by Total_count desc
limit 5;

--5. Identify the Longest movie?
select * from netflix
where type_s = 'Movie' 
and duration = (select max(duration)from netflix);

--6. Find all the movies/TV shows by director 'Rajiv Chilaka'.
select * from netflix
where director like '%Rajiv Chilaka%';

--7. List all the TV shows with more than 5 seasons
select * from netflix
where type_s = 'TV Show' and
duration > '5Seasons';

--8. count the number of Content items in each genre
select 
unnest(string_to_array(listed_in,',')) as genre,
count(show_id)
from netflix
group by 1;

--9. Find each year numbers of content release by india on netflix.
select count(*),
Extract(year from to_date(date_added,'Month DD, YYYY')) as years
from netflix
where country = 'India'
group by 2;

--10. List all the movies that are documentaries.
select * from netflix
where listed_in Like '%Documentaries%';

--11. Find all the content without a director

select * from netflix
where 
director is null;

--12. Find how many movies actor 'Salman Khan' appeared in last 12 years
select * from netflix
where 
casts ilike '%Salman Khan%'
and 
release_year > extract(year from current_Date) - 12;

--13. Find the top 10 actors who have appeared in the highest number of movies produced in india.
select 
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
group by 1
order by 2 desc
limit 10;

--14. Categories a movie based on its contant like 'kill','violence' bad else good content
with new_table as(select 
*,
  case 
  when
     descriptions ilike '%kill%' or
     descriptions ilike '%violence%' then 'Bad_content'
     else 'Good Content'
end category
from netflix)
select category, count(*) as total_content
from new_table
group by 1;

--15.Extracts the year from the date_added field (which is in text format) 
--and filters for titles added in 2021.
select 
    title,
    date_added
from netflix
where date_part('year', TO_DATE(date_added, 'Month DD, YYYY')) = 2021;

--16.Get Titles Where the Description Mentions ‘Love’ but Not ‘Hate’
select 
    title,
    descriptions
from netflix
where descriptions ilike '%love%'
  and descriptions not ilike '%hate%';
  
--17. Find the Average Release Year per Country (Only Countries with 20+ Titles)
select 
    country,
    ROUND(avg(release_year), 2) as avg_release_year,
    count(*) as total_titles
from netflix
where country is not null
group by country
having count(*) > 20
order by avg_release_year desc;

--18. Categorize Each Title as “Old” or “Modern”
select 
    title,
    release_year,
    case 
        when release_year < 2000 then 'Old'
        when release_year between 2000 and 2015 then 'Modern'
        else 'Recent'
    end as category
from netflix;

--19.Show distinct countries available in dataset
select distinct country
from netflix
where country is not null
order by country;

--20 Find All Titles That Belong to the “Horror” Genre. 
select title, listed_in
from netflix
where  listed_in ilike '%horror%';

--21. Find the Year with the Highest Number of Titles Released
select
    release_year,
    count(*) as total_titles
from netflix
group by release_year
order by total_titles desc
limit 1;








