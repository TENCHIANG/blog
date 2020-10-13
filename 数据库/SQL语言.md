### SQL 结构化查询语言

* 结构化查询语言 Structured Query Language，可以操纵所有的关系型数据库
* 每种数据库基于SQL都会有一定的修改（方言）

#### SQL 分为四类

* DDL Data Definition Language 数据定义语言
  * 操作数据库对象（数据库和表）：create、drop、alter
  * 数据的组织形式为 schema
* DML Data Manipulation Language 数据操作语言
  * 表操作：insert、delete、update
* DQL Data Query Language 数据查询语言
  * select、where
* DCL Data Control Language 数据控制语言
  * 访问权限、安全级别：grant、revoke

### SQL 常用操作

* SQL 最佳实践：关键字最好大写，语句结尾最好用 \G，字符串用双引号，反标号括起数据库和表名

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

SHOW TABLES FROM `company`\G # 查看所有表
SHOW CREATE TABLE `company`.`customers`\G # 查看表结构（创建时的语句）
DESC `company`.`customers`\G # 查看表结构（以查询结果的形式）

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

#### 特殊的 USE 语句

* 不结尾或分号结尾提示 Database changed
* \g 结尾会提示 Query OK, 0 rows affected (0.00 sec)
* 也可以用反标号括起来，情况与上述相同，独 \G 不同：
  * 不括起来，转义为 g 添加到原来数据库名字的后面
  * 括起来，则报语法错误 ERROR 1064 (42000): You have an error in your SQL syntax

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

### 创建表

* 分为定义字段（括号内）和定义整个表（括号外，有等号）
* 定义字段
  * IF NOT EXISTS 有相同的名字只警告，不继续创建（否则报错）
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

#### 操作数据库 CRUD

* Create 创建
  * `create database if not exists db character set utf8mb4;` 不报错
* Retrieve 查询
  * `show databases;`
    * information_schema（视图，没有实际文件夹）
    * mysql
    * performace_schema
    * test
  * `show create database test;` 查看某个数据库的创建语句（**字符集**）
    * `CREATE DATABASE `test` /*!40100 DEFAULT CHARACTER SET utf8 */`
* Update 修改
  * `alter database 数据库名 character set 字符集名;`
* Delete 删除
  * `drop database if exists 数据库名;`
* 使用数据库
  * `select database();` 查看当前使用的数据库（默认为NULL）
  * `use 数据库名;`

#### 操作表：CRUD

* create

```sql
create table 表名 (
	列名1 数据类型1,
	列名2 数据类型2,
    ...
	列名n 数据类型n # 注意最后一行没有逗号
);
```

* retrieve
  * `show tables;` 查看当前数据库的所有表
* update
* delete