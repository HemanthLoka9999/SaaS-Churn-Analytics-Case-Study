WITH refdate AS (
    SELECT MAX(DATE(event_timestamp)) AS maxdate
    FROM `saas-churn-project-h1-493410.churn_data.activity_fact`
),

temp AS (
    SELECT 
        user_id,
        MAX(DATE(event_timestamp)) AS usermaxdate
    FROM `saas-churn-project-h1-493410.churn_data.activity_fact`
    GROUP BY user_id
),

temp2 AS (
    SELECT 
        t.user_id,
        DATE_DIFF(r.maxdate, t.usermaxdate, DAY) AS gap_days
    FROM refdate r
    CROSS JOIN temp t
)

SELECT 
    ROUND(
        SUM(CASE WHEN gap_days > 14 THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),
        2
    ) AS churn_rate_pct
FROM temp2;