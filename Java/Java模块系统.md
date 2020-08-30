## Java 模块系统

* 为了管理库的**封装**和**依赖**
* 为了裁剪和安全，使之能够在小型设备用，而不是整个 JRE

### 创建模块

* 模块类似于包，在包目录下多了**模块描述文件（Module descriptor）**
  * 源码目录要多加 module-info.java（描述模块信息）
  * 字节码目录多了 module-info.class（编译后）
* 模块描述文件也需要被编译为 class 文件（虽然只是配置文件）
* 设置自己的模块 exports 以公开 API
* 设置依赖模块
  * 默认依赖 java.base 模块（exports 了 java.lang 等常用包）

```java
// src\tenchiang\Main.Java
package tenchiang;
public class Main {
    public static void main (String[] args) {
        System.out.println("Hello World!");
    }
}
// javac -d classes src\tenchiang\Main.Java
// java -cp classes tenchiang.Main

// src\tenchiang\module-info.java
module tenchiang {}

// javac -d mods/tenchiang src\tenchiang\module-info.java
// javac -d mods/tenchiang src\tenchiang\Main.Java
```

### 使用模块

* 使用 java 命令时
  * --module-path（-p）指定模块路径（类似于 -classpath）
  * --module（-m）指定模块的入口（**模块名/全限定名**）
    * 如果有清单文件则无需全限定名甚至无需该参数

```sh
java -p mods -m tenchiang/tenchiang.Main # 完整调用
java -cp mods/tenchiang tenchiang.Main # 也可以基于目录运行
```

* 使用 jar 命令打包模块
  * -e（--main-class） 指定入口（运行模块）
  * -m（--manifest=） 只需指定模块名（而非清单文件）
  * （以上两个都是指定入口）
  * --release VERSION 把后面指定的文件都放入 META-INF/versions/VERSION/
    * 要与前面的（jar 根目录）不重复（可配合 -C）
      * 若重复则报错 java.util.zip.ZipException: duplicate entry
    * VERSION 版本号必须 >= 9
    * META-INF 如果有重复的或多的 class 文件（比起 jar 根目录），则执行 META-INF 的，否则执行根目录的（保证 jre 运行对应版本的字节码）


```sh
mkdir dist # -c要先建立目录
jar cvfe dist/tenchiang.jar tenchiang.Main -C mods/tenchiang / # . 也可以
# 运行
java -jar dist\tenchiang.jar # 读取清单
java -cp dist\tenchiang.jar tenchiang.Main # 把jar当做classpath
java -p dist\tenchiang.jar -m tenchiang # 因为打包时指定了-e
java -p dist\tenchiang.jar -m tenchiang/tenchiang.Main # 完整调用

javac -sourcepath src -d classes src\tenchiang\Main.java # jdk9编译一下
java -cp classes tenchiang.Main # 运行看看
jar cvfe dist\tenchiang.jar tenchiang.Main -C mods/tenchiang . --release 9 classes . # 打包
jar tf dist\tenchiang.jar # 查看
```

* 在类路径下发现的类，默认为未命名模块（Unnamed module）
  * 未命名模块可以读取其它模块（兼容性）
  * 不能 reuqires 未命名模块（因为没有名字）
  * 所以不要混用类路径和模块路径

### 导出模块和引用模块

* 源代码

```java
// src\tenchiang.util\module-info.java
module tenchiang.util {
    exports tenchiang.util;
}
// src\tenchiang.util\tenchiang\util\Console.java
package tenchiang.util;
public class Console {
    public static void writeLine(String text) {
        System.out.println(text);
    }
}
// src\tenchiang\module-info.java
module tenchiang {
    requires tenchiang.util;
}
// src\tenchiang\tenchiang\Main.java
package tenchiang;
import tenchiang.util.Console;
public class Main {
    public static void main (String[] args) {
        Console.writeLine("Hello World!");
    }
}
```

* 编译及运行（有模块的字节码）
  * -p（--module-path）对应 -cp（-classpath、--class-path）
  * 注意
    * 编译模块和模块描述文件的**顺序**很重要
    * JDK 的命令行工具使用的**路径分隔符**
      * 在 Windows 可以是反斜杠，也可以是斜杠（自动转换）
      * 驱动器号用的是 /d:/（与 mingw /d/ 比多了个冒号）

```cmd
javac -d mods/tenchiang.util src/tenchiang.util/tenchiang/util/Console.java src/tenchiang.util//module-info.java
javac -p mods -d mods/tenchiang src/tenchiang/module-info.java src/tenchiang/tenchiang/Main.java
java -p mods -m tenchiang/tenchiang.Main
java -cp mods/tenchiang;mods/tenchiang.util tenchiang.Main
```

* 编译及运行（有模块的源代码）
  * -sourcepath（--source-path）对应 --module-source-path

```java
javac -d mods --module-source-path src src/tenchiang/tenchiang/Main.java
java -p mods -m tenchiang/tenchiang.Main
```

* 总结：可以看到模块通常和包结合使用（模块名和包名一样，其中源码结构又是包管理的形式）