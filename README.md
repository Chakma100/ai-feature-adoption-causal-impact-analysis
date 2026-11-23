# AI-Powered Feature Adoption Prediction & Causal Impact Analysis

## Business Problem

An AI-powered social and productivity platform wants to better understand how users interact with its features and what influences their adoption. The product team also wants to evaluate whether product improvements lead to better user engagement and retention.

This project focuses on three key business challenges:

- Understanding user behavior and identifying the factors that influence feature adoption.
- Predicting feature adoption and exploring user engagement patterns.
- Measuring the impact of product improvements through A/B testing and causal inference.

## Analysis & Key Findings

### 1. User Behavior & Feature Adoption Analysis

- Analyzed user activity, product events, and feature usage to understand how users interact with the platform.
- Compared feature adoption across user roles, acquisition channels, and countries.
- Examined SDK integration and first API requests as indicators of user activation.
- Developed a Random Forest classification workflow to predict feature adoption.

### 2. A/B Testing & Experiment Analysis

- Compared feature adoption between the Control and Treatment groups.
- Found an adoption rate of **45.85%** in the Control group and **64.97%** in the Treatment group.
- Observed an absolute adoption lift of **19.12 percentage points** and a relative lift of **41.71%**.
- Used a two-proportion Z-test and a 95% confidence interval to assess the adoption difference.
- Found higher SDK integration, first API request, and D7 retention rates in the Treatment group.

### 3. Causal Inference & Propensity Score Matching

- Applied **Propensity Score Matching (PSM)** to compare treatment and control users with similar observed characteristics.
- Used caliper-based matching to improve the quality of matched comparisons.
- Evaluated covariate balance using Standardized Mean Difference (SMD).
- Retained **2,885 matched treatment-control pairs** after caliper matching.
- Achieved an absolute SMD below **0.10 across all 19 encoded covariates**.
- Found a matched Treatment adoption rate of **64.71%**, compared with **45.75%** in the matched Control group.
- Observed a matched-sample adoption difference of **18.96 percentage points**.
- Used McNemar's test to evaluate paired binary outcomes.

*Note: This project uses synthetic data. Propensity Score Matching provides an adjusted comparison based on observed characteristics, but it does not establish definitive causality.*

## Business Recommendations

- Improve the onboarding experience to help new users discover and adopt product features.
- Make SDK integration and first API requests easier to reduce activation barriers.
- Identify user segments with lower adoption rates and develop targeted engagement strategies.
- Monitor early user activity and D7 retention to better understand engagement patterns.
- Continue using controlled experiments to evaluate future product improvements.
- Track feature adoption, activation, engagement, and retention KPIs regularly.

## Project Outcome

Developed an end-to-end Product Data Science workflow that combines product analytics, machine learning, statistical analysis, A/B testing, and causal inference. The project demonstrates how user behavior data can support product decisions and help identify opportunities to improve feature adoption and retention.

## Technical Stack

Python | Pandas | NumPy | SciPy | Statsmodels | Scikit-learn | Matplotlib | Seaborn | SQL Server | BigQuery | dbt | Power BI

**Causal Inference Methods:** Propensity Score Matching (PSM) | Caliper-Based Matching | Standardized Mean Difference (SMD) | Covariate Balance Assessment | Matched-Sample Treatment Effect Estimation | McNemar's Test

**Statistical & Experimentation Methods:** A/B Testing | Two-Proportion Z-Test | Hypothesis Testing | Confidence Intervals | Absolute Lift | Relative Lift