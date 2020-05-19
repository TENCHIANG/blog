## Java包机制

包和类，就像文件夹和文件，解决的是类重名的问题

### package

* package定义包名
* 类的第一句非注释语句
* 域名倒着写.模块名.类名
* 就算不用package，也有默认的包名
* 包与包之间，除了层级关系外，没有任何关系

### import

* 跨包的类引用需要指定包名或者导包
* 导包后调用别的包的类，就像调用自己包的类一样（public）
* import 导包的时候需要指定类名或者通配符（如果重名则优先精确）
* 默认导入 java.lang.*
* 如果导包也重名了，那就用全名

### import static

* 静态导入导入类的静态成员（JDK5）

### 参考

* [jdk8note.md#package](jdk8note.md#package)

