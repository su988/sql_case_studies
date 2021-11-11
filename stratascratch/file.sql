-- 1. Find the titles of workers that earn the highest salary. Output the highest-paid title or multiple titles that share the highest salary.

select 
    worker_title 
from 
    title
join 
    worker
ON 
    title.worker_ref_id = worker.worker_id
WHERE 
    salary = (SELECT MAX(salary) FROM worker)

-- 2. Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments. Output just the difference in salaries.
SELECT 
    (
        SELECT MAX(salary) 
        FROM db_employee as emp
        JOIN db_dept as dept
            ON emp.department_id = dept.id
        WHERE dept.department = 'marketing'
    ) 
    - 
    (
        SELECT MAX(salary) 
        FROM db_employee as emp
        JOIN db_dept as dept
            ON emp.department_id = dept.id
        WHERE dept.department = 'engineering'
    ) AS salary_diff

-- 3. Find the current salary of each employee assuming that salaries increase each year.
select id, first_name, last_name, department_id, MAX(salary) 
from ms_employee_salary
GROUP BY 1, 2, 3, 4
ORDER BY id

-- 4. Find the average popularity of the Hack per office location.
SELECT
    location,
    AVG(popularity)
FROM facebook_employees as fe
JOIN facebook_hack_survey as fs
    ON fe.id = fs.employee_id
GROUP BY location

-- 5. Find the top 5 states with the most 5 star businesses.
select 
    state,  
    COUNT(*) as n_businesses
from yelp_business
WHERE stars = 5
GROUP BY state
ORDER BY COUNT(*) DESC, state 
LIMIT 5

with cte1 AS (
    select 
        department as dept,
        AVG(salary) as avg_s
    from employee
    GROUP BY department
)

-- 6. Compare each employee's salary with the average salary of the corresponding department.
SELECT
    department,
    first_name,
    salary,
    avg_s
FROM employee
JOIN cte1 
ON department = dept
ORDER BY department 

--7. Find the details of each customer regardless of whether the customer made an order
select
    first_name,
    last_name,
    city,
    order_details
from customers as c
LEFT JOIN orders as o
ON c.id = o.cust_id
ORDER BY first_name, order_details

-- 8. Find the average number of bathrooms and bedrooms for each city’s property types
select 
    city,
    property_type,
    AVG(bathrooms) as n_bathrooms_avg,
    AVG(bedrooms) as n_bedrooms_avg
from airbnb_search_details
GROUP BY city, property_type

--9. Produce a list of the top three revenue generating facilities (including ties). Output facility name and rank
with total_revenue as (
	SELECT
	name,
	SUM(
		CASE 
	  		WHEN b.memid = 0 then slots*guestcost
		  	ELSE slots*membercost
	  	END
	) as revenue 
FROM cd.facilities f
JOIN cd.bookings b
ON f.facid = b.facid
GROUP BY 1
ORDER BY revenue desc LIMIT 3  
)

SELECT 
	name,
	rank() over (order by revenue desc) as rank
FROM total_revenue


-- 10. For each date, find the difference between the distance per dollar for that date and the average distance per dollar for that year/month. distance_per_dollar = distance travelled / cost of ride
SELECT 
    request_date,
    ROUND(ABS(CAST(distance_to_travel / monetary_cost - AVG(distance_to_travel / monetory_cost)  OVER (PARTITION BY date_trunc("month", request_date)) as decimal)), 2) AS difference
FROM interviews.uber_rides
ORDER BY request_date











