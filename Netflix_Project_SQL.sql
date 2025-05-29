-- NETFLIX SQL ANALYSIS 
-- ====================================

-- 0) Check that the cleaned database connected correctly from vs-code
SELECT * FROM netflix_titles;

-- ====================================

-- 1) Count the Number of Movies vs TV Shows
	-- There are 5185 movies and 147 TV shows 

SELECT type, 
COUNT (*)
FROM netflix_titles
GROUP BY type;

-- ====================================

-- 2) Find the Most Common Rating for Movies and TV Shows
	-- The most common rating for both Movies and TV shows was TV-MA. 
	-- Movies had 14 different ratings while TV shows only had 6 different ratings. 
	-- The overall trend is there tends to be more adult rated moveis and TV programs than kid rated content. 
	-- The exception being TV-14 rating for movies which was the second most common rating. 

SELECT type, rating, count, 
       RANK() OVER (PARTITION BY type ORDER BY count DESC) AS ranking
FROM (
    SELECT type, rating, COUNT(*) AS count
    FROM netflix_titles
    GROUP BY type, rating
) AS sub
ORDER BY type, ranking;

-- ====================================

-- 3) Find how many movies and TV shows were realeased each year
	-- The late twenty-teens had the highest number of movie releases, more than 500. 
	-- Before 2008 there were less than 100 moveies released each year
	-- TV shows showed a similar, but smaller pattern. There was a large increase in the number of TV shows released each year after 2016.
	-- The maximum number of TV shows released each year was 33 shows in 2020. There were fewer than 4 TV shows released each year before 2012.

SELECT type, release_year, COUNT(*) AS count 
FROM netflix_titles
GROUP BY type, release_year
ORDER BY type, count DESC, release_year;


-- ====================================

-- 4)  Find the Top 4 Countries with the Most Content on Netflix
	-- Overall the USA (1846), India (875), UK (183), and Canada (107) had the most content on Netflix.
	-- In regards to movies, USA (1819), India (868), UK (164), and Canada (104) had the highest number of movies on Netflix.
	-- In regards to TV shows, USA (27), UK (19), South Korea (10), Japan (10) had the higehst number of TV shows on Netflix.

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) AS country, 
	COUNT(*) AS totalCount,
	COUNT(*) FILTER(WHERE type='Movie') AS movieCount,
	COUNT(*) FILTER(WHERE type='TV Show') AS tvCount
FROM netflix_titles
GROUP BY country
ORDER BY totalCount DESC;


-- ====================================

-- 5) Identify the Longest Movie
	-- The longest movie was over 4 hours long and called "The School of Mischief"
	
SELECT *
FROM netflix_titles
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ',1)::INT DESC;


-- ====================================

-- 6)  Find Content Added in the Last 5 Years

SELECT *
FROM netflix_titles
WHERE date_added::DATE >= CURRENT_DATE - INTERVAL '5 years'
ORDER BY date_added::DATE DESC;


	-- Bonus: finding the total number of movies and tv shows that were added in the last 5 years. 

SELECT 
    COUNT(*) AS total_count,
    COUNT(*) FILTER (WHERE type = 'Movie') AS movie_count,
    COUNT(*) FILTER (WHERE type = 'TV Show') AS tv_count
FROM netflix_titles
WHERE date_added::DATE >= CURRENT_DATE - INTERVAL '5 years';


-- ====================================

-- 7) Find All Movies/TV Shows by Director 'Rajiv Chilaka'
	-- There are 3 movies solely made by Rajiv Chilaka and 1 colaboration between him and another director. 
SELECT * 
FROM(
	SELECT 
		*, 
		UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
	FROM netflix_titles
)
WHERE director_name = 'Rajiv Chilaka'
ORDER BY title; 

-- ====================================

-- 8)  List All TV Shows with More Than 5 Seasons

SELECT *
FROM netflix_titles
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5
ORDER BY title;


-- ====================================

-- 9)  Count the Number of Content Items in Each Genre
	-- There were 42 genres in total.
	-- International movies and dramas both had more than 2000 items.
	-- Comedies was the third highest category at 1553.
	-- The bottom 12 genres had 10 items or less.
	
SELECT 
  TRIM(genre) AS genre,
  COUNT(*) AS total_items
FROM (
  SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
  FROM netflix_titles
) AS genre_list
GROUP BY TRIM(genre)
ORDER BY total_items DESC;

-- ====================================

-- 10)  Find the number of Netflix titles released each year in India.
	-- Content was only released in India from 2016-2021
	-- 2018 was the year with the most amount of content released. 
	

SELECT 
	COUNT (*) AS total_items, 
	SPLIT_PART(date_added,'-',1)::INT AS yearAdded 
FROM netflix_titles
WHERE country = 'India'
GROUP BY yearAdded
ORDER BY yearAdded DESC;

	-- bonus: What is the average nummber of releases per year in India?
		-- On average, there is 145 new releases per year in India.
WITH year_counts AS (
    SELECT 
        SPLIT_PART(date_added, '-', 1)::INT AS yearAdded
    FROM netflix_titles
    WHERE country = 'India'
      AND date_added IS NOT NULL
    GROUP BY yearAdded
),
total_content AS (
    SELECT COUNT(*) AS total_items
    FROM netflix_titles
    WHERE country = 'India'
      AND date_added IS NOT NULL
)
SELECT 
    total_items,
    (SELECT COUNT(*) FROM year_counts) AS total_years,
    total_items::FLOAT / (SELECT COUNT(*) FROM year_counts) AS avg_content_per_year
FROM total_content;


-- ====================================

-- 11)  List All Movies that are Documentaries
	-- There are documentaries on Netflix.
	
SELECT 
	nt.*,
	TRIM(genre) AS genre
FROM netflix_titles nt,
	UNNEST(STRING_TO_ARRAY(nt.listed_in, ',')) AS genre
WHERE genre ='Documentaries';


-- ====================================

-- 12) Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
	-- there are 20 movies 

SELECT COUNT(*) AS movie_count
FROM netflix_titles nt,
	UNNEST(STRING_TO_ARRAY(nt.cast, ',')) AS actor
WHERE TRIM(actor) = 'Salman Khan'
	AND type = 'Movie'
	AND date_added::DATE >= CURRENT_DATE - INTERVAL '10 years';


	-- bonus: if you want to see all 20 movies Salman Khan is in:
SELECT nt.*,
	TRIM(actor) AS actor
FROM netflix_titles nt,
	UNNEST(STRING_TO_ARRAY(nt.cast, ',')) AS actor
WHERE TRIM(actor) = 'Salman Khan'
	AND type = 'Movie'
	AND date_added::DATE >= CURRENT_DATE - INTERVAL '10 years';




-- ====================================

-- 13)  Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
	-- There are over 3368 actors who appeared in Indian films. 83 of whome appeared in 10 or more films.

SELECT 
	TRIM(actor) AS actorSum,
	COUNT(*) AS movieCount
FROM netflix_titles nt,
	UNNEST(STRING_TO_ARRAY(nt.cast, ',')) AS actor
 WHERE nt.country = 'India'
 	AND nt.type = 'Movie' 
GROUP BY TRIM(actor)
ORDER BY movieCount DESC;

-- ====================================

-- 14)  Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
	-- There are 5104 pieces of content that do not contain 'kill' or 'violence' and 228 that do.

SELECT
	category,
	COUNT(*) AS content_count
FROM(
	SELECT
		CASE
			WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
			ELSE 'Good'
		END AS category
	FROM netflix_titles
) AS categorized_content
GROUP BY category;


-- ====================================

























