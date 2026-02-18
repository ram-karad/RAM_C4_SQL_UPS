/*
LEARNINGS, ADDITIINAL ACTIVITIES, NOTES, CONCLUDING REMARK
--
Task 6: Shipment Tracking Analytics (15 Marks)
● For each order, list the last checkpoint and time.
● Find the most common delay reasons (excluding None).
● Identify orders with >2 delayed checkpoints
*/
-- create database RS_C4_SQL_UPS;
use RS_C4_SQL_UPS;
show tables;
-- Imported table details : deliveryagents, orders,  routes,  shipment_tracking, warehouses
-- Relationships : orders.Warehouse_ID--> warehouses, orders.Route_ID -- > routes,  orders.Warehouse_ID-->shipment_tracking, 
-- 					deliveryagents.Route_ID --> routes


-- ● For each order, list the last checkpoint and time.
-- SELECT * FROM shipment_tracking WHERE Order_ID='O0002';
DROP TABLE IF EXISTS T6_1;
CREATE TABLE T6_1 AS
SELECT S.Order_ID,LAST_Shipment_ID, Checkpoint, Checkpoint_Time 
FROM(
SELECT Order_ID, MAX(Shipment_ID) LAST_Shipment_ID FROM shipment_tracking GROUP BY Order_ID ORDER BY Order_ID
)MAIN LEFT JOIN shipment_tracking S ON MAIN.LAST_Shipment_ID=S.Shipment_ID;
select * from T6_1;

-- ● Find the most common delay reasons (excluding None).
DROP TABLE IF EXISTS T6_2;
CREATE TABLE T6_2 AS
SELECT Delay_Reason, count(*) CNT FROM shipment_tracking  WHERE Delay_Reason <>'None' group by Delay_Reason  ORDER BY CNT DESC;
select * from T6_2;

-- ● Identify orders with >2 delayed checkpoints
DROP TABLE IF EXISTS T6_3;
CREATE TABLE T6_3 AS
SELECT Order_ID, COUNT(Checkpoint) Delayed_Checkpoints 
FROM shipment_tracking 
WHERE Delay_Reason LIKE '%Delay%' 
GROUP BY Order_ID 
HAVING Delayed_Checkpoints >2 
ORDER BY Order_ID;
select * from T6_3;