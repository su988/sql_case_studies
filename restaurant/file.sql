
-- 1. What is the total amount each customer spent at the restaurant?

SELECT
  s.customer_id,
  SUM(m.price) as Total
FROM dannys_diner.sales as s
JOIN dannys_diner.menu as m
	ON s.product_id = m.product_id
JOIN dannys_diner.members as mem
	ON s.customer_id = mem.customer_id
GROUP BY s.customer_id


-- 2. How many days has each customer visited the restaurant?

SELECT 
	customer_id,
  COUNT(DISTINCT order_date)
FROM dannys_diner.sales
GROUP BY customer_id

