-- 1. How many pizzas were ordered?
SELECT COUNT(*) FROM pizza_runner.customer_orders;


-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT pizza_id) FROM pizza_runner.customer_orders;


-- 3. How many successful orders were delivered by each runner?
SELECT 
  runner_id,
  SUM (
    CASE
      WHEN pickup_time != 'null' THEN 1
      ELSE 0
    END
    ) AS successful_orders
FROM pizza_runner.runner_orders
GROUP BY 1
ORDER BY successful_orders DESC


-- 4. How many of each type of pizza was delivered?
SELECT 
  pizza_name,
  COUNT(customer_orders.pizza_id) as delivered_pizzas
FROM pizza_runner.pizza_names 
JOIN pizza_runner.customer_orders 
  ON pizza_runner.pizza_names.pizza_id = pizza_runner.customer_orders.pizza_id
JOIN pizza_runner.runner_orders
  ON pizza_runner.customer_orders.order_id = pizza_runner.runner_orders.order_id
WHERE pizza_runner.runner_orders.pickup_time != 'null'
GROUP BY 1

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
  customer_id, 
  SUM(CASE WHEN pizza_names.pizza_id = 1 THEN 1 ELSE 0 END) AS meatlovers,
  SUM(CASE WHEN pizza_names.pizza_id = 2 THEN 1 ELSE 0 END) AS vegetarian
FROM pizza_runner.customer_orders
JOIN pizza_runner.pizza_names
  ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY 1;

-- 6. How many pizzas were delivered that had both exclusions and extras?
WITH cte_cleaned_customer_orders AS (
  SELECT
    order_id,
    customer_id,
    pizza_id,
    CASE WHEN exclusions IN ('null', '') THEN NULL ELSE exclusions END AS exclusions,
    CASE WHEN extras IN ('null', '') THEN NULL ELSE extras END AS extras,
    order_time
  FROM pizza_runner.customer_orders
)
SELECT
  COUNT(*)
FROM cte_cleaned_customer_orders
WHERE exclusions IS NOT NULL AND extras IS NOT NULL;

