# Machine Learning Project Report

## AI-Powered Feature Adoption Prediction & Causal Impact Analysis for Developer Tools

## 1. Executive Summary

This project develops a machine learning model to predict whether a developer-tool user will adopt API Monitoring within the next 30 days.

The project uses synthetic product usage data and a Random Forest classifier.

The final model achieved:

| Metric | Result |
|---|---:|
| Accuracy | 94.03% |
| Precision | 6.88% |
| Recall | 64.34% |
| F1-score | 12.44% |
| ROC-AUC | 0.9547 |
| Average Precision | 0.0722 |

The model identified 240 of 373 actual adopters in the test dataset.

## 2. Business Problem

Developer-tool companies need to understand which users may adopt important product features.

The project investigates whether historical user activity, API usage, feature adoption, organization information, and subscription characteristics can help predict future API Monitoring adoption.

## 3. Prediction Objective

Target variable: feature_adopted

- Observation window: Previous 30 days.
- Prediction window: Next 30 days.
- Positive class: User adopts API Monitoring.
- Negative class: User does not adopt API Monitoring.

Each modeling record represents a user at a particular cohort index date.

## 4. Dataset Overview

- Dataset type: Synthetic.
- Cohort index dates: 32.
- Cohort date range: 2024-03-01 to 2026-09-17.
- Training records: 70,577.
- Testing records: 56,642.
- Training positive rate: 2.30%.
- Testing positive rate: 0.66%.

Users may appear in multiple cohort periods.

## 5. Data Preparation and Feature Engineering

Features were constructed using historical information available within the observation window.

Feature categories included:

- User activity and engagement.
- Event and session behavior.
- API usage and performance.
- Organization characteristics.
- Subscription information.
- Previous feature adoption.

Potential leakage variables were excluded from model predictors.

## 6. Model Development

The following models were evaluated:

1. Dummy Classifier.
2. Logistic Regression.
3. Decision Tree.
4. Random Forest.

Random Forest was selected as the final model.

## 7. Model Evaluation

The final Random Forest was trained on the complete training dataset.

A chronological validation split was used to select a prediction threshold of 0.55 based on F1-score.

Final test confusion matrix:

| Actual Outcome | Predicted Non-Adopter | Predicted Adopter |
|---|---:|---:|
| Non-Adopter | 53,022 | 3,247 |
| Adopter | 133 | 240 |

The model identified approximately 64.34% of actual adopters.

However, precision was only 6.88%, meaning many predicted adopters did not adopt within the prediction window.

## 8. Feature Importance

Permutation importance identified the following leading predictive features:

1. signup_tenure_days
2. has_adopted_analytics_dashboard
3. organization_tenure_days
4. has_adopted_webhooks
5. subscription_tenure_days
6. has_adopted_api_documentation
7. has_adopted_api_authentication
8. organization_company_size
9. api_success_rate
10. api_requests_products

These findings describe predictive relationships and do not establish causal effects.

## 9. Business Insights

The analysis identified five potential business opportunity areas:

- User activation.
- Feature discovery.
- Product engagement.
- Subscription lifecycle.
- API experience.

Recommended initiatives include guided onboarding, contextual feature education, lifecycle-based engagement, and improved API documentation.

These recommendations require further validation.

## 10. Model Limitations

- The dataset is synthetic.
- The positive class is highly imbalanced.
- Test precision is low.
- False discovery rate is 93.12%.
- Adoption prevalence differs between training and test periods.
- Some users appear in both training and test cohorts.
- The evaluation does not establish generalization to entirely unseen users.
- Feature importance does not establish causation.
- Real-world performance has not been validated.

## 11. Conclusion

This project demonstrates an end-to-end machine learning workflow for predicting product feature adoption.

The Random Forest model identifies a portion of future adopters, but its low precision limits direct targeting effectiveness.

The results suggest opportunities for further experimentation, model calibration, and validation using real product usage data.

The predictions should be treated as prioritization signals rather than guaranteed adoption outcomes.

## 12. Future Work

- Validate the model using real developer-tool product data.
- Investigate probability calibration.
- Evaluate alternative models and threshold strategies.
- Test recommendations through controlled A/B experiments.
- Conduct causal impact analysis to estimate the effects of product interventions.
