WITH sessions AS (
    SELECT 
        user_id,
        event_timestamp AS session_time,
        LAG(event_timestamp) OVER (
            PARTITION BY user_id 
            ORDER BY event_timestamp
        ) AS prev_session_time
    FROM `saas-churn-project-h1-493410.churn_data.activity_fact`
)

SELECT 
    user_id,
    DATE_DIFF(DATE(session_time), DATE(prev_session_time), DAY) AS gap_days,

    CASE 
        WHEN DATE_DIFF(DATE(session_time), DATE(prev_session_time), DAY) <= 1 THEN 'Daily'
        WHEN DATE_DIFF(DATE(session_time), DATE(prev_session_time), DAY) <= 3 THEN 'Frequent'
        WHEN DATE_DIFF(DATE(session_time), DATE(prev_session_time), DAY) <= 7 THEN 'Weekly'
        ELSE 'At Risk'
    END AS gap_segment

FROM sessions
WHERE prev_session_time IS NOT NULL;