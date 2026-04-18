SELECT 
    column_name, 
    data_type
FROM 
    `saas-churn-project-h1-493410.churn_data.INFORMATION_SCHEMA.COLUMNS`
WHERE 
    table_name = 'subscription_fact';
