SELECT 
    feature_used,
    COUNT(DISTINCT user_id) AS user_count
FROM `saas-churn-project-h1-493410.churn_data.activity_fact`
GROUP BY feature_used
ORDER BY user_count DESC;