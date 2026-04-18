WITH user_last_seen AS (
    -- Step 1: Find the last time every user was active
    SELECT 
        user_id, 
        MAX(DATE(event_timestamp)) as last_login_date
    FROM 
        `saas-churn-project-h1-493410.churn_data.activity_fact`
    GROUP BY 1
),
risk_segmentation AS (
    -- Step 2: Compare last login to the end of the year (Dec 31, 2023)
    -- and join with subscription data to get the MRR
    SELECT 
        u.user_id,
        s.mrr_amount,
        DATE_DIFF(DATE('2023-12-31'), u.last_login_date, DAY) as days_since_last_seen
    FROM 
        user_last_seen u
    JOIN 
        `saas-churn-project-h1-493410.churn_data.subscription_fact` s
        ON u.user_id = s.user_id
    WHERE 
        s.status = 'Active' -- We only care about active users who are quiet
)
-- Step 3: Group them into risk buckets and sum the money
SELECT 
    CASE 
        WHEN days_since_last_seen <= 3 THEN 'Healthy (0-3 Days)'
        WHEN days_since_last_seen <= 7 THEN 'Warning (4-7 Days)'
        ELSE 'Critical Risk (7+ Days)'
    END AS risk_profile,
    COUNT(user_id) as user_count,
    ROUND(SUM(mrr_amount), 2) as total_mrr_at_risk
FROM 
    risk_segmentation
GROUP BY 1
ORDER BY 1;