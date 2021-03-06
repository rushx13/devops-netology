# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

## Ответ:

```
Содержимое docker-compose.yaml:

version: "3"
services:
  db:
    image: postgres:12
    restart: always
    volumes:
       - /home/quattrox/sqlbackup:/sqlbackup
    environment:
      POSTGRES_PASSWORD: test

Запущенный контейнер:

root@Test:/home/quattrox# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED             STATUS         PORTS      NAMES
e80bfaf8da33   postgres:12   "docker-entrypoint.s…"   About an hour ago   Up 7 seconds   5432/tcp   task1_db_1

Зашел в контейнер, вижу подключенный sqlbackup:

root@Test:/home/quattrox# docker exec -it e80bfaf8da33 bash
root@e80bfaf8da33:/# ls
bin   dev			  etc	lib    media  opt   root  sbin	     srv  tmp  var
boot  docker-entrypoint-initdb.d  home	lib64  mnt    proc  run   sqlbackup  sys  usr

```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
 ```
 root@e80bfaf8da33:/# su postgres
 postgres@e80bfaf8da33:/$ psql
 postgres=# CREATE USER "test-admin-user" WITH PASSWORD 'admin';
 postgres=# CREATE database test_db;
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
 \c test_db
 test_db=# CREATE TABLE orders (id SERIAL PRIMARY KEY, наименование VARCHAR (255), цена INT);
 test_db=# CREATE TABLE clients (id SERIAL PRIMARY KEY, фамилия VARCHAR (255), "страна проживания" VARCHAR (255), заказ INT, FOREIGN KEY (заказ) REFERENCES orders (id));
 ```
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
 ```
 postgres=# GRANT ALL PRIVILEGES ON DATABASE test_db TO "test-admin-user"
 \c test_db
 test_db=# GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "test-admin-user";
 ```
- создайте пользователя test-simple-user
 ```
 postgres=# CREATE USER "test-simple-user" WITH PASSWORD 'user';
 ```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
 ```
 \c test_db
 test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON public.orders to "test-simple-user";
 test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON public.clients to "test-simple-user";
 ```

Приведите:
- итоговый список БД после выполнения пунктов выше,
```
test_db=# \list
                                     List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |       Access privileges        
-----------+----------+----------+------------+------------+--------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                   +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                  +
           |          |          |            |            | postgres=CTc/postgres         +
           |          |          |            |            | "test-admin-user"=CTc/postgres
```
- описание таблиц (describe)
```
test_db=# \d clients
                                         Table "public.clients"
      Column       |          Type          | Collation | Nullable |               Default               
-------------------+------------------------+-----------+----------+-------------------------------------
 id                | integer                |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying(255) |           |          | 
 страна проживания | character varying(255) |           |          | 
 заказ             | integer                |           |          | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

test_db=# \d orders
                                       Table "public.orders"
    Column    |          Type          | Collation | Nullable |              Default               
--------------+------------------------+-----------+----------+------------------------------------
 id           | integer                |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying(255) |           |          | 
 цена         | integer                |           |          | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
select * from information_schema.table_privileges where table_name='clients' or table_name = 'orders';
```
- список пользователей с правами над таблицами test_db
```
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | postgres         | test_db       | public       | orders     | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | orders     | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | orders     | TRIGGER        | YES          | NO
 postgres | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | postgres         | test_db       | public       | clients    | INSERT         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | SELECT         | YES          | YES
 postgres | postgres         | test_db       | public       | clients    | UPDATE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | DELETE         | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | REFERENCES     | YES          | NO
 postgres | postgres         | test_db       | public       | clients    | TRIGGER        | YES          | NO
 postgres | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
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
test_db=# INSERT INTO public.orders VALUES (1, 'Шоколад', 10);
INSERT 0 1
test_db=# INSERT INTO public.orders VALUES (2, 'Принтер', 3000);
INSERT 0 1
test_db=# INSERT INTO public.orders VALUES (3, 'Книга', 500);
INSERT 0 1
test_db=# INSERT INTO public.orders VALUES (4, 'Монитор', 7000);
INSERT 0 1
test_db=# INSERT INTO public.orders VALUES (5, 'Гитара', 4000);
INSERT 0 1

test_db=# select * from public.orders;
 id | наименование | цена 
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
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
test_db=# INSERT INTO public.clients (id, фамилия, "страна проживания") VALUES (1, 'Иванов Иван Иванович', 'USA'),(2, 'Петров Петр Петрович', 'Canada'),(3, 'Иоганн Себастьян Бах', 'Japan'),(4, 'Ронни Джеймс Дио', 'Russia'),(5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5

test_db=# select * from public.clients;
 id |       фамилия        | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |      
  2 | Петров Петр Петрович | Canada            |      
  3 | Иоганн Себастьян Бах | Japan             |      
  4 | Ронни Джеймс Дио     | Russia            |      
  5 | Ritchie Blackmore    | Russia            |      
(5 rows)

Исходя из данных изменим столбец фамилия на ФИО:

test_db=# ALTER table clients RENAME COLUMN фамилия TO ФИО;
ALTER TABLE
test_db=# select * from public.clients;
 id |         ФИО          | страна проживания | заказ 
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |      
  2 | Петров Петр Петрович | Canada            |      
  3 | Иоганн Себастьян Бах | Japan             |      
  4 | Ронни Джеймс Дио     | Russia            |      
  5 | Ritchie Blackmore    | Russia            |      
(5 rows)


```

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
```
test_db=# SELECT count (*) FROM orders;
 count 
-------
     5
(1 row)

test_db=# SELECT count (*) FROM clients;
 count 
-------
     5
(1 row)
```
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

