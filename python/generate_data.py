
from pathlib import Path
from datetime import datetime, timedelta
import random
import pandas as pd

random.seed(42)

# Find the project and data folders
PROJECT_ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = PROJECT_ROOT / "data"
DATA_DIR.mkdir(parents=True, exist_ok=True)

# STEP 1: Create 10 simulated stores
cities = [
    "Ranchi", "Delhi", "Gurugram", "Noida", "Bengaluru",
    "Mumbai", "Pune", "Hyderabad", "Kolkata", "Jaipur"
]

stores = pd.DataFrame([
    {
        "StoreID": f"DS{i:02d}",
        "StoreName": f"Dark Store {i:02d}",
        "City": city,
        "StaffCapacity": random.randint(5, 12)
    }
    for i, city in enumerate(cities, start=1)
])

stores.to_csv(DATA_DIR / "stores.csv", index=False)

# STEP 2: Define product categories
categories = [
    "Dairy", "Fruits & Vegetables", "Snacks",
    "Beverages", "Personal Care", "Household"
]

# STEP 3: Generate 5,000 simulated orders
now = datetime.now().replace(second=0, microsecond=0)
orders = []

for i in range(1, 5001):

    store = stores.iloc[random.randrange(len(stores))]

    # Order placed within the past 30 days
    order_time = now - timedelta(
        minutes=random.randint(0, 30 * 24 * 60)
    )

    hour = order_time.hour

    # Morning and evening are designated peak periods
    peak_hour = (
        hour in range(8, 11)
        or hour in range(18, 22)
    )

    # Simulated time spent picking items
    picking_minutes = max(
        2,
        round(random.gauss(8 if peak_hour else 5, 2))
    )

    # Simulated picker availability
    picker_available = random.random() > (
        0.16 if peak_hour else 0.06
    )

    # Simulated stockout indicator
    stockout = int(random.random() < 0.08)

    # Stockouts have a higher assumed cancellation probability
    cancellation_probability = (
        0.025 + (0.20 if stockout else 0)
    )

    cancelled = int(
        random.random() < cancellation_probability
    )

    # Promised delivery time in minutes
    promised_minutes = random.choice(
        [10, 15, 20, 25, 30]
    )

    # Simulated delivery duration
    delivery_minutes = (
        picking_minutes
        + random.randint(3, 10)
        + (random.randint(5, 15) if peak_hour else 0)
        + (
            random.randint(5, 12)
            if not picker_available else 0
        )
        + (random.randint(3, 10) if stockout else 0)
    )

    # Store the order
    orders.append({
        "OrderID": f"ORD{i:05d}",
        "StoreID": store["StoreID"],
        "OrderTimestamp": order_time,
        "HourOfDay": hour,
        "Category": random.choice(categories),
        "ItemsCount": random.randint(1, 12),
        "OrderValueINR": round(
            random.uniform(99, 1499), 2
        ),
        "PromisedDeliveryMinutes": promised_minutes,
        "PickingMinutes": picking_minutes,
        "PickerAvailable": int(picker_available),
        "StockoutFlag": stockout,
        "CancelledFlag": cancelled,
        "ActualDeliveryMinutes": (
            None if cancelled else delivery_minutes
        ),
        "OrderStatus": (
            "Cancelled" if cancelled else "Delivered"
        )
    })

# STEP 4: Save orders to CSV
orders_df = pd.DataFrame(orders)

orders_df.to_csv(
    DATA_DIR / "orders.csv",
    index=False
)

# STEP 5: Display confirmation
print("\nDATA GENERATION SUCCESSFUL")
print("--------------------------")
print("Total stores:", len(stores))
print("Total orders:", len(orders_df))

print("\nOrder status summary:")
print(orders_df["OrderStatus"].value_counts())

print("\nFirst five orders:")
print(orders_df.head().to_string(index=False))

print("\nFiles saved in:", DATA_DIR)
