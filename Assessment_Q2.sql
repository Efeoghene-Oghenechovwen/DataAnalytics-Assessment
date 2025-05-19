WITH monthly_tx_counts AS (
    SELECT id, month,
        FORMAT(COUNT(*),0) AS number_of_transactions_per_month
    FROM savings_savingsaccount
    GROUP BY id, month
    
								-- The above step counts how many transactions each user (id) performs per month.
    
),
avg_monthly_tx AS (
    SELECT id,
        month,
        AVG(number_of_transactions_per_month) AS avg_monthly_transactions
    FROM monthly_tx_counts
    GROUP BY id, month
    
								-- While this step calculates the average number of monthly transactions for each user.
)
SELECT 
    u.id AS user_id,
    u.first_name,
    ROUND(a.avg_monthly_transactions, 2) AS avg_monthly_transactions,
    CASE 
        WHEN a.avg_monthly_transactions >= 10 THEN 'High Frequency'
        WHEN a.avg_monthly_transactions BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category
FROM avg_monthly_tx a
JOIN users_customuser u ON u.id = a.id
ORDER BY avg_monthly_transactions DESC;

								-- 		WHAT THIS FINAL STEP DOES
                                
                                -- Joins the average monthly transactions with the user table.

								-- Categorizes them as High, Medium, or Low Frequency based on thresholds.

								-- Orders by average monthly transactions.


