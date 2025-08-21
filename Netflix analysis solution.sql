--Netflix database analysis
CREATE TABLE netflix_titles (
    show_id VARCHAR(10) PRIMARY KEY,
    type VARCHAR(10),
    title VARCHAR(255),
    director VARCHAR(255),
    "cast" TEXT,
    country TEXT,
    date_added DATE,
    release_year INTEGER,
    rating VARCHAR(10),
    duration VARCHAR(20),
    listed_in VARCHAR(255),
    description TEXT
);


-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows--
select type , count(*) 
From netflix_titles as type_count
group by type ;

--2. Find the most common rating for movies and TV shows--
SELECT type, rating, count(*)
FROM netflix_titles
GROUP BY type, rating
ORDER BY type , count(*) DESC;

--3. List all movies released in a specific year (e.g., 2020)--
select type , title , release_year 
from netflix_titles 
where release_year =2020 and type = 'Movie'; 

--4. Find the top 5 countries with the most content on Netflix--
select country , count(*) as content_count
from netflix_titles 
Group by country 
order by count(country) DESC
Limit 5;

--5. Identify the longest movie--
SELECT type, duration
FROM netflix_titles
WHERE type = 'Movie' and duration notnull
ORDER BY duration DESC;

--6. Find content added in the last 5 years--
SELECT * FROM netflix_titles
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!--
select type , director 
from netflix_titles
where director = 'Rajiv Chilaka' ;

--8. List all TV shows with more than 5 seasons--

SELECT * FROM netflix_titles
WHERE TYPE = 'TV Show'AND SPLIT_PART(duration, ' ', 1)::INT > 5 ;

--9. Count the number of content items in each genre--
SELECT listed_in , COUNT(*) AS content_count
FROM netflix_titles
GROUP BY listed_in
ORDER BY content_count DESC;

--10.Find each year and the average numbers of content release in India on netflix.--
return top 5 year with highest avg content release!
WITH MonthlyReleases AS (
    SELECT
        EXTRACT(YEAR FROM date_added) AS release_year,
        EXTRACT(MONTH FROM date_added) AS release_month,
        COUNT(*) AS monthly_count
    FROM
        netflix_titles
    WHERE
        country = 'India'
    GROUP BY
        EXTRACT(YEAR FROM date_added),
        EXTRACT(MONTH FROM date_added)
)
SELECT
    release_year,
    AVG(monthly_count) AS avg_content_release
FROM
    MonthlyReleases
GROUP BY
    release_year
ORDER BY
    avg_content_release DESC
LIMIT 5;

--11. List all movies that are documentaries

SELECT title
FROM netflix_titles
WHERE listed_in = 'Documentaries' AND type = 'Movie';


--12. Find all content without a director
select show_id , title , director from netflix_titles 
where director is null ;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT COUNT(*) AS movie_count
FROM netflix_titles
WHERE type = 'Movie'
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10
  AND "cast" LIKE '%Salman Khan%';


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT
  UNNEST(string_to_array("cast", ', ')) AS actor_name,
  COUNT(*) AS movie_count
FROM
  netflix_titles
WHERE
  type = 'Movie'
  AND country LIKE '%India%'
GROUP BY
  actor_name
ORDER BY
  movie_count DESC
LIMIT 10;

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
SELECT
  CASE
    WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
    ELSE 'Good'
  END AS content_category,
  COUNT(*) AS content_count
FROM
  netflix_titles
GROUP BY
  content_category;