# Synthetic Data Generation Notes

The dataset was created for portfolio use with a fixed random seed.

## Scenario assumptions

- Subscription activity covers January 2024 through June 2026.
- Lower usage, payment failures, repeated support contacts, low NPS, and disabled
  auto-renew increase synthetic churn probability.
- Premium and Business plans generally have stronger retention.
- A subset of cancelled subscriptions reactivates within six months.
- Save offers are shown only for selected voluntary-cancellation scenarios.
- Raw files intentionally include realistic data-quality issues.

## Interpretation rule

These assumptions create useful patterns for learning. They are not estimates of
real churn, revenue, customer behavior, or retention-program effectiveness.
