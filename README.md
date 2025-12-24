# 🏦 Credit Loan Risk Analysis using PostgreSQL

<p align="center">
  <img 
    src="Screenshots/businessman-carrying-money-bag-balancing-on-seesaw-facing-financial-risk-challenge-with-risk-blocks-metaphor-free-vector.webp" 
    width="500"
  />
</p>

---

## 📌 Project Overview
This project focuses on **Credit Loan Risk Analysis** using **PostgreSQL**.  
It analyzes real-world loan data to identify **financial risk**, **credit behavior**, and **potential defaulters** using SQL.

The project follows a **real industry data analytics pipeline**:
- Raw data ingestion  
- Data cleaning & transformation  
- Business analysis  
- Advanced risk analytics  

---

## 🎯 Why This Project Matters

Credit risk analysis is crucial in banking and financial services for:
- Evaluating loan applicants
- Reducing default losses
- Improving lending decisions
- Supporting fair risk-based pricing

This project showcases **how to handle messy real-world data**, perform **data cleaning**, and generate **business and risk insights** using SQL.

---

## 🎯 Project Objectives
- Clean and standardize messy loan data
- Analyze customer credit behavior
- Identify high-risk customers
- Calculate key risk metrics:
  - Debt-to-Income (DTI)
  - Credit Utilization Ratio
  - Risk Categories
- Showcase strong **SQL + PostgreSQL** skills

---

## 🛠️ Tools & Technologies
| Tool | Usage |
|----|----|
| PostgreSQL 18 | Database |
| SQL | Data Cleaning & Analysis |
| pgAdmin 4 | Query Execution |
| CSV Dataset | Loan Data |
| GitHub | Version Control |

---


---

## 🧱 Database Design

### 🔹 Raw Table – `credit_data`
- Stores CSV data exactly as imported
- All columns stored as **TEXT**
- Prevents issues with:
  - `NA` values
  - Empty strings
  - Invalid formats

### 🔹 Clean Table – `credit_data_clean`
Used for all analytics after:
- Type conversion
- NULL handling
- Data standardization

---

## 🧹 Data Cleaning Highlights
- Converted `NA` and empty values to `NULL`
- Safely cast TEXT → UUID / NUMERIC / INT
- Standardized categorical values
- Handled real-world data inconsistencies

---

## 📊 Analysis Performed

### ✅ Basic Analysis
- Total loans
- Average loan amount
- Average credit score
- Loan distribution by term

### 📈 Moderate Analysis
- Credit score segmentation
- Purpose-wise loan analysis
- Debt-to-Income (DTI) calculation

### 🚀 Advanced Analysis
- Risk classification
- Credit utilization ratio
- Potential defaulter detection
- Window functions & ranking
- Composite risk scoring

---

## 🧠 Key Insights
- High DTI + low credit score = higher default risk
- Credit utilization is a strong stress indicator
- Certain loan purposes contribute more to risk exposure

---


## 🚀 Future Enhancements
- Power BI / Tableau dashboard
- Machine Learning model for default prediction
- Automated ETL pipeline

---

## ⭐ Conclusion
This project demonstrates **real-world SQL skills**, **data cleaning expertise**, and **advanced analytical thinking** suitable for **Data Analyst / FinTech roles**.

---

### ⭐ If you find this project useful, give it a star!

---

## 👨‍💻 Developer

Rushikesh Sable

MIT AOE College,Pune

📧 rushikeshsable9850@gmail.com
---
