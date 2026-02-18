/*
LEARNINGS, ADDITIINAL ACTIVITIES, NOTES, CONCLUDING REMARK
--

Task 4: Warehouse Performance (10 Marks)
● Find the top 3 warehouses with the highest average processing time.
● Calculate total vs. delayed shipments for each warehouse.
● Use CTEs to find bottleneck warehouses where processing time > global
average.
● Rank warehouses based on on-time delivery percentage
*/

-- create database RS_C4_SQL_UPS;
use RS_C4_SQL_UPS;
show tables;
-- Imported table details --> deliveryagents, orders,  routes,  shipment_tracking, warehouses
-- orders.Warehouse_ID--> warehouses, orders.Route_ID -- > routes,  orders.Warehouse_ID-->shipment_tracking, 
-- deliveryagents.Route_ID --> routes

-- ● Find the top 3 warehouses with the highest average processing time.
select * from warehouses;
select Warehouse_ID, round(avg(Processing_Time_Min),3) AS Avg_Processing_Time_Min from warehouses group by Warehouse_ID order by Avg_Processing_Time_Min desc limit 3;

-- ● Calculate total vs. delayed shipments for each warehouse.
DROP TABLE IF EXISTS T4_1;
CREATE TABLE T4_1 AS
select Warehouse_ID,
(select  count(Warehouse_ID) Total_Shipments from orders o where o.Warehouse_ID=orders.Warehouse_ID) as Total_Shipments, 
(select  count(Warehouse_ID) Total_Shipments from orders o where o.Warehouse_ID=orders.Warehouse_ID and o.Delivery_Status='Delayed') as Delayed_Shipments 
from orders group by Warehouse_ID 
order by Warehouse_ID;
select * from T4_1;

-- ● Use CTEs to find bottleneck warehouses where processing time > global
DROP TABLE IF EXISTS T4_2;
CREATE TABLE T4_2 AS
WITH warehouse_avg AS ( select round(avg(Processing_Time_Min)) Average_Time from warehouses )
select a.Warehouse_ID,  a.Processing_Time_Min,Average_Time  
from warehouses A cross join warehouse_avg B 
where a.Processing_Time_Min> Average_Time;
select * from T4_2;

-- ● Rank warehouses based on on-time delivery percentage
select Warehouse_ID,Total_Shipments,On_Time_Shipments, (On_Time_Shipments/Total_Shipments)*100 as On_Time_Shipments_percentage  from (
select Warehouse_ID,(select  count(Warehouse_ID) Total_Shipments from orders o where o.Warehouse_ID=orders.Warehouse_ID) as Total_Shipments, (select  count(Warehouse_ID) Total_Shipments from orders o where o.Warehouse_ID=orders.Warehouse_ID and o.Delivery_Status='On Time') as On_Time_Shipments from orders group by Warehouse_ID order by Warehouse_ID)MAIN;

DROP TABLE IF EXISTS T4_3;
CREATE TABLE T4_3 AS
WITH warehouse_otd AS (
select Warehouse_ID,  count(Warehouse_ID) Total_Shipments, sum(CASE WHEN Delivery_Status='On Time' THEN 1 ELSE 0 END) On_Time_Shipments,
round(100.0 * SUM(CASE WHEN Delivery_Status='On Time' THEN 1 ELSE 0 END) / COUNT(*),2) AS On_Time_Percentage
from orders group by Warehouse_ID order by Warehouse_ID
)
select *,  RANK() OVER (ORDER BY On_Time_Percentage DESC) AS OTP_rank from warehouse_otd;
select * from T4_3;

