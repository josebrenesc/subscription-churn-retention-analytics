"""
Demonstrates cleaning applied to the raw subscription portfolio data.

Run from the project root:
    python python/clean_subscription_data.py
"""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
PROCESSED = ROOT / "data" / "processed"

customers = pd.read_csv(RAW / "customers.csv", parse_dates=["signup_date"])
payments = pd.read_csv(RAW / "payments.csv", parse_dates=["payment_date"])

print(f"Raw customer rows: {len(customers):,}")
print(f"Raw payment rows: {len(payments):,}")

customers = customers.drop_duplicates(subset=["customer_id"]).copy()
customers["country"] = customers["country"].str.strip().str.upper()
customers["acquisition_channel"] = (
    customers["acquisition_channel"]
    .fillna("Unknown")
    .str.strip()
    .str.title()
)

payments = payments.drop_duplicates(subset=["payment_id"]).copy()
payments["payment_method"] = (
    payments["payment_method"]
    .fillna("Unknown")
    .str.strip()
    .str.title()
)

for column in ["billed_amount_usd", "paid_amount_usd", "refund_amount_usd"]:
    payments[column] = pd.to_numeric(payments[column], errors="coerce")

payments = payments[
    payments["billed_amount_usd"].ge(0)
    & payments["paid_amount_usd"].ge(0)
    & payments["refund_amount_usd"].ge(0)
    & (
        payments["paid_amount_usd"] + payments["refund_amount_usd"]
        <= payments["billed_amount_usd"] + 0.01
    )
]

customers.to_csv(PROCESSED / "customers_clean_from_script.csv", index=False)
payments.to_csv(PROCESSED / "payments_clean_from_script.csv", index=False)

print(f"Clean customer rows: {len(customers):,}")
print(f"Clean payment rows: {len(payments):,}")
