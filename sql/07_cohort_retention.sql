-- Cohort retention through month 12

WITH subscription_months AS (
    SELECT
        s.subscription_id,
        SUBSTR(s.start_date, 1, 7) AS cohort_month,
        SUBSTR(u.usage_month, 1, 7) AS activity_month,
        (
            (CAST(SUBSTR(u.usage_month, 1, 4) AS INTEGER)
             - CAST(SUBSTR(s.start_date, 1, 4) AS INTEGER)) * 12
            + (CAST(SUBSTR(u.usage_month, 6, 2) AS INTEGER)
             - CAST(SUBSTR(s.start_date, 6, 2) AS INTEGER))
        ) AS month_number
    FROM subscriptions s
    JOIN monthly_usage u ON s.subscription_id = u.subscription_id
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT subscription_id) AS cohort_subscriptions
    FROM subscription_months
    WHERE month_number = 0
    GROUP BY cohort_month
),
retention AS (
    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT subscription_id) AS retained_subscriptions
    FROM subscription_months
    WHERE month_number BETWEEN 0 AND 12
    GROUP BY cohort_month, month_number
)
SELECT
    r.cohort_month,
    r.month_number,
    c.cohort_subscriptions,
    r.retained_subscriptions,
    ROUND(
        100.0 * r.retained_subscriptions / c.cohort_subscriptions,
        2
    ) AS retention_rate_pct
FROM retention r
JOIN cohort_size c ON r.cohort_month = c.cohort_month
ORDER BY r.cohort_month, r.month_number;
