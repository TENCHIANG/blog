### classpath 的特点

* classpath 没设置默认从**默认 jar 和当前目录**开始找
  * 默认的 jar 路径一般为 Java 根目录下 jre\lib 目录下的 jar 包
  * 默认的 jar 路径与**类加载器**有关
* classpath 如果设置了，则会**替换**当前目录，然后**严格**按照所设置的找
* 有两种设置 classpath 的方法
  * 设置 CLASSPATH **环境变量**（一般大写）
  * 调用 java 或 javac 时**用命令参数** -cp 指定（**优先**）
    * -cp + 空格 + 若干目录（分号分隔多个目录，通常第一个为当前目录）
  * 如果是 jar 包，则需指定**完整**的 jar 包的路径（把 jar 包当**目录**）
  * 可以用星号 * 表示目录下的**所有** jar 包
* classpath 对于虚拟机 java 的意义就是从哪里找 class 文件
* classpath 对于编译器 javac 的意义
  * 有其它目录的类文件需要指定 classpath 
  * 有其它目录的源文件则要指定 sourcepath

### 源代码搜索目录 sourcepath

* 用 javac 编译时
  * -sourcepath 指定要编译的源代码所引用其它源代码的目录（默认是**当前目录**）
    * 还是要指定要编译的源代码，sourcepath 只是补充
  * -d 指定要生成字节码的目录（默认当前目录）
    * 注意 JDK8 中，-d 指定的文件夹要先生成（不能自动生成）
  * -verbose 查看编译细节（-verbose 的输出使用**逗号**分隔目录）
  * -sourcepath 可以分开源代码和字节码文件

```java
public class Console { // src/Console.java
    public static void writeLine(String text) {
        System.out.println(text);
    }
}
public class Main { // src/Main.java
    public static void main (String[] args) {
        Console.writeLine("Hello World!");
    }
}
// mkdir classes
// javac -sourcepath src -d classes src/Main.java -verbose
// java -verbose:class -cp classes Main > verbose_class.txt
```

#### javac 的编译顺序

* 先检查 sourcepath 有没有使用到的源代码
* 在检查 classpath 有没有已编译的字节码
* 检查如果源代码有改变或者还未被编译
  * 则编译源代码放入 -d 指定目录（不指定则当前目录），否则不编译
  * 注意，**指定**的源代码一定会被重新编译
* -encoding 以什么编码读取源代码（默认系统编码）
  * 源代码可多种编码，字节码为 UTF-16 Big Endian 编码
  * javac 不支持 UTF-8 BOM 编码的**源代码**，而要使用 UTF-8
  * JDK8 **字符类型**似采用 Unicode 6.2.0（UTF-8）
    * 源代码可多种编码，但是转为字节码的时候，会以 UTF 8 编码的转译形式
  * **字节码**恒为 UTF-16 Big Endian（每字符等长 2 字节）

#### java 虚拟机的执行顺序

* -verbose[:class|:gc|:jni] 默认是 class
* **类是最后一个参数**，否则在类后面使用 java 命令的参数会无效
* 如果要执行有 package 关键字的字节码，则要使用**全限定名**

### 用 package 管理类

* 包名一般是小写点分隔（也有大写）
* package 语句必须是**第一行非注释代码**
* 为了不重复，还会以域名的倒序作为包的开头
* **全限定名 Fully Qualified Name**：包名 + 类名
  * 如果不用全限定名，则只能用 import
* 在包之间可以可以直接使用 public 类和方法（构造方法无修饰符默认为 public）
* 源代码和字节码要放在包名对应的文件夹中，而它们又不一定在同一个文件夹
  * 项目名 + src + 包名 + 源代码
  * 项目名 + classes（有的 IDE 为 out） + 包名 + 字节码
  * 项目目录则为 classpath 和 sourcepath

### 用 import 偷懒

* 使用 import 可以避免写包名，但是要注意冲突（此时用全限定名）
* import 要明确指定包名或者使用通配符星号（表示包下所有类）
  * java.lang 包不用 import（默认已经 import）
  * 同一个包下的类不用 import
* import 只占编译时间（然后转为全限定名）
* javac 碰到非全限定名的类
  * 先找同包下的类
  * 再找 import 过的包下的类
