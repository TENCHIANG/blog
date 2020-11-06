### SQL 结构化查询语言

* 结构化查询语言 Structured Query Language，可以操纵所有的关系型数据库
* 每种数据库基于SQL都会有一定的修改（方言）
* SQL 不区分大小写

#### SQL 分为四类

* 所有 DDL、DML（除了 SELECT）执行成功显示 Query OK
  * DROP 成功显示 0 rows affected

##### DDL Data Definition Language 数据定义语言

* **DDL 操作数据库对象（DBA）**：CREATE、ALTER、DROP
* 数据库对象：tables、views、clusters、sequences（序列）、 indexes、synonyms（同义词）
* 数据的组织形式为 schema

##### DML Data Manipulation Language 数据操作语言

* **DML 操作表内数据**：INSERT、UPDATE、DELETE

##### DQL Data Query Language 数据查询语言

* SELECT、WHERE

##### DCL Data Control Language 数据控制语言

* 访问权限、安全级别：GRANT、REVOKE

### SQL 常用操作

* SQL 最佳实践：关键字最好大写，语句结尾最好用 \G，字符串用双引号，反标号括起数据库和表名，用完全限定名（不用 USE 偷懒）

```mysql
SELECT VERSION()\G # 查看 mysql 版本

SHOW DATABASES\G # 查看所有数据库（当前用户有权访问的）
SELECT DATABASE()\G # 查看当前数据库（默认为 NULL）

# 当前的数据目录 一般是 /data
# /data/数据库/表
SHOW VARIABLES LIKE "datadir"\G
SHOW WARNINGS\G # 查看警告

CREATE DATABASE IF NOT EXISTS `company` CHARACTER SET utf8mb4\G # 创建数据库
SHOW CREATE DATABASE `company`\G # 查看数据库结构（创建时的语句，且可以看到编码）
DROP DATABASE `company`\G # 删除数据库
USE `company` # 使用数据库，注意没有结尾符

CREATE TABLE IF NOT EXISTS `company`.`customers` ( # 创建表
    `id` int unsigned AUTO_INCREMENT PRIMARY KEY,
    `first_name` varchar(20),
    `last_name` varchar(20),
    `country` varchar(20) # 最后一个不加逗号 否则语法错误
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4\G

SELECT table_name
FROM information_schema.tables 
WHERE table_schema = 'company'\G  # 查看mysql的所有表
SHOW TABLES FROM `company`\G # 查看company的所有表

SHOW CREATE TABLE `company`.`customers`\G # 查看表结构（创建时的语句）
DESC `company`.`customers`\G # 查看表结构（以查询结果的形式）
SHOW `company`.`customers`\G # 等价于 DESC、DESCRIBE

CREATE TABLE `company`.`new_customers` LIKE `company`.`customers`\G # 克隆表结构
DROP TABLE `company`.`new_customers`\G # 删除表

# 全指定才可能会重复插入
INSERT IGNORE INTO `company`.`customers` (first_name, last_name, country)
VALUES  ("Mike", "Christensen", "USA"),
		("Andy", "Hollands", "Australia"),
		("Ravi", "Vedantam", "India")\G

# 无 WHERE 则更新整个表
# 建议在事务中 UPDATE 以便回滚
UPDATE `company`.`customers`
SET first_name="D",
	last_name="QY",
	country="China"
WHERE id=1\G

DELETE FROM `company`.`customers` WHERE id=1 AND first_name="D"\G # 删除符合条件的行

# 已存在行 RELACE = DELETE + INSERT
# 不存在行 REPLACE = INSERT

SELECT * FROM `company`.`customers`\G # 查看表的所有字段
```

####  MySQL 命令

* use（\u）Use another database
  * 不结尾或分号结尾提示 Database changed
  * \g 结尾会提示 Query OK, 0 rows affected (0.00 sec)
  * 也可以用反标号括起来，情况与上述相同，独 \G 不同：
    * 不括起来，转义为 g 添加到原来数据库名字的后面
    * 括起来，则报语法错误 ERROR 1064 (42000): You have an error in your SQL syntax
