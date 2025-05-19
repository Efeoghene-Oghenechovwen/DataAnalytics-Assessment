 SELECT
  u.id AS customer_id,
  CONCAT(u.first_name, ' ', u.last_name) AS fullname,
  TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
  COUNT(s.id) AS total_transactions,
 /*

													 The above query Fetches each customer’s ID and full name.

													-- TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months

													Calculate how long the customer has had an account (in full months) by subtracting the date_joined from today (CURDATE()).

													-- COUNT(s.id) AS total_transactions

													Count the total number of savings transactions (i.e., records in savings_savingsaccount) linked to the customer.

													This represents how active the customer is.
*/
  
  
  
  ROUND(
    (COUNT(s.id) 
     / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)
     * 12
     * AVG(s.amount * 0.001)
    ), 2
  ) AS estimated_clv
  
													/*  CLV Estimation Formula

													Here I applied the formula inside a ROUND(..., 2) function to round it to 2 decimal places.

													PURPOSE OF THIS STEP:

													-- COUNT(s.id) → Total transactions

													-- NULLIF(..., 0) prevents division by zero (if tenure is 0 months)

													-- * 12 → Annualize the per-month transaction value

													-- AVG(s.amount * 0.001) → Computes the average profit (0.1%) per transaction based on amount

													-- If the user has a 0-month tenure (that means he or she just joined), we avoid division-by-zero by using NULLIF.

													*/
  
  
FROM users_customuser u
LEFT JOIN savings_savingsaccount s
  ON s.owner_id = u.id
GROUP BY
  u.id,
  fullname,
  tenure_months
HAVING total_transactions > 0
ORDER BY estimated_clv DESC;

												/*   PURPOSE OF THIS STEP:

												1). Here I used LEFT JOIN to ensure that I included all users even those with zero transactions using GROUP BY 
												2). Then I Aggregated all transaction data per customer using GROUP BY
												3). I went forward to Remove customers who haven’t made any savings transactions (their CLV would be 0 anyway) With the HAVING CLAUSE
												4). Finaly, I Sorted the results so the most valuable customers (by projected CLV) will appear at the top

												*/
