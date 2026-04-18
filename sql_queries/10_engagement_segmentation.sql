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
)
SELECT 
    CASE 
        WHEN segment = 1 THEN 'Low' 
        WHEN segment = 2 THEN 'Medium'
        ELSE 'High'
    END AS engagement,
    COUNT(*) AS user_count
FROM temp2
GROUP BY engagement
ORDER BY engagement;