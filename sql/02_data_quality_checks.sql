-- Data quality checks

-- Duplicate primary keys
SELECT subscription_id, COUNT(*) AS duplicate_count
FROM subscriptions
GROUP BY subscription_id
HAVING COUNT(*) > 1;

SELECT payment_id, COUNT(*) AS duplicate_count
FROM payments
GROUP BY payment_id
HAVING COUNT(*) > 1;

-- Invalid financial values
SELECT COUNT(*) AS invalid_payment_rows
FROM payments
WHERE billed_amount_usd < 0
   OR paid_amount_usd < 0
   OR refund_amount_usd < 0
   OR paid_amount_usd + refund_amount_usd > billed_amount_usd + 0.01;

-- Orphan payments
SELECT COUNT(*) AS orphan_payments
FROM payments p
LEFT JOIN subscriptions s ON p.subscription_id = s.subscription_id
WHERE s.subscription_id IS NULL;

-- Cancellation consistency
SELECT
    s.subscription_id,
    s.subscription_status,
    s.end_date,
    c.cancellation_date
FROM subscriptions s
LEFT JOIN cancellations c ON s.subscription_id = c.subscription_id
WHERE s.subscription_status = 'Cancelled'
  AND (s.end_date IS NULL OR s.end_date = '');

-- Standardized categories
SELECT country, COUNT(*) AS customer_count
FROM customers
GROUP BY country
ORDER BY customer_count DESC;
