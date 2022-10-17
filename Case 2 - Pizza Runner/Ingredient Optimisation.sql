--C. Ingredient Optimisation

--1.What are the standard ingredients for each pizza?
with cte as (
select pizza_id, cs.Value --SplitData
from pizza_recipes
cross apply STRING_SPLIT (toppings, ',') cs
),
combaine as (
select cte.pizza_id,cte.value,pt.topping_id,pt.topping_name,pn.pizza_name   
from cte
join pizza_toppings pt on pt.topping_id = cte.value
join pizza_names pn on pn.pizza_id = cte.pizza_id
)
select
    pizza_name,
    stuff((
        select ', ' + c.topping_name
        from combaine c
        where c.pizza_id = c1.pizza_id
        order by c.topping_name
        for xml path('')
    ),1,1,'') as ingredients
from combaine c1
group by c1.pizza_name,pizza_id
;

--2.What was the most commonly added extra?
select pt.topping_name,
       count(*) as extras_orderd 
from (
		select order_id,
			   customer_id,cs.Value 
		from customer_orders co
		cross apply STRING_SPLIT (co.extras, ',') cs
	) as sep
join pizza_toppings pt on pt.topping_id = sep.value
group by sep.value,pt.topping_name

--3.What was the most common exclusion?
select pt.topping_name,
       count(*) as exclusions 
from (
select order_id,
       customer_id,
	   cs.Value
from customer_orders co
cross apply STRING_SPLIT (co.exclusions, ',') cs
) as sep
join pizza_toppings pt on pt.topping_id = sep.value
group by sep.value,pt.topping_name

--4.
select report.pizza + ' ' + report.Exclud + ' ' + report.Extra as Report
from (
select case 
       when a.pizza_name = 'Meatlovers' then 'Meat Lovers'
	   else a.pizza_name
end as pizza,
       case 
	   when a.exclusions = '4' then '- Exclude Cheese'
	   when a.exclusions = '1' then '- Exclude Bacon'
	   when a.exclusions = '1, 5' then '- Exclude Bacon, Chicken'
	   when a.exclusions = '2, 6' then '- Exclude BBQ Sauce, Mushrooms'
	   else a.exclusions
end as Exclud,
	   case 
	   when a.Extras = '4' then '- Extra Cheese'
	   when a.Extras = '1' then '- Extra Bacon'
	   when a.Extras = '2, 6' then '- Extra BBQ Sauce, Mushrooms'
	   when a.Extras = '1, 4' then '- Extra Bacon, Cheese'
	   when a.Extras = '1, 5' then '- Extra Bacon, Chicken'
	   else a.Extras
end as Extra
from (
select pn.pizza_name,
       co.order_id,
	   co.customer_id,
       case when co.exclusions is null then '' else exclusions end as Exclusions,
	   case when co.extras is null then '' else extras end as Extras   
from customer_orders co
join pizza_names pn on pn.pizza_id = co.pizza_id
)a
)report 


