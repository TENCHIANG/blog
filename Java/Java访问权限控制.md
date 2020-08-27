### 包是库的单元

* 未指定包名就是默认包 default package
* 一个 java 源文件（编译单元）有且只有一个 public 类，且名称与文件名相同
* java 应用程序的单位是 jar 包（Java Archive）
  * jar 包是根据包以目录形式压缩打包类文件
* 类库是一组类文件，用 package 关键字组织在一起（同属一组）
  * 别人想用就得指定包名加上类名使用（全限定名），或者使用 import
  * import 关键字可以导入包的类（明确指定类名或用通配符 *）
  * 如果 import 相同的类，不使用不会报错，**使用则会报错**
* package 语句必须是**第一行非注释代码**
  * 包名一般作为文件夹分割构件（class 文件和 java 文件）
    * 包的层级对应为目录的层级，更方便地管理构件
    * 斜杠或反斜杠的目录分隔符变成点
  * 还可在包前面拼接域名的倒序中增加其唯一性（其实还是目录）
  * 包名都是小写
* Java 解释器根据包查找类文件
  * 环境变量 CLASSPATH，包含一个或多个目录根目录（另外还有标准库目录作为根目录）
    * 如果是 jar 包，则要明确指定 jar 包（当做目录）
    * 如果 CLASSPATH 不包含当前目录（.）则 Java 解释器或编译器不会从当前目录搜索包类文件或源代码
  * 把包名转换为目录（点转为目录分隔符）与上面的根目录拼接再去查找相应的类文件

```java
// com/mindviewinc/simple/Vector.java
package com.mindviewinc.simple;
public class Vector {
    public Vector () {
        System.out.println("com.mindviewinc.simple.Vector");
    }
}
// CLASSPATH=.;D:\JAVA\LIB;C:\DOC\Java
```

### 访问修饰符 Access Specifiers

* 访问修饰符放在定义类、成员前（属性、方法、域）
* public
* protected（继承访问权限）
* 无关键词（只能本包访问，构造方法例外默认为 public）
* private

#### 包访问权限 Package Access

* 默认的访问权限无关键字，表示这个类在包里是可访问的，包外不可被访问（除非用 public 修饰）
  * 可以互相访问的类放在一个包里，不可以的放在另外的包里
* 对某成员访问的方式（不考虑类）
  * 用 public 修饰该成员
  * 成员不加任何访问权限，其他类在同一包内
  * 继承的类可以访问 public 和 protected 的成员（同一包内才能访问不加访问修饰符的成员）
  * 对某成员提供 get / set 方法（accessor 和 mutator）
* 在同一目录下两个默认包的类，可以互相访问各自未经修饰的成员
* 构造方法无修饰符默认为 public
* 无修饰符的类和强制 public 修饰的构造方法，编译没问题，运行报错

#### private

* 除了本类，其它任何类都无法访问 private 成员（即使是同一个包）
  * 辅助成员都可以为 private
  * 阻止访问某些或全部构造器（唯一构造器为 private 则该类不能被继承）

```java
class Sundae {
    private Sundae () {}
    static Sundae makeASundae () {
        return new Sundae();
    }
}

public class IceCream {
    public static void main (String[] args) {
        Sundae x = Sundae.makeASundae();
    }
}
```

#### protected 继承访问权限

* protected 表示该成员**可以被继承**，但又不可以被其他成员直接调用（public）
  * protected 成员可以被子类调用，不能被其它包调用

#### 接口和实现

* 实现隐藏 implementation hiding：访问控制 access control
* 封装 encapsulation：将数据和方法包装进类中并把具体实现隐藏（带有状态特质和行为的数据类型）