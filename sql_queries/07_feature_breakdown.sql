SELECT 
    feature_used,
    COUNT(*) AS usage_count
FROM `saas-churn-project-h1-493410.churn_data.activity_fact`
GROUP BY feature_used
ORDER BY usage_count DESC
LIMIT 1;