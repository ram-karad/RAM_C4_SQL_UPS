/*
LEARNINGS, ADDITIINAL ACTIVITIES, NOTES, CONCLUDING REMARK
--
Task 7: Advanced KPI Reporting (10 Marks)
Calculate KPIs using SQL queries:
Average Delivery Delay per Region (Start_Location).
On-Time Delivery % = (Total On-Time Deliveries / Total Deliveries) * 100.
Average Traffic Delay per Route.
*/
-- create database RS_C4_SQL_UPS;
use RS_C4_SQL_UPS;
show tables;
-- Imported table details : deliveryagents, orders,  routes,  shipment_tracking, warehouses
-- Relationships : orders.Warehouse_ID--> warehouses, orders.Route_ID -- > routes,  orders.Warehouse_ID-->shipment_tracking, 
-- 					deliveryagents.Route_ID --> routes


-- Average Delivery Delay per Region (Start_Location).
DROP TABLE IF EXISTS T7_1;
CREATE TABLE T7_1 AS
select Route_ID, 
(select Start_Location from routes R where r.Route_ID= orders.Route_ID)Region, 
round(avg(DATEDIFF(Actual_Delivery_Date, Expected_Delivery_Date)),2) Avg_Delayed_Delivery_Days 
from orders where Delivery_Status ='Delayed' group by Route_ID 
order by Avg_Delayed_Delivery_Days desc;
select * from T7_1;

-- On-Time Delivery % = (Total On-Time Deliveries / Total Deliveries) * 100.
DROP TABLE IF EXISTS T7_2;
CREATE TABLE T7_2 AS
select count(*) Total_Deliveries, 
sum(case when  delivery_Status='On Time' then 1 else 0 end) OnTime__Deliveries, 
round(100*(sum(case when  delivery_Status='On Time' then 1 else 0 end)/count(*)))  OnTime__Deliveries_Percent  
from orders ;
select * from T7_2;

-- Average Traffic Delay per Route.
DROP TABLE IF EXISTS T7_3;
CREATE TABLE T7_3 AS
select Route_ID, round(avg(Traffic_Delay_Min)) Avg_Traffic_Delay_Min 
from routes group by Route_ID 
order by Avg_Traffic_Delay_Min desc;
select * from T7_3;