* **静态导入 import static**（导入类的静态成员）
* import 同名冲突的优先级：局部 > 成员 > 重载 > 报错

### jar 命令和 manifest.mf 编写

* 又叫 jar 包、jar 文档
* jar 命令可以压缩（zip）源代码和字节码为 jar 文件（以包的形式）
  * -c 创建 jar 包
  * -t 列出 jar 包信息（加 -v 列出更详细信息）
  * -x 提取所有文件到当前目录
  * -u 添加文件
  * -v 详细输出
  * -f 指定 jar 包名
  * -m 指定清单文件 manifest.mf（如指定 Main-Class）
    * 坑：清单文件的格式很严格（最后一定要有空格）
    * 清单文件名大小写无所谓（可能因为 Windows？），到包里都会变成大写 META-INF\MANIFEST.MF
    * 可以合并的参数 key，value 在后面按顺序空白符分隔（有的参数不能合并具体看 -help）
  * -M 不包含清单文件（也无需指定）
  * -0 （零）纯打包不压缩
  * -C folder . 相当于先进入 folder 再对 folder 目录下的文件打包（jar 包中不包含 folder）
    * 不使用 -C 参数，如果指定目录则连目录一块儿打包（很忠实的把文件放进去，包括文件夹！）
  * -i 添加索引文件 META-INF\INDEX.LIST （注意要在 jar 包生成后）

```sh
jar cvfm classes.jar manifest.mf -C classes .
java -jar classes.jar
jar i classes.jar # 创建索引
jar tvf classes.jar # 列出目录
jar ucf classes.jar xxx # 添加文件xxx

# 以下是清单文件的内容
# Manifest-Version: 1.0
# Created-By: 1.8.0_241 (Oracle Corporation)
# Main-Class: Main # 好像只需要这一行跟下一行即可
# 这是回车（必须包括）

# 索引文件示例
# JarIndex-Version: 1.0
# 回车
# classes.jar
# Console.class
# Main.class
# 回车
```

