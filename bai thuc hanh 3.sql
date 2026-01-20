create extension if not exists pg_trgm;

explain analyze
select *
from post
where is_public = true and content ilike '%du lich%';

create index idx_post_content_lower_trgm
on post
using gin (lower(content) gin_trgm_ops);

explain analyze
select *
from post
where is_public = true and lower(content) like '%du lich%';

explain analyze
select *
from post
where tags @> array['travel'];

create index idx_post_tags_gin
on post
using gin (tags);

explain analyze
select *
from post
where tags @> array['travel'];

explain analyze
select *
from post
where is_public = true and created_at >= now() - interval '7 days';

create index idx_post_recent_public
on post (created_at desc)
where is_public = true;

explain analyze
select *
from post
where is_public = true and created_at >= now() - interval '7 days'
order by created_at desc;

create index idx_post_user_createdat_desc
on post (user_id, created_at desc);

explain analyze
select *
from post
where user_id in (2, 5, 9)
order by created_at desc
limit 50;
