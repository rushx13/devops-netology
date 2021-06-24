# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

```
root@Test:/home/quattrox# docker run -d --name postgres13 -e POSTGRES_PASSWORD=postgres -v /home/quattrox/sqlbackup:/sqlbackup postgres:13
```

Подключитесь к БД PostgreSQL используя `psql`.

```
root@Test:/home/quattrox# docker exec -it a1fe9d0aad27 bash
root@a1fe9d0aad27:/# su postgres
postgres@a1fe9d0aad27:/$ psql
psql (13.3 (Debian 13.3-1.pgdg100+1))
Type "help" for help.

postgres=# 
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```
\l[+]   [PATTERN]      list databases
```
- подключения к БД
```
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```
- вывода списка таблиц
```
  \d[S+]                 list tables, views, and sequences
```
- вывода описания содержимого таблиц
```
\d[S+]  NAME           describe table, view, sequence, or index
```
- выхода из psql
```
 \q                     quit psql
```

## Задача 2

Используя `psql` создайте БД `test_database`.

```
postgres=# CREATE DATABASE test_database;
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

```
psql -U postgres -W test_database < /sqlbackup/test_dump.sql
```

Перейдите в управляющую консоль `psql` внутри контейнера.

```
postgres@a1fe9d0aad27:/$ psql 
psql (13.3 (Debian 13.3-1.pgdg100+1))
Type "help" for help.

postgres=# \c test_database 
You are now connected to database "test_database" as user "postgres".
test_database=# 
```

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

```
test_database=# \c test_database;
You are now connected to database "test_database" as user "postgres".
test_database=# ANALYZE orders;
ANALYZE
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

```
test_database=# SELECT avg_width from pg_stats where tablename='orders' ORDER BY avg_width DESC limit 1;
 avg_width 
-----------
        16
(1 row)
```

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
