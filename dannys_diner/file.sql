-- 1. What is the total amount each customer spent at the restaurant?
SELECT
  sales.customer_id,
  SUM(menu.price) AS total_sales
FROM dannys_diner.sales
JOIN dannys_diner.menu
ON dannys_diner.sales.product_id = dannys_diner.menu.product_id
GROUP BY
  sales.customer_id;


-- 2. How many days has each customer visited the restaurant?\
SELECT
  customer_id,
  COUNT(DISTINCT order_date)
FROM dannys_diner.sales
GROUP BY 1;


-- 3. What was the first item from the menu purchased by each customer?
WITH ordered_sales AS (
  SELECT
    sales.customer_id,
    RANK() OVER (
      PARTITION BY sales.customer_id
      ORDER BY sales.order_date
    ) AS order_rank,
    menu.product_name
  FROM dannys_diner.sales
  INNER JOIN dannys_diner.menu
    ON sales.product_id = menu.product_id
)
SELECT DISTINCT
  customer_id,
  product_name
FROM ordered_sales
WHERE order_rank = 1;


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT
  menu.product_name,
  COUNT(sales.*) AS total_purchases
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu
  ON dannys_diner.sales.product_id = dannys_diner.menu.product_id
GROUP BY 1
ORDER BY total_purchases DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
WITH customer_cte AS (
  SELECT
    sales.customer_id,
    menu.product_name,
    COUNT(sales.*) AS item_quantity,
    RANK() OVER (
      PARTITION BY sales.customer_id
      ORDER BY COUNT(sales.*)
    ) AS item_rank
  FROM dannys_diner.sales
  INNER JOIN dannys_diner.menu
  ON dannys_diner.sales.product_id = dannys_diner.menu.product_id
  GROUP BY
    sales.customer_id,
    menu.product_name
)
SELECT
  customer_id,
  product_name,
  item_quantity
FROM customer_cte
WHERE item_rank = 1;


-- 6. Which item was purchased first by the customer after they became a member?
WITH member_sales_cte AS (
  SELECT
    sales.customer_id,
    sales.order_date,
    menu.product_name,
    RANK() OVER (
      PARTITION BY sales.product_id
      ORDER BY sales.order_date
    ) AS order_rank
  FROM dannys_diner.sales
  INNER JOIN dannys_diner.menu
    ON sales.product_id = menu.product_id
  INNER JOIN dannys_diner.members
    ON sales.customer_id = members.customer_id
  WHERE
    sales.order_date >= members.join_date::DATE
)
SELECT 
  DISTINCT customer_id,
  order_date,
  product_name
FROM member_sales_cte
WHERE order_rank = 1


-- 7. Which item was purchased just before the customer became a member?
WITH member_sales AS (
  SELECT
    sales.customer_id,
    sales.order_date,
    menu.product_name,
    RANK() OVER (
      PARTITION BY sales.customer_id
      ORDER BY sales.order_date DESC
    ) AS order_rank
  FROM dannys_diner.menu
  INNER JOIN dannys_diner.sales
    ON sales.product_id = menu.product_id
  INNER JOIN dannys_diner.members
    ON sales.customer_id = members.customer_id
  WHERE
    sales.order_date < members.join_date::DATE
)
SELECT
  customer_id
  order_date,
  product_name
FROM member_sales
WHERE order_rank = 1;


-- 8. What is the total items and amount spent for each member before they became a member?
SELECT
  sales.customer_id,
  COUNT(DISTINCT sales.product_id) AS unique_menu_items,
  SUM(menu.price) AS total_spend
FROM dannys_diner.sales
INNER JOIN dannys_diner.menu
  ON sales.product_id = menu.product_id
INNER JOIN dannys_diner.members
  ON sales.customer_id = members.customer_id
WHERE
  sales.order_date < members.join_date::DATE
GROUP BY 1;


-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
