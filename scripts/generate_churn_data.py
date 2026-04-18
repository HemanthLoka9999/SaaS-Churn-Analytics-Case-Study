# 1. Generate synthetic data
# 2. Run SQL externally (BigQuery)
# 3. Load CSV outputs
# 4. Create visualizations


import pandas as pd
import random
from datetime import datetime, timedelta

# --- CONFIGURATION ---
NUM_USERS = 35000  # This will generate ~1,000,000 activity rows
START_DATE = datetime(2023, 1, 1)
END_DATE = datetime(2023, 12, 31)

print(f"🚀 Starting Data Generation for {NUM_USERS} users (Target: 1M+ rows)...")

# --- 1. GENERATE USERS TABLE ---
print("📊 Building Users Table...")
user_ids = [f"USR_{i:05d}" for i in range(NUM_USERS)]
signup_dates = [START_DATE + timedelta(days=random.randint(0, 90)) for _ in range(NUM_USERS)]
plans = random.choices(["Basic", "Pro", "Enterprise"], weights=[0.6, 0.3, 0.1], k=NUM_USERS)
countries = random.choices(["India", "USA", "UK", "Singapore"], weights=[0.5, 0.3, 0.1, 0.1], k=NUM_USERS)

users_df = pd.DataFrame({
    "user_id": user_ids, 
    "signup_date": signup_dates, 
    "plan_type": plans,
    "country": countries
})


# --- 2. GENERATE ACTIVITY TABLE (The Engine) ---
print("⚙️ Building Activity Table (This will take 30-60 seconds)...")
activity_data = []

for i, row in users_df.iterrows():
    if i % 5000 == 0 and i > 0:
        print(f"   ...Processed {i} users...")
        
    uid = row['user_id']
    current_time = row['signup_date']
    
    # 30% of users are "Churners" (They will have massive >10 day gaps in their data)
    is_churner = random.random() < 0.3 
    
    # Each user logs in between 10 and 45 times
    num_sessions = random.randint(10, 45)
    
    for _ in range(num_sessions):
        # Behavioral logic: Churners get big gaps and short sessions, Healthy users get small gaps and long sessions
        if is_churner:
            gap_days = random.randint(5, 15) 
            duration_mins = random.randint(2, 15)  # Short engagement depth
        else:
            gap_days = random.randint(1, 3)
            duration_mins = random.randint(10, 120) # Deep engagement
            
        # Add hours and minutes for realistic timestamps
        current_time += timedelta(days=gap_days, hours=random.randint(1, 12), minutes=random.randint(0, 59))
        
        # Stop if the timeline goes past the end of the year
        if current_time > END_DATE:
            break
            
        # Granular behavior events
        feature = random.choice(["Dashboard_View", "Export_Report", "Settings_Change", "API_Call"])
        device = random.choices(["Desktop", "Mobile", "Tablet"], weights=[0.6, 0.3, 0.1])[0]
        
        activity_data.append({
            "session_id": f"S_{random.randint(100000,999999)}", 
            "user_id": uid, 
            "event_timestamp": current_time.strftime('%Y-%m-%d %H:%M:%S'), 
            "feature_used": feature,
            "device_type": device,
            "session_duration_minutes": duration_mins
        })

activity_df = pd.DataFrame(activity_data)
print(f"✅ Activity Table built! Total Rows: {len(activity_df):,}")


# --- 3. GENERATE SUBSCRIPTIONS TABLE ---
print("💳 Building Subscriptions Table...")
mrr_mapping = {"Basic": 19.99, "Pro": 49.99, "Enterprise": 199.99}
subscriptions_data = []

# Group activity to find the very last login for each user quickly
last_logins = activity_df.groupby('user_id')['event_timestamp'].max().to_dict()

for i, row in users_df.iterrows():
    uid = row['user_id']
    mrr = mrr_mapping[row['plan_type']]
    
    # Get last login (convert back to datetime for math)
    last_login_str = last_logins.get(uid)
    
    if last_login_str is None:
        status = "Churned"
    else:
        last_login_dt = datetime.strptime(last_login_str, '%Y-%m-%d %H:%M:%S')
        # Business Logic: If they haven't logged in for 14 days before Dec 31, they are churned
        if (END_DATE - last_login_dt).days > 14:
            status = "Churned"
        else:
            status = "Active"
            
    subscriptions_data.append({"user_id": uid, "mrr_amount": mrr, "status": status})

subscriptions_df = pd.DataFrame(subscriptions_data)


# --- 4. EXPORT TO CSV ---
print("💾 Saving files to CSV...")
users_df.to_csv("users_dim.csv", index=False)
activity_df.to_csv("activity_fact.csv", index=False)
subscriptions_df.to_csv("subscription_fact.csv", index=False)

print("🎉 DONE! You now have 3 production-grade CSV files ready for BigQuery.")