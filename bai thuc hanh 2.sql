create view v_order_summary as
select c.full_name, o.total_amount, o.order_date
from customer c
join orders o on o.customer_id = c.customer_id;

select * from v_order_summary;

create view v_orders_updatable as
select order_id, customer_id, total_amount, order_date
from orders;

update v_orders_updatable
set total_amount = 999.99
where order_id = 1;

create or replace view v_orders_2024 as
select order_id, customer_id, total_amount, order_date
from orders
where order_date >= date '2024-01-01'
with check option;

create view v_monthly_sales as
select date_trunc('month', o.order_date)::date as month,
       sum(o.total_amount) as total_sales
from orders o
group by date_trunc('month', o.order_date)
order by month;

select * from v_monthly_sales;

drop view v_order_summary;
drop view v_orders_updatable;
drop view v_orders_2024;
drop view v_monthly_sales;
