SELECT 
    user_id,
    COUNT(*) AS total_sessions,
    ROUND(AVG(session_duration_minutes),2) AS avg_session_duration
FROM `saas-churn-project-h1-493410.churn_data.activity_fact`
GROUP BY user_id
ORDER BY avg_session_duration DESC;