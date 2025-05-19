WITH
-- 1. Aggregate savings plans
sav AS (
  SELECT
    s.owner_id,
    COUNT(*) AS savings_count,
    SUM(s.confirmed_amount) AS savings_deposits
  FROM savings_savingsaccount s
  JOIN plans_plan p
    ON s.plan_id = p.id
  WHERE
    p.is_regular_savings = 1      -- only savings plans
    AND p.is_a_fund = 1    -- only funded
  GROUP BY s.owner_id
),
											/*
											1). Here I filtered for funded savings plans (is_regular_savings = 1 AND is_a_fund = 1)

											2). Grouped by owner_id (customer) and:

											3). Counts number of savings accounts (savings_count)

											4). Sumed up all confirmed deposits (savings_deposits)
											*/

-- 2. Aggregate investment plans
inv AS (
  SELECT
    p.id,
    COUNT(*)     AS investment_count,
    SUM(p.amount) AS investment_deposits
  FROM plans_plan p
  WHERE
    p.is_a_fund = 1    -- only investment plans
    AND p.amount > 0   -- only funded
  GROUP BY p.id
)

-- 3. Join them to users and compute totals
SELECT
  u.id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  sav.savings_count,
  inv.investment_count,
  ROUND(sav.savings_deposits + inv.investment_deposits, 2) AS total_deposits
FROM users_customuser u
JOIN sav ON sav.owner_id = u.id
JOIN inv ON inv.id = u.id
ORDER BY total_deposits DESC;

												/*
												Dont worry, what I did in the final steps here is not that technical. LOL!

												1). First of all, I Joined users who have both savings and investment plans

												2). Then I CombineD and rounded their total deposits

												3). Lastly, I ordered customers from highest to lowest by total deposits.

*/
