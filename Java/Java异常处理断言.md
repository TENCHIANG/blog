### 异常处理 Exception Handling

* 一般讲错误或异常都差不多，是同义词，后面降到异常的架构时会详谈
* Java 中所有的异常都会被封装为对象
* 可以尝试（try）捕捉（catch）错误对象后做一些处理
  * 如尝试恢复程序的正常流程
* 注意：若父类异常先被捕获，则 catch 子类异常的代码块就永不会被执行
  * 编译器会检查到这个错误，说子类异常已经被捕获了
  * 把子类异常放在父类异常的前面即可

```java
import java.util.Scanner;
import static java.lang.System.out;
public class Average {
    public static void main (String[] args) {
        ver console = new Scanner(Systen.in);
        var count = 0;
        var sum = 0.0; // var的副作用
        while (true) {
            try {
                var number = console.nextInt();
                if (number == 0) break;
                sum += number;
                count++;
            } catch (InputMismatchException ex) {
                out.printf("略过非整数输入：%s\n", console.next());
            }
        }
        out.prnitf("平均 %.2f%n", sum / count); // %n跨平台回车
    }
}
```

* 多重捕获异常（Multi-catch）：避免重复的操作，可以一次 catch 多个异常（JDK7 起）
  * 注意：多重捕获不得包含继承关系的异常，否则报错

```java
try {
} catch (IOException | InterruptedException | ClassCastException e) {
    e.printStackTrace();
}
```

### 异常的继承架构

* 所有的错误都被封装为对象
* 这些对象都是可抛出（throws）的，继承自 java.lang.Throwable 类
* Throwable 定义了一些方法：取得错误信息、堆栈追踪（Stack Trace）等
* Throwable 有两个子类：java.lang.Error、java.lang.Exception
  * Error 表示严重的系统错误，如硬件错误、JVM 错误、内存不足等
    * Error 和 java.lang.RuntimeException 及其子类一般无需 try-catch 来处理
    * 也处理不了，顶多记录日志做一些善后（所以编译器也不强制要你处理）
  * Exception 表示代码本身的错误，是有能力且必须要做处理的（除了 RuntimeException）
    * 所以通常叫错误处理为异常处理（Exception Handling）
* 如果 throws 了 Throwable 对象，程序没有 catch，最后会由 JVM 捕捉到
* JVM 处理就是：**显示**错误的信息并**中断**程序
* 查看 API 文档，看方法声明 throws 了什么异常，就要处理那个异常
  * 方法定义中的 throws 表示：**调用过程中**，在某些情况下会引发异常，调用者应该有能力处理，所以我抛出，并要求编译器提醒调用者要明确处理（一般**可以挽回**）
* 总结：
  * Java 中代码的错误叫异常，其它处理不了的叫错误
  * 可以挽回的，发生异常再处理，无法挽回的，再之前就要检查好避免异常的发生

#### 受检异常与非受检异常

* **受检异常（Checked Exception）**：编译器编译时检查有无处理，无处理则报错（必须得处理）
  * 除 Error 和 RuntimeException 及其子类之外，必须抛出或捕获，不然编译报错
  * RuntimeException：在某些情况下会引发异常，调用者应在**调用前**就做好检查避免错误（一般**无法挽回**）
  * 受检异常一般表示严重的系统错误，如硬件错误、JVM 错误、内存不足等
  * 所以也处理不了或挽回不了，顶多记录日志做一些善后
* **非受检异常（Unchecked Exception）**：编译器不检查有无处理，代码也无需处理
* **异常的最终归宿是 JVM**：如果一个异常一直没有代码处理，最终会被 JVM 捕获

#### 处理异常的三种方式

* 捕获：try-catch
* 抛出：throws（抛给别人处理）
* 不管：留给 JVM 处理（编译器会检测）

#### Throwable 常用继承

* **Throwable**
  * **Error**
    * VirtualMachineError
    * AssertionError
    * ThreadDeath
  * Exception
    * ReflectiveOperationException
      * ClassNotFoundException
      * InstantiationException
    * IOException
      * FileNotFoundException
      * EOFException
    * InterruptedException
    * **RuntimeException**
      * ArithmeticException
      * ClassCastException
      * IndexOutOfBoundsException（下标越界）
        * ArrayIndexOutOfBoundsException
      * java.util.NoSuchElementException（异常定义在 java.util 而不是 java.lang）
        * java.util.InputMismatchException
* **加粗**表示非受检异常
* ReflectiveOperationException 是 JDK7 及之后新增的类
* JDK6 及之前 ClassNotFoundException 直接继承自 Exception

