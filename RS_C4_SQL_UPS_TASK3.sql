/*
LEARNINGS, ADDITIINAL ACTIVITIES, NOTES, CONCLUDING REMARK
-- It would have been better if Time operation are done in miuts rather  than Days
-- No routes with >20% delayed shipments

Task 3: Route Optimization Insights (10 Marks)
● For each route, calculate:
○ Average delivery time (in days).
○ Average traffic delay.
○ Distance-to-time efficiency ratio: Distance_KM / Average_Travel_Time_Min.

● Identify 3 routes with the worst efficiency ratio.
● Find routes with >20% delayed shipments.
● Recommend potential routes for optimization
*/

-- create database RS_C4_SQL_UPS;
use RS_C4_SQL_UPS;
show tables;
-- Imported table details --> tables deliveryagents, orders,  routes,  shipment_tracking, warehouses
/*
● For each route, calculate:
○ Average delivery time (in days).
○ Average traffic delay.
○ Distance-to-time efficiency ratio: Distance_KM / Average_Travel_Time_Min.
*/
DROP TABLE IF EXISTS T3_1;
CREATE TABLE T3_1 AS
select Route_ID, round(avg(Average_Travel_Time_Min / 1440),3) AS Avg_Delivery_Days,
round(avg(Traffic_Delay_Min / 1440),3) AS Avg_Delay_Days,
(select round((Distance_KM / Average_Travel_Time_Min),2) AS efficiency  from routes r where r.Route_ID=routes.Route_ID) AS efficiency
from routes group by Route_ID
order by Route_ID;
select * from T3_1;

-- ● Identify 3 routes with the worst efficiency ratio 
DROP TABLE IF EXISTS T3_2;
CREATE TABLE T3_2 AS
select Route_ID, round(avg(Average_Travel_Time_Min / 1440),3) AS Avg_Delivery_Days 
from routes group by Route_ID  
order by Avg_Delivery_Days desc limit 3;
select * from T3_2;

-- ● Find routes with >20% delayed shipments.
DROP TABLE IF EXISTS T3_3;
CREATE TABLE T3_3 AS
select Route_ID,ROUND(SUM(Traffic_Delay_Min) * 100.0 / (SELECT SUM(r.Traffic_Delay_Min) FROM routes r),2) AS percentage_delayed_shipments 
from routes group by Route_ID 
order by percentage_delayed_shipments desc; 
-- where percentage_delayed_shipments>20
select * from T3_3;

-- ● Recommend potential routes for optimization
-- Based on efficiency ratio  R018,R007,R008
-- Based on  delayed shipments  R014, R007, R009