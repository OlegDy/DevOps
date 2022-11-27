# Домашнее задание 24 ["6.2. SQL"](https://github.com/netology-code/virt-homeworks/tree/master/06-db-02-sql)

## Олег Дьяченко DEVOPS-22

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

```
vagrant@server1:~$ sudo docker pull postgres:12
    12: Pulling from library/postgres

vagrant@server1:~$ sudo docker images
    REPOSITORY         TAG       IMAGE ID       CREATED       SIZE
    postgres           12        dcb2210db7e5   8 days ago    373MB

droot@server1:/# docker run -d -v /db1:/var/lib/postgresql/data -v /db2:/tmp/backup -e POSTGRES_PASSWORD=passwd --name postgres12 postgres:12
    2bd25488ca35586d6753a28a68a8b9a30096e4cd06505140c0107c924db88c1c
    
root@server1:/# docker ps -a
    CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS      NAMES
    2bd25488ca35   postgres:12   "docker-entrypoint.s…"   3 seconds ago   Up 2 seconds   5432/tcp   postgres12
    
docker exec -it postgres12 /bin/bash   
    
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
```
CREATE DATABASE test_db;
CREATE USER "test-admin-user";
```
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)
```
CREATE TABLE orders (id SERIAL PRIMARY KEY, name VARCHAR, price INT);
CREATE TABLE clients (id SERIAL PRIMARY KEY, lastname VARCHAR, country VARCHAR, order_id INT, FOREIGN KEY (order_id) REFERENCES orders (id));
CREATE INDEX country_index ON clients(country);
```
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
```
GRANT ALL ON orders, clients TO "test-admin-user";
```
- создайте пользователя test-simple-user 
```
CREATE USER "test-simple-user";
```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
```
GRANT SELECT,INSERT,UPDATE,DELETE ON orders, clients to "test-simple-user";
```

Приведите:
- итоговый список БД после выполнения пунктов выше,
``` 
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```
- описание таблиц (describe)
```
test_db=# \d+
                            List of relations
 Schema |      Name      |   Type   |  Owner   |    Size    | Description
--------+----------------+----------+----------+------------+-------------
 public | clients        | table    | postgres | 8192 bytes |
 public | clients_id_seq | sequence | postgres | 8192 bytes |
 public | orders         | table    | postgres | 8192 bytes |
 public | orders_id_seq  | sequence | postgres | 8192 bytes |
(4 rows)

test_db=# \d+ orders
                                                     Table "public.orders"
 Column |       Type        | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+-------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer           |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 name   | character varying |           |          |                                    | extended |              |
 price  | integer           |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
Access method: heap

test_db=# \d+ clients
                                                      Table "public.clients"
  Column  |       Type        | Collation | Nullable |               Default               | Storage  | Stats target | Description
----------+-------------------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id       | integer           |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 lastname | character varying |           |          |                                     | extended |              |
 country  | character varying |           |          |                                     | extended |              |
 order_id | integer           |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_index" btree (country)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
Access method: heap
```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
SELECT grantee, table_catalog, table_name, privilege_type FROM information_schema.table_privileges WHERE table_name='clients' OR table_name='orders';
```
- список пользователей с правами над таблицами test_db
```
     grantee      | table_catalog | table_name | privilege_type
------------------+---------------+------------+----------------
 postgres         | test_db       | orders     | INSERT
 postgres         | test_db       | orders     | SELECT
 postgres         | test_db       | orders     | UPDATE
 postgres         | test_db       | orders     | DELETE
 postgres         | test_db       | orders     | TRUNCATE
 postgres         | test_db       | orders     | REFERENCES
 postgres         | test_db       | orders     | TRIGGER
 test-admin-user  | test_db       | orders     | INSERT
 test-admin-user  | test_db       | orders     | SELECT
 test-admin-user  | test_db       | orders     | UPDATE
 test-admin-user  | test_db       | orders     | DELETE
 test-admin-user  | test_db       | orders     | TRUNCATE
 test-admin-user  | test_db       | orders     | REFERENCES
 test-admin-user  | test_db       | orders     | TRIGGER
 test-simple-user | test_db       | orders     | INSERT
 test-simple-user | test_db       | orders     | SELECT
 test-simple-user | test_db       | orders     | UPDATE
 test-simple-user | test_db       | orders     | DELETE
 postgres         | test_db       | clients    | INSERT
 postgres         | test_db       | clients    | SELECT
 postgres         | test_db       | clients    | UPDATE
 postgres         | test_db       | clients    | DELETE
 postgres         | test_db       | clients    | TRUNCATE
 postgres         | test_db       | clients    | REFERENCES
 postgres         | test_db       | clients    | TRIGGER
 test-admin-user  | test_db       | clients    | INSERT
 test-admin-user  | test_db       | clients    | SELECT
 test-admin-user  | test_db       | clients    | UPDATE
 test-admin-user  | test_db       | clients    | DELETE
 test-admin-user  | test_db       | clients    | TRUNCATE
 test-admin-user  | test_db       | clients    | REFERENCES
 test-admin-user  | test_db       | clients    | TRIGGER
 test-simple-user | test_db       | clients    | INSERT
 test-simple-user | test_db       | clients    | SELECT
 test-simple-user | test_db       | clients    | UPDATE
 test-simple-user | test_db       | clients    | DELETE
(36 rows)
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|
```
INSERT INTO orders (name,price) VALUES
('Шоколад',10),
('Принтер',3000),
('Книга',500),
('Монитор',7000),
('Гитара',4000);
INSERT 0 5
```
Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

```
INSERT INTO clients (lastname,country) VALUES
('Иванов Иван Иванович','USA'),
('Петров Петр Петрович','Canada'),
('Иоганн Себастьян Бах','Japan'),
('Ронни Джеймс Дио','Russia'),
('Ritchie Blackmore','Russia');
```
Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
```
test_db=# SELECT * FROM orders;
 id |  name   | price
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)