### 捕获还是抛出

* 对于受检异常才考虑捕获或者抛出，非受检异常不考虑（尽量在程序设计上避免）
* 如果当前方法不足以处理**受检异常**，应用 throws 异常类声明方法
  * throws 的是该受检异常的类型或父类型
  * 受检异常由该方法的调用者处理
  * 该方法只有抛出或捕获异常才能编译通过
  * 受检异常的 throws 声明是方法声明的一部分，也是 API 文档的一部分（异常文档化）
* 为了避免调用者的调用不当，应该抛出**非受检异常**
  * 非受检异常要求调用者要检查好避免该异常的发生，而不是发生了怎么处理
  * 编译器不要求处理非受检异常，而应该让它自动往外传播（中断程序）
  * 处理非受检异常最好方式是不管，让它被 JVM 捕获，显示给人看，然后处理
  * **非受检异常无需 throws 声明**，不然每个经过的方法都得声明一遍，多此一举

### throw 处理再抛出

* 可以 catch 到处理部分，再 throw 异常实例，再用 throws 声明抛出的异常
* **throws 是声明异常（异常的类），throw 是抛出异常（异常的实例）**
* throws 是方法声明的一部分，所以接的是异常的类，表示该方法可能会抛出什么类型的异常
* throw 抛出的是异常实例，可以在方法体的任何地方抛出（一般是 catch 区块）
  * 如果没有 throw 默认也会在异常发生的时候抛出（**异常一旦抛出方法也就结束了**）
  * 所以只要有 throw 语句必须要有 throws 的声明
  * 在任何地方都可 throw 的意思是
    * 如果在 catch 区块 ，表示先捕获异常，做一些处理后再抛出这个异常
    * 如果在其它地方，表示我生成一个异常，再抛出这个异常
* **重抛不会改变堆栈追踪起点**，除非调用异常对象的 fillInStackTrace 方法
  * 重新装填异常堆栈，并返回 Throwable 对象

```java
catch (NullPointerException ex) {
    ex.printStackTrace();
    Throwable t = ex.fillInStackTrace();
    throw (NullPointerException)t;
}
```

### 重抛异常的类型 More Precise Rethrow

* JDK7 及之后，编译器对于重新抛出的异常类型有着更精确的判断

```java
// catch 到的一定是 FileNotFoundException EOFException
// 所以 throws 声明这两个即可，但是 JDK7 之前的编译器不行会报错
public static void doSome (String arg) throws FileNotFoundException, EOFException {
    try {
        if ("one".equals(arg))
            throw new FileNotFoundException();
        else
            throw new EOFException();
    } catch (IOException ex) {
        ex.printStackTrace();
        throw ex;
    }
}
```

### 继承和异常

* 父类某方法声明 throws 某些异常，子类重写该方法时
  * 不声明 throws 任何异常
  * throws 父类声明中的**某些异常**
  * throws 父类声明中**异常的子类**
* 但是不可以
  * throws 父类未声明的其它异常
  * throws 父类声明中异常的父类
* 总结：对于异常的继承，也**只能缩小而不是扩大**（类似权限声明）

### 异常处理要注意的

* **自定义异常**更能编写应用程序特有的错误信息
  * 如捕获异常后，重新抛出自定义异常，表示已经处理一部分了，抛出更精确的异常（范围缩小）
* 自定义异常一般继承 Exception
* 如果调用者可以处理异常，则抛出受检异常
* 如果调用者没有能力处理异常，则抛出未受检异常

```java
try {
} catch (SomeException ex) {
    // 做一些处理 如 Logging
    throw new CustiomizedException("error message...");
}
```

* 未受检异常要求程序员必须处理，造成程序设计上的麻烦
* 因此有些库，完全采用未受检异常（如 Spring 和 Hibernate），给予调用者弹性同时对经验有跟高的要求
* 如果受检异常老是一层一层向外抛出造成麻烦（抛出说明无力处理），就要考虑转为非受检异常了
* 不要**私吞**异常，就是不要 catch 异常了然后什么也不做，会造成 debug 异常困难（只能找哪里 catch 了啥也不做）
* 异常的提示信息和异常本身不符合，会造成困扰或误导
  * 如 catch 到 IOException 就说找不到文档

### 堆栈追踪 Stack Trace

