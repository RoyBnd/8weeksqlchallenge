--B.Runner and Customer Experience

--1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

declare @first_day int
set @first_day = datepart(dw, '2021-01-01');

-- set first day of week to '2021-01-01'
set datefirst @first_day;

select
    concat(
	    'Week ',
		datepart(WEEK, registration_date)
		) as week_no
	, count(r.runner_id) runners
from runners r
group by datepart(wk, registration_date)

-- return first day of week to default
set datefirst 1;

--2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
with cte as (
select distinct ro.order_id,
       ro.runner_id,
	   DATEDIFF(MINUTE,co.order_time,ro.pickup_time) as diff
from runner_orders ro 
left join customer_orders co on co.order_id = ro.order_id
where ro.pickup_time is not null
)
select 
       cte.runner_id,
	   avg(diff) as Avg_Min_For_Pickup
from cte
group by cte.runner_id;

--3.What was the average distance travelled for each customer?
with calc as (
select customer_id,
       sum(ro.[distance (km)]) as Distance,
	   count(co.order_id) as Orders
from customer_orders co
join runner_orders ro on ro.order_id = co.order_id
where ro.pickup_time is not null
group by co.customer_id
)
select c.customer_id,
       round((c.Distance/c.Orders),2) As Avg_Distance
from calc c;

--4.What was the difference between the longest and shortest delivery times for all orders?
select (max(ro.[duration (min)]) - min(ro.[duration (min)])) as delivery_time_difference
from runner_orders ro;

--5.What was the average speed for each runner for each delivery and do you notice any trend for these values?
select ro.runner_id,
       ro.order_id,
      round(avg(ro.[distance (km)] /ro.[duration (min)]),2) as Avg_speed
from customer_orders co
join runner_orders ro on ro.order_id = co.order_id
where ro.pickup_time is not null
group by ro.runner_id,ro.order_id
order by ro.runner_id,ro.order_id;

--If you calculate the speed for each delivery per runner, 
--then you can see that it increases over time.

select ro.runner_id,
       ro.order_id,
      avg(ro.[duration (min)]) as Avg_Distance
from customer_orders co
join runner_orders ro on ro.order_id = co.order_id
where ro.pickup_time is not null
group by ro.runner_id,ro.order_id
order by ro.runner_id,ro.order_id;

--Delivery times are shortened due to increased speed.

--6.What is the successful delivery percentage for each runner?

with suc as (
select ro.runner_id,
       sum(case when ro.pickup_time is not null then 1 else 0 end) as good,
	   cast(count(*) as float) as total
from runner_orders ro
group by ro.runner_id
 )
select s.runner_id,
     (good / total) * 100 as successful_deliverys_perc
from suc s

