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

### 自动拆箱装箱

* Autoboxing Unboxing
* 想让基本类型像对象一样操作
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

### 类型转换 cast

* narrowing conversion 窄化转换：范围缩小，必须显式类型转换（大桶的水倒到小桶里，可能会损失信息）
* widening conversion 扩展转换：范围扩大，无需显式转换（小桶的水倒到大桶）
* 除了类类型和布尔类型，类型之间都可以转换（类可以在同类之间类型转换）

### 截断和舍入 Truncation and Rounding

* 窄化转换时需要注意截断和舍入
* 截断：浮点转整形时，小数部分会被直接抛弃
* 舍入：浮点转整形时，用 `java.lang.Math.round()` 四舍五入

### 提升 Promotion

* 对基本类型进行算数运算或位运算时，只要比 int 小，就会先自动转为 int 型再进行运算（而不论里面是不是有 int 型）
  * 所以 char byte short int 可以通称为整形，long 是长整型
  * 提升的近义词是对齐
* 通常表达式里类型最大的就是表达式结果的类型

### 操作数组对象

* 对象就是类的**实例**，有 new 就会**新建**对象，有对象就有**初始值**为 0（堆）
* 数组一旦建立，长度就**固定**了
* `int[] arr = new int[10];` 相当于 `Arrays.fill(arr, 0);`
* 二维数组是一种嵌套结构，而不是矩阵结构，每一行的长度可以不相等
* 数组复制：
  * `System.arraycopy(form, fi, to, ti, n) `（需要手动新建数组）
  * `Arrays.copyOf(from, n)`（自动新建数组）

### 字符串对象

* 字符串有常量池，相同的字符串常量用同一个引用
* 只要有 `new` 关键字，那就是生成了新的对象
* 对象内容的比较不要用 `==`（比较地址），而要用 `.equals()`
* **字符串常规操作**
  * `.length()` 字符串长度
  * `.charAt(i)` 返回第 i + 1 个字符（字符串毕竟不是数组）
  * `.toUpperCase()` 新建一个全大写的字符串
* **不可变动（Immutable）字符串**
  * 字符串对象都是不可变动的（**以新建对象来代替修改对象**）
* 字符串连接符 `+`（加号）
  * `"a" + "b"` 等价于` (new StringBuilder()).append("a").append("b").toString()`
  * 也就是说，使用连接运算符会生成新的字符串实例（Immutable字符串）
  * 如果要在循环或递归里不断用字符串连接，不如直接用 `StringBuilder`，更好优化
* 编译器优化的坑

```java
String s1 = "a" + "b";
String s2 = "ab";
System.out.println(s1 == s2); // 看样子是false 其实会返回true

// 反编译展开
String s1 = "ab"; // 编译器优化!
String s2 = "ab";
System.out.println(s1 == s2);
```

### 对象封装

* 封装的主要目的就是**隐藏**对象细节（黑匣子）
* private 类私有
* protected 包私有（可省）
  * 不加修饰符的成员：public
  * 成员只有 public（可省） 和 private
  * 类只有 public 和 protected（可省）

### 构造函数 Constructor

* Java 中，创建（new）和初始化（构造函数）捆绑在一起，不能分别操作
* 如果没有自行编写构造函数，编译器会自动加入默认构造函数（Default Constructor 或 No-arg Constructors）
  * 修饰符为 public static，没有返回值（非 void），返回新建对象引用的是 new
  * 默认构造函数，一是**无参数无内容**的函数，二是编译器**自动加**的（用户编写的一样的也不算）
* 如果手动加了构造函数，编译器就**不会加**默认构造函数了

### 重载重写与多态

* 重载和重写**都是多态**的表现
* 重载（Overload）可以理解成多态的具体表现形式（类中）
  * 参数**类型**和**个数**的不同（甚至**顺序**也可以但不建议）
  * 基本类型的重载和表达式差不多（扩展无需显式转换窄化要）
  * 为什么不以返回值区别重载：如果不适用方法的返回值又该调用哪个呢？
* 重写（Override）是父类与子类之间多态性的一种表现（类与类）
  * 参数类型个数返回值都相同，只有**方法体不同**

### 重载与自动装箱

* **先检查没装箱的**
* 再检查装箱的
* 不定长参数检查
* 找不到，报错

```java
class Some {
    void f (int i) {
        System.out.println("int");
    }
    void f (Integer i) {
        System.out.println("Integer");
    }
}

public class OverloadBoxing {
    public static void main (String[] args) {
        (new Some()).f(1); // int
    }
}
```

* 台湾：因变量 大陆：形参
* 台湾：自变量 大陆：实参

### 终结函数：finalize()

