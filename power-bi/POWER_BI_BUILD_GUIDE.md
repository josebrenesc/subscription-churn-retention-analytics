# Power BI Build Guide

## Import cleaned CSV files

- plans_clean.csv
- customers_clean.csv
- subscriptions_clean.csv
- payments_clean.csv
- monthly_usage_clean.csv
- support_contacts_clean.csv
- cancellations_clean.csv
- reactivations_clean.csv
- cohort_retention.csv

Rename the tables to:

- Plans
- Customers
- Subscriptions
- Payments
- Monthly_Usage
- Support_Contacts
- Cancellations
- Reactivations
- Cohort_Retention

## Relationships

Use one-to-many, single-direction relationships:

- Customers[customer_id] → Subscriptions[customer_id]
- Plans[plan_id] → Subscriptions[plan_id]
- Subscriptions[subscription_id] → Payments[subscription_id]
- Subscriptions[subscription_id] → Monthly_Usage[subscription_id]
- Subscriptions[subscription_id] → Support_Contacts[subscription_id]
- Subscriptions[subscription_id] → Cancellations[subscription_id]
- Subscriptions[subscription_id] → Reactivations[subscription_id]

Create a Date table and connect it to payment, usage, cancellation, and
reactivation dates using active or inactive relationships as appropriate.

## Recommended pages

### 1. Executive Overview
KPI cards:
- Active Subscriptions
- Current MRR
- Current ARR
- Current Cancelled Share
- Reactivation Event Rate
- Refund Rate
- Average NPS

Visuals:
- Monthly churn rate
- Monthly collected revenue
- Active and churned subscriptions
- Cancellation reasons

### 2. Churn Drivers
- Cancelled share by plan
- Cancelled share by acquisition channel
- Usage before churn
- Payment failures before churn
- Support contacts and CSAT before churn
- Voluntary versus involuntary churn

### 3. Revenue & Payments
- Billed versus collected revenue
- Refund rate by plan
- Payment failure rate
- Current MRR by plan
- Revenue by segment and acquisition channel

### 4. Cohort Retention
- Cohort retention matrix
- Month 1, 3, 6, and 12 retention
- Cohort size
- Retention by plan or acquisition channel

### 5. Reactivation & Save Offers
- Reactivation events by channel
- Average days inactive
- Promo use
- Save-offer presentation and acceptance
- Cancellation reason and reactivation relationship

### 6. Customer Experience
- Support FCR and CSAT
- Contact reasons
- Refund requests
- NPS by plan, usage, and churn status

Use the measures in `measures.dax`.
