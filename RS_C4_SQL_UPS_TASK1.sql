/*
LEARNINGS, ADDITIINAL ACTIVITIES, NOTES, CONCLUDING REMARK
-- MySQL DATE datatype ALWAYS stores data as YYYY-MM-DD internally, You CANNOT permanently store a DATE as DD-MM-YYYY.
-- `shipment tracking table` Table renamed to shipment_tracking
*/

-- Task 1: Data Cleaning & Preparation (10 Marks)
-- ● Identify and delete duplicate Order_ID records.
-- ● Replace null Traffic_Delay_Min with the average delay for that route.
-- ● Convert all date columns into YYYY-MM-DD format using SQL functions.
-- ● Ensure that no Actual_Delivery_Date is before Order_Date (flag such records).


create database RS_C4_SQL_UPS;
use RS_C4_SQL_UPS;
show tables;


-- Imported table details --> tables deliveryagents,routes,  shipment_tracking, warehouses,  orders,
  select * from orders;
  
 select * from orders;
-- SELECT Actual_Delivery_Date FROM orders WHERE STR_TO_DATE(Actual_Delivery_Date, '%Y-%m-%d') IS NULL  AND Actual_Delivery_Date IS NOT NULL;
ALTER TABLE orders MODIFY COLUMN Actual_Delivery_Date date;
ALTER TABLE orders MODIFY COLUMN Expected_Delivery_Date date;
ALTER TABLE orders MODIFY COLUMN Delivery_Status date;

-- ● Identify and delete duplicate Order_ID records.
 -- > ZERO RECORDS
 select Order_ID, count(*) from orders group by Order_ID HAVING COUNT(*) > 1;
 
 -- ● Ensured that no Actual_Delivery_Date is before Order_Date (flag such records).
 -- > ZERO RECORDS
 select * from orders WHERE  Actual_Delivery_Date < Order_Date;
 
select * from routes;
-- ● Replaced null Traffic_Delay_Min with the average delay for that route.
 -- > ZERO RECORDS
select Traffic_Delay_Min from routes WHERE Traffic_Delay_Min IS NULL;

 select * from `shipment tracking table`;
RENAME TABLE `shipment tracking table` TO shipment_tracking;
select * from shipment_tracking;
ALTER TABLE shipment_tracking MODIFY COLUMN Checkpoint_Time date;

select * from warehouses;
ALTER TABLE warehouses MODIFY COLUMN Dispatch_Time time;


-- ----------------------------------------------------------------------
/*
-- new user for PW BI connection
CREATE USER 'bi_user'@'%' IDENTIFIED BY 'Helgaon@123456';
GRANT SELECT ON RS_C4_SQL_UPS.* TO 'bi_user'@'%';
FLUSH PRIVILEGES;
*/
