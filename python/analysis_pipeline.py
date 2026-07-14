"""
Reproducible subscription churn and retention analysis.

Run from the project root:
    python python/analysis_pipeline.py
"""

from pathlib import Path
import sqlite3
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "processed"

subscriptions = pd.read_csv(
    DATA / "subscriptions_clean.csv",
    parse_dates=["start_date", "end_date"],
)
payments = pd.read_csv(
    DATA / "payments_clean.csv",
    parse_dates=["payment_date"],
)
usage = pd.read_csv(
    DATA / "monthly_usage_clean.csv",
    parse_dates=["usage_month"],
)
cancellations = pd.read_csv(
    DATA / "cancellations_clean.csv",
    parse_dates=["cancellation_date"],
)

assert subscriptions["subscription_id"].is_unique
assert payments["payment_id"].is_unique
assert usage["usage_id"].is_unique
assert payments["billed_amount_usd"].ge(0).all()

total_subscriptions = len(subscriptions)
active_subscriptions = subscriptions["subscription_status"].eq("Active").sum()
cancelled_subscriptions = subscriptions["subscription_status"].eq("Cancelled").sum()
cancelled_share = cancelled_subscriptions / total_subscriptions
refund_rate = payments["refund_amount_usd"].sum() / payments["billed_amount_usd"].sum()

print(f"Subscriptions: {total_subscriptions:,}")
print(f"Active subscriptions: {active_subscriptions:,}")
print(f"Cancelled share: {cancelled_share:.2%}")
print(f"Refund rate: {refund_rate:.2%}")

payments["month"] = payments["payment_date"].dt.to_period("M").astype(str)
monthly_revenue = payments.groupby("month", as_index=False).agg(
    billed_revenue_usd=("billed_amount_usd", "sum"),
    collected_revenue_usd=("paid_amount_usd", "sum"),
    refund_amount_usd=("refund_amount_usd", "sum"),
)
monthly_revenue["refund_rate"] = (
    monthly_revenue["refund_amount_usd"]
    / monthly_revenue["billed_revenue_usd"]
)
monthly_revenue.to_csv(
    DATA / "python_monthly_revenue_summary.csv",
    index=False,
)

database = sqlite3.connect(DATA / "subscription_churn_retention.db")
query = """
SELECT
    cancellation_reason,
    COUNT(*) AS cancellation_events
FROM cancellations
GROUP BY cancellation_reason
ORDER BY cancellation_events DESC;
"""
reason_summary = pd.read_sql_query(query, database)
database.close()

print("\nCancellation reasons:")
print(reason_summary.to_string(index=False))
