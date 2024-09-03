-- TOP 10 HIGHEST REVENUE GENERATING PRODUCT -- 
SELECT 
    product_id,
    SUM(sale_price) AS sales
FROM 
    df_order
GROUP BY 
    product_id
ORDER BY 
    sales DESC
LIMIT 10;

-- top 5 highest selling products in each region --
with cte as(SELECT 
    region,
    product_id,
    SUM(sale_price) AS sales
FROM 
    df_order
GROUP BY 
    region,product_id
)
SELECT * from (SELECT * , row_number() over(partition by region order by sales desc) 
as rn from cte)A where rn <=5;

-- Find  Monthly comparison for 2022 vs 2023 sales -- 

with cta as(select  sum(sale_price) as sales, year(order_date) as order_year,month(order_date) as order_month from df_order
 group by  year(order_date), month(order_date)
--  order by  year(order_date), month(order_date) -- 
 )
 select order_month, 
 sum(case when order_year=2022 then sales else 0 end) as sales_2022,
 sum(case when order_year=2023 then sales else 0 end) as sales_2023
 from cta
 group by order_month
 order by order_month;
 
 -- For each category, which month had the highest sales -- 
 with cta as (select sum(sale_price) as sales, category, month(order_date) as month_num from df_order
 group by category,month_num
 order by category,sales desc)
 select sales, category, month_num from cta 
WHERE (category, sales) IN (
    SELECT 
        category, 
        MAX(sales)
    FROM cta
    GROUP BY category
)
ORDER BY category, month_num;

-- Which sub category had the highest growth in profit in 2023 compared to 2022 -- 
with cta as(select  sub_category, year(order_date) as order_year,sum(sale_price) as sales from df_order
 group by  sub_category,year(order_date)
--  order by  year(order_date), month(order_date) -- 
 )
 ,cte2 as (
 select sub_category, 
 sum(case when order_year=2022 then sales else 0 end) as sales_2022,
 sum(case when order_year=2023 then sales else 0 end) as sales_2023
 from cta
 group by sub_category)
 
SELECT  *,(sales_2023-sales_2022)
from cte2
order by (sales_2023-sales_2022) desc
limit 1;


 
    

