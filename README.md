# SaaS Churn & User Behavior Analytics

**Focus:** User Engagement | Churn Analysis | Revenue Risk
**Tech Stack:** SQL (BigQuery), Python (Pandas, Matplotlib)

---

## 📌 Business Overview

This project analyzes user activity data from a SaaS platform to understand:

* How user engagement evolves over time
* What behavioral patterns are associated with churn
* How inactivity translates into potential revenue risk

The dataset (~1M+ rows) is synthetically generated to simulate real-world SaaS usage patterns.

**Objective:**
Identify **early churn signals** and quantify **business impact (MRR at risk)**.

---

## ⚙️ Technical Pipeline

1. **Ingestion:** Raw SaaS activity and subscription logs stored as CSVs
2. **Processing (BigQuery):** 16 SQL scripts for aggregation & window functions
3. **Extraction:** Business metrics exported to `data/csv_files/`
4. **Intelligence:** Python generates visual insights in `/visuals`

---

## 📊 Key Insights

### 🔍 High-Level Business Insights

* User engagement shows a clear **post-onboarding drop-off**, indicating weak early retention
* **Session inactivity (gap days)** emerges as the strongest early predictor of churn
* **Low engagement users** contribute disproportionately to churn rates
* A significant portion of revenue is linked to **inactive but still subscribed users**
* Feature usage alone is not a strong retention driver, suggesting deeper behavioral patterns at play

---

### 1. Daily Active Users (DAU Trend)

![DAU Trend](visuals/01_dau_trend.png)

> ⚠️ **Engagement drops after initial adoption — indicating early-stage retention is the primary failure point.**

* DAU shows initial growth followed by steady decline
* Rolling average smooths short-term fluctuations

**Interpretation:**
User engagement drops after the initial adoption phase, suggesting weak retention in early lifecycle stages.

---

### 2. Session Gap Analysis (Churn Signal)

![Session Gap](visuals/03_session_gap.png)

* Users segmented by inactivity: Daily → At Risk
* Significant volume observed in higher gap buckets

**Interpretation:**
Increasing session gaps act as an early warning signal for churn.

---

### 3. Engagement vs Churn

![Engagement vs Churn](visuals/04_engagement_churn.png)

* Users segmented into Low, Medium, High engagement
* Lower engagement segments show higher churn

**Interpretation:**
Engagement intensity strongly correlates with retention likelihood.

---

### 4. Feature Stickiness

![Feature Stickiness](visuals/02_feature_stickiness.png)

* Churn rates are relatively similar across features

**Interpretation:**
Feature usage alone does not explain retention differences. This indicates the need to analyze:

* Usage frequency (depth)
* Feature combinations
* User journey behavior

---

### 5. Revenue at Risk

![Revenue at Risk](visuals/05_revenue_at_risk.png)

> 💰 **35% of revenue is tied to inactive users — highlighting a gap in proactive retention strategy.**

* Users grouped by inactivity duration
* MRR aggregated across risk segments

**Key Observation:**

* Total Active MRR: **~$212K**
* Critical Risk (7+ days): **~$75K (~35%)**
* Warning (4–7 days): **~$78K (~37%)**

**Interpretation:**
A significant portion of revenue is associated with users already showing inactivity signals, indicating potential near-term revenue loss.

---

## 💡 Key Takeaways

* Engagement declines after initial adoption
* Session inactivity is a strong churn signal
* Low engagement users are high-risk
* Revenue risk can be quantified using behavioral signals

---

## 💡 Recommendations

### 1. Trigger Re-engagement at 4–7 Days

* Target users before entering critical risk

**Actions:**

* Email reminders
* In-app nudges

---

### 2. Prioritize High-Value At-Risk Users

* ~35% MRR in high-risk segment

**Actions:**

* Customer success outreach
* Retention incentives

---

### 3. Improve Early Engagement

* Low engagement users churn more

**Actions:**

* Better onboarding
* Highlight core features early

---

### 4. Deepen Feature Analysis

* Current feature data lacks differentiation

**Next Steps:**

* Analyze feature usage depth
* Combine with engagement segments

---

### 5. Build Monitoring System

* Track inactivity + engagement trends

**Outcome:**
Early detection of churn risk

---

## 📁 Repository Structure

```
├── sql_queries/       # SQL scripts (16 queries covering full analysis flow)
├── scripts/           # Data generation & visualization scripts
├── data/
│   ├── raw/           # Sample datasets
│   └── csv_files/     # Processed outputs
├── visuals/           # Final charts used in analysis
├── exploration/       # Intermediate analysis & debugging
└── README.md
```

---

## 🚀 How to Reproduce

1. Run `scripts/generate_churn_data.py` to generate synthetic data
2. Execute SQL queries in BigQuery
3. Run `scripts/generate_visuals.py` to recreate charts

---

## 🧠 Skills Demonstrated

* SQL (CTEs, Window Functions like `LAG`, aggregations)
* Behavioral Data Analysis
* Churn Analysis
* Data Visualization
* Translating analytical findings into business recommendations

---

## 📌 Notes

* Data is synthetically generated for demonstration purposes
* Sample datasets are included instead of full raw data
