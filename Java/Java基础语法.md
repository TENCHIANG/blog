## Java基础语法

### 类型

* 基本类型（Primitive Type）
  * 数值型
    * 整数类型（byte 1、short 2、int 4、long 8）
    * 浮点类型（float 4、double 8）
  * 字符型（char 1）
  * 布尔型（boolean 1bit）
* 引用类型（Reference Type ）又叫类类型（Class Type）
  * 类（class）
  * 接口（interface）
  * 数组

```java
public class PrimitiveType {
	public static void main (String[] args) {
		System.out.printf("Byte %x ~ %x%n", Byte.MIN_VALUE, Byte.MAX_VALUE);
		System.out.printf("Short %x ~ %x%n", Short.MIN_VALUE, Short.MAX_VALUE);
		System.out.printf("Integer %x ~ %x%n", Integer.MIN_VALUE, Integer.MAX_VALUE);
		System.out.printf("Long %x ~ %x%n", Long.MIN_VALUE, Long.MAX_VALUE);
		
		System.out.printf("Float %x ~ %x%n", Float.MIN_EXPONENT, Float.MAX_EXPONENT);
		System.out.printf("Double %x ~ %x%n", Double.MIN_EXPONENT, Double.MAX_EXPONENT);
		
		System.out.printf("Character %h ~ %h%n", Character.MIN_VALUE, Character.MAX_VALUE);
		
		System.out.printf("Boolean %b ~ %b%n", Boolean.TRUE, Boolean.FALSE);
	}
}
/*
Byte 80 ~ 7f
Short 8000 ~ 7fff
Integer 80000000 ~ 7fffffff
Long 8000000000000000 ~ 7fffffffffffffff
Float ffffff82 ~ 7f
Double fffffc02 ~ 3ff
Character 0 ~ ffff
Boolean true ~ false
*/
```

* Java采用 Unicode 6.2.0
* JVM结果采用 UTF-16 Big Endian

### System.out.printf

* `%%`：显示百分号
* `%d`：十进制整数（包括 BigInteger）
  * `%o`
  * `%x, %X, %#x, %#X`
* `%f`：十进制浮点数（包括 BigDecimal）
  * `%n.mf`：
    * 总长度为n（包括小数点，不够的左边补空格）
    * 保留m位小数（不够的右边补0）
  * `%e, %E`
* `%s`：字符串（`%S` 表示全转为大写，`%C`同理）
* `%b, %B`：输出真假值
* `%h, %H`：`Integer.toHexString(arg.hashCode())` 十六进制显示
  * 如果 arg 为 null 则输出 null
* `%n`：自适应平台的换行符
  * Windows：`"\r\n"`
  * Linux：`'\n'`
  * MacOS：`'\r'`

### 变量

* 变量分为三类
  * 局部变量（local variable）：语句块定义的变量，生命周期就是在语句块内，如果没有花括号，就是一行
    * 局部变量必须初始化
  * 成员变量（member variable）：也叫实例变量（对象），对象的创建到回收
    * 不用初始化（填充0）
  * 静态变量（static variable）：也叫类变量，类的加载到卸载（程序本身的生命周期）

### 常量

* 使用 final 修饰的叫符号常量（区别字面常量？）

#### 整形常量的四种表示

* 二进制：0b 或 0B 开头（为 0 下同）
* 八进制：0 开头
* 十进制：默认为 int，加 l 或 L 后缀为 long
* 十六进制：0x 或 0X

#### 浮点数常量的两种表示

* 十进制：默认为 double，加 f 或 F 后缀为 float
* 科学计数法
  * aeb 或 aEb（a * 10^b）
  * 其中 a 只能是十进制形式
* 非十进制表示浮点数
  * 二进制、十六进制：直接报错
  * 八进制：忽略前缀当成十进制
    * 011.1 == 11.1
    * 011.1e1 == 11.1e1

#### BigInteger 和 BigDecimal

* BigInteger 任意精度整形
* BigDecimal 任意精度浮点（不允许舍入误差如金融领域）

```java
/**
 * 一般的浮点数减 0.1 三次或以上其结果就不太正常了
 */
import java.math.BigDecimal;

public class TestBigDecimal {
	
	public static void main (String[] args) {
		
		BigDecimal bd = BigDecimal.valueOf(1);
		BigDecimal zeroDotOne = BigDecimal.valueOf(0.1);
		bd = bd.subtract(zeroDotOne);
		bd = bd.subtract(zeroDotOne);
		bd = bd.subtract(zeroDotOne);
		System.out.println(bd.equals(BigDecimal.valueOf(0.7)));
		
		double n = 1;
		n -= 0.1;
		n -= 0.1;
		n -= 0.1;
		System.out.println(n == 0.7); // 0.7000000000000001
		
	}
}
```

### 常量和变量命名规范

* 原则：见名知意
* 成员变量、静态变量、局部变量、方法名：小驼峰
* 常量：大写字母下划线
* 类名：大驼峰

### 综合案例：桌球小游戏项目