test_db=# SELECT COUNT(*) FROM orders;
 count
-------
     5
(1 row)
```
```
test_db=# SELECT * FROM clients;
 id |       lastname       | country | order_id
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |
  2 | Петров Петр Петрович | Canada  |
  3 | Иоганн Себастьян Бах | Japan   |
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
(5 rows)

test_db=# SELECT COUNT(*) FROM clients;
 count
-------
     5
(1 row)
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.
```
UPDATE clients SET order_id = (SELECT id FROM orders WHERE name = 'Книга') WHERE lastname = 'Иванов Иван Иванович';

UPDATE clients SET order_id = (SELECT id FROM orders WHERE name = 'Монитор') WHERE lastname = 'Петров Петр Петрович';

UPDATE clients SET order_id = (SELECT id FROM orders WHERE name = 'Гитара') WHERE lastname = 'Иоганн Себастьян Бах';
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
```
test_db=# SELECT * FROM clients WHERE order_id IS NOT NULL;
 id |       lastname       | country | order_id
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
(3 rows)
test_db=# select * from orders;
 id |  name   | price
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```
test_db=# EXPLAIN SELECT * FROM clients WHERE order_id IS NOT NULL;
                        QUERY PLAN
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: (order_id IS NOT NULL)
(2 rows)
```
EXPLAIN отображает план запроса и предполагаемую стоимость запроса, но не выполняет сам запрос;

EXPLAIN ANALYZE выполняет запрос в дополнение к отображению плана запроса, отбрасывая любой вывод оператора SELECT, но выполняя другие операции, например, INSERT, UPDATE или DELETE.
- cost — стоимость при последовательном чтении страниц с диска, включая стоимость получения первой строки и общую стоимость получения всех строк;
- rows — количество строк, выводимых узлом плана, что может быть меньше фактического количества строк, 
обработанных или отсканированных узлом из-за избирательности условий WHERE. 
При этом общая стоимость предполагает, что будут извлечены все строки.
- width — общая ширина в байтах всех столбцов, выводимых узлом плана.

```
test_db=# ANALYZE clients;
ANALYZE
test_db=# EXPLAIN SELECT * FROM clients WHERE order_id IS NOT NULL;
                       QUERY PLAN
--------------------------------------------------------
 Seq Scan on clients  (cost=0.00..1.05 rows=3 width=47)
   Filter: (order_id IS NOT NULL)
(2 rows)

test_db=# EXPLAIN (ANALYZE) SELECT * FROM clients WHERE order_id IS NOT NULL;
                                            QUERY PLAN
--------------------------------------------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..1.05 rows=3 width=47) (actual time=0.009..0.010 rows=3 loops=1)
   Filter: (order_id IS NOT NULL)
   Rows Removed by Filter: 2
 Planning Time: 0.035 ms
 Execution Time: 0.020 ms
(5 rows)
```
- actual time — реальное время в миллисекундах, затраченное для получения первой строки и всех строк соответственно.
- rows — реальное количество строк, полученных при Seq Scan.
- loops — сколько раз пришлось выполнить операцию Seq Scan.
- Execution Time — общее время выполнения запроса.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

```
Делаю бэкап всей базы данных
pg_dumpall -U postgres > /tmp/backup/backup_all
```
Остановите контейнер с PostgreSQL (но не удаляйте volumes).
```
root@server1:/# docker ps -a
  CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS       PORTS      NAMES
  2bd25488ca35   postgres:12   "docker-entrypoint.s…"   4 hours ago   Up 4 hours   5432/tcp   postgres12
root@server1:/# docker stop  2bd25488ca35
  2bd25488ca35
root@server1:/# docker rm 2bd25488ca35
  2bd25488ca35
root@server1:/# docker ps -a
  CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
Поднимите новый пустой контейнер с PostgreSQL.
```
root@server1:/# docker exec -it postgres12 /bin/bash
root@b39c6685bc11:/#
root@b39c6685bc11:/#
root@b39c6685bc11:/# psql -U postgres
psql (12.13 (Debian 12.13-1.pgdg110+1))
Type "help" for help.

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
Восстановите БД test_db в новом контейнере.
```
docker exec -it postgres12 /bin/bash
psql -U postgres -f /tmp/backup/backup_all
```
либо 
```
docker exec -it postgres12 psql -U postgres -f /tmp/backup/backup_all
```
Восстановленная база.
```
postgres=# \l
   postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
   template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
             |          |          |            |            | postgres=CTc/postgres
   template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
             |          |          |            |            | postgres=CTc/postgres
   test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
postgres-# \c test_db
  You are now connected to database "test_db" as user "postgres".
test_db-# \dt
   public | clients | table | postgres
   public | orders  | table | postgres

test_db=# SELECT * FROM orders;
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000

test_db=# SELECT * FROM clients;
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
  1 | Иванов Иван Иванович | USA     |        3
  2 | Петров Петр Петрович | Canada  |        4
  3 | Иоганн Себастьян Бах | Japan   |        5
```