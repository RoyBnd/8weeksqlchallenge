--Data cleaning

/* 
customer_orders table
*/

update customer_orders 
set exclusions = case
                     when exclusions = 'null' then NULL
					 when exclusions = '' then NULL
					 else exclusions
					 end;
update customer_orders 
set extras = case
                     when extras = 'null' then NULL
					 when extras = '' then NULL
					 else extras
					 end;


/*
runner_orders table
*/

update runner_orders 
set cancellation = case
                     when cancellation = 'null' then NULL
					 when cancellation = '' then NULL
					 else cancellation
					 end;

update runner_orders 
set pickup_time = case
                     when pickup_time = 'null' then NULL
					 when pickup_time = '' then NULL
					 else pickup_time
					 end;

update runner_orders 
set [distance (km)] = case
                     when [distance (km)] = 'null' then NULL
					 when [distance (km)] = '' then NULL
					 else [distance (km)]
					 end;

update runner_orders 
set [duration (min)] = case
                     when [duration (min)] = 'null' then NULL
					 when [duration (min)] = '' then NULL
					 else [duration (min)]
					 end;

UPDATE runner_orders 
SET [distance (km)]=REPLACE([distance (km)],'km','');
				
UPDATE runner_orders 
SET [duration (min)] =REPLACE([duration (min)] ,'minutes','');

UPDATE runner_orders 
SET [duration (min)] =REPLACE([duration (min)] ,'minute','');

UPDATE runner_orders 
SET [duration (min)] =REPLACE([duration (min)] ,'mins','');

UPDATE runner_orders 
SET [duration (min)] =REPLACE([duration (min)] ,'s','');