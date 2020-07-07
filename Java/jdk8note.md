## jdk8学习笔记

### CLASSPATH

* java会严格从CLASSPATH里面找
* javac编译时，如果用到了其它class文件，也需要指定CLASSPATH（可以加速）
* 可以把jar文件当做特殊的文件夹（必须指定jar名称或*代表所有jar文件）
* **Windows用 ; 分隔，Linux用 : 分隔！**

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

* NetBeans 的优势
  * 直接使用已安装的JDK
  * 编译错误信息也是JDK显示的信息
* 设置JDK目录：`netbeans\etc\netbeans.conf`
  
  * `netbeans_jdkhome="JDK的目录"`
* **尽量使用安装包而不是压缩包**
* 创建Java项目的时候，会先**Finding Feature**一下
  * 下载nv-javac（编辑java文件的插件）
  * 装好插件后，以后再新建项目的时候，就没有 Finding Feature 了
* **netbeans字体问题**
  * 默认字体设置为 `Monospaced` 很丑，设置为其它字体如 `Consolas` 中文又显示不了
  * 最简单的方案：安装字体（可能得重启才能显示）
    * 立即生效：`jdk_home\jre\lib\fonts\fallback\`
  * 本质解决方案（影响Java GUI程序）
    * 前面说了netbeans读取的是已安装的java环境（`jdk_home\jre\lib\fontconfig.properties.src`）
    * 可以看到默认字体 monospaced 的搜索顺序是 chinese-ms936 也就是宋体所以很丑
    * 另存为 `fontconfig.properties`，然后改内容
      * 注意：[openjdk用不了](https://www.oschina.net/question/3504093_2278507)（openjdk用的是开源freetype运行没效果）
  * 修改 netbeans 界面字体：`netbeans -fontsize 12`

```
allfonts.chinese-ms936=Microsoft YaHei
allfonts.chinese-ms936-extb=Microsoft YaHei
allfonts.chinese-gb18030=Microsoft YaHei
allfonts.chinese-gb18030-extb=Microsoft YaHei
allfonts.chinese-hkscs=Microsoft YaHei
allfonts.chinese-ms950-extb=Microsoft YaHei

sequence.monospaced.GBK=alphabetic,chinese-ms936,dingbats,symbol,chinese-ms936-extb
sequence.monospaced.GB18030=alphabetic,chinese-gb18030,dingbats,symbol,chinese-gb18030-extb

monospaced.plain.alphabetic=Consolas
monospaced.bold.alphabetic=Consolas Bold
monospaced.bolditalic.alphabetic=Consolas Italic
monospaced.bolditalic.alphabetic=Consolas Bold Italic

filename.Consolas=CONSOLA.TTF
filename.Consolas_Bold=CONSOLAB.TTF
filename.Consolas_Italic=CONSOLAI.TTF
filename.Consolas_Bold_Italic=CONSOLAZ.TTF
```

* 参考：
  * [Netbeans8.1设置Consola字体并解决中文乱码问题 - 白超华 - 博客园](https://www.cnblogs.com/bc8web/p/5767548.html)
  * [OpenJDK8编译后遇到字体绘制问题 - OSCHINA](https://www.oschina.net/question/3504093_2278507)
  * [修改NetBeans默认字体 - 念月思灵 - 博客园](https://www.cnblogs.com/xxpal/articles/1219354.html)

### break continue

* break 可跳过区块标签
* continue 只能跳过循环标签

```java
back: {
    for (int i = 0; i < 10; i++)
        if (i == 9) {
            System.out.println("break");
            break back;
        }
}
```

### JDK8 的编码

* Java源代码：Unicode 6.2.0
* JVM虚拟机：UTF-16 Big Endian（**字符占 2 个字节**）

### JDK7 之后的 switch

*  整数、字符、字符串、Enum（以前只支持整数）

### Autoboxing Unboxing

* JDK5 开始支持自动拆箱装箱
* 其实是一种语法糖，在编译器展开

```java
Integer i = 100;
// 自动装箱
Integer i = Integer.valueOf(100);

int j = i;
// 自动拆箱
int j = i.intValue();

// 如果传入 null 就会有问题
Integer i = null;
// 展开为
Object localObject = null;
int i = localObject.intValue(); // NullPionterException

// 坑：两个打包器比较不会自动拆箱，而回直接比较实例地址值（缓存范围内一样）

// -128 与 127 之间 返回缓存的 Integer 实例
// low 和 hight 只能在启动 JVM 的时候修改
// java -Djava.lang.Integer.IntegerCache.hight=300 className
public static Integer java.lang.valueOf (int i) {
    if (i >= IntegerCache.low && i <= IntegerCache.hight)
        return IntegerCache.cache[i + (-IntegerCache.low)];
    return new Integer(i);
}
```

### Enhanced for Loop

* 增强型 for 循环

```java
int[][] cords = { // 完整形式为 new int[] [] { ... }
    { 1, 2, 3 },
    { 4, 5, 6 }
};
for (int[] row : cords) { // cords.length == 2
    for (int value : row)
        System.out.printf("%2d", value);
    System.out.printf("%n");
}
```

### 操作数组对象

* 有 new 就有对象，有对象初始值就为 0
* `int[] arr = new int[10];` 相当于 `Arrays.fill(arr, 0);`
* 二维数组是一种嵌套结构，而不是矩阵结构，每一行的长度可以不相等
* 数组复制：
  * System.arraycopy(form, fi, to, ti, n) （需要手动新建数组）
  * Arrays.copyOf(from, n)（自动新建数组）

