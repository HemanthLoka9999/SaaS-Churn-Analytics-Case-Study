 
WITH user_metrics AS (
select user_id,
count(session_id) as total_sessions,
round(avg(session_duration_minutes),2) as avg_duration,
count(distinct feature_used) as feature_used
FROM `saas-churn-project-h1-493410.churn_data.activity_fact`
group by user_id
)
SELECT 
    s.status,
    AVG(total_sessions),
    AVG(avg_duration),
    AVG(feature_used)
FROM user_metrics u
JOIN `saas-churn-project-h1-493410.churn_data.subscription_fact` s
ON u.user_id = s.user_id
GROUP BY s.status;







