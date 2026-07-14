# Project Walkthrough

## 1. Define the lifecycle problem

The project follows subscriptions from acquisition and activation through usage,
payment, support, cancellation, and possible reactivation.

## 2. Inspect raw data

The raw files intentionally include:

- Duplicate subscription, payment, usage, contact, and cancellation records
- Inconsistent country, channel, and acquisition formatting
- Missing acquisition channels and payment methods

## 3. Clean and validate

The cleaning workflow:

- Removes duplicate primary keys
- Standardizes text categories
- Replaces missing categories with `Unknown`
- Validates billed, paid, and refunded amounts
- Confirms relationships between subscriptions and lifecycle events

## 4. Model the portfolio

Customers and plans describe each subscription. Payments measure financial
activity, monthly usage measures engagement, support contacts measure customer
experience, and cancellation/reactivation tables describe lifecycle outcomes.

## 5. Calculate KPIs

The project measures:

- Active and cancelled subscriptions
- Monthly churn rate
- MRR and ARR
- Collected revenue
- Refund and payment-failure rates
- Product utilization
- NPS
- Cancellation reasons
- Save-offer activity
- Reactivation events
- Cohort retention

## 6. Segment performance

Metrics are compared by month, plan, customer segment, acquisition channel,
cancellation reason, reactivation channel, usage, and payment status.

## 7. Interpret carefully

Cancellation counts must be compared with plan and segment size. Churn signals
can be associated with outcomes without proving that a single factor caused the
cancellation.
