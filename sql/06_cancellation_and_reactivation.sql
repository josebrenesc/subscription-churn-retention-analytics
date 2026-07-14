-- Cancellation reasons

SELECT
    cancellation_reason,
    COUNT(*) AS cancellation_events,
    SUM(voluntary_churn) AS voluntary_events,
    ROUND(100.0 * AVG(save_offer_presented), 2) AS save_offer_presentation_pct,
    ROUND(100.0 * AVG(save_offer_accepted), 2) AS save_offer_acceptance_pct
FROM cancellations
GROUP BY cancellation_reason
ORDER BY cancellation_events DESC;

-- Reactivation performance

SELECT
    reactivation_channel,
    COUNT(*) AS reactivation_events,
    ROUND(AVG(days_inactive), 1) AS avg_days_inactive,
    ROUND(100.0 * AVG(promo_applied), 2) AS promo_applied_pct
FROM reactivations
GROUP BY reactivation_channel
ORDER BY reactivation_events DESC;

-- Support signals before cancellation

WITH last_contact AS (
    SELECT
        c.subscription_id,
        c.cancellation_date,
        COUNT(sc.contact_id) AS contacts_30d_before_churn,
        AVG(sc.csat_score) AS avg_csat_30d_before_churn,
        AVG(sc.resolved_first_contact) AS support_fcr_30d_before_churn
    FROM cancellations c
    LEFT JOIN support_contacts sc
      ON c.subscription_id = sc.subscription_id
     AND sc.contact_date BETWEEN DATE(c.cancellation_date, '-30 day')
                             AND c.cancellation_date
    GROUP BY c.subscription_id, c.cancellation_date
)
SELECT
    ROUND(AVG(contacts_30d_before_churn), 2) AS avg_contacts_before_churn,
    ROUND(AVG(avg_csat_30d_before_churn), 2) AS avg_csat_before_churn,
    ROUND(100.0 * AVG(support_fcr_30d_before_churn), 2) AS support_fcr_before_churn_pct
FROM last_contact;
