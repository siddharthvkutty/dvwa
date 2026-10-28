# Spark SQL Cheat Sheet: Common Queries, Usage & Syntax

> Targets Spark 3.x. Items marked **(Delta/Iceberg)** need a table format that supports row-level operations; plain Parquet/Hive tables do not support `UPDATE`, `DELETE` or `MERGE`.

## Table of Contents
1. [Basic Queries](#1-basic-queries)
2. [Databases, Tables & Views (DDL)](#2-databases-tables--views-ddl)
3. [Inserting & Modifying Data (DML)](#3-inserting--modifying-data-dml)
4. [Aggregations & Grouping](#4-aggregations--grouping)
5. [Joins](#5-joins)
6. [Set Operations](#6-set-operations)
7. [Subqueries & CTEs](#7-subqueries--ctes)
8. [Window Functions](#8-window-functions)
9. [Conditional Logic & NULL Handling](#9-conditional-logic--null-handling)
10. [String Functions](#10-string-functions)
11. [Date & Time Functions](#11-date--time-functions)
12. [Numeric & Math Functions](#12-numeric--math-functions)
13. [Arrays, Maps & Structs](#13-arrays-maps--structs)
14. [Higher-Order Functions](#14-higher-order-functions)
15. [JSON Handling](#15-json-handling)
16. [PIVOT & UNPIVOT](#16-pivot--unpivot)
17. [Querying Files Directly](#17-querying-files-directly)
18. [Performance & Tuning](#18-performance--tuning)
19. [Handy Metadata Commands](#19-handy-metadata-commands)
20. [Common Gotchas](#20-common-gotchas)

---

## 1. Basic Queries

```sql
-- Select columns
SELECT id, name, salary FROM employees;

-- Select everything
SELECT * FROM employees;

-- Select all except some columns
SELECT * EXCEPT (ssn, password) FROM employees;       -- Databricks / newer runtimes
-- In open-source Spark, use a regex column spec instead:
SET spark.sql.parser.quotedRegexColumnNames = true;
SELECT `(ssn|password)?+.+` FROM employees;

-- Alias
SELECT name AS employee_name, salary * 12 AS annual_salary FROM employees;

-- Distinct
SELECT DISTINCT department FROM employees;

-- Filtering
SELECT * FROM employees
WHERE salary > 50000
  AND department IN ('Sales', 'IT')
  AND hire_date BETWEEN '2020-01-01' AND '2023-12-31'
  AND name LIKE 'A%'
  AND manager_id IS NOT NULL;

-- Regex match
SELECT * FROM employees WHERE name RLIKE '^[A-M].*son$';

-- Sorting & limiting
SELECT * FROM employees
ORDER BY salary DESC, name ASC
LIMIT 10;

-- Null ordering
SELECT * FROM employees ORDER BY bonus DESC NULLS LAST;

-- Sample data
SELECT * FROM employees TABLESAMPLE (10 PERCENT);
SELECT * FROM employees TABLESAMPLE (100 ROWS);
```

**Execution order (logical):** `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `DISTINCT` → `ORDER BY` → `LIMIT`

---

## 2. Databases, Tables & Views (DDL)

### Databases
```sql
CREATE DATABASE IF NOT EXISTS sales_db COMMENT 'Sales data' LOCATION '/data/sales_db';
USE sales_db;
SHOW DATABASES;
DESCRIBE DATABASE EXTENDED sales_db;
DROP DATABASE IF EXISTS sales_db CASCADE;   -- CASCADE drops contained tables
```

### Tables
```sql
-- Managed table
CREATE TABLE IF NOT EXISTS employees (
  id         INT,
  name       STRING,
  department STRING,
  salary     DECIMAL(10,2),
  hire_date  DATE
)
USING PARQUET;                      -- or DELTA, ORC, CSV, JSON, ICEBERG

-- Partitioned table
CREATE TABLE events (
  event_id   BIGINT,
  user_id    BIGINT,
  event_type STRING,
  event_date DATE
)
USING PARQUET
PARTITIONED BY (event_date);

-- Bucketed table
CREATE TABLE users_bucketed (id INT, name STRING)
USING PARQUET
CLUSTERED BY (id) INTO 16 BUCKETS;

-- External table (data stays at LOCATION when dropped)
CREATE TABLE ext_logs (ts TIMESTAMP, msg STRING)
USING CSV
OPTIONS (header 'true', delimiter ',')
LOCATION '/data/logs/';

-- CTAS: Create Table As Select
CREATE TABLE high_earners USING PARQUET AS
SELECT * FROM employees WHERE salary > 100000;

-- Copy schema only
CREATE TABLE employees_copy LIKE employees;

-- Drop / truncate
DROP TABLE IF EXISTS employees;
TRUNCATE TABLE employees;
```

### Altering tables
```sql
ALTER TABLE employees ADD COLUMNS (email STRING COMMENT 'work email');
ALTER TABLE employees RENAME COLUMN email TO work_email;       -- Delta/Iceberg
ALTER TABLE employees DROP COLUMN work_email;                   -- Delta/Iceberg
ALTER TABLE employees ALTER COLUMN salary TYPE DECIMAL(12,2);   -- table-format dependent
ALTER TABLE employees RENAME TO staff;
ALTER TABLE employees SET TBLPROPERTIES ('comment' = 'HR master table');

-- Partitions
ALTER TABLE events ADD IF NOT EXISTS PARTITION (event_date = '2024-01-01');
ALTER TABLE events DROP IF EXISTS PARTITION (event_date = '2023-01-01');
MSCK REPAIR TABLE events;        -- discover partitions already on disk
```

### Views
```sql
-- Persistent view
CREATE OR REPLACE VIEW active_employees AS
SELECT * FROM employees WHERE status = 'active';

-- Session-scoped temp view
CREATE OR REPLACE TEMPORARY VIEW tmp_sales AS
SELECT * FROM sales WHERE year = 2024;

-- Global temp view (shared across sessions in the same app, lives in global_temp)
CREATE OR REPLACE GLOBAL TEMPORARY VIEW g_sales AS SELECT * FROM sales;
SELECT * FROM global_temp.g_sales;

DROP VIEW IF EXISTS active_employees;
```

---

## 3. Inserting & Modifying Data (DML)

```sql
-- Insert values
INSERT INTO employees VALUES
  (1, 'Alice', 'IT',    85000.00, DATE'2021-03-15'),
  (2, 'Bob',   'Sales', 62000.00, DATE'2020-07-01');

-- Insert with explicit columns
INSERT INTO employees (id, name) VALUES (3, 'Carol');

-- Insert from query
INSERT INTO employees_archive
SELECT * FROM employees WHERE hire_date < '2015-01-01';

-- Overwrite whole table
INSERT OVERWRITE TABLE employees_archive SELECT * FROM employees;

-- Overwrite a static partition
INSERT OVERWRITE TABLE events PARTITION (event_date = '2024-01-01')
SELECT event_id, user_id, event_type FROM staging_events;

-- Dynamic partition overwrite
SET spark.sql.sources.partitionOverwriteMode = dynamic;
INSERT OVERWRITE TABLE events
SELECT event_id, user_id, event_type, event_date FROM staging_events;
```

### Row-level operations **(Delta/Iceberg)**
```sql
UPDATE employees SET salary = salary * 1.05 WHERE department = 'IT';

DELETE FROM employees WHERE status = 'terminated';

-- Upsert
MERGE INTO employees AS t
USING updates AS s
  ON t.id = s.id
WHEN MATCHED AND s.is_deleted = true THEN DELETE
WHEN MATCHED THEN UPDATE SET t.salary = s.salary, t.name = s.name
WHEN NOT MATCHED THEN INSERT (id, name, salary) VALUES (s.id, s.name, s.salary);
```

---

## 4. Aggregations & Grouping

```sql
SELECT
  department,
  COUNT(*)                    AS headcount,
  COUNT(DISTINCT manager_id)  AS managers,
  SUM(salary)                 AS total_salary,
  AVG(salary)                 AS avg_salary,
  MIN(salary)                 AS min_salary,
  MAX(salary)                 AS max_salary,
  STDDEV(salary)              AS stddev_salary,
  PERCENTILE(salary, 0.5)     AS median_salary,
  PERCENTILE_APPROX(salary, 0.9) AS p90_salary,
  APPROX_COUNT_DISTINCT(id)   AS approx_ids
FROM employees
GROUP BY department
HAVING COUNT(*) > 5
ORDER BY total_salary DESC;

-- Group by position / alias
SELECT department, COUNT(*) AS c FROM employees GROUP BY 1 ORDER BY c DESC;
SELECT department, COUNT(*) FROM employees GROUP BY ALL;     -- Spark 3.4+

-- Collect values
SELECT department,
       COLLECT_LIST(name) AS all_names,       -- keeps duplicates
       COLLECT_SET(name)  AS unique_names
FROM employees GROUP BY department;

-- Conditional aggregation
SELECT department,
       SUM(CASE WHEN salary > 80000 THEN 1 ELSE 0 END) AS high_earners,
       COUNT(*) FILTER (WHERE status = 'active')       AS active_count
FROM employees GROUP BY department;

-- Multi-level totals
SELECT department, job_title, SUM(salary)
FROM employees
GROUP BY ROLLUP (department, job_title);       -- subtotals per department + grand total

SELECT department, job_title, SUM(salary)
FROM employees
GROUP BY CUBE (department, job_title);         -- all combinations

SELECT department, job_title, SUM(salary)
FROM employees
GROUP BY GROUPING SETS ((department), (job_title), ());

-- Tell which rows are subtotals
SELECT department, GROUPING(department) AS is_total, SUM(salary)
FROM employees GROUP BY ROLLUP (department);
```

---

## 5. Joins

```sql
-- Inner join
SELECT e.name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.id;

-- Left / right / full outer
SELECT * FROM employees e LEFT  JOIN departments d ON e.dept_id = d.id;
SELECT * FROM employees e RIGHT JOIN departments d ON e.dept_id = d.id;
SELECT * FROM employees e FULL OUTER JOIN departments d ON e.dept_id = d.id;

-- Cross join (cartesian product)
SELECT * FROM sizes CROSS JOIN colors;

-- Semi join: rows in left that HAVE a match (returns only left columns)
SELECT * FROM employees e LEFT SEMI JOIN departments d ON e.dept_id = d.id;

-- Anti join: rows in left with NO match
SELECT * FROM employees e LEFT ANTI JOIN departments d ON e.dept_id = d.id;

-- USING (merges the join column)
SELECT * FROM employees JOIN departments USING (dept_id);

-- Natural join (joins on all same-named columns, use with care)
SELECT * FROM employees NATURAL JOIN departments;

-- Self join
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;

-- Broadcast hint for a small table
SELECT /*+ BROADCAST(d) */ e.*, d.dept_name
FROM employees e JOIN departments d ON e.dept_id = d.id;
```

| Join type | Returns |
|-----------|---------|
| `INNER` | Rows matching in both tables |
| `LEFT [OUTER]` | All left rows + matches from right (NULLs if none) |
| `RIGHT [OUTER]` | All right rows + matches from left |
| `FULL [OUTER]` | All rows from both |
| `LEFT SEMI` | Left rows that have a match (left columns only) |
| `LEFT ANTI` | Left rows that have no match |
| `CROSS` | Cartesian product |

---

## 6. Set Operations

```sql
SELECT id FROM a UNION     SELECT id FROM b;   -- distinct union
SELECT id FROM a UNION ALL SELECT id FROM b;   -- keeps duplicates (faster)
SELECT id FROM a INTERSECT SELECT id FROM b;
SELECT id FROM a EXCEPT    SELECT id FROM b;   -- in a, not in b (alias: MINUS)

-- Union by column name instead of position (Spark 3.1+)
SELECT * FROM a UNION ALL BY NAME SELECT * FROM b;
```

---

## 7. Subqueries & CTEs

```sql
-- CTE (Common Table Expression)
WITH dept_avg AS (
  SELECT department, AVG(salary) AS avg_sal
  FROM employees
  GROUP BY department
),
high_depts AS (
  SELECT department FROM dept_avg WHERE avg_sal > 70000
)
SELECT e.*
FROM employees e
JOIN high_depts h ON e.department = h.department;

-- Scalar subquery
SELECT name, salary,
       (SELECT AVG(salary) FROM employees) AS company_avg
FROM employees;

-- IN subquery
SELECT * FROM employees
WHERE dept_id IN (SELECT id FROM departments WHERE region = 'EMEA');

-- EXISTS / NOT EXISTS (correlated)
SELECT * FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.dept_id = d.id);

-- Subquery in FROM
SELECT department, avg_sal
FROM (SELECT department, AVG(salary) AS avg_sal FROM employees GROUP BY department) t
WHERE avg_sal > 60000;

-- Recursive CTEs are NOT supported in open-source Spark (Databricks supports them in newer runtimes)
```

---

## 8. Window Functions

**Syntax:**
```sql
function() OVER (
  [PARTITION BY col, ...]
  [ORDER BY col [ASC|DESC], ...]
  [ROWS | RANGE BETWEEN frame_start AND frame_end]
)
```

```sql
-- Ranking
SELECT name, department, salary,
  ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num,   -- 1,2,3,4
  RANK()       OVER (PARTITION BY department ORDER BY salary DESC) AS rnk,       -- 1,2,2,4
  DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rnk, -- 1,2,2,3
  NTILE(4)     OVER (PARTITION BY department ORDER BY salary DESC) AS quartile,
  PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary)    AS pct_rank
FROM employees;

-- Top N per group
SELECT * FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
  FROM employees
) WHERE rn <= 3;

-- Spark 3.x also allows QUALIFY in some runtimes (Databricks):
-- SELECT * FROM employees QUALIFY ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) <= 3;

-- Deduplicate: keep the latest row per id
SELECT * FROM (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY id ORDER BY updated_at DESC) AS rn
  FROM raw_table
) WHERE rn = 1;

-- Lead / lag
SELECT order_date, amount,
  LAG(amount, 1)  OVER (ORDER BY order_date) AS prev_amount,
  LEAD(amount, 1) OVER (ORDER BY order_date) AS next_amount,
  amount - LAG(amount) OVER (ORDER BY order_date) AS delta
FROM daily_sales;

-- First / last / nth value
SELECT name, department, salary,
  FIRST_VALUE(name) OVER (PARTITION BY department ORDER BY salary DESC) AS top_earner,
  LAST_VALUE(name)  OVER (PARTITION BY department ORDER BY salary DESC
                          ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest_earner
FROM employees;

-- Running totals and moving averages
SELECT order_date, amount,
  SUM(amount) OVER (ORDER BY order_date
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
  AVG(amount) OVER (ORDER BY order_date
                    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)         AS moving_avg_7d
FROM daily_sales;

-- Share of total
SELECT department, salary,
       salary / SUM(salary) OVER (PARTITION BY department) AS pct_of_dept
FROM employees;
```

> **Note:** with `ORDER BY` and no explicit frame, the default frame is `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`, which is why `LAST_VALUE` often looks "wrong" unless you set the frame explicitly.

---

## 9. Conditional Logic & NULL Handling

```sql
-- CASE
SELECT name,
  CASE
    WHEN salary >= 100000 THEN 'High'
    WHEN salary >= 60000  THEN 'Medium'
    ELSE 'Low'
  END AS salary_band
FROM employees;

-- Simple CASE
SELECT CASE department WHEN 'IT' THEN 'Tech' WHEN 'HR' THEN 'People' ELSE 'Other' END FROM employees;

-- IF / IIF
SELECT IF(salary > 50000, 'Yes', 'No') FROM employees;

-- NULL handling
SELECT COALESCE(bonus, commission, 0)   AS comp,       -- first non-null
       NVL(bonus, 0)                    AS bonus_safe, -- 2-arg COALESCE
       NULLIF(department, '')           AS dept_or_null,
       IFNULL(bonus, 0),
       NVL2(bonus, 'has bonus', 'none'),
       ISNULL(bonus), ISNOTNULL(bonus)
FROM employees;

-- NULL-safe equality (NULL <=> NULL is true)
SELECT * FROM a JOIN b ON a.key <=> b.key;

-- Greatest / least across columns
SELECT GREATEST(q1, q2, q3, q4), LEAST(q1, q2, q3, q4) FROM quarterly;
```

---

## 10. String Functions

```sql
SELECT
  UPPER(name), LOWER(name), INITCAP(name),
  LENGTH(name), TRIM(name), LTRIM(name), RTRIM(name),
  CONCAT(first_name, ' ', last_name),
  CONCAT_WS('-', year, month, day),              -- skips NULLs
  SUBSTRING(name, 1, 3),                         -- 1-based index
  LEFT(name, 3), RIGHT(name, 3),
  REPLACE(name, 'a', 'A'),
  REGEXP_REPLACE(phone, '[^0-9]', ''),           -- strip non-digits
  REGEXP_EXTRACT(email, '@(.+)$', 1),            -- capture group 1
  SPLIT(tags, ','),                              -- returns ARRAY<STRING>
  SPLIT(tags, ',')[0],
  LPAD(CAST(id AS STRING), 8, '0'),              -- 00000042
  RPAD(name, 10, '.'),
  INSTR(name, 'son'),                            -- position, 0 if absent
  LOCATE('son', name),
  REPEAT('ab', 3),
  REVERSE(name),
  TRANSLATE(name, 'abc', 'xyz'),
  FORMAT_NUMBER(salary, 2),                      -- 85,000.00
  FORMAT_STRING('%s earns %d', name, salary),
  SOUNDEX(name), LEVENSHTEIN(a, b),
  MD5(name), SHA2(name, 256), BASE64(name),
  STARTSWITH(name, 'A'), ENDSWITH(name, 'n'), CONTAINS(name, 'li')
FROM employees;

-- Pattern matching
WHERE name LIKE 'A%'          -- starts with A
WHERE name LIKE '%son'        -- ends with son
WHERE name LIKE '_ob'         -- _ = exactly one char
WHERE name ILIKE 'alice'      -- case-insensitive (Spark 3.3+)
WHERE name RLIKE '^[A-Z]{3}'  -- regex
```

---

## 11. Date & Time Functions

```sql
SELECT
  CURRENT_DATE()                            AS today,
  CURRENT_TIMESTAMP()                       AS now,
  DATE'2024-03-15'                          AS date_literal,
  TIMESTAMP'2024-03-15 10:30:00'            AS ts_literal,

  -- Parsing and formatting
  TO_DATE('2024-03-15')                     AS d1,
  TO_DATE('15/03/2024', 'dd/MM/yyyy')       AS d2,
  TO_TIMESTAMP('2024-03-15 10:30:00')       AS t1,
  DATE_FORMAT(CURRENT_TIMESTAMP(), 'yyyy-MM-dd HH:mm:ss') AS formatted,

  -- Extract parts
  YEAR(d), MONTH(d), DAY(d), HOUR(ts), MINUTE(ts), SECOND(ts),
  DAYOFWEEK(d),        -- 1 = Sunday
  DAYOFYEAR(d), WEEKOFYEAR(d), QUARTER(d),
  EXTRACT(YEAR FROM d),

  -- Arithmetic
  DATE_ADD(d, 7), DATE_SUB(d, 7),
  ADD_MONTHS(d, 3),
  DATEDIFF(end_date, start_date)            AS days_between,
  MONTHS_BETWEEN(end_date, start_date),
  d + INTERVAL 1 DAY,
  ts - INTERVAL '2' HOURS,

  -- Truncation / boundaries
  DATE_TRUNC('month', ts)                   AS month_start,   -- returns timestamp
  TRUNC(d, 'MM')                            AS month_start_d, -- returns date
  LAST_DAY(d),
  NEXT_DAY(d, 'Mon'),

  -- Unix time
  UNIX_TIMESTAMP('2024-03-15', 'yyyy-MM-dd'),
  FROM_UNIXTIME(1710498600),
  TO_UNIX_TIMESTAMP(ts),

  -- Time zones
  FROM_UTC_TIMESTAMP(ts, 'Asia/Kolkata'),
  TO_UTC_TIMESTAMP(ts, 'Asia/Kolkata')
FROM t;

-- Generate a date range
SELECT EXPLODE(SEQUENCE(DATE'2024-01-01', DATE'2024-01-31', INTERVAL 1 DAY)) AS dt;

-- Group by time bucket
SELECT WINDOW(event_time, '10 minutes') AS w, COUNT(*)
FROM events GROUP BY WINDOW(event_time, '10 minutes');
```

**Common format letters:** `yyyy` year · `MM` month · `dd` day · `HH` hour (24h) · `hh` hour (12h) · `mm` minute · `ss` second · `SSS` millis · `EEE` weekday name · `a` AM/PM

---

## 12. Numeric & Math Functions

```sql
SELECT
  ROUND(3.14159, 2),      -- 3.14 (half up)
  BROUND(2.5),            -- banker's rounding -> 2
  CEIL(3.2), FLOOR(3.8),
  ABS(-5), SIGN(-5),
  POWER(2, 10), SQRT(16), EXP(1), LN(10), LOG10(100), LOG2(8),
  MOD(10, 3), 10 % 3, PMOD(-7, 3),
  10 DIV 3,                -- integer division
  RAND(), RAND(42),        -- uniform [0,1), seeded
  CAST('123' AS INT),
  TRY_CAST('abc' AS INT),  -- returns NULL instead of failing (Spark 3.2+)
  CAST(salary AS DECIMAL(12,2)),
  TRY_DIVIDE(a, b)         -- NULL on divide-by-zero
FROM t;
```

---

## 13. Arrays, Maps & Structs

### Arrays
```sql
SELECT
  ARRAY(1, 2, 3)                          AS arr,
  SIZE(arr),
  arr[0],                                 -- 0-based; out of range -> NULL (or error in ANSI mode)
  ELEMENT_AT(arr, 1),                     -- 1-based; negative counts from end
  ARRAY_CONTAINS(arr, 2),
  ARRAY_DISTINCT(arr),
  ARRAY_SORT(arr),
  SORT_ARRAY(arr, false),                 -- descending
  ARRAY_UNION(a, b), ARRAY_INTERSECT(a, b), ARRAY_EXCEPT(a, b),
  ARRAYS_OVERLAP(a, b),
  ARRAY_JOIN(arr, ','),
  ARRAY_MAX(arr), ARRAY_MIN(arr),
  SLICE(arr, 2, 2),                       -- start, length (1-based)
  FLATTEN(nested_arr),
  ARRAY_REMOVE(arr, 2),
  ARRAY_REPEAT('x', 3),
  CONCAT(a, b),                           -- concatenates arrays too
  SEQUENCE(1, 5)                          -- [1,2,3,4,5]
FROM t;
```

### Exploding arrays to rows
```sql
-- EXPLODE: one row per element (drops rows where array is NULL/empty)
SELECT id, EXPLODE(tags) AS tag FROM posts;

-- POSEXPLODE: with position
SELECT id, POSEXPLODE(tags) AS (pos, tag) FROM posts;

-- EXPLODE_OUTER: keeps rows with NULL/empty arrays
SELECT id, EXPLODE_OUTER(tags) AS tag FROM posts;

-- LATERAL VIEW (when you need other columns too)
SELECT p.id, p.title, t.tag
FROM posts p
LATERAL VIEW EXPLODE(p.tags) t AS tag;

LATERAL VIEW OUTER EXPLODE(p.tags) t AS tag;   -- keeps empty arrays

-- Inline an array of structs into columns
SELECT INLINE(ARRAY(STRUCT(1, 'a'), STRUCT(2, 'b')));
```

### Maps
```sql
SELECT
  MAP('a', 1, 'b', 2)       AS m,
  m['a'],
  ELEMENT_AT(m, 'a'),
  MAP_KEYS(m), MAP_VALUES(m),
  MAP_CONTAINS_KEY(m, 'a'),
  MAP_CONCAT(m1, m2),
  MAP_FROM_ARRAYS(keys, vals),
  MAP_FROM_ENTRIES(arr_of_structs),
  SIZE(m)
FROM t;

SELECT id, EXPLODE(m) AS (k, v) FROM t;   -- map -> rows
```

### Structs
```sql
SELECT
  STRUCT(1 AS id, 'Alice' AS name)    AS s,
  s.name,                             -- dot access
  s.*,                                -- expand all fields to columns
  NAMED_STRUCT('id', 1, 'name', 'Alice')
FROM t;
```

---

## 14. Higher-Order Functions

Lambda syntax: `x -> expression` or `(x, y) -> expression`.

```sql
-- Apply to each element
SELECT TRANSFORM(arr, x -> x * 2) FROM t;
SELECT TRANSFORM(arr, (x, i) -> x + i) FROM t;      -- with index

-- Filter elements
SELECT FILTER(arr, x -> x > 10) FROM t;

-- Any / all
SELECT EXISTS(arr, x -> x > 100) FROM t;            -- any element matches
SELECT FORALL(arr, x -> x > 0) FROM t;              -- all elements match

-- Fold / reduce
SELECT AGGREGATE(arr, 0, (acc, x) -> acc + x) FROM t;               -- sum
SELECT AGGREGATE(arr, 0, (acc, x) -> acc + x, acc -> acc / SIZE(arr)) FROM t;  -- average

-- Zip two arrays
SELECT ZIP_WITH(a, b, (x, y) -> x + y) FROM t;

-- Map operations
SELECT TRANSFORM_VALUES(m, (k, v) -> v * 2) FROM t;
SELECT TRANSFORM_KEYS(m, (k, v) -> UPPER(k)) FROM t;
SELECT MAP_FILTER(m, (k, v) -> v > 1) FROM t;
```

---

## 15. JSON Handling

```sql
-- Extract with JSONPath (returns STRING)
SELECT GET_JSON_OBJECT(json_col, '$.user.name') FROM t;
SELECT GET_JSON_OBJECT(json_col, '$.items[0].price') FROM t;

-- Extract multiple fields at once
SELECT JSON_TUPLE(json_col, 'name', 'age') AS (name, age) FROM t;

-- Colon syntax (Spark 3.4+ / Databricks)
SELECT json_col:user.name FROM t;

-- Parse JSON into a struct using a schema
SELECT FROM_JSON(json_col, 'name STRING, age INT, tags ARRAY<STRING>') AS parsed FROM t;
SELECT parsed.name, parsed.age FROM (
  SELECT FROM_JSON(json_col, 'name STRING, age INT') AS parsed FROM t
);

-- Infer the schema from a sample
SELECT SCHEMA_OF_JSON('{"name":"a","age":1}');

-- Struct/map/array -> JSON string
SELECT TO_JSON(STRUCT(id, name)) FROM employees;
```

---

## 16. PIVOT & UNPIVOT

```sql
-- PIVOT: rows -> columns
SELECT * FROM (
  SELECT department, quarter, revenue FROM sales
)
PIVOT (
  SUM(revenue)
  FOR quarter IN ('Q1', 'Q2', 'Q3', 'Q4')
);

-- Multiple aggregates
SELECT * FROM sales
PIVOT (
  SUM(revenue) AS rev, COUNT(*) AS cnt
  FOR quarter IN ('Q1' AS q1, 'Q2' AS q2)
);

-- UNPIVOT: columns -> rows (Spark 3.4+)
SELECT * FROM quarterly_sales
UNPIVOT (
  revenue FOR quarter IN (q1, q2, q3, q4)
);

-- Older Spark: unpivot with STACK
SELECT id, STACK(3, 'q1', q1, 'q2', q2, 'q3', q3) AS (quarter, revenue)
FROM quarterly_sales;
```

---

## 17. Querying Files Directly

```sql
-- Query files without creating a table
SELECT * FROM parquet.`/data/events/`;
SELECT * FROM csv.`/data/users.csv`;
SELECT * FROM json.`/data/logs/`;
SELECT * FROM delta.`/data/delta_table`;

-- Temp view over a CSV with options
CREATE TEMPORARY VIEW users
USING CSV
OPTIONS (path '/data/users.csv', header 'true', inferSchema 'true');

-- Write query results to files
INSERT OVERWRITE DIRECTORY '/output/report'
USING PARQUET
SELECT * FROM employees;

-- Show the source file for each row
SELECT *, INPUT_FILE_NAME() FROM parquet.`/data/events/`;
```

---

## 18. Performance & Tuning

### Inspect plans
```sql
EXPLAIN SELECT ...;                    -- physical plan
EXPLAIN EXTENDED SELECT ...;           -- parsed, analyzed, optimized, physical
EXPLAIN FORMATTED SELECT ...;          -- readable tree + details
EXPLAIN COST SELECT ...;               -- with statistics
```

### Statistics & caching
```sql
ANALYZE TABLE employees COMPUTE STATISTICS;
ANALYZE TABLE employees COMPUTE STATISTICS FOR COLUMNS id, salary;

CACHE TABLE employees;
CACHE LAZY TABLE employees;            -- cached on first use
UNCACHE TABLE employees;
CLEAR CACHE;
REFRESH TABLE employees;               -- invalidate cached metadata after external changes
```

### Hints
```sql
SELECT /*+ BROADCAST(small) */ * FROM big JOIN small ON big.k = small.k;
SELECT /*+ MERGE(a, b) */ ...;                 -- sort-merge join
SELECT /*+ SHUFFLE_HASH(b) */ ...;
SELECT /*+ SHUFFLE_REPLICATE_NL(b) */ ...;

SELECT /*+ REPARTITION(200) */ * FROM t;       -- or REPARTITION(200, col)
SELECT /*+ COALESCE(10) */ * FROM t;           -- reduce partitions, no full shuffle
SELECT /*+ REBALANCE */ * FROM t;              -- even partitions (AQE)
```

### Useful configs
```sql
SET spark.sql.shuffle.partitions = 200;                -- default 200
SET spark.sql.adaptive.enabled = true;                 -- AQE (default true in 3.2+)
SET spark.sql.autoBroadcastJoinThreshold = 10485760;   -- 10 MB; -1 disables
SET spark.sql.ansi.enabled = true;                     -- stricter, ANSI SQL semantics
SET spark.sql.session.timeZone = 'UTC';
SET;                                                    -- list all
```

### Rules of thumb
- Filter early, and filter on **partition columns** to enable partition pruning.
- Select only needed columns; with Parquet/ORC this avoids reading the rest.
- Use `UNION ALL` instead of `UNION` unless you need de-duplication.
- Broadcast small dimension tables; avoid skewed join keys (AQE skew join helps).
- Prefer built-in functions over Python/Scala UDFs: UDFs block optimizer pushdown.
- Avoid `SELECT *` on wide tables and `ORDER BY` on huge results without `LIMIT`.
- Watch for lots of tiny files: compact them (`OPTIMIZE` on Delta, or rewrite with `COALESCE`/`REPARTITION`).

---

## 19. Handy Metadata Commands

```sql
SHOW DATABASES;                          -- or SHOW SCHEMAS
SHOW TABLES;
SHOW TABLES IN sales_db LIKE 'emp*';
SHOW VIEWS;
SHOW COLUMNS IN employees;
SHOW PARTITIONS events;
SHOW CREATE TABLE employees;
SHOW TBLPROPERTIES employees;
SHOW FUNCTIONS LIKE '*date*';

DESCRIBE employees;
DESCRIBE EXTENDED employees;             -- includes location, provider, properties
DESCRIBE FORMATTED employees;
DESCRIBE FUNCTION EXTENDED date_trunc;   -- built-in function docs & examples

SELECT current_database(), current_user(), version();
```

---

## 20. Common Gotchas

| Gotcha | Detail |
|--------|--------|
| **NULL comparisons** | `col = NULL` is never true. Use `IS NULL` / `IS NOT NULL` or `<=>`. |
| **`NOT IN` with NULLs** | If the subquery returns any NULL, `NOT IN` returns no rows. Prefer `NOT EXISTS` or `LEFT ANTI JOIN`. |
| **Integer division** | `5 / 2` returns `2.5` in Spark SQL; use `DIV` for integer division. |
| **Array indexing** | `arr[0]` is 0-based; `ELEMENT_AT(arr, 1)` is 1-based. |
| **`SUBSTRING` index** | 1-based (position 0 behaves like 1). |
| **Case sensitivity** | Identifiers are case-insensitive by default; string comparisons are case-sensitive. |
| **Backticks** | Quote identifiers containing special chars/reserved words with `` `col name` ``. |
| **`ORDER BY` in subqueries/CTEs** | Ordering is not guaranteed to be preserved unless it is in the outermost query. |
| **`LAST_VALUE` surprises** | Needs an explicit `ROWS BETWEEN ... UNBOUNDED FOLLOWING` frame. |
| **ANSI mode** | With `spark.sql.ansi.enabled=true`, overflow and invalid casts raise errors instead of returning NULL; use `TRY_CAST` / `TRY_DIVIDE`. |
| **`UPDATE`/`DELETE`/`MERGE`** | Only work on Delta/Iceberg/Hudi tables, not plain Parquet/Hive. |
| **`UNION` column matching** | By position, not name (use `UNION ALL BY NAME` or `unionByName`). |
| **Timestamps & time zones** | Governed by `spark.sql.session.timeZone`; be explicit when comparing across systems. |
| **Division by zero** | Returns NULL by default (non-ANSI); errors under ANSI mode. |

---

## Quick Reference: Query Template

```sql
WITH cte AS (
  SELECT ...
)
SELECT /*+ hint */ DISTINCT
       col1, agg_fn(col2) AS metric,
       win_fn() OVER (PARTITION BY ... ORDER BY ...) AS w
FROM table_a a
JOIN table_b b ON a.k = b.k
LATERAL VIEW EXPLODE(a.arr) x AS item
WHERE condition
GROUP BY col1
HAVING agg_fn(col2) > 0
ORDER BY metric DESC
LIMIT 100;
```
