WITH user_features AS (
    SELECT 
        user_id,
        feature_used
    FROM `saas-churn-project-h1-493410.churn_data.activity_fact`
    GROUP BY user_id, feature_used
)

SELECT 
    uf.feature_used,
    COUNT(DISTINCT CASE WHEN s.status = 'Active' THEN uf.user_id END) AS active_users,
    COUNT(DISTINCT CASE WHEN s.status = 'Churned' THEN uf.user_id END) AS churned_users,
    COUNT(DISTINCT uf.user_id) AS total_users,
    ROUND(
        COUNT(DISTINCT CASE WHEN s.status = 'Churned' THEN uf.user_id END) * 100.0
        / COUNT(DISTINCT uf.user_id), 2
    ) AS churn_rate
FROM user_features uf
JOIN `saas-churn-project-h1-493410.churn_data.subscription_fact` s
    ON uf.user_id = s.user_id
GROUP BY uf.feature_used
ORDER BY churn_rate DESC;