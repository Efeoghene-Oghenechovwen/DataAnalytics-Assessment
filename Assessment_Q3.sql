SELECT 
    s.plan_id,
    s.owner_id,
    'Savings' AS type,
    MAX(transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM savings_savingsaccount s
GROUP BY s.plan_id, s.owner_id
HAVING inactivity_days > 365

											/*
											WHAT THIS QUERY DOES:

											MAX(transaction_date) → Gets the most recent transaction date per savings account.

											DATEDIFF(CURDATE(), MAX(...)) → Calculates how many days since the last transaction.

											HAVING inactivity_days > 365 → Keeps only accounts inactive for over a year.

											Adds a static label 'Savings' AS type for clarity.

											*/

UNION ALL                                  -- I used the UNION ALL to Combine both savings and investment account which results into one list.

                                           -- UNION ALL is used (instead of UNION) to include all results without removing duplicates as opposed to UNION



SELECT 
    p.plan_group_id,
    p.owner_id,
    'Investment' AS type,
    MAX(last_returns_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(last_returns_date)) AS inactivity_days
FROM plans_plan p
GROUP BY p.id, p.owner_id
HAVING inactivity_days > 365;

									/*
									WHAT THIS QUERY DOES:

									Same logic as above, but uses:

									last_returns_date as the equivalent of a "transaction" for investment plans.

									'Investment' AS type for easy distinction.

									p.plan_group_id is used to represent the investment plan (instead of p.id, which is grouped by but not selected).

									*/