# AI-Powered Feature Adoption Prediction & Causal Impact Analysis

An end-to-end Product Data Science project focused on understanding user behavior, predicting feature adoption, and evaluating product improvements using machine learning, A/B testing, and causal inference.

## Business Problem

An AI-powered social and productivity platform wants to understand what drives feature adoption and how product improvements influence user engagement and retention.

This project addresses three key questions:

- What factors influence users to adopt product features?
- Can machine learning help identify users likely to adopt features?
- Do product improvements lead to higher adoption and engagement?

## Analysis & Key Findings

### 1. User Behavior & Feature Adoption

- Analyzed user activity, product events, and feature usage.
- Compared adoption patterns across user roles, acquisition channels, and countries.
- Examined SDK integration and first API requests as indicators of user activation.

### 2. Machine Learning — Feature Adoption Prediction

- Developed a Random Forest classifier with preprocessing, feature engineering, and class balancing.
- Used a chronological train-test split and selected a decision threshold of **0.55** based on validation F1-score.

**Test Set Performance**

| Metric | Score |
|---|---:|
| Accuracy | 94.03% |
| Precision | 6.88% |
| Recall | 64.34% |
| F1-score | 12.44% |
| ROC-AUC | 95.47% |
| Average Precision | 7.22% |

**Key Insight:** The model achieved a ROC-AUC of 95.47% and recall of 64.34%, but precision was 6.88%. It can help prioritize users for targeted engagement, although its predictions require further optimization before operational use.

### 3. A/B Testing & Experiment Analysis

- Compared feature adoption between Control and Treatment groups.
- Control adoption rate: **45.85%**.
- Treatment adoption rate: **64.97%**.
- Absolute adoption lift: **19.12 percentage points**.
- Relative adoption lift: **41.71%**.
- Used a two-proportion Z-test and 95% confidence interval to evaluate the difference.
- Observed higher SDK integration, first API request, and D7 retention rates in the Treatment group.

### 4. Causal Inference — Propensity Score Matching

- Applied Propensity Score Matching (PSM) with caliper-based matching.
- Retained **2,885 matched treatment-control pairs**.
- Achieved absolute SMD below **0.10 across all 19 encoded covariates**.
- Matched Treatment adoption rate: **64.71%**.
- Matched Control adoption rate: **45.75%**.
- Matched-sample adoption difference: **18.96 percentage points**.
- Used McNemar's test to evaluate paired binary outcomes.

*Note: The project uses synthetic data. PSM adjusts for observed characteristics but does not establish definitive causality or eliminate unmeasured confounding.*

## Business Recommendations

- Improve onboarding to encourage early feature discovery and adoption.
- Simplify SDK integration and first API requests to reduce activation barriers.
- Use adoption predictions to prioritize targeted user engagement.
- Monitor activation, feature adoption, and D7 retention KPIs.
- Continue controlled experiments to evaluate product improvements.

## Project Outcome

Built an end-to-end Product Data Science workflow combining product analytics, machine learning, statistical testing, A/B experimentation, and causal inference to generate actionable insights for product decision-making.

## Dashboard Preview

### 1. Executive Overview

![Executive Overview Dashboard](screenshots/executive-overview.jpg)

### 2. Product Usage & Engagement

![Product Usage & Engagement Dashboard](screenshots/product-usage-engagement.jpg)

### 3. Experiment & Causal Impact

![Experiment & Causal Impact Dashboard](screenshots/experiment-causal-impact.jpg)

**Dashboard:** AI-Powered Feature Adoption & Causal Impact Dashboard  
**Tool:** Power BI

## Technical Stack

**Programming & Analysis:** Python | Pandas | NumPy | SciPy | Statsmodels

**Machine Learning:** Scikit-learn | Random Forest | Feature Engineering | Classification Evaluation

**Data & Transformation:** SQL Server | BigQuery | dbt

**Visualization:** Matplotlib | Seaborn | Power BI

**Statistical Methods:** A/B Testing | Two-Proportion Z-Test | Confidence Intervals | Propensity Score Matching | Caliper-Based Matching | SMD | McNemar's Test