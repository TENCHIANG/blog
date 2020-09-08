### 为什么要有接口

* 不要滥用继承，要优先考虑使用接口
* 继承是一种类别的抽象，接口是一种行为的抽象
  * 人也会游泳，但人不是一种鱼
  * 父类对应的也是一种实物（对物品抽象），而接口比继承更加抽象（对行为抽象）
  * 接口避免继承层次太高（人和与抽象为动物）
* 继承：**${子类} 是一种（继承） ${父类}**
* 接口：**${实现类} 拥有（实现） ${接口} 的行为**
  * ${实现类} 可以当做 ${接口} 来用，${实现类} 实例放入 ${接口} 的类型
  * LinkedList 具有 Queue 的行为，可以当做 Queue 来用（LinkedList 实例放入 Queue 的类型）
* **接口也可以继承接口**

### 实现接口

* 接口 interface 是用来实现 implements 的（接口也可拥有抽象方法）
  * 如果是继承多接口则用逗号分开
  * **又有继承又有实现**：先 extends 再 implements
* 接口几乎可以被看做类
  * 定义时 interface 代替 class
  * 作为文件名
  * 也可以作为类型
  * 在多态上，和类继承的多态也是一样的
* 实现接口和继承抽象类，有两种方式
  * 实现接口中的抽象方法
  * 再次将方法重写为抽象方法（抽象类实现接口和继承抽象类）

```java
// Swimmer.java
public interface Swimmer {
    public abstract void swim();
}

// Fish.java
public abstract class Fish implements Swimmer {
    protected String name;
    public Fish (String name) {
        this.name = name;
    }
    public String getName () {
        return name;
    }
    @Override
    public abstract void swim();
}

// GoldFish.java
public abstract class GoldFish extends Fish {
    @Override
    public abstract void swim();
}
```

### 接口是限制的多继承

* Java 是单继承，接口可以理解为限制的多继承
  * 单继承：人是一种动物
  * 多继承：人是一种动物，也是一种游泳者
  * 在 Java 的单继承前提下，继承理解为**是一种（is-a）**的关系，接口理解为**拥有某种行为**的关系
    * 人是一种动物，会游泳
  * JDk8 开始，接口可以有条件的包含方法的实现，而不是有抽象方法（[Lambda](Lambda.md)）
  * 因为单继承和多继承都有其麻烦之处
    * 多继承：设计上容易考虑不周
    * 单继承：设计上多有不便掣肘

### 代码的弹性、可维护性

* 要增加新功能时，只需增加代码，无需修改原来的代码即可（开闭原则）
  * 尽可能使设计好的东西，多适应新的需求，顶多只需增加代码
  * 就算要修改，改的越少越好（高内聚，低耦合）
  * 在方法层面，参数返回值尽量不变，变的是方法体
* 所以要对经常变化的进行抽象，使之方便扩展（方式之一就是接口）
* 也要避免过度设计或过度抽象：过度优化是万恶之源（根据实际需求来）

### 接口定义抽象方法可省略 public abstract

* 接口的方法一般只能是抽象方法且是公共的，也就是 public abstract（但是可以省略）
* 其实是编译器的语法糖（编译器自动加上）
* 接口的抽象方法可以省略，但是抽象类中的抽象方法不可省略（只有接口有）

```java
interface Action {
    void execute(); // public abstract
}
class Some implements Action {
    void execute () { // 编译报错 因为缩小了权限
        System.out.println("execute");
    }
}
public class Main {
    public static void main (String[] args) {
        Action action = new Some();
        action.execute();
    }
}
```

#### 两个接口抽象方法重复

* 假如要实现两个接口时，有相同的抽象方法，直接重写实现是没有问题的
* 但是在设计上不对
  * 如果两个抽象方法是不一样的，那应该取不同的名字
  * 如果两个是一样的，应该再新建一个父接口定义该抽象方法，再由这两个接口继承

### 接口定义常量可省略 public static final

* 在接口中可用 public static final 定义常量
* 也可以省略 public static final，直接定义也是枚举常量（语法糖），但要注意**即时赋值**
  * 同样在类中就没有该语法糖（只有接口有）

```java
// Action.java
public interface Action {
    int STOP = 0; // public static final
    int RIGHT = 1;
    int LEFT = 2;
    int UP = 3;
    int DOWN = 4;
}
// Game.java
public class Game {
    public static void main (String[] args) {
        play(Action.RIGHT);
        play(Action.UP);
    }
    public static void play (int action) {
        System.out.println(switch(action) { // JDK 14 switch 表达式
            case Action.STOP -> "STOP";
            case Action.RIGHT -> "RIGHT";
            case Action.LEFT -> "LEFT";
            case Action.UP -> "UP";
            case Action.DOWN -> "DOWN";
            default -> "Illegal";
        });
    }
}
```

* 其实常量更好用的是枚举 enum

### 枚举 enum

* 枚举是一种语法，enum 关键字限定了 int 的范围（经常与 switch 连用）
  * 直接使用实例 Action.STOP
  * 作为类型使用 Action action
  * 经常与 switch 连用

