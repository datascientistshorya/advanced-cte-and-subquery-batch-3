/*Q1 — Customers Above City Average
Find customers whose total spending is greater than the average total spending 
of customers in their city*/

with customer_data as(
select c.customer_id,c.customer_name,c.city, sum(o.amount) as total_spent
from customers c inner join orders o 
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name,c.city
),
city_data as(
	select city,avg(total_spent) as city_avg from customer_data
    group by city
)
select *from customer_data cd
inner join city_data ctd
on cd.city=ctd.city
where cd.total_spent>ctd.city_avg;

/*Q2 — Customers Above Overall Average
Find customers whose total spending is greater than the overall average customer spending*/


/*Q3 — Products Above Category Average Price
Find products whose price is higher than the average price of products in their category.*/

with prod_data as(
select category, avg(price) as avg_price from products
group by category)

select * from products p
inner join prod_data pd
on p.category=pd.category
where p.price> pd.avg_price;

/* Q4 — Customers Who Bought Expensive Products
Find customers who have purchased at least one product 
whose price is above the overall average product price*/

WITH expensive_products AS (
    SELECT product_id,product_name,category,price
    FROM products
    WHERE price > (
        SELECT AVG(price)FROM products
    )
)

SELECT
    c.customer_id,c.customer_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    INNER JOIN expensive_products ep
        ON o.product_id = ep.product_id
    WHERE o.customer_id = c.customer_id
);

/*Q5 — Customers With No Cancelled Orders
Find customers who have never placed a cancelled order.*/

SELECT
    c.customer_id,
    c.customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.status = 'Cancelled'
);

/*Q6 — Above-Average Spending + Successful Orders
Find customers whose:
1.	Total spending is above the overall average customer spending, and 
2.	They have at least one order with status 'Completed'. */

with customer_data as(
	select c.customer_id, c.customer_name, sum(o.amount) as amount_spent
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_id, c.customer_name
)
select * from customer_data cd
where (cd.amount_spent)>
(select avg(amount_spent) from customer_data)
and
cd.customer_id in
(select customer_id from orders
 where status='Completed');
    

/*Q7 — Category Revenue Above Average Category Revenue
Calculate total revenue for each product category.
Then return only categories whose revenue is greater than
the average revenue across all categories.*/

with category_data as(
	select p.category, sum(o.amount) as category_revenue
    from products p inner join orders o 
    on p.product_id=o.product_id
    group by p.category
)
select category, category_revenue from category_data
where category_revenue>
(select avg(category_revenue) from category_data);

/* Q8 — High-Value Customers With Cancellation Risk 🔥
Identify customers who satisfy both:
1.	Their total spending is above the overall average customer spending. 
2.	Their cancelled-order count is greater than the average cancelled-order count per customer*/

with customer_data as(
	select c.customer_id, c.customer_name, sum(o.amount) as total_spend, 
    sum(case when o.status='Cancelled' then 1 else 0 end) as Cancelled_orders
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_id, c.customer_name
),

benchmarks AS (
    SELECT
        AVG(total_spend) AS avg_customer_spend,
        AVG(cancelled_orders) AS avg_cancelled_orders
    FROM customer_data
)
select * from customer_data cd
cross join benchmarks b
WHERE cd.total_spend > b.avg_customer_spend
  AND cd.cancelled_orders > b.avg_cancelled_orders;





