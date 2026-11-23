# Machine Learning Methodology

## 1. Project Overview

Project: AI-Powered Feature Adoption Prediction & Causal Impact Analysis for Developer Tools

Objective: Predict whether a user will adopt API Monitoring within the next 30 days.

Dataset: Synthetic developer-tool product usage data.

## 2. Prediction Definition

- Observation window: Previous 30 days.
- Prediction window: Next 30 days.
- Target: feature_adopted.
- Positive class (1): User adopts API Monitoring within the prediction window.
- Negative class (0): User does not adopt API Monitoring within the prediction window.

## 3. Dataset and Cohort Structure

The modeling dataset contains user-by-index-date cohort records.

- Number of cohort index dates: 32.
- Cohort date range: 2024-03-01 to 2026-09-17.
- Each record represents a user at a specific index date.
- Users may appear in multiple cohorts.

## 4. Feature Engineering

Features were calculated using information available during the observation window.

Feature groups include:
- User activity and engagement.
- Event and session behavior.
- API usage and performance.
- Organization characteristics.
- Subscription information.
- Previous feature adoption.

Leakage prevention:
- Post-adoption monitoring_enabled was excluded.
- usage_count and last_used_at were excluded.
- subscriptions.end_date was excluded because it represents current/final status.

## 5. Train-Test Split

A chronological split was used.

Training:
- First 24 cohort dates.
- 2024-03-01 to 2026-01-20.
- 70,577 records.

Testing:
- Last 8 cohort dates.
- 2026-02-19 to 2026-09-17.
- 56,642 records.

The test period represents future cohorts rather than a random sample.

## 6. Class Imbalance

Training positive rate: 2.30%.

Test positive rate: 0.66%.

The positive class is substantially underrepresented.

## 7. Models Evaluated

- Dummy Classifier.
- Logistic Regression.
- Decision Tree.
- Random Forest.

Random Forest was selected based on validation and test evaluation results.

## 8. Threshold Selection

A chronological validation split was used.

The selected threshold was 0.55, based on validation F1-score.

The threshold is provisional and may require recalibration for different business costs.

## 9. Evaluation Metrics

Metrics:
- Accuracy.
- Precision.
- Recall.
- F1-score.
- ROC-AUC.
- Average Precision.

Average Precision was used to evaluate ranking performance under class imbalance.

## 10. Model Interpretation

Two feature importance methods were used:

- Random Forest impurity-based importance.
- Permutation importance using Average Precision.

signup_tenure_days was the strongest feature by permutation importance.

Feature importance indicates predictive contribution, not causation.

## 11. Limitations

- The dataset is synthetic.
- The target class is highly imbalanced.
- Test precision is low.
- Adoption prevalence differs between training and test periods.
- Users overlap across training and test cohorts.
- Feature importance does not establish causal relationships.
- Real-world validation is required.
