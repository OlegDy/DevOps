# Домашнее задание 26 [6.4. PostgreSQL](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql)

## Олег Дьяченко DEVOPS-22

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
```
root@server1:/db2#docker run -d -v /db1:/var/lib/postgresql/data -v /db2:/tmp/backup -e POSTGRES_PASSWORD=passwd --name postgres13 postgres:13
    Unable to find image 'postgres:13' locally
    13: Pulling from library/postgres
    Digest: sha256:3c6a77caf1ef2ae91ef1a2cdc2ae219e65e9ea274fbfa0d44af3ec0fccef0d8d
    Status: Downloaded newer image for postgres:13
    49dba36a245b0f6ed983f2313ea703f3271335e75c2d6e550f0415bc629bbf98
root@server1:/db2# docker ps -a
    CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS      NAMES
    49dba36a245b   postgres:13   "docker-entrypoint.s…"   13 seconds ago   Up 11 seconds   5432/tcp   postgres13
```

Подключитесь к БД PostgreSQL используя `psql`.
Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.
```
root@server1:/db2# docker exec -it postgres13 psql -U postgres
    psql (13.9 (Debian 13.9-1.pgdg110+1))
    Type "help" for help.
    
    postgres=# \?
    General
      \copyright             show PostgreSQL usage and distribution terms
      \crosstabview [COLUMNS] execute query and display results in crosstab
      \errverbose            show most recent error message at maximum verbosity
      \g [(OPTIONS)] [FILE]  execute query (and send results to file or |pipe);
                             \g with no arguments is equivalent to a semicolon
    ...                         
```
**Найдите и приведите** управляющие команды для:
- вывода списка БД ```\l[+]   [PATTERN]      list databases```
```
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```
- подключения к БД
```
- Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
 ```
- вывода списка таблиц  ```\dt[S+] [PATTERN]      list tables ```
- вывода описания содержимого таблиц  ```\d[S+]  NAME           describe table, view, sequence, or index```
- выхода из psql ```\q                     quit psql```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Добавил в дамп `test_dump26.sql` строки
 ```
CREATE DATABASE test_database WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
ALTER DATABASE test_database OWNER TO postgres;
\connect test_database
 ```
и восстановил
 ```
root@server1:/db2# docker exec -it postgres13 psql -U postgres -f /tmp/backup/test_dump26.sql
CREATE DATABASE
ALTER DATABASE
You are now connected to database "test_database" as user "postgres".
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
 ```

Перейдите в управляющую консоль `psql` внутри контейнера.
```
docker exec -it postgres13 psql -U postgres
    psql (13.9 (Debian 13.9-1.pgdg110+1))
    Type "help" for help.
```
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.
```
test_database=# SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders';
 attname | avg_width
---------+-----------
 id      |         4
 title   |        16
 price   |         4
(3 rows)

test_database=# SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders' ORDER BY avg_width DESC LIMIT 1;
 attname | avg_width
---------+-----------
 title   |        16
(1 row)rards

Столбец 'title'
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```
test_database=# begin;
BEGIN
test_database=# alter table orders rename to orders_old;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_less499 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_more499 partition of orders for values from (499) to (2147483647);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_old;
INSERT 0 8
test_database=# commit;
COMMIT
test_database=#
test_database=#
test_database=# \dt
                   List of relations
 Schema |      Name      |       Type        |  Owner
--------+----------------+-------------------+----------
 public | orders         | partitioned table | postgres
 public | orders_less499 | table             | postgres
 public | orders_more499 | table             | postgres
 public | orders_old     | table             | postgres
(4 rows)

test_database=# ANALYZE verbose orders;
INFO:  analyzing "public.orders" inheritance tree
INFO:  "orders_less499": scanned 1 of 1 pages, containing 4 live rows and 0 dead rows; 4 rows in sample, 4 estimated total rows
INFO:  "orders_more499": scanned 1 of 1 pages, containing 4 live rows and 0 dead rows; 4 rows in sample, 4 estimated total rows
INFO:  analyzing "public.orders_less499"
INFO:  "orders_less499": scanned 1 of 1 pages, containing 4 live rows and 0 dead rows; 4 rows in sample, 4 estimated total rows
INFO:  analyzing "public.orders_more499"
INFO:  "orders_more499": scanned 1 of 1 pages, containing 4 live rows and 0 dead rows; 4 rows in sample, 4 estimated total rows
ANALYZE
```
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Я думаю что можно было бы сделать сразу, но был бы эффект, вручную то мы поровну разделили. 
"Знал бы, где упасть, соломки бы подостлал".

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```
root@server1:/db2# docker exec -t postgres13 pg_dump -U postgres test_database -f /tmp/backup/test_dump_26.sql
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Добавить директиву UNIQUE или PRIMARY KEY в строки: title character varying(80)
