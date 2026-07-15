-- Plan performance
-- Aggregate subscription status, usage, and payments separately to avoid
-- duplicating subscriptions across one-to-many joins.

WITH plan_subscriptions AS (
    SELECT
        p.plan_name,
        COUNT(*) AS total_subscriptions,
        SUM(CASE WHEN s.subscription_status = 'Active' THEN 1 ELSE 0 END)
            AS active_subscriptions,
        SUM(CASE WHEN s.subscription_status = 'Cancelled' THEN 1 ELSE 0 END)
            AS cancelled_subscriptions,
        1.0 * SUM(
            CASE WHEN s.subscription_status = 'Cancelled' THEN 1 ELSE 0 END
        ) / COUNT(*) AS current_cancelled_share
    FROM subscriptions s
    JOIN plans p ON s.plan_id = p.plan_id
    GROUP BY p.plan_name
),
plan_usage AS (
    SELECT
        p.plan_name,
        AVG(u.plan_limit_utilization) AS avg_utilization,
        AVG(u.nps_score) AS avg_nps
    FROM subscriptions s
    JOIN plans p ON s.plan_id = p.plan_id
    JOIN monthly_usage u ON s.subscription_id = u.subscription_id
    GROUP BY p.plan_name
),
plan_revenue AS (
    SELECT
        p.plan_name,
        SUM(py.paid_amount_usd) AS collected_revenue_usd
    FROM subscriptions s
    JOIN plans p ON s.plan_id = p.plan_id
    JOIN payments py ON s.subscription_id = py.subscription_id
    GROUP BY p.plan_name
)
SELECT
    ps.plan_name,
    ps.total_subscriptions,
    ps.active_subscriptions,
    ps.cancelled_subscriptions,
    ROUND(100.0 * ps.current_cancelled_share, 2)
        AS current_cancelled_share_pct,
    ROUND(pu.avg_utilization, 3) AS avg_utilization,
    ROUND(pu.avg_nps, 2) AS avg_nps,
    ROUND(pr.collected_revenue_usd, 2) AS collected_revenue_usd
FROM plan_subscriptions ps
LEFT JOIN plan_usage pu ON ps.plan_name = pu.plan_name
LEFT JOIN plan_revenue pr ON ps.plan_name = pr.plan_name
ORDER BY current_cancelled_share_pct DESC;


-- Customer segment and acquisition channel
-- Calculate the cancellation numerator before joining monthly usage.

WITH segment_subscriptions AS (
    SELECT
        c.customer_segment,
        c.acquisition_channel,
        COUNT(*) AS subscriptions,
        SUM(CASE WHEN s.subscription_status = 'Cancelled' THEN 1 ELSE 0 END)
            AS cancelled_subscriptions,
        1.0 * SUM(
            CASE WHEN s.subscription_status = 'Cancelled' THEN 1 ELSE 0 END
        ) / COUNT(*) AS current_cancelled_share
    FROM customers c
    JOIN subscriptions s ON c.customer_id = s.customer_id
    GROUP BY c.customer_segment, c.acquisition_channel
),
segment_usage AS (
    SELECT
        c.customer_segment,
        c.acquisition_channel,
        AVG(u.plan_limit_utilization) AS avg_utilization,
        AVG(u.nps_score) AS avg_nps
    FROM customers c
    JOIN subscriptions s ON c.customer_id = s.customer_id
    JOIN monthly_usage u ON s.subscription_id = u.subscription_id
    GROUP BY c.customer_segment, c.acquisition_channel
)
SELECT
    ss.customer_segment,
    ss.acquisition_channel,
    ss.subscriptions,
    ss.cancelled_subscriptions,
    ROUND(100.0 * ss.current_cancelled_share, 2)
        AS current_cancelled_share_pct,
    ROUND(su.avg_utilization, 3) AS avg_utilization,
    ROUND(su.avg_nps, 2) AS avg_nps
FROM segment_subscriptions ss
LEFT JOIN segment_usage su
  ON ss.customer_segment = su.customer_segment
 AND ss.acquisition_channel = su.acquisition_channel
WHERE ss.subscriptions >= 100
ORDER BY current_cancelled_share_pct DESC;
