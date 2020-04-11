## jdk8学习笔记

### CLASSPATH

* java会严格从CLASSPATH里面找
* javac编译时，如果用到了其它class文件，也需要指定CLASSPATH（可以加速）
* 可以把jar文件当做特殊的文件夹（必须指定jar名称或*代表所有jar文件）

```sh
# ./Main.java调用了./classes/Console.class
javac -cp classes Main.java
java -cp .;classes Main
```

Main.java

```java
public class Main {
	public static void main (String[] args) {
		Console.writeLine("Hello");
	}
}
```

Console.java

```java
public class Console {
	public static void writeLine (String string) {
		System.out.println(string);
	}
}
```

### SOURCEPATH

* 用来分开java文件和class文件

```sh
# proj/src/ 下有 Main.java Console.java
# Main.java调用了Console.java
cd proj
javac -sourcepath src -cp classes -d classes src/Main.java # classes下就有了两个class文件
java -cp classes Main
```

### javac -verbose

* 用来查看编译详情
* 搜索`-sourcepath`指定的文件夹找源文件
* 搜索CLASSPATH是不是有类文件
  * 先找默认的jar文件（类加载器）
  * 最后找当前目录（没有指定`-cp`的默认操作）
  * 检查是否有编译好的类文件
    * 如果有：检查源代码有改动则重新编译
      * 但是指定的java文件一定会被编译
    * 如果没有：直接编译

### package

* package定义的名称称为 包名（小写字母）
* 就算没有定义包名：默认包
* 源文件、类文件要放在包名相同的文件夹中
* 包名 + 类名 = Fully Qualified Name
  * 同一包间调用：直接使用（public）
  * 不同包间调用：使用全名或import
* 包间直接访问的class或method必须声明为public
* `javac -d`会自动建立对应包的文件夹层级（类文件）

### import

* `import xxx.*;` 有两个相同的类名也没事，调用的时候用全名就好了
* `import java.lang.*;`默认就会有

### 使用IDE

* NetBeans
  * 直接使用已安装的JDK
  * 编译错误信息也是JDK显示的信息
* netbeans版本号
  * **jdk8最高只支持 netbeans9**
    * 不知道为啥netbeans9不支持openjdk8，netbeans8却支持
  * netbeans9在往上就必须得 jdk9了
* 设置JDK目录：`netbeans\etc\netbeans.conf`
  
  * `netbeans_jdkhome="JDK的目录"`
* 执行文件：`netbeans\bin\netbeans64.exe`
* **尽量使用安装包而不是压缩包**
* 创建Java项目的时候，会先Finding Feature一下
  * 下载nv-javac（）
  * 然后就可以启用Java的编辑功能啦
* **netbeans字体问题**
  * 问题描述
    * 默认字体设置为 `Monospaced` 虽然支持中文但很丑
    * 如果设置为其它字体如 `Consolas` 中文又显示不了
  * 最简单的方案：安装字体（又有英文又有中文）
  * 本质解决方案
    * 前面说了netbeans读取的是已安装的java环境
    * 而字体读取的是`%JAVA_HOME%\jre\lib\fontconfig.properties.src`
      * 可以看到默认字体 monospaced 的搜索顺序是 chinese-ms936 也就是宋体所以很丑
      * 只需要把 chinese-ms936 放到后面就好了，然后另存为 `fontconfig.properties`
      * 奇怪的是：[这对openjdk8好像不管用](https://www.oschina.net/question/3504093_2278507)
        * OpenJDK字体处理问题很多，建议用Oracle的JDK
        * JDK 运行没有问题，OpenJDK使用开源freetype，运行有误。

```
monospaced.plain.alphabetic=Courier New
monospaced.plain.chinese-ms950=MingLiU
monospaced.plain.chinese-ms950-extb=MingLiU-ExtB
monospaced.plain.hebrew=Courier New
monospaced.plain.japanese=MS Gothic
monospaced.plain.korean=GulimChe

sequence.monospaced.GBK=chinese-ms936,alphabetic,dingbats,symbol,chinese-ms936-extb

allfonts.chinese-ms936=SimSun
allfonts.chinese-ms936-extb=SimSun-ExtB
allfonts.chinese-gb18030=SimSun-18030
allfonts.chinese-gb18030-extb=SimSun-ExtB
allfonts.chinese-hkscs=MingLiU_HKSCS
allfonts.chinese-ms950-extb=MingLiU-ExtB
```

* 参考：
  * [NetBeans 字体设置_Java_zjl5231123的专栏-CSDN博客](https://blog.csdn.net/zjl5231123/article/details/83434021)
  * [Netbeans8.1设置Consola字体并解决中文乱码问题 - 白超华 - 博客园](https://www.cnblogs.com/bc8web/p/5767548.html)
  * [Windows字体拯救计划(雅黑+monaco+mactype)_运维_云别-CSDN博客](https://blog.csdn.net/qq_35472880/article/details/81266199)