* USE 其实属于 MySQL 命令，必须是第一行、以分号结尾
  * help（\h）或 ?（\?） 显示所有的 MySQL 命令
  * clear（\c）清屏
  * exit（\e）或 quit（\q）退出 MySQL monitor
  * source（\\.） 运行指定 sql 文件

### SQL 的各种符号

* SQL 不区分大小写
* 语句的结尾：`;`、`\g`、`\G`
  * `; ` 等价于 `\g` 表示输出水平显示，表格格式，容易宽度不够
  * `\G` 表示输出垂直显示，文本格式，列是一行行显示，更美观但是标头会重复
  * 所以 SQL 语句单行多行都行
* 反标记符 ` 用于引用标识符：数据库名称包含特殊字符（如句点）时使用
* 数据库或表名包含特殊字符时，用反标记符括起来即可
  * 引用标识符：如数据库和表名
  * 如用句点作为标识符的一部分，则要用反标记符括起来
  * 因为句点表示 `数据库.表` 也不能用引号括起来变成字符串
  * 最佳实践：**数据库和表名都分别用反标记符（又叫反标号）括起来**

```mysql
SELECT * FROM `information_schema`.`character_sets`\G
# SELECT * FROM `information_schema.character_sets`\G
# ERROR 1146 (42S02): Table 'test.information_schema.character_sets' doesn't exist
```

* 字符串：单双引号都可以表示
* 单行注释：`#` 和 `--` （右边必须加空格）
* 多行注释：`/**/`

## Data Definition Language

### CREATE DATABASE 创建数据库

