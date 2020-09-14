### 流 Stream 的设计概念

* Java 将输入输出抽象化为流，数据有来源有目的，衔接两者的就是流对象
  * **取出数据用输入流** java.io.InputStream（来源）
  * **存储数据用输出流** java.io.OutputStream（目的）
  * 不管数据从何而来要往何处去，只需以上两个流，read 和 write 都是统一的
  * InputStream 和 OutputStream 都实现了 java.io.Closeable
  * 其父接口为 java.lang.AutoCloseable，因此可使用 JDK7 的 try-with-resources 语法

```java
import java.io.*;
import java.net.URL;
public class IO {
    private static byte[] data = new byte[1024]; // 这个不是缓冲 只是一次读写的单位
    public static void dump (InputStream src, OutputStream dest) throws IOException {
        try (InputStream input = new BufferedInputStream(src);
             OutputStream output = new BufferedOutputStream(dest)) { // JDK9
            for (int len; (len = input.read(data)) != -1;)
                output.write(data, 0, len);
        }
    }
    public static void copy (String src, String dest) throws IOException {
        dump(new FileInputStream(src), new FileOutputStream(dest));
    }
    public static void down (String url, String dest) throws IOException {
        dump(new URL(url).openStream(), new FileOutputStream(dest));
    }
    public static void main (String[] args) throws IOException {
        IO.copy("IO.java", "IO.java.txt");
    }
}
```

* JDK 许多 I/O 操作都会声明抛出 IOException 异常
* 如果想捕捉后转为非检查异常（RuntimeException），可用 JDK8 新增的 java.io.UncheckedIOException
* 注意：**jshell 不存在静态初始化！**

### Stream 的架构

* InputStream、OutputStream 实现了 Closeable（父接口为 AutoCloseable）
* ByteArrayOutputStream 读取到的数据可通过 toByteArray 获取 byte[]
* InputStream
  * FileInputStream
  * ByteArrayInputStream
  * FilterInputStream
    * BufferedInputStream
    * DataInputStream
  * ObjectInputStream
* OutputStream
  * FileOutputStream
  * ByteArrayOutputStream
  * FilterOutputStream
    * BufferedOutputStream
    * DataOutputStream
    * PrintStream
  * ObjectOutputStream

### 标准输入输出

* System.in（InputStream 的实例）
  * 一般是一行一行读取，所以一般用 Scanner 包装使用
  * System.setIn 可重新指定标准输入来源
* System.out（PrintStream 的实例）
  * System.setout 可重新指定标准输出目的
* System.err
  * System.setErr

### FileInputStream 和 FileOutputStream

* FileInputStream 主要实现了 InputStream.read
  * 可用 Scanner 包装使用
* FileOutputStream 主要实现了 OutputStream.write
  * 可用 PrintStream 包装使用
* 两者在不用时要 close 关闭
* 两者皆以字节 byte 为单位

### ByteArrayInputStream 和 ByteArrayOutputStream

* 将 byte[] 当做输入输出
* 也可用 ByteArrayOutputStream.**toByteArray 返回 byte[]**

### 流处理装饰器 Decorator

* InputStream、OutputStream 只提供字节流的基本操作，想要更多功能，就用流的装饰器
* 先读取缓冲区 BufferedInputStream、BufferedOutputStream
* 读写基本类型 DataInputStream、DataOutputStream
* 对象序列化 ObjectInputStream、ObjectOutputStream
* 装饰器只是做一些**加工**处理，不改变本身的行为，就像相框的装饰不改变相片本身

#### DataInputStream 和 DataOutputStream

* 提供读写**基本类型**的方法
  * readXXX 读特定类型
  * writeXXX 写特定类型

```java
import java.io.*;
try (DataOutputStream output = new DataOutputStream(new FileOutputStream(xxx))) {
	output.writeUTF(name);
	output.writeInt(age);
}
try (DataInputStream input = new DataInputStream(new FileInputStream(xxx))) {
	name = output.readUTF();
	age = output.readInt();
}
```

#### ObjectInputStream 和 ObjectOutputStream

