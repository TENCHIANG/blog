## Java的类型、变量、运算符

### 类型

* Primitive Type
* Reference Type（Class Type）

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

