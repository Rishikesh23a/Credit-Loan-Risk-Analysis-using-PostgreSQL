DROP TABLE IF EXISTS credit_data_clean;

/* TABLE 1: credit_data  (RAW / STAGING TABLE)
   ============================================================

   Purpose:
   --------
   - This table stores raw loan data directly loaded from CSV.
   - All columns are stored as TEXT to safely handle:
       • Missing values (NA, empty strings)
       • Incorrect formats
       • Inconsistent data types
   - No business logic or analysis is performed on this table.
   - Used only as a staging layer before cleaning and casting.
*/
---- DATA CLEANING & INSERTION FROM RAW TABLE
CREATE TABLE credit_data_clean (
    loan_id UUID,
    customer_id UUID,
    current_loan_amount NUMERIC(12,2),
    term VARCHAR(20),
    credit_score INT,
    annual_income NUMERIC(14,2),
    years_in_current_job VARCHAR(50),
    home_ownership VARCHAR(30),
    purpose VARCHAR(100),
    monthly_debt NUMERIC(12,2),
    years_of_credit_history NUMERIC(6,2),
    months_since_last_delinquent NUMERIC(6,2),
    number_of_open_accounts INT,
    number_of_credit_problems INT,
    current_credit_balance NUMERIC(14,2),
    maximum_open_credit NUMERIC(14,2),
    bankruptcies INT,
    tax_liens INT
);

/* ============================================================
   TABLE 2: credit_data_clean  (CLEAN / ANALYTICAL TABLE)
   ============================================================

   Purpose:
   --------
   - This is the final cleaned and structured table used
     for all analysis and reporting.
   - Data is converted from TEXT to appropriate data types
     such as UUID, NUMERIC, and INT.
   - Handles missing values using NULLIF and safe casting.

   Data Transformations Applied:
   ------------------------------
   - Empty strings ('') converted to NULL
   - UUID fields safely cast from TEXT
   - Numeric financial fields converted to NUMERIC
   - Credit score converted to INT
   - Categorical fields standardized using INITCAP()
*/
-- DATA CLEANING & INSERTION FROM RAW TABLE
INSERT INTO credit_data_clean
SELECT
    NULLIF(loan_id, '')::UUID,
    NULLIF(customer_id, '')::UUID,
    NULLIF(current_loan_amount, '')::NUMERIC,
    INITCAP(term),
    NULLIF(credit_score, '')::INT,
    NULLIF(annual_income, '')::NUMERIC,
    years_in_current_job,
    INITCAP(home_ownership),
    INITCAP(purpose),
    NULLIF(monthly_debt, '')::NUMERIC,
    NULLIF(years_of_credit_history, '')::NUMERIC,
    NULLIF(months_since_last_delinquent, '')::NUMERIC,
    NULLIF(number_of_open_accounts, '')::INT,
    NULLIF(number_of_credit_problems, '')::INT,
    NULLIF(current_credit_balance, '')::NUMERIC,
    NULLIF(maximum_open_credit, '')::NUMERIC,
    NULLIF(bankruptcies, '')::INT,
    NULLIF(tax_liens, '')::INT
FROM credit_data;

SELECT COUNT(*) FROM credit_data_clean;

SELECT * FROM credit_data_clean LIMIT 10;

SELECT * FROM credit_data_clean ;


-- 1. Total number of loans
SELECT COUNT(*) AS total_loans
FROM credit_data_clean;


-- 2. Average loan amount
SELECT ROUND(AVG(current_loan_amount), 2) AS avg_loan_amount
FROM credit_data_clean;


-- 3. Average credit score
SELECT ROUND(AVG(credit_score), 2) AS avg_credit_score
FROM credit_data_clean;


-- 4. Loan distribution by term
SELECT
    term,
    COUNT(*) AS loan_count
FROM credit_data_clean
GROUP BY term
ORDER BY loan_count DESC;

-- 5. Home ownership distribution
SELECT
    home_ownership,
    COUNT(*) AS total_customers
FROM credit_data_clean
GROUP BY home_ownership
ORDER BY total_customers DESC;


-- 6. Credit score segmentation
SELECT
    CASE
        WHEN credit_score >= 750 THEN 'Excellent'
        WHEN credit_score BETWEEN 700 AND 749 THEN 'Good'
        WHEN credit_score BETWEEN 650 AND 699 THEN 'Fair'
        ELSE 'Poor'
    END AS credit_category,
    COUNT(*) AS customers
FROM credit_data_clean
GROUP BY credit_category
ORDER BY customers DESC;


-- 7. Purpose-wise loan amount analysis
SELECT
    purpose,
    ROUND(AVG(current_loan_amount), 2) AS avg_loan_amount
FROM credit_data_clean
GROUP BY purpose
ORDER BY avg_loan_amount DESC;


-- 8. Debt-to-Income (DTI) calculation
SELECT
    loan_id,
    annual_income,
    monthly_debt,
    ROUND((monthly_debt / (annual_income / 12)) * 100, 2) AS dti_percentage
FROM credit_data_clean
WHERE annual_income > 0
  AND monthly_debt IS NOT NULL;


-- 9. Customers with high DTI (>40%)
SELECT *
FROM (
    SELECT
        loan_id,
        ROUND((monthly_debt / (annual_income / 12)) * 100, 2) AS dti_percentage
    FROM credit_data_clean
    WHERE annual_income > 0
      AND monthly_debt IS NOT NULL
) t
WHERE dti_percentage > 40;


-- 10. Risk classification model
SELECT
    loan_id,
    credit_score,
    annual_income,
    monthly_debt,
    CASE
        WHEN credit_score < 600 THEN 'High Risk'
        WHEN credit_score BETWEEN 600 AND 699 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM credit_data_clean;


-- 11. Rank loans by loan amount (Window Function)
SELECT
    loan_id,
    current_loan_amount,
    RANK() OVER (ORDER BY current_loan_amount DESC) AS loan_rank
FROM credit_data_clean;


-- 12. Credit utilization ratio
SELECT
    loan_id,
    ROUND(
        current_credit_balance / NULLIF(maximum_open_credit, 0),
        2
    ) AS credit_utilization_ratio
FROM credit_data_clean;


-- 13. Customers with credit utilization > 80%
SELECT *
FROM (
    SELECT
        loan_id,
        ROUND(
            current_credit_balance / NULLIF(maximum_open_credit, 0),
            2
        ) AS credit_utilization_ratio
    FROM credit_data_clean
) t
WHERE credit_utilization_ratio > 0.8;


-- 14. Potential defaulters (high-risk customers)
SELECT *
FROM credit_data_clean
WHERE credit_score < 650
  AND bankruptcies > 0
  AND tax_liens > 0;


--Loan Amount Distribution (Min, Max, Avg)
SELECT
    MIN(current_loan_amount) AS min_loan,
    MAX(current_loan_amount) AS max_loan,
    ROUND(AVG(current_loan_amount), 2) AS avg_loan
FROM credit_data_clean;


--Top 5 Loans per Purpose
SELECT *
FROM (
    SELECT
        loan_id,
        purpose,
        current_loan_amount,
        RANK() OVER (PARTITION BY purpose ORDER BY current_loan_amount DESC) AS rnk
    FROM credit_data_clean
) t
WHERE rnk <= 5;
