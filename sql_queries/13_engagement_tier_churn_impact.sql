WITH temp1 AS (
  SELECT 
      user_id, 
      COUNT(session_id) AS numofsess
  FROM `saas-churn-project-h1-493410.churn_data.activity_fact`
  GROUP BY user_id
),
temp2 AS (
  SELECT *,
         NTILE(3) OVER (ORDER BY numofsess) AS segment
  FROM temp1
),
temp3 AS (
  SELECT 
      a.user_id,
      a.segment,
      b.status
  FROM temp2 a
  JOIN `saas-churn-project-h1-493410.churn_data.subscription_fact` b
    ON a.user_id = b.user_id
)
SELECT
    CASE 
        WHEN segment = 1 THEN 'Low' 
        WHEN segment = 2 THEN 'Medium'
        ELSE 'High'
    END AS engagement,
    
    COUNT(DISTINCT user_id) AS total_users,

    COUNT(DISTINCT CASE 
        WHEN status = 'Churned' THEN user_id 
    END) AS churned_users,

    ROUND(
        COUNT(DISTINCT CASE 
            WHEN status = 'Churned' THEN user_id 
        END) * 1.0 
        / COUNT(DISTINCT user_id), 
    2) AS churn_rate

FROM temp3
GROUP BY engagement
ORDER BY churn_rate DESC;