* 对象的序列化
* ObjectInputStream.readObject
* ObjectOutputStream.writeObject
* 目标对象必须实现 java.io.Serializable 接口
  * 该接口没有定义任何方法，只做**标识**用
  * 标识该对象可被序列化（Serializable）
  * 如果不希望某些成员被序列化，使用 **transient** 关键字（`private transient String passwd;`）
    * 只能修饰成员变量，不能修饰方法和类（包括本地变量）
    * 静态变量无论是否被 transient，都不会被序列化（也不需要）
    * 由此看出，序列化针对的是对象，而不是类
    * [Java transient关键字使用小记 - Alexia(minmin) - 博客园](https://www.cnblogs.com/lanxuezaipiao/p/3369962.html)

```java
import java.io.*;
public class Member implements Serializable {
    private String number;
    private String name;
    private int age;
    public Member (String number, String name, int age) {
        this.number = number;
        this.name = name;
        this.age = age;
    }
    @Override
    public String toString () {
        return String.format("(%s, %s, %d)", number, name, age);
    }
    public void save () throws IOException {
        try (var output = new ObjectOutputStream(new FileOutputStream(number))) {
            output.writeObject(this);
        }
    }
    public static Member load (String number) 
            throws IOException, ClassNotFoundException {
        try (var input = new ObjectInputStream(new FileInputStream(number))) {
            return (Member)input.readObject();
        }
    }
    public static void main (String[] args) throws Exception {
        for (var member : new Member[] {
            new Member("B1234", "YY", 24),
            new Member("B4567", "LJ", 25)
        }) member.save();
        System.out.println(Member.load("B1234"));
        System.out.println(Member.load("B4567"));
    }
}

```

### 字符处理类 Reader 和 Writer

* InputStream、OutputStream 是读写**字节**的，如果要读取**字符**，就得考虑编码问题了
* Reader 和 Writer 默认使用系统编码、可指定 -Dfile.encoding=UTF-9 来指定其使用的编码
  * `java -Dfile.encoding=UTF-8 CharUtil sample.txt`
  * 如果想在程序运行中改变编码，则需使用 InputStreamReader 和 OutputStreamWriter 作为装饰器
  * [非關語言: 亂碼 1/2](https://openhome.cc/Gossip/Encoding/)

```java
import java.io.*;
public class CharUtil {
    private static char[] data = new char[1024];
    public static void dump (Reader src, Write dest) throw IOException {
        try (src; dest) {
            for (int len; (len = src.read(data)) != -1;) dest.write(data, 0, len);
        }
    }
	public static void main (String[] args) throw IOException {
        var reader = new FileReader(args[0]);
        var write = new FileWriter();
        dump(reader, writer);
        System.out.println(writer.toString());
    }
}
```

### Reader 与 Writer 架构

* InputStream、OutputStream 实现了 Closeable（父接口为 AutoCloseable）
* Writer 读取到的数据可通过 toString 获取 String
* Reader
  * StringReader
  * CharArrayReader
  * InputStreamReader 编码转换
    * FileReader
  * BufferedReader 缓冲提速
* Writer
  * StringWriter
  * CharArrayWriter
  * OutputStreamWriter 编码转换
    * FileWriter
  * BufferedWriter 缓冲提速
  * PrintWriter

### 字符处理装饰器

* 就是 Reader 和 Writer 的装饰器

#### InputStreamReader 和 OutputStreamWriter

* 必须提供字符编码，否则可用 System.getProperty("file.encoding") 获取 JVM 编码

```java
// 扩展 CharUtil
public static void dump (InputStream src, OutputStream dest, String charset)
    	throws IOException {
    dump(new InputStreamReader(src, charset), new OutputStreamWriter(dest, charset));
}
// 使用默认编码
public static void dump (InputStream src, OutputStream dest)
    	throws IOException {
    dump(src, dest, System.getProperty("file.encoding"));
}
CharUtil.dump(
	new FileInputStream("CharUtil.java"),
	new FileOutputStream("CharUtil.txt"),
    "UTF-8"
);
```

#### BufferedReader 和 BufferedWriter

* 为 Reader 和 Writer 提供缓冲
* JDk5 之前，没有 Scanner
  * System.in 是 InputStream 的实例，可以给 InputStreamReader 构造器用（字符编码）
  * InputStreamReader 是一种 Reader，可以给 BufferedReader 构造器用（缓冲）
  * BufferedReader.readLine 读取一行，返回 String（不包括换行符）

```java
BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
String name = reader.readLine();
Systenm.out.printf("%s%n", name);
```

#### PrintWriter

* 用法与 PrintStream 相似
* PrintWriter 除了可以包装 OutputStream 外，还可以包装 Writer
* 提供 print、println、format 等方法