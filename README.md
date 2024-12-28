# Data Cleaning with MySQL

This project demonstrates a systematic approach to cleaning data using SQL on MySQL. The dataset contains various issues typical of real-world data, such as duplicate records, inconsistent formatting, and unnecessary whitespace. The steps in this project illustrate effective SQL techniques to identify and resolve these issues.

## Project Structure

- **Cleaning Data**: Contains the SQL file `Cleaning_Data.sql`, which includes all steps for cleaning the dataset.
- **layoffs.csv**: Contains the `layoffs` dataset, which includes information about companies, their layoffs, and related statistics. The dataset has fields like company names, industry, location, number of layoffs, and the date of the layoffs. This data is used to demonstrate data cleaning techniques.

## Steps Covered

### 1. Removing Duplicate Rows
- **Purpose**: Duplicate records can skew analysis and lead to incorrect conclusions. The `ROW_NUMBER()` function is used to identify duplicate rows based on key fields such as `company`, `location`, `industry`, and other attributes. These duplicates are then removed to ensure a unique and accurate dataset.

### 2. Standardizing Text Data
- **Purpose**: Data entries may have inconsistent formatting, such as leading/trailing spaces or slight variations in names (e.g., "Crypto" vs "Crypto Currency"). These inconsistencies can hinder data analysis. Fields like `company`, `industry`, and `country` are standardized to ensure uniformity across the dataset, making it easier to work with.

### 3. General Data Cleaning
- **Purpose**: After handling duplicates and standardizing text data, additional formatting and data type issues are addressed. This includes ensuring proper data types (e.g., converting dates from text format to a `DATE` type) and handling missing or null values. By cleaning this data, we ensure the dataset is ready for reliable analysis.

## Key SQL Techniques Used

- **Window Functions**: The `ROW_NUMBER()` function was used to identify and manage duplicate rows by partitioning data into logical groups.
- **Text Functions**: Functions like `TRIM()` were used to clean up leading/trailing spaces and standardize text values, ensuring consistency across the dataset.
- **Conditional Updates**: Conditional updates were performed for tasks such as standardizing values (e.g., changing "Crypto" to "Crypto Currency") and ensuring consistency in textual data.
- **JOIN Operations**: JOIN operations were used to fill missing values in the dataset by matching records from different rows based on common attributes, ensuring that the data was as complete as possible.
  
## Explanation for Data Types

- **DATE Conversion**: The dataset initially had dates stored as text, which could cause issues when performing date-related operations (e.g., filtering or sorting by date). Converting the `DATE` column to the appropriate `DATE` datatype ensures that MySQL correctly handles date functions and operations, providing accurate results when querying the data.
---  

## Some of SQL Operations used in this project

### 1. Removing Duplicate rows 
```sql
-- Query to identify duplicate rows using window function

SELECT 
    *, 
    ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, 
                       percentage_laid_off, `DATE`, stage, country, funds_raISed_millions) AS row_num
FROM lay_copy;


-- Query to find duplicate rows where row_num > 1

SELECT *
FROM (
    SELECT 
        *, 
        ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, 
                           percentage_laid_off, `DATE`, stage, country, funds_raISed_millions) AS row_num
    FROM lay_copy
) AS row_TABLE
WHERE row_num > 1;

-- Creating a new table to delete duplicates easily

CREATE TABLE lay_copy2 AS
SELECT 
    *, 
    ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, 
                       percentage_laid_off, `DATE`, stage, country, funds_raISed_millions) AS row_num
FROM lay_copy;

-- Disabling safe update mode temporarily to allow delete

SET SQL_SAFE_UPDATES = 0;

-- Deleting duplicate rows
DELETE FROM lay_copy2
WHERE row_num > 1;
```  

### 2. Standardize Data
```sql
-- Checking for distinct company names to identify unwanted spaces
SELECT DISTINCT company FROM lay_copy2;

-- Removing unwanted spaces from the 'company' column
UPDATE lay_copy2 SET company = TRIM(company);

-- Checking for distinct values in the 'industry' column to standardize "crypto"
SELECT DISTINCT industry FROM lay_copy2 ORDER BY 1;

-- Standardizing 'industry' values related to crypto
UPDATE lay_copy2 SET industry = "Crypto Currency" WHERE industry LIKE "Crypto%";

-- Checking for distinct country values to standardize "United States"
SELECT DISTINCT country FROM lay_copy2 ORDER BY 1;

-- Standardizing 'country' values related to United States
UPDATE lay_copy2 SET country = "United States" WHERE country LIKE "united states%";

-- Updating 'country' values for Israel
UPDATE lay_copy2 SET country = "there IS no country called ISr***l" WHERE country LIKE "IS%";

-- Checking the 'DATE' column for formatting issues
SELECT `DATE` FROM lay_copy2;

-- Fixing the DATE format before changing it
UPDATE lay_copy2 SET `DATE` = STR_TO_DATE(`DATE`, "%m/%d/%Y");

-- Converting 'DATE' column to DATE datatype
ALTER TABLE lay_copy2 MODIFY COLUMN `DATE` DATE;

-- Checking the columns of the updated table
SHOW COLUMNS FROM lay_copy2;
```

### 3. Dealing with NULLs and Blank Values
```sql
-- Identifying rows with blank values in the 'industry' column
SELECT * FROM lay_copy2 WHERE industry = "";

-- Replacing blank values with NULL in the 'industry' column
UPDATE lay_copy2 SET industry = NULL WHERE industry = "";

-- Filling missing 'industry' values based on other columns
SELECT * FROM lay_copy2 WHERE company IN (SELECT company FROM lay_copy2 WHERE industry IS NULL);

-- Joining data to fill missing 'industry' values
SELECT 
    t1.company, t1.location, t1.industry, 
    t2.company, t2.location, t2.industry
FROM lay_copy2 AS t1
JOIN lay_copy2 AS t2 ON t1.company = t2.company AND t1.location = t2.location
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- Updating missing 'industry' values by joining tables
UPDATE lay_copy2 AS t1
JOIN lay_copy2 AS t2 ON t1.company = t2.company AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- Identifying rows where both 'total_laid_off' and 'percentage_laid_off' are NULL
SELECT *
FROM lay_copy2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Deleting rows with NULL values in both 'total_laid_off' and 'percentage_laid_off'
DELETE FROM lay_copy2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
```

### 4. Deleting Any Unnecessary Columns
```sql
-- Dropping the 'row_num' column as it's no longer needed
ALTER TABLE lay_copy2 DROP COLUMN row_num;

-- Displaying the final version of the table
SELECT * FROM lay_copy2;
```

## Contact

For any queries or suggestions, feel free to reach out:  
**Bahaa Medhat Wanas**  
- LinkedIn: [Bahaa Wanas](https://www.linkedin.com/in/bahaa-wanas-9797b923a)  
- Email: [bahaawanas427@gmail.com](mailto:bahaawanas427@gmail.com)
