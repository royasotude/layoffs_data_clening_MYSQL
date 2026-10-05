
# Layoffs Data Cleaning with MySQL

A SQL data cleaning project on a global tech layoffs dataset (2020–2023), turning raw, messy records into an analysis-ready table.

> Based on a YouTube tutorial by **[Alex The Analyst + https://www.youtube.com/watch?v=4UltKCnnnTA]**.

## Objective
Clean the raw `layoffs` table using only MySQL, following a four-step workflow, while preserving the original data.

## Workflow

| Step | What I did |
|------|-----------|
| **1. Remove duplicates** | Copied raw data into staging tables, then used `ROW_NUMBER() OVER (PARTITION BY ...)` across all columns to flag and delete duplicates. |
| **2. Standardize data** | Trimmed whitespace in `company`; merged variants (e.g. `Crypto`, `Crypto Currency`) into one label; fixed `United States.` with `TRIM(TRAILING)`; converted `date` from text to `DATE` using `STR_TO_DATE`. |
| **3. Handle NULL/blank values** | Converted blanks to `NULL`; filled missing `industry` values by self-joining on company; removed rows where both `total_laid_off` and `percentage_laid_off` were NULL. |
| **4. Remove unnecessary columns** | Dropped the helper `row_num` column. |

## Results
- Raw rows: **2,361**
- Final cleaned rows: **1,995**

## SQL Techniques Used
CTEs · Window functions (`ROW_NUMBER`) · Self-joins · `UPDATE` with `JOIN` · String functions (`TRIM`) · Date conversion (`STR_TO_DATE`) · `ALTER TABLE`

## Key Decisions
- **Staging tables:** the raw table is never modified, so the process can be repeated safely.
- **Dropped rows with no layoff data:** rows with neither a count nor a percentage can't support analysis. This is a judgement call, and these rows could be kept for other uses.
- **No unique ID:** duplicates were defined as identical values across all columns.

## Repository Structure
```
├── data/
│   └── layoffs.csv
├── layoffs_data_cleaning.sql
└── README.md
```

## How to Run
1. Import `layoffs.csv` into a MySQL schema as a table named `layoffs`.
2. Run `layoffs_data_cleaning.sql` step by step in MySQL Workbench.

## Next Steps
Exploratory analysis of layoffs by year, industry, country, and company.