```java
// Action.java
public enum Action {
    STOP, RIGHT, LEFT, UP, DOWN
}
// Game.java
public class Game {
    public static void mian (String[] args) {
        play(Action.STOP);
        play(Action.UP);
    }
    public static void play (Action action) {
        System.out.println(switch (action) {
                case STOP -> "STOP";
                case RIGHT -> "RIGHT";
                case LEFT -> "LEFT";
                case UP -> "UP";
                case DOWN -> "DOWN";
                // 因为是枚举所以无需 default
        });
    }
}
```

* 枚举本质是由继承特殊的类 java.lang.Enum 实现的
* 直接继承 Enum 类编译会报错（编译器的活）

```java
// Action.java jad 反编译
public final class Action extends Enum {
    public static Action[] values () {
        return (Action[])$VALUES.clone();
    }
    public static Action valueOf (String s) {
        return (Action)Enum.valueOf(Action, s);
    }
    private Action (String s, int i) { // 只能在内部实例化
        super(s, i);
    }
    public static final Action STOP;
    public static final Action RIGHT;
    public static final Action LEFT;
    public static final Action UP;
    public static final Action DOWN;
    private static final Action $VALUES[];
    static {
        STOP = new Action("STOP", 0);
        RIGHT = new Action("RIGHT", 1);
        LEFT = new Action("LEFT", 2);
        UP = new Action("UP", 3);
        DOWN = new Action("DOWN", 4);
        $VALUES = (new Action[] { STOP, RIGHT, LEFT, UP, DOWN });
    }
}
```

### 匿名内部类 Anonymous Inner Class

* 临时需要某个类或接口实现的**实例**，无需额外定义类
* 格式为：**new 父类() | 接口() {};**
* 如果接口只有一个抽象方法，可直接使用 Lambda 表达式（匿名函数）
  * 超过一个就报错：不是函数接口

```java
// 类的实例
Object o = new Object() {
    public String toString () {
        return "xxxx";
    }
};
// 实现接口
interface Some {
    void doSome(); // public abstract
}
Some some = new Some() { // 匿名内部类实现接口
	public void doSome () {
        System.out.println("doSome");
    }   
};
Some some = () -> System.out.println("doSome"); // Lambda实现接口
some.doSome();
```

* 匿名类使用局部变量
  * 在 JDK8 前，匿名内部类只能使用 final 局部变量
  * JDK8 开始，局部变量不强制加 final 只要等效即可（不在匿名类里被修改）
  * 因为匿名类使用局部变量本质上是传值（里面改了，外面改不了）

```java
int numbers[] = {1, 2};
Object obj = new Object() {
    public String toString () {
        return "example: " + numbers[0];
    }
};
System.out.println(obj); // obj.toString()

// jad反编译后
int ai[] = {1, 2};
Object obj = new Object(ai) {
    public String toString () {
        return (new StringBuilder()).append("example: ").apend(x[0]).toString();
    }
    final int x[];
    {
        x = ai;
        super();
    }
};
System.out.println(obj);
```

### 综合示例

```java
// Client.java
public class Client {
    public final String ip;
    public final String name;
    public Client (String ip, String name) {
        this.ip = ip;
        this.name = name;
    }
}
// ClientEvent.java
public class ClientEvent {
    private Client client;
    public ClientEvent (Client client) { this.client = client }
    public String getIp () { return client.ip; }
    public String getName () { return client.name; }
}
// ClientListener.java
public interface ClientListener {
    void clientAdded(ClientEvent event);
    void clientRemoved(ClientEvent event);
}
// ClientQueue.java
import java.util.ArrayList;
public class ClientQueue {
    private ArrayList clients = new ArrayList();
    private ArrayList listeners = new ArrayList();
    public void addClientListener (ClientListener listener) {
        listeners.add(listener);
    }
    public void add (Client client) {
        var event = new ClientEvent(client); // JDK10 局部类型推断
        clients.add(client);
        for (var i = 0; i < listeners.size(); i++) {
            var listener = (ClientListener) listeners.get(i);
            listener.clientAdded(event);
        }
    }
    public void remove (Client client) {
        var event = new ClientEvent(client);
        clients.remove(client);
        for (var i = 0; i < listeners.size(); i++) {
            var listener = (ClientListener) listeners.get(i);
            listener.clientRemoved(event);
        }
    }
}
// MultiChat.java
import static java.lang.System.out;
public class MultiChat {
    public static void main (String[] args) {
        var c1 = new Client("127.0.0.1", "AAA");
        var c2 = new Client("192.168.0.2", "BBB");
        var queue = new ClientQueue();
        queue.addClientListener(new ClientListener() {
        	public void clientAdded () {
                out.printf("$s 从 $s 连线\n", event.getIp(), event.getName());
            }  
        	public void clientRemoved () {
                out.printf("$s 从 $s 断开\n", event.getIp(), event.getName());
            }  
        });
        queue.add(c1);
        queue.add(c2);
        queue.remove(c1);
        queue.remove(c2);
    }
}
```

