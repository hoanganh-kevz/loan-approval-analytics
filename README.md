# Loan Approval Analytics

An end-to-end data analytics project analyzing loan applications, approval patterns, borrower characteristics, and credit risk using SQL Server and Power BI.

## 📌 Project Overview

This project analyzes loan application data to understand the factors associated with loan approval and borrower risk.

The analysis focuses on:

- Loan approval performance
- Credit score and approval relationships
- Employment status
- Loan purposes
- Debt-to-income ratio
- Risk score
- Borrower age groups
- Loan amount and financial characteristics

The project combines **SQL Server for data analysis** and **Power BI for interactive data visualization**.

---

## 🎯 Business Questions

This project aims to answer the following questions:

1. What is the overall loan approval rate?
2. How does credit score affect loan approval?
3. Which employment groups have higher approval rates?
4. Which loan purposes receive the most applications?
5. How does RiskScore relate to approval outcomes?
6. How does Debt-to-Income Ratio differ by employment status?
7. Which borrower segments represent higher financial risk?
8. How do loan amounts vary across borrower groups?

---

## 🛠️ Tools & Technologies

- **SQL Server**
  - Aggregation
  - CASE WHEN
  - CTE
  - Window Functions
  - NTILE
  - Data segmentation

- **Power BI**
  - Data visualization
  - DAX
  - Slicers
  - KPI Cards
  - Interactive dashboard

- **GitHub**
  - Project documentation
  - Version control
  - Portfolio

---

## 📂 Dataset

The dataset contains information about loan applicants, including:

- Credit Score
- Annual Income
- Loan Amount
- Debt-to-Income Ratio
- Employment Status
- Education Level
- Loan Purpose
- Risk Score
- Bankruptcy History
- Loan Approval Status

### Dataset Source

The dataset was obtained from Kaggle:

[Financial Risk for Loan Approval](https://www.kaggle.com/datasets/lorenzozoppelletto/financial-risk-for-loan-approval)

> The dataset is used for educational and analytical purposes.

---

## 📊 SQL Analysis

The SQL analysis includes:

- Overall loan application and approval statistics
- RiskScore analysis
- Loan purpose analysis
- Credit score segmentation
- Bankruptcy history analysis
- Debt-to-income ratio analysis
- Employment status analysis
- Education level analysis
- Age segmentation
- RiskScore segmentation
- RiskScore quartile analysis using `NTILE()`

SQL queries can be found in:

`sql/loan_analysis.sql`

---

## 📈 Power BI Dashboard

The Power BI dashboard provides an interactive overview of loan applications and approval patterns.

### Dashboard Preview

![Loan Approval Dashboard](screenshots/dashboard_overview.png)

### Dashboard Features

- Total Loans
- Approved Loans
- Approval Rate
- Average Credit Score
- Applications by Credit Score Range
- Approval Rate by Employment Status
- Approval Rate by Loan Purpose
- Approved Loans Trend
- Loan Amount by Employment Status
- Interactive filters

Power BI file:

`powerbi/Loan_Approval_Analytics.pbix`

---

## 🔎 Key Insights

The analysis examines the relationship between:

### Credit Score

Applicants are segmented into four credit score ranges to evaluate differences in approval rates.

### Employment Status

Approval rates and financial characteristics are compared between employed, self-employed, and unemployed applicants.

### Loan Purpose

Different loan purposes are analyzed based on application volume, approval rate, and average loan amount.

### Risk Score

Borrowers are divided into risk segments to compare approval rate, loan amount, and credit characteristics.

### Age

Borrowers are grouped into four age ranges to evaluate differences in risk profiles.

Detailed insights:

`docs/insights.md`

---

## 📁 Project Structure

```text
loan-approval-analytics/
│
├── README.md
│
├── data/
│   └── README.md
│
├── sql/
│   └── loan_analysis.sql
│
├── powerbi/
│   └── Loan_Approval_Analytics.pbix
│
├── screenshots/
│   └── dashboard_overview.png
│
└── docs/
    └── insights.md