* 清理不是被 new 申请的空间（GC 只处理 new）
* finalize() 在 GC 之前被调用（准备 GC 时）
* finalize() 不是析构函数（destructor）
  * Java 的对象不一定被 GC
  * GC 不是 destruction
  * GC 只与内存有关
  * GC 是为了得到连续的空间（以便在堆新建对象时加速）
* GC 和 finalize 都不一定会发生（GC 本身也有开销，不能完全代替析构函数）
  * 所以应该避免使用终结函数
  * 或者使用终结函数检查不恰当的清理（Termination Condition）

### this：当前对象

* 除了 static，this 可以在任何地方用
* this作为方法调用：**构造函数**
  * 只能在构造函数里调用（作为构造函数的一部分）
  * 只能在构造函数的**第一行**，且只能调用**一次**
* **instance initialization 实例初始化**：创建对象之后，构造函数之前，用 {}（普通初始化的扩展）

### final

* 如果指定初始化：后面则无法修改
* 没有指定初始化：延迟到构造器里初始化，否则报错，后面也无法修改（默认初始化无意义）
* final 前面通常加上 static 也就是 static final，表示类的常量（而不是重复的值）

### static

* 不能用在局部变量，只能用在类的字段（field），表示成员**属于类**（虽然对象也可以访问但不建议）
* 静态数据只占一份内存，而不管创建了多少实例
* 静态变量在默认初始化和指定初始化和普通成员变量没什么两样
* 静态方法（类方法）
  * 相当于把类名当成**命名空间**（全局方法）
  * 静态方法不能调用 this（类成员，除非作为参数传进来）
  * 类方法太多说明设计有问题（非面向对象）
* **static block 静态块**：在类文件加载后执行**一次**（静态初始化的扩展）
  * 静态块类似于只调用一次的静态方法
  * 也叫**静态子句 static clause**

### 对象的创建过程

* 一、静态成员（方法或字段）被**首次**访问时，解释器定位类文件
* 二、静态初始化，只在类文件**首次**加载时进行一次（创建一个 Class 对象）
  * 静态默认初始化
  * 静态指定初始化
  * static{} 静态块
* 三、非静态初始化（new 时）
  * 成员会在方法调用之前按顺序初始化完成（包括构造方法）
  * 默认初始化清零 or 指定初始化
  * {} 实例初始化
* 四、构造器（new 时）
  * 构造器是静态方法
* 初始化总结：**先静后动，静一次，new 多少动多少**

```java
public class StaticBlock {
    static {
        System.out.println("static{}");
    }

    {
        System.out.println("{}");
    }

    StaticBlock () {
        System.out.println("constructor");
    }

     public static void main () {
        System.out.println("main");
     }
}

new StaticBlock();
/*
static{}
{}
constructor
*/

StaticBlock.main();
/*
main
*/
```

#### 成员初始化补充

* Java 保证初始化
  * 类成员默认初始化为 0
  * 局部变量无默认初始化（未初始化使用则报错）
* 指定初始化：可以用成员 A 去初始化成员 B（前提是 A 起码得先定义，否则报错 Illegal forward reference）
  * **初始化顺序**：就算成员在方法之间，在方法（包括构造器）调用之前按顺序初始化
* 只有指定初始化才能**阻止**默认初始化的发生（构造器初始化不能）

### 数组初始化 Array Initialization

* 不允许直接指定数组的大小，要用初始化表达式指定
* 数组的初始化表达式 initialization expression
  * 用花括号抱起来的值序列
  * 类似于 new，但是只能出现在定义的时候（new 可以在任何地方）
* 数组也可以用 new 初始化
  * 可以指定数组大小：`int[] a = new int[0];`
  * 可以指定初始化：`int[] a = new int[] {};`
  * 用 new 初始化数组时，指定大小和指定初始化**不能同时**存在
* 所有数组都有一个只读成员 length（String 则是方法）
  * 数组是特殊的对象（也是 Object 的子类，但其类型不可见），String 则是字符数组的封装
  * 同时 Arrays 类的构造方法是 private 的（无法直接 `new Arrays()`）

```java
int a[] = {};
System.out.println(a.length); // 0

String s;
s = new String(); // 空字符串
System.out.println(s.length()); // 0

System.out.println(s.getClass()); // class java.lang.String
System.out.println(s.getClass().getName()); // java.lang.String

System.out.println(a.getClass()); // class [I 等价于 (new int[0]).getClass()
System.out.println(a.getClass().getName()); // [I

/*
Array type             Corresponding class Name
int[]					[I
int[][]					[[I
double[]				[D
double[][]              [[D
short[]                 [S
byte[]                  [B
boolean[]               [Z
String[]				[Ljava.lang.String;
*/
```