* 需要有创建数据库的权限
* CREATE SCHEMA 等价于 CREATE DATABASE
* IF NOT EXISTS 同名则忽略而非报错
* CHARACTER SET 指定字符集
* COLLATE 指定字符序（校对规则）
* MySQL 中的数据库是文件夹，而表则是其中的文件
  * Windows 在 ProgramData 文件夹下
    * 所以创建系统同名数据库会以用户创建的为准
    * 原来的数据库会被隐藏
  * 因此 CREATE DATABASE 只会创建一个文件夹和 db.opt 文件
  * db.opt 文件表示该数据库的字符集和字符序（更改也在此体现）
  * 所以手动创建文件夹也会在 SHOW DATABASES 中体现
    * 如果手动改了 USE 中的文件夹名 SELECT DATABASE() 会为 NULL
  * [mysql关于db.opt文件的总结_cjh81378066的博客-CSDN博客](https://blog.csdn.net/cjh81378066/article/details/100509498)

```sql
CREATE DATABASE|SCHEMA [IF NOT EXISTS] db_name
	[create_option] ...
create_option =
	[DEFAULT]
	CHARACTER SET [=] charset_name |
	COLLATE [=] collation_name
charset_name = SHOW CHARACTER SET;
collation_name = SHOW COLLATION;
-- db.opt默认内容
default-character-set=latin1
default-collation=latin1_swedish_ci
```

#### CHARACTER SET & COLLACTION 字符集和字符序

* 字符集是一套字符和编码的集合
* 字符序也叫校对规则（或校对集），是用于字符集的排序
  * _ci（case insensitive）大小写不敏感（默认）
  * _cs（case sensitive）大小写敏感
  * _bin（binary）用编码值进行比较（大小写敏感）
* 因为 MySQL 默认字符序是 _ci，所以排序是大小写不敏感的
* [charset & collation_耘田-CSDN博客](https://blog.csdn.net/fgszdgbzdb/article/details/77051324)

#### 修改数据库名

* 直接修改文件夹名：mv old_name new_name
* InnoDB 没有直接修改数据库名的命令

```sql
CREATE DATABASE newdb;
RENAME TABLE old_db.tb1 TO new_db.tb1; -- 只能一张张表赋值
```

### CREATE TABLE 创建表

* 分为定义字段（括号内）和定义整个表（括号外，有等号）
* 定义字段
  * IF NOT EXISTS 有相同的名字避免报错
    * Query OK, 0 rows affected, 1 warning (0.00 sec)
  * PRIMARY KEY 每行由非空的 UNIQUE 列唯一标识，是为主键
  * AUTO_INCREMENT 自增，一般自增列作为这一行的主键
    * INSERT 时可以指定也可以不指定（默认从 1 开始）
    * 一般字段全部指定才可能会重复（否则主键可能会自增导致不重复）
    * INSERT IGNORE 表示插入重复行会忽略之（否则报错）
      * INSERT 语句仍然执行成功，但不会更新覆盖数据，只会记录重复的行数
      * Query OK, 0 rows affected (0.00 sec)
      * Records: 3  Duplicates: 3  Warnings: 0
  * NOT NULL 非空
* 定义整个表
  * ENGINE=InnoDB、MyISAM、FEDERATED、BLACKHOLE、CSV、MEMORY
  * AUTO_INCREMENT=1 自定义自增步长，默认就是 1
  * DEFAULT CHARSET=utf8mb4
* 创建表默认行为
  * 存储引擎默认为 InnoDB
  * 如果表已存在（重名），则报错
  * 如果没有默认数据库就创建表，则报错
  * 如果指定了不存在的数据库创建表，则报错
  * MySQL 本身不限制表的数量，但是存储引擎会，InnoDB 最多 40 亿张表（unsigned int）

```sql
CREATE TABLE 表名 (
    列名1 数据类型 约束条件,
    列名2 数据类型 约束条件,
    ...,
    表约束1, 表约束2, ...
);

CREATE [GLOBAL|LOCAL TEMPORARY] TABLE table_name
	table_element_list | OF user-defined_type
		[UNDER supertable_name]
		[table_element_list]
	[ON COMMIT PRESERVE|DELETE ROWS]
	
table_element_list = left_paren table_element, ... right_paren
table_element = column_definition | table_constraint_definition | LIKE table_name | self-referencing_column_specification | column_options

self-referencing_column_specification = REF IS self-referencing_column_name reference_generation
reference_generation = SYSTEM GENERATED | USER GENERATED | DERIVED

column_options = column_name WITH OPTIONS 
[scope_clause] [default_clause] [column_constraint_definition...] [collate_clause]
```

### ALTER TABLE 修改表

* ALTER TABLE table_name MODIFY [COLUMN] col_name col_def [FIRST | AFTER col_name]

```sql
ALTER TABLE table_name MODIFY name varchar(20);
```

### DISTINCT 去重

* 如果指定了多个列则是综合了所有列之后的去重

```sql
SELECT DISTINCT vend_id FROM products;
```

### LIMIT 限制行数

* Limit n, m 表示从第 n + 1 行开始的 m 行（n 从 0 开始，默认为 0）
  * 取 m 行只能尽量满足，后面行不够就没办法了
  * 等价于 LIMIT m OFFSET n

```sql
SELECT vend_id FROM products LIMIT 3, 4; -- 第4行开始取4行
SELECT vend_id FROM products LIMIT 4 OFFSET 3; -- 取4行偏移3行开始
```

### ORDER BY 排序

* SELECT 的结果没有特定的顺序，所以 ORDER BY 子句可取一列或多列排序
* 对多列进行排序，是先以第一个指定的列排序，再以后面指定列排序
* 默认升序（ASC），DESC 为降序（每个列需分别指定）
* 字典序：大小写相等（a 权重等于 A）
* ORDER BY 和 LIMIT 的组合，可以取最大或最小值

```sql
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price DESC, prod_name; -- 价格降序，再对产品名升序

SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price DESC
LIMIT 1; -- 取最贵的
```

#### clause 子句

* 子句由一个关键字和数组组成（一列或多列数据），如 FROM 子句

### WHERE 过滤数据

* WHERE 也相当于指定检索条件，在 FROM 子句后给出
* 在 Server 层的过滤数据有助于提高性能

```sql
SELECT prod_name
FROM products
WHERE prod_price = 2.50; -- 指定价格取产品名
```

#### WHERE 子句判断条件

* =、<>、!=、<、<=、>、>=、BETWEEN（闭区间）、IS NULL（空值检查）
* 指定范围区间：BETWEEN n AND m
  * 为闭区间 [n, m]
* WHERE 判断字符串时也**不区分大小写**
* NULL 与 0、空字符串、空格、**不匹配**不同

```sql
SELECT cust_id
FROM customers
WHERE cust_email IS NULL; -- 取出邮箱为空的用户ID
```

#### SELECT 及其子句的顺序

* SELECT - FROM - WHERE - ORDER BY - LIMIT