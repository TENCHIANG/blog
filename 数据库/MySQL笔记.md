### MySQL的下载

[MySQL :: Download MySQL Community Server (Archived Versions)](https://downloads.mysql.com/archives/community/)

下载压缩包即可，解压后点击bin目录的`MySQLInstanceConfig.exe`即可完成配置

### Windows服务的停止和启动（管理员权限）

```cmd
services.msc
net start mysql
net stop mysql
```

### MySQL的登录和退出

```cmd
mysql -uroot -proot :: 直接输入密码
mysql -u roo -p :: 加密输入密码
exit
quit
```

### MySQL目录结构

* my.ini 配置文件
* data/数据库/表
  * 数据库是文件夹
  * 表是文件

### SQL（Structured Query Language）

* 结构化查询语言（可以操纵所有的关系型数据库）
* 每种数据库基于SQL都会有一定的修改（方言）
* SQL语句单行多行都行，以分号结尾
* MySQL的SQL不区分大小写（关键字建议大写）
* 单行注释：`--` （必须加空格）或 `#`
* 多行注释：`/**/`

### SQL分为四类

* DDL（Data Definition Language）
  * 操作数据库和表
  * create、drop、alter
* DML（Data Manipulation Language）
  * insert、delete、update
* DQL（Data Query Language）
  * select、where
* DCL（Data Control Language）
  * 访问权限、安全级别
  * grant、revoke

### MySQL的utf8不是真正的UTF-8

* utf8：3字节，不支持部分汉字、emoji表情（存储的话会报错）
* utf8mb4：4字节，完整版的UTF-8（`select version();`mysql5.5.3之后）
* `select * from information_schema.character_sets where character_set_name like 'utf8%';`
* `alter database 数据库名 character set utf8mb4;`

### DDL：操作数据库、表

#### 操作数据库：CRUD

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