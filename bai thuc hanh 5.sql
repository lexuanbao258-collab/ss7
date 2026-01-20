insert into customers (full_name, email, city) values
('nguyen van a','a@gmail.com','ha noi'),
('tran thi b','b@gmail.com','ho chi minh'),
('le van c','c@gmail.com','da nang'),
('pham thi d','d@gmail.com','ha noi'),
('vo van e','e@gmail.com','can tho');

insert into products (product_name, category, price) values
('iphone 14', array['electronics','phone'], 999.99),
('samsung tv', array['electronics','tv'], 799.99),
('logitech mouse', array['electronics','accessory'], 25.50),
('office chair', array['furniture','office'], 150.00),
('gaming laptop', array['electronics','computer'], 1200.00);

insert into orders (customer_id, product_id, order_date, quantity) values
(1,1,'2024-08-01',1),
(1,3,'2024-08-02',2),
(2,2,'2024-08-03',1),
(2,4,'2024-08-03',1),
(3,5,'2024-08-04',1),
(3,3,'2024-08-04',1),
(4,1,'2024-08-05',1),
(4,2,'2024-08-05',1),
(5,4,'2024-08-06',2),
(5,3,'2024-08-06',1);

explain analyze
select *
from customers
where email = 'a@gmail.com';

create index idx_customers_email
on customers (email);

explain analyze
select *
from customers
where email = 'a@gmail.com';

create index idx_customers_city_hash
on customers using hash (city);

create index idx_products_category_gin
on products using gin (category);

create extension if not exists btree_gist;

create index idx_products_price_gist
on products using gist (price);

explain analyze
select *
from products
where category @> array['electronics'];

explain analyze
select *
from products
where price between 500 and 1000;

create index idx_orders_order_date
on orders (order_date);

cluster orders using idx_orders_order_date;

create view v_top_customers as
select c.customer_id, c.full_name, sum(o.quantity) as total_quantity
from customers c
join orders o on o.customer_id = c.customer_id
group by c.customer_id, c.full_name
order by total_quantity desc;

select *
from v_top_customers
limit 3;

create view v_revenue_by_product as
select p.product_id, p.product_name, sum(o.quantity * p.price) as total_revenue
from products p
join orders o on o.product_id = p.product_id
group by p.product_id, p.product_name
order by total_revenue desc;

select * from v_revenue_by_product;

create view v_customer_city as
select customer_id, full_name, city
from customers
with check option;

update v_customer_city
set city = 'hai phong'
where customer_id = 1;

select * from customers where customer_id = 1;