* 异常一般会经历过多个方法，也就是多个堆栈
* 异常对象在抛出传播的过程中，会自动收集堆栈信息，是为堆栈追踪
* 堆栈追踪有助于查看异常发生的根源，以及传播的过程
* 最简单的方法就是直接调用异常对象的 printStackTrace 方法
* printStackTrace 还可配合 PrintStream、PrintWriter 输出到指定地方（如文件）
* 堆栈追踪信息会显示
  * 第一行是异常的类型（全限定名）
  * 然后从发生异常最底层的方法（包括代码所在行数）
  * 开始往上直到调用 printStackTrace 的方法
* javac 编译时会默认把代码行数等调试信息包含在字节码里
  * **-g:none** 表示不包含调试信息（字节码尺寸缩小）
* 除了 printStackTrace，也可以调用 getStackTrace 方法
  * 会返回 StackTraceElement 数组，0 为异常的最底层（第一个 StackTraceElement）
  * 对于每个 StackTraceElement，可以调用一下方法获取各层方法的信息
    * getClassName、getFileName、getLineNumber、getMethodName
    * getModuleName、getModuleVersion、getClassLoaderName（JDK9）
* Throwable 和 Thread 都有 getStackTrace 方法
  * 使用 new Throwable() 或 Thread.currentThread() 取的相应的实例后
  * 再调用 getStackTrace 取得 StackTraceElement 数组
  * JDK9 还增加了 Stack-Walking API

### 断言 assert

* 断言加入于 JDK1.4，为避免与 JDK1.3 及之前代码关键字冲突，JVM 默认不开启断言功能
* java -ea（-enableassertions）开启断言
* 断言有两种语法
  * assert bool_expression; 
    * 表达式若为 false 则发生 java.lang.AssertionError 错误（**未受检**）
  * assert bool_expression : detail_expression;
    * 表达式若为 false 则将第二个表达式的结果显示出来
    * 如果是对象则调用 toString
* 何时使用断言
  * 已经提前准备好某些前置条件（private 方法），然后断言不会出问题
  * 断言后，保证后面结果的正确性
  * 断言对象的状态
  * 用断言取代批注
  * 断言正常流程走不到的地方（断言异常流程）
    * 如 switch 的 default
* 断言是判断程序中某个执行点必然是或不是某个状态
* 不能当做 if 使用，不能算程序正常的执行流程
* 只能算严重错误，未受检错误，开发时用来提升代码质量

#### 防御式程序设计 Defensive Programming

* 开发的时候，可以使用**未受检**异常，让程序直接停在出错的地方（让 bug 无处遁形），实现 Fail Fast
* 但是上线时，就不需要这么严格检测了（主要是为了完善代码），此时可以用断言 assert 取代
  * 开发时使用 -ea 开启断言，上线时取消开关

```java
public void charge (int money) throws InsufficientException {
    checkGreaterThanZero(money); // 前置条件检查
    checkBlance(money);
    balance -= money;
}
private void checkGreaterThanZero (int money) {
    if (money < 0) throw new IllegalArgumentException("不能为负数"); // 未受检异常
}
private void checkBlance (int money) throws InsufficientException { // 受检异常
    if (money > balance) throw new InsufficientException("余额不足", balance);
}
```

* 用断言改造

```java
public void charge (int money) throws InsufficientException {
    assert money >= 0 : "不能为负数";
    checkBlance(money);
    balance -= money;
    assert balance >= 0 : "越不能为负数";
}
```

### 异常与资源管理

* 抛出异常时，原本的执行流程中断
* 后面关闭资源的代码不会被执行，所以也要考虑已打开的资源
* 一般使用 try-catch-finally 和 try-with-resources 关闭资源

### 使用 finally

* try-catch-finally 无论有没有 catch 到异常，都会执行 finally
* 所以可以在 finally 里面关闭资源
* finally 是**一定会被执行**的，就算 try 里面有 return，也是先 finally 再 return

```java
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Scanner;
public class FileUtil {
    public static String readFile (String name) throws FileNotFoundException {
        var sb = new StringBuilder();
        Scanner s = null;
        try {
            s = new Scanner(new FileInputStream(name));
            while (s.hasNext()) sb.append(s.nextLine()).append('\n');
        } finally {
            if (s != null) s.close();
        }
        return sb.toString();
    }
}
```

### 自动关闭资源 try-with-resources

* JDK7 开始的功能（语法糖），简化了 finally 手动关闭资源的麻烦
  * 协助关闭资源，而不是帮你处理异常
* 其实内部对关闭资源本身这个操作，也做了异常处理
* 在使用 try-with-resources 语法时，也不会影响其它的异常处理

