### 为什么要有继承

* 继承是为了避免重复，对类进行抽象的一种方法，但也不要滥用继承
* 对于父类来说，继承对子类重复的部分进行抽象，避免重复
* 对于子类来说，继承可以使子类获得一些额外的功能

### 类之间的转换 cast

* cast 也有扮演的意思
* is-a（是一种）：继承可以把子类归类，${子类} 是一种（继承） ${父类}（**反过来不是**）
  * 金鱼是一种鱼，所以金鱼可以赋给鱼
    * 子类可以放在父类
  * 鱼不一定是一种金鱼，也可以是一种鲨鱼，所以鱼不可以赋给金鱼（编译错，但可强制）
    * 父类不一定放在子类
    * 父类能放在子类的前提是，不是父类的直接实例，其实还是那个子类，强转保证就是那个子类
  * 子类一定不能放在子类：金鱼一定不是一种鲨鱼，所以强制也没用（运行错）
  * 以上规则是为了构造适用于所有子类的公共方法
    * 只操作父类部分的方法，避免对每个子类重写方法，也是多态的一种
* **多态**：使用单一接口操作多种类型的对象
  * 以接口和继承实现的多态：次态（subtype）多态（父类型可以操作子类型）
* 对象 **instanceof** 类（测试某类可不可以转为另一类）
  * instanceof 本意是判断对象是否由某类创建（是否为某类的实例，包括继承和接口）

```java
class A {}
class B extends A {}
class C extends A {}

A a = new B(); // B是一种A
// B b = new A(); // 错误 A不是一种B

B b = (B)a; // 转回来会报错 除非强制转换（a不一定是B）
// 强制转换也报错（a真不是C）
// B b = (C)a;
// C c = (C)a;
```

* private 成员可以被继承，但是子类无法直接访问（如果父类不提供公共的访问方法）

### 类图

|            类名            |
| :------------------------: |
|    修饰符 成员名 : 类型    |
| 修饰符 方法名() : 返回类型 |

* 继承
  * 用空心箭头：指向谁就是继承谁
  * 抽象方法、抽象类用斜体表示
* 接口
  * 接口名用 << 书名号 >> 括起来
  * 虚线空心箭头：指向谁就是实现谁
* 修饰符
  * \+ 表示 public
  * \- 表示 private
  * \# 表示 protected

### 重写 Override

* 重写：子类重写父类的方法（也可通过 super 实现新增）
  * super 相当于父类的 this
  * 重写方法的权限范围只能扩大或维持现状，不能缩小
  * 重写方法的返回类型可以是子类型（is-a）（JDK5 之前返回类型也必须一样）
* 经常把父类要重写的方法写成空方法（如果子类没有重写，也不至于报错）（配合次态多态）
* 保证重写：@Override 注解（还有抽象类和抽象方法）
* 静态成员和方法属于类，不存在继承和重写

#### super 作为构造方法

* 如果不显式调用 super 构造方法，会默认调用无参构造方法 super()（总是父类先初始化）
* this 和 super 作为构造方法只能取其一，且只能在构造方法第一行调用
* 注意：手写了构造方法，编译器就不会自动加无参构造方法了（Default Constructor）
  * 如果要手写构造方法，一定要把无参构造方法也加上

### 抽象类和抽象方法

* 子类继承抽象类，必须得实现抽象方法（保证重写）
  * 不实现也可以，子类必须也是抽象类（抽象类可继承抽象类）（添加必须要重写的方法）
* 抽象方法只能存在于抽象类或接口，抽象类可以包含普通方法
* 抽象方法无需写方法体，但要写分号（不用写参数）
* abstract 写在权限关键字的后面
* 子类重写抽象方法也可以用 @Override 注解
* 通过抽象方法，可以先写已经确定的逻辑，不确定的留给子类去实现（Template Method 设计模式）

```java
abstract class A {
    public abstract void fight();
}
abstract class B extends A {
    public abstract void show();
}
class C extends A {
    @Override
    public void fight () {}
    @Override
    public void show () {}
}
```

### protected 成员

* 想被子类继承但又不想完全对外开放（private 可以被继承，但是子类无法直接使用）
* 权限关键字与范围

| 权限关键字   | 同一个类 | 同一个包 | 不同的包   |
| ------------ | -------- | -------- | ---------- |
| public       | 可读写   | 可读写   | 可读写     |
| protected    | 可读写   | 可读写   | 子类可读写 |
| 无（包权限） | 可读写   | 可读写   | 不可读写   |
| private      | 可读写   | 不可读写 | 不可读写   |

### final 关键字与继承

* final 成员在初始化之后无法再被修改（final 初始化可延迟到构造方法）
* final class 表示最后一个子类（无法再被继承）（如 String 类）
* final 方法（跟在修饰符后面），表示该方法最后一次被重写（无法再被其子类重写）（如 Object 的 notify）
  * public static final int a = 1;

### java.lang.Object

* 所有的类都继承自 Object（任何类都是一种 Object 类，也就是说 Obvject 可以装任何东西）
* 新定义的类也会默认继承 Object（除非继承了别的类，但最终还是 Object）
* Object 只要不是 final 方法都经常被重写：toString、equals

#### 重写 toString

* Systen.out.println 传对象也是调用 toString 再打印字符串的

```java
public String toString () {
    return getClass().getName() + "@" + Integer.toHexString(hashCode());
}
```

#### 重写 equals

* 也很容易出错

```java
public boolean equals (Object obj) {
    return this == obj;
}
```