Ответ:
```
test_db=# UPDATE clients SET "заказ" = 3 WHERE id = 1;
test_db=# UPDATE clients SET "заказ" = 4 WHERE id = 2;
test_db=# UPDATE clients SET "заказ" = 5 WHERE id = 3;

test_db=# select * from public.clients;

 id |         ФИО          | страна проживания | заказ 
----+----------------------+-------------------+-------
  4 | Ронни Джеймс Дио     | Russia            |      
  5 | Ritchie Blackmore    | Russia            |      
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(5 rows)

```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

Ответ:

```
test_db=# EXPLAIN SELECT * FROM public.clients;
                         QUERY PLAN                         
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..10.70 rows=70 width=1040)
(1 row)

- Seq Scan — последовательное, блок за блоком, чтение данных таблицы clients
- Cost это понятие, призванное оценить затратность операции. 
  Первое значение 0.00 — затраты на получение первой строки. 
  Второе — 10.70 — затраты на получение всех строк.
- rows — приблизительное количество возвращаемых строк при выполнении операции Seq Scan. 
  Это значение возвращает планировщик.
- width — средний размер одной строки в байтах.
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Ответ:

```
root@e80bfaf8da33:/# pg_dump -U postgres test_db > sqlbackup/test_db.sql
root@e80bfaf8da33:/# ls sqlbackup/
test_db.sql
```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

```
root@Test:/home/quattrox# docker run -d --name postgresnew -e POSTGRES_PASSWORD=postgres -v /home/quattrox/sqlbackup:/sqlbackup postgres:12
root@Test:/home/quattrox# docker exec -it postgresnew bash
```

Восстановите БД test_db в новом контейнере.
Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```
root@67d64d2ee52a:/# su postgres
postgres=# CREATE DATABASE test_db WITH ENCODING='UTF-8';
exit
root@67d64d2ee52a:/# psql -U postgres -W test_db < /sqlbackup/test_db.sql

Таблицы с данными восстановились.

Важный комментарий - мы получаем сообщение о том, что роли test-simple-user и test-admin-user отсутствуют.
Их можно создать так же как и в задачах выше.
```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
