create database quick_commerce;
use quick_commerce;

select * from quick_commerce;

#1. Company wise performance

select Company,sum(Order_Value) as revenue,avg(order_value)as avg_value,count(*)as total_orders,round(avg(Customer_Rating),2) as avg_rating,row_number() over (order by sum(Order_Value)  desc) as company_rank 
from quick_commerce
group by Company;

#2. Category wise performance

select Product_Category,sum(Order_Value) as revenue,count(*)as total_orders,
AVG(Order_Value) AS avg_order_value,
       AVG(Items_Count) AS avg_items
from quick_commerce
group by Product_Category;

#3. City wise performance

select City, round(sum(Order_Value),2) AS revenue, count(*)as total_orders,round(avg(Customer_Rating),2) as avg_rating, row_number() over (order by sum(Order_Value)  desc) as city_rank 
from quick_commerce
group by City;

#4. Top 3 performing companies by City

with performance as(
select City,Company,round(sum(Order_Value),2) AS revenue, count(*)as total_orders,row_number()over (partition by City order by sum(Order_Value) desc) as rnk
from quick_commerce
group by City,Company)

select * from performance
where rnk<=3;

#5. Low performing companies by City by Ratings

with citywise_performance as(
select City,Company,round(AVG(Customer_Rating),2)AS avg_Rating,
count(*) as total_orders,
MIN(Customer_Rating) AS worst_rating,
MAX(Customer_Rating) AS best_rating,
rank() over (partition by City order by AVG(Customer_Rating) asc) as rating_rank
from quick_commerce
group by City,Company)

select *
from citywise_performance
where rating_rank<=3;

#6. Which Age_Category are the prime customers

select age_group,round(sum(Order_Value),2)as revenue,AVG(Order_Value) AS avg_order_value,count(*) as total_orders
from quick_commerce
group by age_group
order by revenue desc;

#7. Late order analysis, Most late orders by Company and City

select Company,city,avg(Delivery_Time_Min) avg_delivery_Time,sum(is_late) as total_late_orders
from quick_commerce
where is_late=1
group by Company,city;

#8. No ratings or ratings missing recorded by company

SELECT company,
ROUND(100 * SUM(rating_missing) / COUNT(*), 2) AS customer_rating_missing_pct,
ROUND(100 * SUM(partner_rating_missing) / COUNT(*), 2) AS partner_rating_missing_pct
FROM quick_commerce
GROUP BY company
ORDER BY customer_rating_missing_pct DESC;

#9. Company's % of orders purchased when discount applied

select Company,
round(100* sum(case when discount_applied ='yes' then 1 else 0 end)/count(*),2)as with_discount_purchase_percentage,
 AVG(order_value) AS avg_order_value
from quick_commerce
group by Company
order by with_discount_purchase_percentage desc;

#10. Average customer rating and order value by Late Deliveries
SELECT is_late,
       COUNT(*) AS total_orders,
       AVG(Customer_Rating) AS avg_rating,
       AVG(Order_Value) AS avg_order_value
FROM quick_commerce
GROUP BY is_late;

