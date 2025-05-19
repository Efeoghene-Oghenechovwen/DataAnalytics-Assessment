# My Approach To Each Question and Challenges Encountered

# DataAnalytics-Assessment
SQL Proficiency Assessment. This evaluation is designed to measure your ability to work with relational databases by writing SQL queries to solve business problems.

## 1. High-Value Customers with Multiple Products
Question: Identify customers with at least one funded savings and investment plan, sorted by total deposits.

My Approach:
I created two temporary aggregations: one for funded savings plans (is_regular_savings = 1 and is_a_fund = 1) and another for funded investment plans (is_a_fund = 1 and amount > 0). I grouped both by owner_id to count the number of plans and sum their deposits. Then, I joined these results with the users table and computed the total deposits by summing savings and investment values, sorted in descending order.

## 2. Transaction Frequency Analysis
Question: Classify customers based on their average number of monthly transactions.

My Approach:
First, I grouped transactions by user and month to count monthly activity. Then, I averaged those counts per user to get the average number of monthly transactions. I joined this with the user data and used a CASE statement to label each customer as High Frequency, Medium Frequency, or Low Frequency, based on defined thresholds.


## 3. Account Inactivity Alert
Question: Find savings and investment plans that have had no transactions in the past year.

My Approach:
I queried the latest transaction_date from the savings_savingsaccount table and the latest last_returns_date from the plans_plan table. I calculated the number of days since each customer’s last activity using DATEDIFF. I then filtered for customers with over 365 days of inactivity and used UNION ALL to combine savings and investment results, labeling each row accordingly.


## 4. Customer Lifetime Value (CLV) Estimation
Question: Estimate CLV using account tenure and transaction volume.

My Approach:
I joined the users_customuser and savings_savingsaccount tables using the owner_id key. I calculated the account tenure in months using TIMESTAMPDIFF, counted the total number of transactions, and computed the average profit per transaction as 0.1% of the transaction value. Then, I applied the given CLV formula:
(total_transactions / tenure) * 12 * avg_profit_per_transaction.
Finally, I ordered the results by estimated CLV in descending order.


# CHALLENGES ENCOUNTERED

## 1. Understanding the JOIN Relationships Between Tables
Challenge:
It was initially unclear how the users_customuser, savings_savingsaccount, and plans_plan tables were connected.

Resolution:
I reviewed the schema and identified the following key relationships:

savings_savingsaccount.owner_id → users_customuser.id

savings_savingsaccount.plan_id → plans_plan.id
This helped me correctly structure the JOINs and prevent inaccurate aggregations.

## 2. Using Aggregates Inside Aggregates
Challenge:
I attempted to use AVG(COUNT(*)) directly, which is not allowed in SQL.

Resolution:
I split the logic into two Common Table Expressions (CTEs):

One to count transactions per month.

Another to average those monthly counts per user.
This modular approach made the query easier to debug and logically sound.

## 3. Combining Multiple Data Types (Savings vs Investment)
Challenge:
When combining savings and investment data for dormant accounts, I needed to merge two different logic paths while keeping the structure uniform.

Resolution:
I used UNION ALL and aligned the column order and types across both SELECT statements. I also added a 'Savings' or 'Investment' tag to identify the source.

## 4. Categorizing Users Based on Transaction Frequency
Challenge:
It was tricky to apply thresholds like “High”, “Medium”, and “Low” frequency accurately based on averages.

Resolution:
I used a CASE statement to classify users after calculating the average monthly transactions in a CTE. This approach made the logic readable and maintainable.

