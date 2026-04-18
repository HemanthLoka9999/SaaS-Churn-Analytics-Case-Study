SELECT 
    DATE_TRUNC(DATE(event_timestamp), MONTH) AS month_date,
    FORMAT_DATE('%b %Y', DATE_TRUNC(DATE(event_timestamp), MONTH)) AS month_label,
    COUNT(DISTINCT user_id) AS mau
FROM `saas-churn-project-h1-493410.churn_data.activity_fact`
GROUP BY month_date, month_label
ORDER BY month_date;