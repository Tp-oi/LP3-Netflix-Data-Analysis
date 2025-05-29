# LP3 - Netflix SQL Data Analysis Project

This project is a complete exploratory analysis of Netflix content using SQL and Python. Inspired by [this video tutorial](https://www.youtube.com/watch?v=-7cT0651_lw), I took a hands-on approach by integrating VS Code for Python for data cleaning and PostgreSQL for SQL querying.

## Project Overview

- **Objective**: Analyze Netflix's content catalog to uncover trends, patterns, and insights using SQL.
- **Dataset**: [Netflix Movies and TV Shows on Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
- **Data Source**: Downloaded using the Kaggle API in VS Code.
- **Database**: PostgreSQL connected via VS Code instead of pgAdmin4.
- **Tools**: Python (pandas), SQL, Jupyter Notebook, PostgreSQL, VS Code.

> You can view the full tutorial project repository here: [GitHub Project Link](https://github.com/najirh/netflix_sql_project?tab=readme-ov-file)

---

## Workflow Summary

1. **Data Acquisition**
   - Pulled the dataset from Kaggle using the Kaggle API.
   - Loaded into a pandas DataFrame for cleaning.

2. **Data Cleaning (Python)**
   - Standardized column types (e.g., `date_added` to `datetime`).
   - Handled missing values.
   - Prepared the data for SQL ingestion.

3. **Data Loading**
   - Loaded the cleaned dataset into PostgreSQL using SQLAlchemy.

4. **SQL Analysis**
   - Ran 14+ analytical queries to explore content types, trends by year, countries with the most content, genre distribution, and actor appearances.

---

## Key Analytical Questions & Insights

- **Movies vs TV Shows**  
  → There are 5,185 movies and 147 TV shows.

- **Most Common Ratings**  
  → TV-MA is the most frequent rating across both content types.

- **Content Over Time**  
  → Movie and TV show production peaked between 2018 and 2020.

- **Top Producing Countries**  
  → USA, India, UK, and Canada top the list for both movies and shows.

- **Longest Movie on Netflix**  
  → *The School of Mischief* at over 4 hours long.

- **Recent Additions**  
  → Query to find all content added in the last 5 years.

- **Director Spotlight**  
  → Rajiv Chilaka has directed at least 4 titles, including collaborations.

- **TV Shows with More than 5 Seasons**  
  → Identified by parsing the `duration` column.

- **Top Genres**  
  → Dramas and International Movies dominate Netflix’s catalog.

- **India Focused Analysis**  
  → Released content by year and average releases per year in India.

- **Actor Insights**  
  → Found all movies with Salman Khan in the last 10 years.  
  → Top actors with the most appearances in Indian movies.

- **Content Categorization by Keywords**  
  → Labeled content as "Good" or "Bad" based on descriptions containing `kill` or `violence`.

---

## Skills Demonstrated

- SQL querying and filtering
- String manipulation and casting
- Aggregate and window functions
- JOIN-like logic using `UNNEST` and `STRING_TO_ARRAY`
- Python data preprocessing
- PostgreSQL database management
- Real-world workflow integration (API, Python, SQL, GitHub)

---

## Files Included

- `netflix_titles.csv` – Original dataset
- `project.ipynb` – Data cleaning and initial analysis in Python
- `Netflix_SQL_Analysis.sql` – All SQL queries used for the analysis

---

## How to Use This Project

1. Clone the repository.
2. Load the CSV file into your database or use the `.ipynb` to preprocess it.
3. Run the SQL queries in your PostgreSQL interface. 
4. Modify and explore your own questions!

---

## Author
Tyler Parnell, Mathematics and Big Data Student.
Feel free to reach out if you have questions about the project.

*This project was completed as part of my ongoing effort to develop my data science skills and build my portfolio.*
