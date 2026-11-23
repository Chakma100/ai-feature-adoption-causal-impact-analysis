
# Causal Impact Analysis Report

## 1. Project Overview

Project: AI-Powered Feature Adoption Prediction & Causal Impact Analysis for Developer Tools

Experiment: API Monitoring Onboarding Experiment

Experiment ID: EXP_FEATURE_ONBOARDING_001

Objective:
Evaluate the relationship between the new API Monitoring onboarding
experience and 7-day feature adoption.

## 2. Causal Business Question

What is the effect of the new API Monitoring onboarding experience
on 7-day feature adoption?

Treatment group: Treatment

Control group: Control

Treatment variable: variant

Outcome variable: adopted_feature

Observation window: 7 days

## 3. Baseline Covariates

The propensity score model used these observed baseline characteristics:

- Country
- User role
- Acquisition channel
- Verification status

Categorical variables were one-hot encoded.

## 4. Baseline Covariate Balance

Standardized Mean Differences (SMD) were calculated before matching.

All 19 encoded baseline features had absolute SMD values below 0.10.

This indicated good observed baseline balance before matching.

## 5. Propensity Score Estimation

A logistic regression model estimated each user's probability
of receiving the Treatment group based on observed baseline covariates.

Propensity score summary:

- Users: 6,000
- Mean: 0.5005
- Standard deviation: 0.0243
- Minimum: 0.4367
- Maximum: 0.5711

## 6. Propensity Score Matching

Method: 1:1 greedy nearest-neighbor matching without replacement.

Caliper: 0.05

Matching results:

- Treatment users: 3,003
- Control users: 2,997
- Initial matched pairs: 2,997
- Pairs retained after caliper: 2,885
- Unmatched Treatment users after caliper: 118

## 7. Covariate Balance After Matching

All 19 encoded baseline features had absolute SMD values below 0.10.

Maximum absolute SMD: 0.0452

This indicates good balance across the measured baseline covariates
in the retained matched sample.

## 8. Matched Treatment Effect

Treatment group:

- Matched users: 2,885
- Feature adopters: 1,867
- Adoption rate: 64.71%

Control group:

- Matched users: 2,885
- Feature adopters: 1,320
- Adoption rate: 45.75%

Absolute adoption-rate difference: +18.96 percentage points

Relative lift: +41.44%

## 9. Confidence Interval

An approximate paired 95% t-based confidence interval was calculated
using within-pair differences.

- Mean difference: 18.96 percentage points
- Standard error: 1.2725 percentage points
- Lower bound: 16.47 percentage points
- Upper bound: 21.46 percentage points

This interval does not account for uncertainty from propensity score
estimation and the matching procedure.

## 10. McNemar's Test

Paired outcome counts:

- Both did not adopt: 566
- Treatment adopted, Control did not: 999
- Control adopted, Treatment did not: 452
- Both adopted: 868

Exact two-sided McNemar test:

- Discordant pairs: 1,451
- p-value: approximately 1.03e-47

The paired adoption outcomes showed a statistically significant
difference between the two groups.

## 11. Business Interpretation

In the matched sample, the Treatment group had a 7-day feature
adoption rate of 64.71%, compared with 45.75% in the Control group.

The observed difference was 18.96 percentage points.

This suggests that the new onboarding experience is associated
with substantially higher feature adoption among the matched users.

## 12. Limitations

- The experiment's randomization mechanism was not independently verified.
- Propensity score matching adjusts only for observed baseline covariates.
- Unmeasured confounding may remain.
- The matching procedure used greedy nearest-neighbor matching,
  not globally optimal matching.
- The confidence interval does not account for propensity score
  estimation and matching uncertainty.
- Statistical significance alone does not establish causality.

Therefore, these findings should be interpreted as an adjusted
matched-sample association rather than definitive causal evidence.

## 13. Conclusion

The matched analysis found a 18.96 percentage-point difference
in 7-day feature adoption between Treatment and Control users.

The measured baseline covariates were well balanced after matching,
and McNemar's test indicated a statistically significant difference.

Further validation of the assignment mechanism and experimental
design is required before making a definitive causal claim.
