# Data Cleaning with MySQL

This project demonstrates a systematic approach to cleaning data using SQL on MySQL. The dataset contains various issues typical of real-world data, such as duplicate records, inconsistent formatting, and unnecessary whitespace. The steps in this project illustrate effective SQL techniques to identify and resolve these issues.

## Project Structure

- **sql_scripts/**: Contains the SQL file `Cleaning_Data.sql`, which includes all steps for cleaning the dataset.
- **data/**: Contains the `layoffs` dataset, used as the sample data for this pr

## Steps Covered

### 1. Removing Duplicate Rows
- A `ROW_NUMBER()` function identifies duplicate rows based on key fields such as `company`, `location`, and `industry`.
- The duplicates are then removed to ensure a unique dataset.

### 2. Standardizing Text Data
- Fields like `company` and `industry` are checked for whitespace issues and standardized.
- Inconsistent values (e.g., variations of “crypto”) are unified for better consistency.

### 3. General Data Cleaning
- Other data formatting issues are addressed to prepare the dataset for reliable analysis.

## Key SQL Techniques Used

- **Window Functions**: `ROW_NUMBER()`
- **Text Functions**: `TRIM()`, `UPPER()`, etc.
- **Conditional Updates**: Used for data standardization
