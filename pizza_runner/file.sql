-- How many pizzas were ordered?
SELECT COUNT(*) FROM pizza_runner.customer_orders;


-- How many unique customer orders were made?
SELECT COUNT(DISTINCT pizza_id) FROM pizza_runner.customer_orders;


-- How many successful orders were delivered by each runner?
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


-- How many of each type of pizza was delivered?
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

-- How many Vegetarian and Meatlovers were ordered by each customer?
