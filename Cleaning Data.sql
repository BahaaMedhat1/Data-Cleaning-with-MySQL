USE MySql_Projects;

-- Creating a copy of our DATASET.
CREATE TABLE lay_copy
AS 
SELECT * FROM layoffs;

-- *******************************************************************************************
-- First Step: Get rid off Duplicate rows 

SELECT -- In thIS query we use a window function to ASsign a number for every row so we can find the duplicates
		*,
		ROW_NUMBER() OVER (PARTITION BY
						   company, location,
						   industry, total_laid_off,
						   percentage_laid_off, DATE,
						   stage, country,
						   funds_raISed_millions) AS row_num
	FROM
		lay_copy;



SELECT -- so if the row hAS number greater than 1 that mean that IS a duplicate row
	*
FROM 
	(SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY
						   company, location,
						   industry, total_laid_off,
						   percentage_laid_off, DATE,
						   stage, country,
						   funds_raISed_millions) AS row_num
	FROM
		lay_copy) AS row_TABLE
WHERE
	row_num > 1;



CREATE TABLE lay_copy2 -- to DELETE the duplicate rows we need to CREATE a new TABLE so we can DELETE it eASily 
AS 
SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY
						   company, location,
						   industry, total_laid_off,
						   percentage_laid_off, DATE,
						   stage, country,
						   funds_raISed_millions) AS row_num
	FROM
		lay_copy;


SET SQL_SAFE_UPDATES = 0; -- To temporarily dISable safe UPDATE mode

DELETE FROM lay_copy2
WHERE row_num > 1;

-- *******************************************************************************************

-- Second Step : Standarized Data	

/* 
Now our mISsion IS to look in the text values of every column to 
check if it hAS any ISsue or NOT.*/

SELECT DISTINCT company -- it looks we have a values with identation 
FROM lay_copy2;


UPDATE lay_copy2 -- removing unwanted spaces
SET company = TRIM(company);


SELECT DISTINCT industry -- we have two values for crypto (crypto & cryptoCurrency & crypto Currency) 
FROM lay_copy2
ORDER BY 1;

UPDATE lay_copy2 -- stANDrized all values of crypto
SET industry = "Crypto Currency"
WHERE industry LIKE "Crypto%";

SELECT DISTINCT country -- we have two value of united states
FROM lay_copy2
ORDER BY 1;


UPDATE lay_copy2 -- stANDrizing values of united states
SET country = "United States"
WHERE country LIKE "united states%";

UPDATE lay_copy2
SET country = "there IS no country called ISr***l"
WHERE country LIKE "IS%"; 


SELECT `DATE` -- if we checked the DATE column we will dIScOVER it's ASsigned AS text NOT DATE AND that would be a problem if try to use any DATE function
FROM lay_copy2;


UPDATE lay_copy2 -- we need to fix the DATE formate before changing it 
SET `DATE` = STR_TO_DATE(`DATE`, "%m/%d/%Y");


ALTER TABLE lay_copy2 -- converting `DATE` column to a DATE datatype
MODIFY COLUMN `DATE` DATE; 


SHOW COLUMNS FROM lay_copy2; -- checkin the DATE column datatype 

-- *******************************************************************************************

-- Third Step: Dealing with NULLS AND BLANK Values

SELECT * FROM lay_copy2  -- we need to replace BLANK Values with NULLS
WHERE industry = "";

UPDATE lay_copy2  -- Replacing BLANK Values with NULLS
SET industry = NULL
WHERE industry = "";



SELECT    -- if you see here we could to fill some industries bASed on aNOTher similar column
	*  
FROM 
	lay_copy2
WHERE 
	 company in (SELECT company
				  FROM lay_copy2
				  WHERE industry IS NULL);



SELECT   -- now we try to JOIN our data so we can fill the mISsing values
	t1.company,
    t1.location,
    t1.industry,
    t2.company,
    t2.location,
    t2.industry
FROM
	lay_copy2 AS t1
JOIN
	lay_copy2 AS t2
ON
	t1.company = t2.company
    AND t1.location = t2.location
WHERE
	t1.industry IS NULL
    AND t2.industry IS NOT NULL;
    
    
    
    
UPDATE lay_copy2 AS t1  -- replacing the values of industry of second TABLE into first TABLE 
JOIN lay_copy2 AS t2
ON 
	t1.company = t2.company
    AND t1.location = t2.location
SET 
	t1.industry = t2.industry 
WHERE
	t1.industry IS NULL
    AND t2.industry IS NOT NULL;
    
    

SELECT  -- we have NULL values in both "total_laid_off" & "percentage_laid_off". so we will remove it because it won't help us in any way.
	*
FROM
	lay_copy2
WHERE
	total_laid_off IS NULL
    AND percentage_laid_off IS NULL;
    

DELETE FROM lay_copy2 -- Deleting NULL Values
WHERE
	total_laid_off IS NULL
    AND percentage_laid_off IS NULL;

-- *******************************************************************************************

-- Final Step : Deleting Any unnecessary column

ALTER TABLE lay_copy2
DROP COLUMN row_num;


SELECT * FROM lay_copy2






