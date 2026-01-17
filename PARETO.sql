---siparislerin %80 getiren ürünler
WITH product_orders AS (
SELECT p.product_id,p.product_name , COUNT(DISTINCT od.order_id)	AS order_count FROM products p
LEFT JOIN order_details od ON p.product_id=od.product_id
GROUP BY p.product_id,p.product_name
),
ranked_product AS (
SELECT product_id,product_name, order_count , SUM(order_count) OVER (ORDER BY order_count DESC) AS cumulative_order
, SUM(order_count) OVER () AS total_orders  FROM product_orders
)
SELECT  product_id,product_name ,order_count,cumulative_order,total_orders,
cumulative_order * 1.0 / total_orders AS cumulative_ratio
FROM ranked_product
WHERE cumulative_order * 1.0 / total_orders <= 0.80
ORDER BY order_count DESC;
---cironun %80 getiren ürünler
WITH product_ciro AS(
SELECT p.product_id,p.product_name,COALESCE(SUM(od.quantity*od.Unit_price),0) AS ciro FROM products p
LEFT JOIN order_details od ON p.product_id=od.product_id
GROUP BY p.product_id,p.product_name
),
ranted_product AS (
SELECT product_id,product_name,ciro,SUM(ciro) OVER (ORDER BY ciro DESC) cumulative_ciro ,
SUM(ciro) OVER () AS total_ciro  FROM product_ciro
)
SELECT product_id,product_name,ciro,cumulative_ciro,total_ciro,
cumulative_ciro *1.0 / total_ciro AS cumulative_ratio
FROM ranted_product
WHERE cumulative_ciro *1.0 / total_ciro <= 0.80
ORDER BY ciro DESC
