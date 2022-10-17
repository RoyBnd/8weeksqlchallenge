--A.Pizza Metrics

--1.How many pizzas were ordered?
select count(co.pizza_id) Orders_Amount
from customer_orders co

--2.How many unique customer orders were made?
select count(distinct(co.customer_id)) Unique_Customer_Orders
from customer_orders co

--3.How many successful orders were delivered by each runner?
select runner_id,count(*) as Orders_Deliverd
from runner_orders ro
where ro.pickup_time is not null
group by ro.runner_id;

--4.How many of each type of pizza was delivered?
select pn.pizza_name,a.Deliverd 
from (
select co.pizza_id,count(*) as Deliverd
from customer_orders co
join runner_orders ro on ro.order_id = co.order_id
join pizza_names pn on pn.pizza_id = co.pizza_id
where ro.pickup_time is not null
group by co.pizza_id
) as a
join pizza_names pn on pn.pizza_id = a.pizza_id

--5.How many Vegetarian and Meatlovers were ordered by each customer?
select co.customer_id,
	   sum(case when co.pizza_id = 1 then 1 else 0 end) as Meatlovers,
	   sum(case when co.pizza_id = 2 then 1 else 0 end) as Vegetarian
from customer_orders co
join runner_orders ro on ro.order_id = co.order_id
where ro.pickup_time is not null
group by co.customer_id;

--6.What was the maximum number of pizzas delivered in a single order?
select top 1 (co.order_id),count(*) as Deliverd
from customer_orders co
join runner_orders ro on ro.order_id = co.order_id
where ro.pickup_time is not null
group by co.order_id
order by count(*) desc

--7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select co.customer_id, 
	   sum(case when (co.exclusions is not null or co.extras is not null) then 1 else 0 end ) as Changed,
	   sum(case when (co.exclusions is null and co.extras is null) then 1 else 0 end ) as NotChanged
from customer_orders co
join runner_orders ro on ro.order_id = co.order_id
where ro.pickup_time is not null
group by co.customer_id;

--8.How many pizzas were delivered that had both exclusions and extras?
select count(*) Exclusions_Extras_Orders
from customer_orders co
join runner_orders ro on ro.order_id = co.order_id
where ro.pickup_time is not null and co.exclusions is not null and co.extras is not null

--9.What was the total volume of pizzas ordered for each hour of the day?
select
    datename(HOUR, order_time) as Day_Hour,
    count(order_id) Orders_Amount
from customer_orders
group by datename(HOUR, order_time);

--10.What was the volume of orders for each day of the week?
select
    datename(DW, order_time) as Week_Day,
    count(order_id) Orders_Amount
from customer_orders
group by datename(DW, order_time);

