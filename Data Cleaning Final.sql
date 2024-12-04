-- Create a new database and switch to it
CREATE DATABASE IF NOT EXISTS healthcaredb;
USE healthcaredb;

-- Rename the original table for clarity
RENAME TABLE healthcare_dataset TO hospital;

-- Sample data preview and column structure check
SELECT * FROM hospital LIMIT 5;
SHOW COLUMNS FROM hospital;

-- ---------------------------------------------
-- 1. COLUMN RENAMING AND DATA TYPE CORRECTION
-- ---------------------------------------------

-- Standardizing column names to follow snake_case format and correcting data types

ALTER TABLE hospital 
    CHANGE `Blood Type` blood_type VARCHAR(10),
    CHANGE `Medical Condition` medical_condition VARCHAR(30),
    CHANGE `Date of Admission` admit_date DATE,
    CHANGE `Insurance Provider` insurance_provider VARCHAR(50),
    CHANGE `Billing Amount` billing_amount DOUBLE,
    CHANGE `Room Number` room_number INT,
    CHANGE `admission type` admission_type VARCHAR(50),
    CHANGE `Discharge Date` discharge_date DATE,
    CHANGE `Test Results` test_results VARCHAR(30);

-- ------------------------------------------------------
-- 2. DUPLICATE RECORDS IDENTIFICATION AND REMOVAL
-- ------------------------------------------------------

-- Check total records vs unique records to identify duplicates
SELECT COUNT(*) AS total_records FROM hospital
UNION ALL
SELECT COUNT(DISTINCT Name, Age, Gender, blood_type, medical_condition, admit_date, Doctor,
				Hospital, insurance_provider, billing_amount, room_number, admission_type,
                discharge_date, Medication, test_results) 
	AS unique_records FROM hospital;

SHOW columns FROM hospital; 

-- Remove duplicates (if any) by creating a new table with distinct records
CREATE TABLE hospital_temp AS
SELECT DISTINCT * FROM hospital;

-- Verify record count to ensure duplicates were removed
SELECT COUNT(*) FROM hospital_temp;

-- ------------------------------------------------------
-- 3. MISSING VALUES IDENTIFICATION
-- ------------------------------------------------------

-- Check for missing/null values in key columns
SELECT 
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Name_nulls,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_nulls,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_nulls,
    SUM(CASE WHEN blood_type IS NULL THEN 1 ELSE 0 END) AS Blood_type_nulls,
    SUM(CASE WHEN medical_condition IS NULL THEN 1 ELSE 0 END) AS Medical_condition_nulls,
    SUM(CASE WHEN admit_date IS NULL THEN 1 ELSE 0 END) AS Admit_date_nulls,
    SUM(CASE WHEN Doctor IS NULL THEN 1 ELSE 0 END) AS Doctor_nulls,
    SUM(CASE WHEN Hospital IS NULL THEN 1 ELSE 0 END) AS Hospital_nulls,
    SUM(CASE WHEN insurance_provider IS NULL THEN 1 ELSE 0 END) AS Insurance_provider_nulls,
    SUM(CASE WHEN billing_amount IS NULL THEN 1 ELSE 0 END) AS Billing_amount_nulls,
    SUM(CASE WHEN room_number IS NULL THEN 1 ELSE 0 END) AS Room_number_nulls,
    SUM(CASE WHEN admission_type IS NULL THEN 1 ELSE 0 END) AS Admission_type_nulls,
    SUM(CASE WHEN discharge_date IS NULL THEN 1 ELSE 0 END) AS Discharge_date_nulls,
    SUM(CASE WHEN Medication IS NULL THEN 1 ELSE 0 END) AS Medication_nulls,
    SUM(CASE WHEN test_results IS NULL THEN 1 ELSE 0 END) AS Test_results_nulls
FROM hospital_temp;

-- Since no missing values are detected, we can proceed to the next step.
-- Optionally, create a copy of the table without missing values for further cleaning.
CREATE TABLE hosp_nonull AS
SELECT * FROM hospital_temp;

-- ------------------------------------------------------
-- 4. DATA STANDARDIZATION AND CLEANING
-- ------------------------------------------------------

-- 4.1 Name Standardization: Clean up titles and ensure consistent capitalization of names
UPDATE hosp_nonull
SET name = TRIM(REPLACE(REPLACE(REPLACE(LOWER(name), 'mr.', ''), 'ms.', ''), 'dr.', ''));

-- Fix capitalization: Capitalize first letter of each part of the name
UPDATE hosp_nonull
SET name = CONCAT(
    UPPER(SUBSTRING(name, 1, 1)), 
    LOWER(SUBSTRING(name, 2, LOCATE(' ', name) - 1)),
    ' ',
    UPPER(SUBSTRING(name, LOCATE(' ', name) + 1, 1)),
    LOWER(SUBSTRING(name, LOCATE(' ', name) + 2))
)
WHERE name IS NOT NULL;

-- 4.2 Age Validation: Check if age values are within a reasonable range (18-85)
SELECT MIN(age) AS minimum_age, MAX(age) AS maximum_age FROM hosp_nonull;

-- 4.3 Gender: Verify gender values are clean and consistent
SELECT DISTINCT gender FROM hosp_nonull;

-- 4.4 Blood Type: Check distinct blood types for inconsistencies
SELECT DISTINCT blood_type FROM hosp_nonull;

-- 4.5 Medical Condition: Verify distinct medical conditions for cleaning needs
SELECT DISTINCT medical_condition FROM hosp_nonull;

-- 4.6 Doctor Name Standardization: Clean up titles (similar to name cleanup)
UPDATE hosp_nonull
SET doctor = TRIM(REPLACE(REPLACE(REPLACE(LOWER(doctor), 'mr.', ''), 'ms.', ''), 'dr.', ''));

-- ---------------------------------------------
-- 5. FINAL CLEANED DATASET PREPARATION
-- ---------------------------------------------

-- Create the final cleaned dataset
CREATE TABLE hospital_final AS
SELECT * FROM hosp_nonull;

-- Final record count verification
SELECT COUNT(*) FROM hospital_final;
