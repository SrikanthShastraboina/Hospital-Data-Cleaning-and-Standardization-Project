# Hospital Data Cleaning and Standardization Project

This repository contains SQL scripts for cleaning, standardizing, and preparing a healthcare dataset for analysis. The data is sourced from a hospital database and involves several cleaning processes such as renaming columns, removing duplicates, handling missing values, and ensuring consistency across the dataset. The goal is to ensure data quality for further analysis and insights extraction.

## Project Overview

The objective of this project is to clean and standardize a hospital dataset to make it ready for analysis. This includes:
- Correcting data types and standardizing column names.
- Removing duplicate records.
- Handling missing data.
- Cleaning up inconsistencies in text fields (names, gender, etc.).
- Validating data ranges for fields such as age and medical condition.

## Database and Table Structure

The dataset resides in a MySQL database named `healthcaredb`. The table used in this project is called `hospital`, which undergoes various transformations during the cleaning process. The final cleaned table is named `hospital_final`.

### Columns in the Dataset
The `hospital` table contains the following columns:
- `Name`: The patient's name.
- `Age`: The patient's age.
- `Gender`: The patient's gender.
- `blood_type`: The patient's blood type.
- `medical_condition`: The patient's medical condition.
- `admit_date`: The date of hospital admission.
- `Doctor`: The attending doctor's name.
- `Hospital`: The hospital name.
- `insurance_provider`: The patient's insurance provider.
- `billing_amount`: The total amount billed for the hospital visit.
- `room_number`: The patient's room number.
- `admission_type`: The type of hospital admission.
- `discharge_date`: The date of discharge.
- `Medication`: Any medications prescribed to the patient.
- `test_results`: Results of any tests performed during the hospital stay.

## Steps in Data Cleaning

### 1. Column Renaming and Data Type Correction
- Standardized column names to `snake_case` format.
- Corrected data types for fields (e.g., date and numeric fields).

### 2. Duplicate Records Identification and Removal
- Checked for duplicate records by comparing all columns.
- Created a new table with distinct records to remove duplicates.

### 3. Missing Values Identification
- Checked key columns for missing or null values.
- Ensured that no missing values exist in critical fields.

### 4. Data Standardization
- **Name Standardization**: Removed prefixes (e.g., Mr., Ms., Dr.) and ensured consistent capitalization of names.
- **Age Validation**: Checked that ages are within a valid range (18-85 years).
- **Gender Standardization**: Verified that gender values are consistent.
- **Blood Type Consistency**: Checked blood type values for inconsistencies.
- **Medical Condition Standardization**: Verified and cleaned the list of distinct medical conditions.

### 5. Final Cleaned Dataset Preparation
- Created a final cleaned table, `hospital_final`, ready for analysis and insights extraction.

## SQL Script

The complete SQL script for cleaning the dataset can be found in the file [`data_cleaning.sql`](data_cleaning.sql). This script includes all the steps mentioned above, starting from creating the database, renaming columns, and ending with the final cleaned dataset.

## How to Use

1. Clone the repository.
2. Run the SQL script on a MySQL server to create the cleaned dataset.
3. Use the `hospital_final` table for analysis and generating insights.

## Future Work

- Add further data validation checks.
- Implement more advanced cleaning techniques for specific fields like medical conditions.
- Automate data cleaning processes for larger datasets.

