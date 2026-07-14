-- Monthly churn, reactivation, revenue, and usage

WITH months AS (
    SELECT DISTINCT SUBSTR(usage_month, 1, 7) AS month
    FROM monthly_usage
),
base AS (
    SELECT
        m.month,
        COUNT(DISTINCT CASE
            WHEN SUBSTR(s.start_date, 1, 7) <= m.month
             AND (s.end_date = '' OR SUBSTR(s.end_date, 1, 7) >= m.month)
            THEN s.subscription_id END
        ) AS active_subscriptions,
        COUNT(DISTINCT CASE
            WHEN SUBSTR(c.cancellation_date, 1, 7) = m.month
            THEN c.subscription_id END
        ) AS churned_subscriptions,
        COUNT(DISTINCT CASE
            WHEN SUBSTR(r.reactivation_date, 1, 7) = m.month
            THEN r.subscription_id END
        ) AS reactivated_subscriptions
    FROM months m
    CROSS JOIN subscriptions s
    LEFT JOIN cancellations c ON s.subscription_id = c.subscription_id
    LEFT JOIN reactivations r ON s.subscription_id = r.subscription_id
    GROUP BY m.month
),
revenue AS (
    SELECT
        SUBSTR(payment_date, 1, 7) AS month,
        SUM(billed_amount_usd) AS billed_revenue_usd,
        SUM(paid_amount_usd) AS collected_revenue_usd,
        SUM(refund_amount_usd) AS refund_amount_usd,
        AVG(CASE WHEN payment_status IN ('Failed', 'Past Due') THEN 1.0 ELSE 0.0 END)
            AS payment_failure_rate
    FROM payments
    GROUP BY SUBSTR(payment_date, 1, 7)
)
SELECT
    b.month,
    b.active_subscriptions,
    b.churned_subscriptions,
    ROUND(
        100.0 * b.churned_subscriptions / NULLIF(b.active_subscriptions, 0),
        2
    ) AS churn_rate_pct,
    b.reactivated_subscriptions,
    ROUND(r.billed_revenue_usd, 2) AS billed_revenue_usd,
    ROUND(r.collected_revenue_usd, 2) AS collected_revenue_usd,
    ROUND(r.refund_amount_usd, 2) AS refund_amount_usd,
    ROUND(100.0 * r.payment_failure_rate, 2) AS payment_failure_rate_pct
FROM base b
LEFT JOIN revenue r ON b.month = r.month
ORDER BY b.month;
