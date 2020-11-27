### MySQL各种版本

* 同一个版本号也分 2 个版本
  * 社区版（Community Server）：自由下载、完全免费
  * 企业版（Enterprise）：无法在线下载、收费，提供技术支持
* 同一个版本分 3 个类型
  * Standard：适合大多数用户
  * Max：Standard + 新特性
  * Debug：Standard + 调试信息（影响性能）

#### MySQL版本的新特性

* 4.1 子查询、UTF-8
* 5.0 2005视图、存储过程、触发器、INFORMATION_SCHEMA 数据库
* 5.1 2008 Event scheduler、Partitioning、Pluggable storage engine API 、Row-based replication、
* 5.5 默认 InnoDB
* 5.6 优化 InnoDB
* 5.7 支持 JSON
* 6.0 FALCON 存储引擎

| 版本 | 年份 | 简介                                                         |
| ---- | ---- | ------------------------------------------------------------ |
| 4.1  | 2004 | R-trees and B-trees, subqueries, prepared statements         |
| 5.0  | 2005 | cursors, stored procedures, triggers, views, XA transactions、INFORATION_SCHEMA |
| 5.1  | 2008 | event scheduler, partitioning, plugin API, row-based replication, server log tables |
| 5.5  | 2010 | 默认 InnoDB、utf16、utf32、utf8mb4、半同步复制、performancn_shema |
| 5.6  | 2013 | InnoDB 优化、TIMESTAMP 存储毫秒、延时复制                    |
| 5.7  | 2015 | JSON、多线程并行复制、多源赋值、引入 sys 系统库、MGR、密码安全性提高 |
| 8.0  | 2018 | NoSQL Document Store, JSON Extended syntax, JSON table       |
* [MySQL - Wikipedia](https://en.wikipedia.org/wiki/MySQL)
* [MySQL 4.1/5.0/5.1/5.5/5.6/5.7各版本的主要区别_chajinglong的专栏-CSDN博客](https://blog.csdn.net/chajinglong/article/details/52939350)

### MySQL的下载与安装

* 各版本下载地址 [[MySQL Product Archives](https://downloads.mysql.com/archives/)](https://downloads.mysql.com/archives/)
  * 压缩包：[MySQL Community Server](https://downloads.mysql.com/archives/community/)
  * 安装包：[MySQL Installer](https://downloads.mysql.com/archives/installer/)
    * 一般只有 32 为的 msi 而且大小很大，还是去第一个那里看
* 下载压缩包即可，解压后点击bin目录的`MySQLInstanceConfig.exe`即可完成配置
* **MySQL 文档**：[MySQL :: MySQL Documentation](https://dev.mysql.com/doc/)

#### 安装MySQL

* Typical：安装常用组件、默认安装到 C:\Program Files\MySQL\MySQL Server5.0
* Complete：安装所有组件、默认安装目录
* Custom：自定义组件、安装目录
  * Will be installed on local hard drive（没有子组件时与完整安装差别不大）
  * Entire feature will be installed on local hard drive（该组件完整安装，如果有子组件的话？）
  * Feature will be installed when required（用到时再安装）
* Lunch the MySQL Instance Configuration Wizard（图形化配置 MySQL）

#### 配置MySQL

* 本来就有默认值，配置只是为了改默认值
* 图形化配置：bin\MySQLInstanceConfig.exe
* 文本化配置：my-xxx.ini
  * my-small.ini：小型数据库
  * my-large.ini：大型数据库
* Detailed Configuration（详细配置）
  * Developer Machine（开发机）：使用最小数量内存
    * Multifunctional Database 多功能数据库：对 InnoDB 和 MyISAM 存取都很快
      * InnoDB 数据文件目录配置界面，默认在安装目录下
      * 并发连接设置界面
    * Transactional Database Only 事务型数据库：优化 InnoDB 但 MyISAM 也能用
    * Non-Transactional Database Only 非事务型数据库：优化 MyISAM 但 InnoDB 不能用
    * 存储引擎可以理解为不同的表类型
  * Server Machine（服务器）：中等内存
  * Dedicated MySQL Server Machine（专用服务器）：可用最大内存
* Standard Configuration（标准配置）

#### Detailed Configuration 详细配置

* Developer Machine - Multifunctional Database - Next - 并发连接设置界面
  * Decision Support (DSS)/OLAP 决策支持系统，需要并发连接数 20（选这个）
  * Online Transaction Processing (OLTP) 在线事务系统，需要并发连接数 500
  * Manual Setting 手动设置并发连接数
* MySQL 网络设置
  * Enable TCP/IP Networking（勾选）
  * Port Number：3306
  * Enable Strict Mode（勾选）
* MySQL 字符集设置
  * Standard Character Set 标准字符集，默认为 Latin1，英语和西欧语支持比较好（先选这个）
  * Best Support For Multilingualism，多语言支持最好的字符集，也就是 utf8
  * Manual Selected Default Character Set/Collation，手工选择字符集
* Windows 选项设置
  * Install as Windows Service（勾选）
    * Service Name（**服务名默认为 MySQL**）
    * Lunch the MySQL Server automatically（勾选，配置完后自动开启服务）
  * Include Bin Directory in Windows PATH（勾选）
* MySQL 安全选项
  * Modify Security Settings（修改 root 密码）
    * 一定要修改默认 root 密码，因为**默认 root 密码为空**
    * Enable root access from remote machines 是否允许远程访问 root
  * Create An Anonymous 创建一个匿名用户（不勾选，会带来安全漏洞）
* 图形化配置完会保存为 \my.ini
* 服务启动 `mysqld --defaults-file=my.ini MySQL`

```ini
[client]
port=3306

[mysql]
default-character-set=latin1

[mysqld]
port=3306

basedir="D:/Program Files/MySQL/MySQL Server 5.5/"
datadir="C:/ProgramData/MySQL/MySQL Server 5.5/Data/"
character-set-server=latin1
default-storage-engine=INNODB
sql-mode="STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
max_connections=100
query_cache_size=0
table_cache=256
tmp_table_size=35M
thread_cache_size=8
myisam_max_sort_file_size=100G
myisam_sort_buffer_size=69M
key_buffer_size=55M
read_buffer_size=64K
read_rnd_buffer_size=256K
sort_buffer_size=256K
innodb_additional_mem_pool_size=3M
innodb_flush_log_at_trx_commit=1
innodb_log_buffer_size=2M
innodb_buffer_pool_size=107M
innodb_log_file_size=54M
innodb_thread_concurrency=18
```

#### Linux 下配置 MySQL

* 配置文件名只能是 my.cnf（Windows 可以是 my.ini）
* 配置文件目录一般是 /etc
* 一般用 MySQL 自带的 cnf 拷贝为 my.cnf，然后稍作改动即可

### MySQL 字符集问题

* 其实 5.5.3 之后就增加了 utf8mb4（emoji），但是这里（5.5.62）不知为啥只有 utf8
* utf8 三字节，只支持 Unicode 中的基本多文种平面（BMP）
* utf8mb4 四字节，支持 emoji、不常用的汉字（如果是 utf8 存 emoji 就会报错）
* **utf8 是阉割版 UTF-8，utf8mb4 才是完整版**
* 最初的 UTF-8 使用 1 ~ 6 个字节，最大编码 31 位的字符
* 最新的 UTF-8 只使用 1 ~ 4 个字节，最大编码 21 位的字符，正好能表示所有的 17个 Unicode 平面
* CHAR 为了向后兼容用的是 utf8，应该总是用 VARCHAR
* select version() 查看版本
* [mysql中utf8和utf8mb4区别 - 彼扬 - 博客园](https://www.cnblogs.com/beyang/p/7580814.html)

```mysql
SELECT * FROM information_schema.character_sets WHERE character_set_name LIKE "utf8%"\G # 检查是否支持 utf8mb4 编码
SHOW CREATE DATABASE test\G # 查看数据库的编码
ALTER DATABASE test CHARACTER SET utf8mb4\G # 设置数据库的编码
```

### MySQL 服务的开启和关闭

* 只有开启了服务，才能够连接并访问
* Windows 管理 MySQL 服务，（注意要管理员权限）

```cmd
netstat -ao # 查看服务状态
# -a 显示所有连接和侦听端口
# -b 显示程序名
# -o 显示PID
# -n 数字形式显示地址和端口号
# netstat 命令在 Windows 很慢 耐心等待
tasklist | findstr PID # 根据 PID 查看程序名

services.msc # 图形界面启动或关闭服务

mysqld --console # 启动服务
mysqld --defaults-file=..\my.ini MySQL # 图形界面启动服务的命令
net start mysql # 服务名要为 MySQL

mysqladmin -uroot shutdown # 关闭服务
net stop mysql
```

* Linux 管理 MySQL 服务

```sh
netstat -nlp | grep mysql
mysqld_safe &
mysqladmin -uroot shutdown
# rpm 安装的 MySQL
service mysql start
service mysql restart
service mysql stop
service mysql status
```

* 启动 MySQL 服务时，加 --console 日志显示在控制台，否则输出到 /data/hostname.err

### MySQL的登录和退出

* -h 指定主机地址
* -u 指定数据库用户名
* -p 指定明文密码，默认手动输入密码，无 -p 则表示无密码
  * 指定密码无需加空格，否则会手动输入密码，而指定的密码被当做要 use 数据库
  * 若无则报错 ERROR 1049 (42000): Unknown database '指定的密码'，并退出
* -P 指定端口，默认 3306 端口
* exit 或 quit 都可以退出，\h 帮助，\c 清屏

```cmd
mysql -hlocalhost -uroot # 等价于只输入mysql
```

* 登录后会显示一些信息
  * Your MySQL connection id is 30 表示服务器目前的连接次数

### 启动服务报 1067

* data 文件夹被删除了，查看 my.ini 的 datadir 字段
* 还是改成安装目录下的 data 目录比较稳，注意目录分隔符是**斜杠**而不是反斜杠
* [window 安装Mysql 5.6 发生系统错误 1067 - 未来-- - 博客园](https://www.cnblogs.com/wei-lai/p/5114093.html)