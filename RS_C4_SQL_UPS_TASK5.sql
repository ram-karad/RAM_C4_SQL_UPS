/*
LEARNINGS, ADDITIINAL ACTIVITIES, NOTES, CONCLUDING REMARK
--
Task 5: Delivery Agent Performance (10 Marks)
● Rank agents (per route) by on-time delivery percentage
● Find agents with on-time % < 80%.
● Compare average speed of top 5 vs bottom 5 agents using subqueries.

*/
-- create database RS_C4_SQL_UPS;
use RS_C4_SQL_UPS;
show tables;
-- Imported table details : deliveryagents, orders,  routes,  shipment_tracking, warehouses
-- Relationships : orders.Warehouse_ID--> warehouses, orders.Route_ID -- > routes,  orders.Warehouse_ID-->shipment_tracking, 
-- 					deliveryagents.Route_ID --> routes


-- ● Rank agents (per route) by on-time delivery percentage
DROP TABLE IF EXISTS T5_1;
CREATE TABLE T5_1 AS
select Route_ID , Agent_ID,On_Time_Percentage, 
rank() over ( partition by Route_ID order by On_Time_Percentage desc) rnk  
from deliveryagents ;
select * from T5_1;

-- ● Find agents with on-time % < 80%.
DROP TABLE IF EXISTS T5_2;
CREATE TABLE T5_2 AS
select  Agent_ID,On_Time_Percentage from deliveryagents 
where On_Time_Percentage <80 order by Agent_ID ;
select * from T5_2;
-- ● Compare average speed of top 5 vs bottom 5 agents using subqueries.
select * from deliveryagents;
select  'Top 5 Speed of Agents' AS group_name, round(AVG(avg_spd)) AS group_Avg_Speed_KM_HR from
(select Agent_ID, avg(Avg_Speed_KM_HR) avg_spd  from deliveryagents group by Agent_ID order by avg_spd desc limit 5) A
UNION
select  'Bottom 5 Speed of Agents' AS group_name, round(AVG(avg_spd)) AS group_Avg_Speed_KM_HR from
(select Agent_ID, avg(Avg_Speed_KM_HR) avg_spd  from deliveryagents group by Agent_ID order by avg_spd asc limit 5) B;

DROP TABLE IF EXISTS T5_3;
CREATE TABLE T5_3 AS
select 
(select  round(AVG(avg_spd)) AS 'Top 5 Speed of Agents1' from
(select Agent_ID, avg(Avg_Speed_KM_HR) avg_spd  from deliveryagents group by Agent_ID order by avg_spd desc limit 5)A) AVERAGE_SPEED_TOP_5,

(select  round(AVG(avg_spd)) AS 'Top 5 Speed of Agents1' from
(select Agent_ID, avg(Avg_Speed_KM_HR) avg_spd  from deliveryagents group by Agent_ID order by avg_spd asc limit 5)B) AVERAGE_SPEED_BOTTOM_5
from dual;
select * from T5_3;