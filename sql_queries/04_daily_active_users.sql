WITH daily AS (
    SELECT 
        DATE(event_timestamp) AS activity_date,
        COUNT(DISTINCT user_id) AS dau
    FROM `saas-churn-project-h1-493410.churn_data.activity_fact`
    GROUP BY activity_date
)

SELECT 
    activity_date,
    dau,
    AVG(dau) OVER (ORDER BY activity_date 
                   ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS rolling_4_day_avg
FROM daily
ORDER BY activity_date;