## Java的类型、变量、运算符

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
  * 静态变量（static variable）：也叫类变量，类的加载到卸载

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







