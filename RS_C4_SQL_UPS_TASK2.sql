/*
LEARNINGS, ADDITIINAL ACTIVITIES, NOTES, CONCLUDING REMARK
--

Task 2: Delivery Delay Analysis (15 Marks)
● Calculate delivery delay (in days) for each order
● Find Top 10 delayed routes based on average delay days.
● Use window functions to rank all orders by delay within each warehouse.
*/

-- create database RS_C4_SQL_UPS;
use RS_C4_SQL_UPS;
show tables;
-- Imported table details --> tables deliveryagents, orders,  routes,  shipment_tracking, warehouses

-- ● Calculate delivery delay (in days) for each order
DROP TABLE IF EXISTS T2_1;
CREATE TABLE T2_1 AS
SELECT  Order_ID, Actual_Delivery_Date,Expected_Delivery_Date, 
DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date) AS Dealy_In_Days 
FROM orders where Delivery_Status ='Delayed'
order by Dealy_In_Days desc;
select * from T2_1;

-- ● Find Top 10 delayed routes based on average delay days.
DROP TABLE IF EXISTS T2_2;
CREATE TABLE T2_2 AS
SELECT Route_ID, round(avg(Traffic_Delay_Min / 1440),3) AS Avg_Delay_Days 
from routes group by Route_ID 
order by  avg(Traffic_Delay_Min / 1440) desc limit 10;
select * from T2_2;

-- ● Use window functions to rank all orders by delay within each warehouse.  -- Warehouse_ID
DROP TABLE IF EXISTS T2_3;
CREATE TABLE T2_3 AS
with Delayed_Orders as (select Warehouse_ID,Order_ID,
round((DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date)),2) Delayed_Delivery_Days  
from orders 
)
select *, 
dense_rank() over (partition by Warehouse_ID ORDER BY Delayed_Delivery_Days DESC ) rnk 
from Delayed_Orders
order by Warehouse_ID, rnk asc;
select * from T2_3;


