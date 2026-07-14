# Data Dictionary

All companies, customers, subscriptions, payments, and outcomes are synthetic.

## `plans`

| Column | Description |
|---|---|
| `plan_id` | Unique plan identifier |
| `plan_name` | Basic, Plus, Premium, or Business |
| `monthly_price_usd` | Standard monthly price |
| `billing_cycle` | Billing frequency |
| `included_features` | Synthetic count of included features |
| `support_tier` | Support service level |

## `customers`

| Column | Description |
|---|---|
| `customer_id` | Unique synthetic customer identifier |
| `signup_date` | Date the customer joined the fictional service |
| `country` | Customer country code |
| `customer_segment` | Consumer, Premium Consumer, or Small Business |
| `acquisition_channel` | Channel that acquired the customer |
| `age_group` | Age range used for segmentation |

## `subscriptions`

| Column | Description |
|---|---|
| `subscription_id` | Unique subscription identifier |
| `customer_id` | Customer foreign key |
| `plan_id` | Plan foreign key |
| `start_date` | Subscription start date |
| `end_date` | Latest cancellation date when currently cancelled |
| `subscription_status` | Active or Cancelled at the analysis date |
| `auto_renew` | Whether automatic renewal is enabled |
| `discount_pct` | Applied subscription discount percentage |

## `payments`

| Column | Description |
|---|---|
| `payment_id` | Unique payment identifier |
| `subscription_id` | Subscription foreign key |
| `payment_date` | Payment billing date |
| `billed_amount_usd` | Amount billed |
| `paid_amount_usd` | Amount collected after refunds or failed payment |
| `payment_status` | Paid, Failed, Past Due, Refunded, or Partially Refunded |
| `refund_amount_usd` | Refunded amount |
| `payment_method` | Synthetic payment method |

## `monthly_usage`

| Column | Description |
|---|---|
| `usage_id` | Unique monthly usage identifier |
| `subscription_id` | Subscription foreign key |
| `usage_month` | Month represented by the record |
| `active_days` | Active product days during the month |
| `sessions` | Synthetic product sessions |
| `feature_events` | Synthetic feature interactions |
| `support_contacts` | Support contacts during the month |
| `plan_limit_utilization` | Usage relative to a synthetic plan limit |
| `nps_score` | Synthetic Net Promoter Score from 0 to 10 |

## `support_contacts`

| Column | Description |
|---|---|
| `contact_id` | Unique support-contact identifier |
| `subscription_id` | Subscription foreign key |
| `contact_date` | Support contact date |
| `channel` | Email, Chat, Phone, or Web Form |
| `reason` | Primary reason for contact |
| `resolved_first_contact` | Whether the issue was resolved on first contact |
| `csat_score` | Customer satisfaction score from 1 to 5 |
| `refund_requested` | Whether a refund was requested |

## `cancellations`

| Column | Description |
|---|---|
| `cancellation_id` | Unique cancellation-event identifier |
| `subscription_id` | Subscription foreign key |
| `cancellation_date` | Cancellation date |
| `cancellation_reason` | Primary cancellation reason |
| `voluntary_churn` | Whether the cancellation was customer-initiated |
| `save_offer_presented` | Whether a retention offer was presented |
| `save_offer_accepted` | Whether the retention offer was accepted |

## `reactivations`

| Column | Description |
|---|---|
| `reactivation_id` | Unique reactivation-event identifier |
| `subscription_id` | Subscription foreign key |
| `reactivation_date` | Date the subscription returned |
| `days_inactive` | Days between cancellation and reactivation |
| `reactivation_channel` | Channel that generated the return |
| `promo_applied` | Whether a reactivation promotion was applied |
