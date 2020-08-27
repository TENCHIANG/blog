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

### jar 命令和 manifest.mf 编写

* 又叫 jar 包、jar 文档
* jar 命令可以压缩（zip）源代码和字节码为 jar 文件（以包的形式）
  * -c 创建 jar 包
  * -t 列出 jar 包信息
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
    * 不使用 -C 参数，如果指定目录则连目录一块儿打包
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
# Main-Class: Main
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
* [jar命令的用法详解 - 在路上------ - 博客园](https://www.cnblogs.com/liyanbin/p/6088458.html)

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
  * -source 指定**语法检查**版本
  * -bootclasspath 指定引导类（Bootstrap Class Loader）路径（rt.jar 的完整路径）
* 注意
  * 上面说的版本都指的是 javac 的版本
  * -target 和 -source 都有默认值，如果不匹配则无法通过编译（-target >= -source）
  * 如果 -bootclasspath 不和 -source 匹配则会**警告**（ -source 版本的 jre\lib\rt.jar）

| Javac 版本 | -target 默认值 | -source 默认值          | 字节码版本 |
| ---------- | -------------- | ----------------------- | ---------- |
| 1.8        | 1.8            | 1.8                     | 52         |
| 1.7        | 1.7            | 1.7                     | 51         |
| 1.6        | 1.6            | 1.5（没有语法上的新增） | 49、50     |
| 1.5        | 1.5            | 1.5                     | 49、50     |