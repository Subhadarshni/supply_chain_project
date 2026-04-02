import pandas as pd

import os
import random
from datetime import datetime, timedelta


folder_path = "supply_chain_data"
os.makedirs(folder_path, exist_ok=True)

rows = 1000

# -----------------------------
# Helper for random dates
# -----------------------------
start_date = datetime(2023,1,1)

def random_date():
    return start_date + timedelta(days=random.randint(0,700))

# -----------------------------
# PRODUCTS DATASET
# -----------------------------
products = pd.DataFrame({
    "product_id": range(1001, 1001+rows),
    "product_name": [f"Product_{i}" for i in range(rows)],
    "category": [random.choice(["Electronics","Clothing","Home","Sports","Books"]) for _ in range(rows)],
    "price": [random.randint(100,5000) for _ in range(rows)],
    "supplier": [random.choice(["Supplier_A","Supplier_B","Supplier_C","Supplier_D"]) for _ in range(rows)]
})

products.to_csv(f"{folder_path}/products.csv", index=False)


# -----------------------------
# INVENTORY DATASET
# -----------------------------
inventory = pd.DataFrame({
    "inventory_id": range(1, rows+1),
    "product_id": [random.randint(1001,1000+rows) for _ in range(rows)],
    "warehouse": [random.choice(["WH_Mumbai","WH_Delhi","WH_Bangalore","WH_Kolkata"]) for _ in range(rows)],
    "stock_quantity": [random.randint(0,500) for _ in range(rows)],
    "last_updated": [random_date() for _ in range(rows)]
})

inventory.to_csv(f"{folder_path}/inventory.csv", index=False)

# -----------------------------
# ORDERS DATASET
# -----------------------------
orders = pd.DataFrame({
    "order_id": range(5001,5001+rows),
    "product_id": [random.randint(1001,1000+rows) for _ in range(rows)],
    "customer_id": [random.randint(1,300) for _ in range(rows)],
    "order_date": [random_date() for _ in range(rows)],
    "quantity": [random.randint(1,5) for _ in range(rows)],
    "order_status": [random.choice(["Placed","Shipped","Delivered","Cancelled"]) for _ in range(rows)]
})

orders.to_csv(f"{folder_path}/orders.csv", index=False)

# -----------------------------
# SHIPMENTS DATASET
# -----------------------------
shipments = pd.DataFrame({
    "shipment_id": range(7001,7001+rows),
    "order_id": [random.randint(5001,5000+rows) for _ in range(rows)],
    "shipment_date": [random_date() for _ in range(rows)],
    "carrier": [random.choice(["FedEx","BlueDart","DHL","Delhivery"]) for _ in range(rows)],
    "delivery_status": [random.choice(["In Transit","Delivered","Delayed"]) for _ in range(rows)]
})

shipments.to_csv(f"{folder_path}/shipments.csv", index=False)

# -----------------------------
# RETURNS DATASET
# -----------------------------
returns = pd.DataFrame({
    "return_id": range(9001,9001+rows),
    "order_id": [random.randint(5001,5000+rows) for _ in range(rows)],
    "return_date": [random_date() for _ in range(rows)],
    "reason": [random.choice(["Damaged","Wrong Item","Customer Dissatisfaction","Defective"]) for _ in range(rows)],
    "refund_amount": [random.randint(100,3000) for _ in range(rows)]
})

returns.to_csv(f"{folder_path}/returns.csv", index=False)

print("All 5 csv datasets with 1000 rows created successfully!")
print("Folder name:", folder_path)