-- Core subscription and revenue KPIs

SELECT
    COUNT(*) AS total_subscriptions,
    SUM(CASE WHEN subscription_status = 'Active' THEN 1 ELSE 0 END) AS active_subscriptions,
    SUM(CASE WHEN subscription_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_subscriptions,
    ROUND(
        100.0 * SUM(CASE WHEN subscription_status = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS current_cancelled_share_pct
FROM subscriptions;

SELECT
    ROUND(SUM(billed_amount_usd), 2) AS billed_revenue_usd,
    ROUND(SUM(paid_amount_usd), 2) AS collected_revenue_usd,
    ROUND(SUM(refund_amount_usd), 2) AS refund_amount_usd,
    ROUND(
        100.0 * SUM(refund_amount_usd) / SUM(billed_amount_usd),
        2
    ) AS refund_rate_pct,
    ROUND(
        100.0 * AVG(
            CASE WHEN payment_status IN ('Failed', 'Past Due') THEN 1.0 ELSE 0.0 END
        ),
        2
    ) AS payment_failure_rate_pct
FROM payments;

SELECT
    ROUND(
        SUM(p.monthly_price_usd * (1 - s.discount_pct / 100.0)),
        2
    ) AS current_mrr_usd
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
WHERE s.subscription_status = 'Active';

SELECT
    ROUND(AVG(plan_limit_utilization), 3) AS avg_utilization,
    ROUND(AVG(active_days), 2) AS avg_active_days,
    ROUND(AVG(nps_score), 2) AS avg_nps
FROM monthly_usage;