```java
import java.awt.*;
import javax.swing.*;

public class BallGame extends JFrame {
	
	Image ball = Toolkit.getDefaultToolkit().getImage("images/ball.png");
	Image desk = Toolkit.getDefaultToolkit().getImage("images/desk.jpg");
	
	int X = 856;
	int Y = 500;
	
	double x = 100;
	double y = 100;
	
	int direction = 1;
	double degree = 3.14 / 3; // 60°
	double speed = 25;
	double percent = 0.1;
	
	void speedDown () {
		if (speed > 0) {
			speed -= percent;
			percent += 0.0001;
		} else if (speed < 0) {
			speed = 0;
		}
	}
	
	void leftAndRight () {
		// 30 小球直径
		// 40 桌子边框
		if (x >= X - 40 - 30) {
			direction = -1;
			percent *= 1.1;
		} else if (x <= 40) {
			direction = 1;
			percent *= 1.1;
		}
		x += direction * speed;
		speedDown();
	}
	
	void upAndDown () {
		x += speed * Math.cos(degree);
		y += speed * Math.sin(degree);
		// 关于x轴对称 上下边界
		// 40 桌子边框
		// 30 小球直径
		// 40 桌子边框
		// 40 标题栏
		if (y > Y - 40 - 30 || y < 40 + 40) {
			degree = -degree;
			percent *= 1.1;
		}
		// 关于y轴对称 左右边界
		if (x > X - 40 - 30 || x < 40) {
			degree = 3.14 * -degree;
			percent *= 1.1;
		}
		
		speedDown();
	}
	
	public void paint (Graphics g) { // 画窗口
		g.drawImage(desk, 0, 0, null);
		g.drawImage(ball, (int)x, (int)y, null);
		
		upAndDown();
	}
	
	void launchFrame () { // 窗口加载
		setSize(X, Y);
		setLocation(50, 50);
		setVisible(true);
		
		while (speed != 0) { // 重绘窗口
			repaint();
			try {
				Thread.sleep(40); // 1000 / 40 = 25fps
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		System.out.println("stop");
	}
	
	public static void main (String[] args) {
		BallGame game = new BallGame();
		game.launchFrame();
	}
}
```

* 图片在这里：[1.8 30分钟完成桌球小游戏项目 | 速学堂教程 - 学的不仅是技术，更是梦想！--尚学堂旗下高端品牌](https://www.sxt.cn/Java_jQuery_in_action/Billiards_Games.html)

![ball](D:\workspace\blog\Java\ball.png)

![desk](D:\workspace\blog\Java\desk.jpg)

### 二元运算符规则

* 左运算数
* 二元运算符
* 右运算数
* 产生一个结果
  * 先全部转为表示范围最大的那个类型，然后再运算
  * 也要注意变量运算和常量运算是不一样的（常量有编译器优化）

#### 整数运算

* 结果默认为 int，除非出现 long
* 就算是 short、byte 也是 int

#### 浮点运算

* 只要有一边是 double，结果就是 double
* 除非两边最为 float，结果为 float

#### 取模运算

* 操作数可以为浮点数
* 取模的结果叫**余数**
* **余数的符号和左操作数相同**

#### 字符串连接符

* 只要一边是字符串，+ 号就是字符串连接符

### 运算符优先级

* 括号运算符优先级最高
* 一元运算符高于二元运算符
* 位运算 > 算数运算 > 逻辑运算 > 赋值运算 > 复合运算符
* 总体来说 **非 > 与 > 或**
  * 位取反 > 位与 > 位异或 > 位或
  * 逻辑非 > 逻辑与 > 逻辑或

### 自动类型装换

* 容量小的自动转为容量大的
  * 容量是指可以表示的**范围**
  * **容量不等于字节数**，如 long 可转为 float （8 -> 4）
* 可以将 **整形常量** 直接赋值给 byte、char 变量而不用转换（float赋值double常量就报错）
  * 编译器检查范围（所以整形变量不行因为编译器无法确定范围）
* 完美转换（容量和字节数都没问题）
  * byte --> short --> int
  * char --> int
  * int --> long, double
* 可能会丢失精度的转换（容量上没问题但是字节数可能不够）
  * int --> float
  * long --> float, double

### 强制类型转换

* 相当于直接从低位开始截取字节数

```java
byte b = (byte)0xffff; // 从低位截取1字节
System.out.println(b); // -1 也就是 0xff 因为有符号 保留符号位取反加一就是 0x81 第一位是符号位所以是 -1
```

* 小数转为整形相当于直接截取掉小数点后面的数字

### switch

* JDK5之前只允许整形和枚举（字符？），jdk7开始支持字符串

### 带标签的 continue break

```java
// 101 到 150 的质数
outer:for (int i = 101; i < 150; i++) {
    for (int j = 2; j < i / 2; j++)
        if (i % j == 0) continue outer;
    System.out.println(i + " ");
}
```

### 方法重载

* 重载的方法，只是名字一样而已，实际上是不同的方法
* 重载的特点：（传不同的参数，有不同的行为）
  * 形参的**类型、个数、顺序**不同（与形参名称无关）
  * 只有返回值不同不构成重载（主要看形参）

### 递归

* 能用递归实现的，迭代也能实现，只不过递归更简单、优雅、清晰
* 递归的缺点就是占用内存大、速度慢
  * 当然有**尾递归优化**：直接返回递归调用