* jar 命令太类似 tar 命令了
* jar 补充：[jar 和 Java 模块]()
* [jar命令的用法详解 - 在路上------ - 博客园](https://www.cnblogs.com/liyanbin/p/6088458.html)
* [製作 Executable JAR](https://openhome.cc/Gossip/JavaGossip-V2/ExecutableJAR.htm)

### 使用哪个 jre

* jre：Java Runtime Environment（Java 运行环境）

* jre 包括：虚拟机 JVM、Java SE API、部署技术

* jdk 安装的时候可能会有两个 jre
  * Public jre
  * Private jre
* 运行 java 命令的时候，寻找 jre 的顺序
  * 能不能在当前目录下找到原生 dll 链接库（Public jre）
  * 能不能在上级目录找到 jre 目录（private jre）
* 通过设置环境变量 Path 来选择使用哪个 jre（放第一个）

### 字节码的版本信息

* jre 运行字节码时会检查其**版本**（新版本编译的字节码，不一定能在旧版本的 jre 上执行）
  * 查看字节码的版本：javap -p ClassName（其中 major version）
  * 当前 jre 支持的字节码版本 System.getProperty("java.class.version")
  * 当前 jre 的版本信息 System.getProperty("java.runtime.version")
* javac 编译时限定字节码的版本
  * -target 指定**编译**版本（不超过本身）
  * -source 指定**语法检查**版本（-target >= -source）
    * -target 和 -source 都有默认值，如果不匹配则无法通过编译
  * -bootclasspath 指定引导类的路径（有关 Class Loader）
    * 默认为当前版本，如果用了一些新 API，会导致在旧 jre 上无法运行
    * 所以如果 -bootclasspath 不和 -source 匹配则会**警告**
    * Java 9 之前是 rt.jar，之后是模块了
    * 用 -bootclasspath 指定相应版本的 jre\lib\rt.jar 或用 --system 指定 JDK 的目录
  * --system 指定 JDK 路径（指定模块）
  * --release 指定特定版本即可（简化操作）

| Javac 版本 | -target 默认值 | -source 默认值          | 字节码版本 |
| ---------- | -------------- | ----------------------- | ---------- |
| 1.8        | 1.8            | 1.8                     | 52         |
| 1.7        | 1.7            | 1.7                     | 51         |
| 1.6        | 1.6            | 1.5（没有语法上的新增） | 49、50     |
| 1.5        | 1.5            | 1.5                     | 49、50     |

### Java 版本

| Product Version   | Developer Version | Code Name       | 发布日期   | 重大更新      |
| ----------------- | ----------------- | --------------- | ---------- | ------------- |
| J2SE 1.4.0        | JDK 1.4.0         | Merlin（梅林）  | 2002.2.13  |               |
| J2SE 5.0          | JDK 1.5.0         | Tiger（老虎）   | 2004.9.29  |               |
| Java SE 6         | JDK 1.6.0         | Mustang（野马） | 2006.12.11 |               |
| Java SE 7         | JDK 1.7.0         | Dolphin（海豚） | 2011.7.28  |               |
| Java SE 8（LTS）  | JDK 1.8.0         | 无              | 2014.3.18  | Lambda        |
| Java SE 9         | JDK 9.0.0         | 无              | 2017.9     | Module        |
| Java SE 10        | JDK 10.0.0        | 无              | 2018.3     | var           |
| Java SE 11（LTS） | JDK 11.0.0        | 无              | 2018.9     | 执行源代码    |
| Java SE 12        | JDK 12.0.0        | 无              | 2019.3     |               |
| Java SE 13        | JDK 13.0.0        | 无              | 2019.9     |               |
| Java SE 14        | JDK 14.0.0        | 无              | 2020.3     | switch 表达式 |

* 从 Java SE 9 开始，JDK 半年为周期持续发布新版本（常态更新）
* 版本号构成：feature.interim.update.patch
  * feature 每半年更新一次，必须包含新增特性
  * interim 保留用（目前始终为 0）
  * 同一个 feature 下，update 每三个月更新一次（安全、debug）
  * patch 紧急重大修补
* 长期支持版本（LTS, Long-Term-Support）
  * Java SE 8 是 LTS，之前**每三年**一个 LTS 版本
  * LTS 版本维护时间为 3 ~ 6 年
  * 短期支持版本放出后半年就**不再维护**了（放出下一个版本）
  * 结论：要么使用 LTS 版，要么更新最新版
* 2019 年 1 月后，OracleJDK 不能免费用于商用，建议使用 OpenJDK

### Java 名词解释

* J2SE：Java 2 Platform, Standard Edition
* Java SE：Java Platform, Standard Edition（去掉 2）
  * **Java SE 包括 JVM、JRE、JDK、Java 语言**
  * JRE：Java SE Runtime Environment
    * JVM：Java Virtual Machine
    * Java SE API
    * Deployment 部署技术
  * JDK：Java SE Development Kit
* Java EE：Enterprise
* Java ME：Micro

### JCP 与 JSR

* JCP：Java Community Process（组织）
* JSR：Java Specification Request（提案）
  * RI：Reference Implementation（开源的参考实现）
  * TCK：Technology Compatibility Kit（技术兼容测试工具箱）
    * 只有通过 TCK 才能使用 Java 这个商标（Open JDK、IBM JDK）
* JSR 须通过 JCP Executive Committee（执行委员会）投票成为标准

### 反编译

* 利用反编译可以了解 Java 的原理
* JAD：[JAD Java Decompiler Download Mirror](https://varaneckas.com/jad/)
  * 反编译代码有更多的细节
  * 把字节码拖到该 exe 上即可
* JD：[Java Decompiler](https://java-decompiler.github.io)
  * 有 jar 的 GUI 版（可以直接在里面预览）
  * 也有 eclipse 的插件版，在 eclipse 上直接双击字节码即可
    * Download JD-Eclipse ZIP file,
    * Launch Eclipse,
    * Click on *"Help > Install New Software..."*,
    * Drag and drop ZIP file on dialog windows,
    * Check *"Java Decompiler Eclipse Plug-in"*,
    * Click on *"Next"* and *"Finish"* buttons,
    * A warning dialog windows appear because *"org.jd.ide.eclipse.plugin_x.y.z.jar"* is not signed. Click on *"Install anyway"* button.