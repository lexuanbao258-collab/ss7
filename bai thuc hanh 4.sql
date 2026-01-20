create view v_revenue_by_region as
select c.region, sum(o.total_amount) as total_revenue
from customer c
join orders o on c.customer_id = o.customer_id
group by c.region;

select region, total_revenue
from v_revenue_by_region
order by total_revenue desc
limit 3;

create view v_orders_updatable as
select order_id, customer_id, total_amount, order_date, status
from orders
where status in ('pending','paid','shipped')
with check option;

update v_orders_updatable
set status = 'shipped'
where order_id = 1;

update v_orders_updatable
set status = 'cancelled'
where order_id = 1;

create view v_revenue_above_avg as
select region, total_revenue
from v_revenue_by_region
where total_revenue > (select avg(total_revenue) from v_revenue_by_region);