```java
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Scanner;
public class FileUtil {
    public static String readFile (String name) throws FileNotFoundException {
        var sb = new StringBuilder();
        try (var s = new Scanner(new FileInputStream(name))) {
            while (s.hasNext()) sb.append(s.nextLine()).append('\n');
        } catch (FileNotFoundException ex) { // 不影响正常的异常处理
            ex.printStackTrace();
            throw ex;
        }
        return sb.toString();
    }
}
```

#### try-with-resources 反编译

* try-catch-finally 也是编译器的语法糖，用 jad 反编译后
* 关闭资源时，直接用异常处理去做 if 用
* JDK7 开始 java.lang.Throwable 的新方法
  * 若一个异常在 catch 后又引发了一个异常，通常会 throw 第一个异常作为响应，然后
  * addSuppressed：将第二个异常记录到第一个异常中
  * getSuppressed：返回 Throwable[]，代表之前被 addSuppressed 的各个异常对象

```java
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Scanner;
public class FileUtil {
    public FileUtil () {}
    public static String readFile(String s) throws FileNotFoundException {
        StringBuilder sb = new StringBuilder();
        try {
            Scanner s = new Scanner(new FileInputStream(s));
            try {
                while(s.hasNext()) sb.append(s.nextLine()).append('\n');
            } catch (Throwable t1) {
                try {
                    s.close();
                } catch (Throwable t2) {
                    t1.addSuppressed(t2);
                }
                throw t1;
            }
            s.close();
        } catch (FileNotFoundException ex) {
            ex.printStackTrace();
            throw ex;
        }
        return sb.toString();
    }
}
```

* JDK9 开始，资源变量不一定要写在 try 括号里面了，等效 final 即可（初始化后不变）

```java
public static String readFile(Scanner s) throws FileNotFoundException {
    var sb = new StringBuilder();
    try (console) {
        while(s.hasNext()) sb.append(s.nextLine()).append('\n');
    }
    return sb.toString();
}
```

#### try-with-resources 支持多个资源

* try 括号里支持多个资源同时管理，用分号分开
* 多个资源的关闭顺序：**越后面的越先关闭**（类似于栈）
  * 反编译可知，每个资源，都独立一个 try-catch，越后面加入的，越是在内层，也就越先关闭

```java
import static java.lang.System.out;
public class AutoCloseableDemoTwo {
    public static void main (String[] args) {
        try (var some = new AutoCloseable() {
                void doSome () { out.println("doSome"); }
                public void close () throws Exception { out.println("some closed"); }
        	};
             var other = new AutoCloseable() {
                 void doOther () { out.println("doOther"); }
                 public void close () throws Exception { out.println("other closed"); }
             }) {
            some.doSome();
            other.doOther();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
```

* jad 反汇编结果

```java
import java.io.PrintStream;
public class AutoCloseableDemoTwo {
    public AutoCloseableDemoTwo() {}
    public static void main (String args[]) {
        try {
            AutoCloseable autocloseable = new AutoCloseable() {
                void doSome () { System.out.println("doSome"); }
                public void close () throws Exception {
                    System.out.println("some closed");
                }
            };
            try {
                AutoCloseable autocloseable1 = new AutoCloseable() {
                    void doOther () { System.out.println("doOther"); }
                    public void close () throws Exception {
                        System.out.println("other closed");
                    }
                };
                try {
                    autocloseable.doSome();
                    autocloseable1.doOther();
                } catch(Throwable throwable1) {
                    try {
                        autocloseable1.close();
                    } catch (Throwable throwable3) {
                        throwable1.addSuppressed(throwable3);
                    }
                    throw throwable1;
                }
                autocloseable1.close();
            } catch (Throwable throwable) {
                try {
                    autocloseable.close();
                } catch (Throwable throwable2) {
                    throwable.addSuppressed(throwable2);
                }
                throw throwable;
            }
            autocloseable.close();
        } catch(Exception exception) {
            exception.printStackTrace();
        }
    }
}
```

### java.lang.AutoCloseable 接口

* 支持 try-with-resources 的资源对象，必须实现 AutoCloseable 接口（如 Scanner）
  * 也叫 AutoCloseable 对象
  * 同为 JDK7 开始的新特性
* 所有继承 AutoCloseable 的子接口和实现类，都可以在 AutoCloseable 的 API 文档上查到

```java
package java.lang;
public interface AutoCloseable {
    void close() throws Exception;
}
```

* 实现 AutoCloseable 接口的例子

```java
import static java.lang.System.out;
public class AutoCloseableDemo {
    public static void main (String[] args) {
        try (var res = new Resource()) {
            res.doSome();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
class Resource implements AutoCloseable {
    void doSome () { out.println("doSome"); }
    public void close () throws Exception { out.println("closed"); }
}
```

