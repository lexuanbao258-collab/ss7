-- tạo bảng
create table books (
  book_id serial primary key,
  title text,
  description text,
  author text,
  genre text,
  price numeric
);

-- truy vấn trước khi tạo index (chậm)
explain analyze
select *
from books
where genre = 'science fiction';

-- tạo b-tree index cho genre
create index idx_books_genre
on books (genre);

-- truy vấn sau khi tạo index (nhanh hơn)
explain analyze
select *
from books
where genre = 'science fiction';

-- tạo gin index cho tìm kiếm toàn văn (title + description)
create index idx_books_title_desc
on books
using gin (
  to_tsvector('english', title || ' ' || description)
);

-- truy vấn full-text search
explain analyze
select *
from books
where to_tsvector('english', title || ' ' || description)
      @@ plainto_tsquery('english', 'database');

-- cluster bảng theo genre
cluster books using idx_books_genre;

-- kiểm tra lại hiệu năng sau khi cluster
explain analyze
select *
from books
where genre = 'science fiction';
