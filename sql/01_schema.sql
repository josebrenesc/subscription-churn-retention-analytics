-- Subscription Churn & Retention Analytics
-- SQLite schema for the cleaned synthetic dataset.

PRAGMA foreign_keys = ON;

CREATE TABLE plans (
    plan_id TEXT PRIMARY KEY,
    plan_name TEXT NOT NULL,
    monthly_price_usd REAL NOT NULL,
    billing_cycle TEXT NOT NULL,
    included_features INTEGER,
    support_tier TEXT
);

CREATE TABLE customers (
    customer_id TEXT PRIMARY KEY,
    signup_date TEXT NOT NULL,
    country TEXT,
    customer_segment TEXT,
    acquisition_channel TEXT,
    age_group TEXT
);

CREATE TABLE subscriptions (
    subscription_id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL,
    plan_id TEXT NOT NULL,
    start_date TEXT NOT NULL,
    end_date TEXT,
    subscription_status TEXT,
    auto_renew INTEGER,
    discount_pct REAL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id)
);

CREATE TABLE payments (
    payment_id TEXT PRIMARY KEY,
    subscription_id TEXT NOT NULL,
    payment_date TEXT NOT NULL,
    billed_amount_usd REAL,
    paid_amount_usd REAL,
    payment_status TEXT,
    refund_amount_usd REAL,
    payment_method TEXT,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

CREATE TABLE monthly_usage (
    usage_id TEXT PRIMARY KEY,
    subscription_id TEXT NOT NULL,
    usage_month TEXT NOT NULL,
    active_days INTEGER,
    sessions INTEGER,
    feature_events INTEGER,
    support_contacts INTEGER,
    plan_limit_utilization REAL,
    nps_score INTEGER,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

CREATE TABLE support_contacts (
    contact_id TEXT PRIMARY KEY,
    subscription_id TEXT NOT NULL,
    contact_date TEXT NOT NULL,
    channel TEXT,
    reason TEXT,
    resolved_first_contact INTEGER,
    csat_score INTEGER,
    refund_requested INTEGER,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

CREATE TABLE cancellations (
    cancellation_id TEXT PRIMARY KEY,
    subscription_id TEXT NOT NULL,
    cancellation_date TEXT NOT NULL,
    cancellation_reason TEXT,
    voluntary_churn INTEGER,
    save_offer_presented INTEGER,
    save_offer_accepted INTEGER,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

CREATE TABLE reactivations (
    reactivation_id TEXT PRIMARY KEY,
    subscription_id TEXT NOT NULL,
    reactivation_date TEXT NOT NULL,
    days_inactive INTEGER,
    reactivation_channel TEXT,
    promo_applied INTEGER,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);
