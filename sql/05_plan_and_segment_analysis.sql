-- Plan performance

SELECT
    p.plan_name,
    COUNT(DISTINCT s.subscription_id) AS total_subscriptions,
    SUM(CASE WHEN s.subscription_status = 'Active' THEN 1 ELSE 0 END)
        AS active_subscriptions,
    SUM(CASE WHEN s.subscription_status = 'Cancelled' THEN 1 ELSE 0 END)
        AS cancelled_subscriptions,
    ROUND(
        100.0 * SUM(CASE WHEN s.subscription_status = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(DISTINCT s.subscription_id),
        2
    ) AS current_cancelled_share_pct,
    ROUND(AVG(u.plan_limit_utilization), 3) AS avg_utilization,
    ROUND(AVG(u.nps_score), 2) AS avg_nps,
    ROUND(SUM(py.paid_amount_usd), 2) AS collected_revenue_usd
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
LEFT JOIN monthly_usage u ON s.subscription_id = u.subscription_id
LEFT JOIN payments py
  ON s.subscription_id = py.subscription_id
 AND SUBSTR(u.usage_month, 1, 7) = SUBSTR(py.payment_date, 1, 7)
GROUP BY p.plan_name
ORDER BY current_cancelled_share_pct DESC;

-- Customer segment and acquisition channel

SELECT
    c.customer_segment,
    c.acquisition_channel,
    COUNT(DISTINCT s.subscription_id) AS subscriptions,
    SUM(CASE WHEN s.subscription_status = 'Cancelled' THEN 1 ELSE 0 END)
        AS cancelled_subscriptions,
    ROUND(
        100.0 * SUM(CASE WHEN s.subscription_status = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(DISTINCT s.subscription_id),
        2
    ) AS current_cancelled_share_pct,
    ROUND(AVG(u.plan_limit_utilization), 3) AS avg_utilization,
    ROUND(AVG(u.nps_score), 2) AS avg_nps
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
LEFT JOIN monthly_usage u ON s.subscription_id = u.subscription_id
GROUP BY c.customer_segment, c.acquisition_channel
HAVING COUNT(DISTINCT s.subscription_id) >= 100
ORDER BY current_cancelled_share_pct DESC;
