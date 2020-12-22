### Lambda 概览

* 等号左边：目标类型（Target type）
  * **形参**也可作为目标类型
* 等号右边：Lambda 表达式
  * `->` 左边：参数列表
    * 只有一个参数可忽略括号
    * 没有参数或多个参数不可忽略括号
    * 忽略参数类型：通过目标类型推导
  * `->` 右边：
    * 忽略花括号：只有一个表达式，表达式结果作为返回值，无结果则不返回
    * 有花括号：多条语句，需要显式返回
    * 不建议写太多语句，可考虑 Method Reference

```java
String[] names = {"YY", "JJ", "DQY"};
Comparator<String> byLength = new Comparator<String>() { // JDK6
    public int compare(String name1, String name2) {
        return name1.length() - name2.length();
    }
};
Comparator<String> byLength = 
    (name1, name2) -> name1.length() - name2.length(); // JDK8
Arrays.sort(names, byLength);
```

* Lambda 前世今生：[專欄文章：Java Lambda Tutorial](https://openhome.cc/Gossip/CodeData/JavaLambdaTutorial/index.html)

### Functional Interface

* Lambda 表达式，是中性的
  * 本身不表示任何类型的实例
  * 但是可以表示目标类型的实现
* 函数式接口还是接口，但是只包含**一个**抽象方法
  * Runnable、Callable、Comparator
  * 只关心方法的**参数**与**返回**值
* JDK8 新功能
  * 允许接口定义**默认方法（Default method）**
  * **@FunctionInterface** 注解接口为函数式接口
    * 若接口本身不符合函数式接口，编译错误

```java
public interface Runnable { void run(); }
public interface Callable<V>{ V call() throws Exception; }
public interface Comparator<T> { int compare(T o1, T o2); }

public interface Func { public void apply(String s); }
Func func = s -> System.out.println(s);
```

### Lambda 的 Context 与 Scope

* Lambda 并非匿名类的语法糖
  * Lambda 的 this：指向**定义**它的上下文（Context）
  * 匿名类的 this：指向新生成的对象

```java
class LambdaThisFinal {
    String s = "{}";
    Runnable r1 = new Runnable() {
        public void run() { System.out.println(this); }
    };
    Runnable r2 = new Runnable() {
        public void run() { System.out.println(toString() + s); }
    };
    Runnable r3 = () -> System.out.println(this);
    Runnable r4 = () -> System.out.println(toString() + s);
    public String toString() { return "Hello"; }
    public static void main(String[] args) {
        // String s = "{}"; 不可，因为this和局部都找不到
        LambdaThisFinal ltf = new LambdaThisFinal();
        ltf.r1.run(); // LambdaThisFinal$1@682a0b20
        ltf.r2.run(); // LambdaThisFinal$2@3d075dc0{}
        ltf.r3.run(); // Hello （this指向ltf实例）
        ltf.r4.run(); // Hello{}
    }
}
```

* 但是 Lambda、匿名类的作用域（Scope）是相似的：都在**父作用域**内
  * 只能用常量：final，或等效 final（JDK8）
    * 为了函数式、为了并行
  * 定义在成员：只能用成员变量
  * 定义在本地：成员变量、本地变量都可以用
  * 静态方法只能访问静态属性，无法直接访问 this（直接 new）

```java
class LambdaThisFinal {
    static String s = "{}";
    public static void main(String[] args) {
        String ss = "[]";
        Runnable r1 = new Runnable() {
            public void run() { System.out.println(s + ss); }
        };
        Runnable r2 = () -> System.out.println(s + ss);
        r1.run(); // {}[]
        r2.run(); // {}[]
    }
}
```

### Method Reference

* 相当于把**函数当做值**来用
  * 用两个冒号代替点，即可把函数当做值，被函数式接口引用
  * 或在函数式接口实现出现的地方，作为替代
  * 为了避免过多的 Lambda 表达式
  * 为了重用现有的 API
* 只要**返回值、参数**一致
  * 函数就可兼容函数式接口，作为函数式接口的实现
  * 静态函数：**包.类::方法**
  * 实例函数：**实例::实例方法**
  * 静态方式引用实例函数：**包.类::方法**
    * 参数一作为实例，实例调用该实例方法
    * 其它参数作为方法的参数

#### 函数式接口引用静态方法

* sort 方法，接收的是 Comparator 接口
* 静态方法 byLength 刚好兼容：接收两个参数，返回 int

```java
public class StringOrder {
    public static int byLength(String s1, String s2) {
        return s1.length() - s2.length();
    }
}
String[] names = {"YYY", "JJ", "DQY"};
Arrays.sort(names, StringOrder::byLength); // byLength 兼容 Comparator 接口
System.out.println(Arrays.toString(names)); // [JJ, YYY, DQY]
```

#### 函数式接口引用实例方法

* JDK8 Iterable 的 forEach 方法，接收的是 Consumer 接口
* out 为 PrintStream 的实例
* 实例方法 println 刚好兼容：接收一个参数，返回 void

```java
List<String> list = Arrays.asList("YYY", "JJ", "DQY"); // List.of JDK9
list.forEach(System.out::println);
new HashSet<>(list).forEach(System.out::println); // 忽略类型
new ArrayDeque(list).forEach(System.out::println); // 都忽略
```

#### 函数式接口以静态方式引用实例方法

* 实例方法 compareTo 也可以兼容：
* 参数一作为实例，实例调用该实例方法
* 其它参数作为方法的参数
* `s1.compareTo(s2)`

```java
String[] names = {"YYY", "JJ", "DQY"};
Arrays.sort(names, String::compareTo);
System.out.println(Arrays.toString(names)); // [DQY, JJ, YYY]
```

### Constructor Reference

* 构造方法，语法上不返回值；实际上返回了值，就是类本身
* 如果只是创建实例，可只引用 `包.类::new`
* **java.util.function.Function** 接口
  * 须实现 R apply(T)
  * 接收 T，返回 R，构造方法可兼容

```java
import java.util.*;
import java.util.function.Function;
public class ConstructorReferenceDemo {
    static class Person {
        String name;
        Person(String name) { this.name = name; }
        public String toString() { return "Person{" + "name=" + name + "}"; }
    }
    static <T, R> List<R> map(List<T> list, Function<T, R> mapper) { // T --> R
        List<R> mapped = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) mapped.add(mapper.apply(list.get(i)));
        return mapped;
    }
    public static void main(String[] args) {
        List<String> names = Arrays.asList("YY", "JJ");
        //List<Person> persons = map(names, name -> new Person(name));
        List<Person> persons = map(names, Person::new);
        persons.forEach(System.out::println);
    }
}
```

#### Interface Default Method

* 在兼容老 API 的情况下，实现函数式的链式调用
  * 新 API 定义在工具类上不合适，修改原来的 API 更不好
  * 于是动接口：默认方法、默认实现
* 用 default 关键字修饰
  * JDK8 除了默认方法（public），还支持静态方法
  * JDK9 开始，支持私有方法、静态私有方法
    * 可被 public 方法调用，用于流程分解
    * 无需加上 default 关键字
  * 区别抽象类：接口无法使用成员
    * 因为接口本身不能定义成员
    * 无法直接改变状态
* 实现接口时，默认方法会 Mix-in 混入：更像多继承了

```java
import java.util.*;
import java.util.function.Consumer; // 通配符 不支持递归
@FunctionalInterface
public interface Iterable<T> {
    Iterator<T> iterator();
    default void forEach(Consumer<? super T> action) {
        Objects.requireNonNull(action);
        for (T t : this) action.accept(t);
    }
}
Arrays.asList("0", "111", "222", "333")
    .filter(s -> s.length() < 3)
    .forEach(System.out::println);
```

### 判断方法的实现版本

* 接口其实是一种多继承
  * 抽象方法、默认方法都会被继承
  * 子类，则要实现抽象方法
  * 在子接口再定义一次父接口的抽象方法（文档化）
* 继承或实现，接口的默认方法
  * 直接使用
  * 重新定义
  * 子接口，还可让默认方法**抽象化**
* 父类：super；父接口：**接口名.super**
* 同级别的，默认方法声明冲突，编译报错，要重新定义
* 不同级别，类 > 接口；重新定义 > 父接口

```java
public interface BigIterable<T> extends Iterable<T> {
    Iterator<T> iterator();
    void forEach(Consumer<? super T> action); // 抽象化
}
```

* 把默认方法就当成普通方法就好了
* 只不过接口还可以把方法变成抽象方法
* 且接口只支持方法（行为），不支持变量（状态）

#### Iterable Iterator Comparator

* Iterable 的默认方法 forEach，迭代 Collection，无需经过 Iterator 实例
* Iterator 的默认方法 forEachRemaining，迭代剩余元素

```java
public interface Iterator<E> {
    default void forEachRemaining(Consumer<? super E> action) {
        Objects.requireNonNull(action);
        while (hasNext()) action.accept(next());
    }
}
```

* Comparator 静态默认方法：nullsFirst、reverseOrder
* 默认方法：thenComparing，组合生成更复杂的 Comparator
  * 每次 thenComparing 都会返回新的 Comparator
  * 由此可以链式组合成更复杂的比较

```java
import java.util.*;
public class Customer {
    private String firstName;
    private String lastName;
    private Integer zipCode;
    public Customer(String firstName, String lastName, Integer zipCode) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.zipCode = zipCode;
    }
    public String toString() {
        return String.format("Customer(%s, %s, %d)", firstName, lastName, zipCode);
    }
    public String getFirstName() { return firstName; }
    public String getLastName() { return lastName; }
    public Integer getZipCode() { return zipCode; }
    public static void main(String[] args) {
        List<Customer> customers = Arrays.asList(
            new Customer("Jing", "Li", 1234),
            new Customer("Irene", "Lin", 1234),
            new Customer("Qingyang", "Deng", 1234)
        );
        Comparator<Customer> byLastName =
            Comparator.comparing(Customer::getLastName);
        customers.sort(
            byLastName
            .thenComparing(Customer::getFirstName)
            .thenComparing(Customer::getZipCode)
        );
        customers.forEach(System.out::println);
    }
}
```

### Functional 与 Stream API

* java.util.function 几种通用的函数式接口（Lambda 形式），优先考虑
  * Consumer、Function、Predicate、Supplier
  * Stream 都有对应的典型应用

```java
void forEach(Consumer<? super T> action);
<R> Stream<R> map(Function<? super T, ? extends R> mapper);
Stream<T> filter(Predicate<? super T> predicate);
<R> R collect(Supplier<R> supplier,
              BiConsumer<R, ? super T> accumulator,
              BiConsumer<R, R> combiner);
```

* java.util.stream
* java.util.Optional

#### Consumer accept forEach

* 接收一个值，不返回
* 不返回结果，是把值消费掉
* 返回结果，是产生了副作用（Side effect）：改变对象状态、输入输出
* Consumer 主要接受实例
* 对于基本类型有：IntConsumer、LongConsumer、DoubleConsumer
* 对于两个实例有：BigConsumer
* 一为实例二为基本类型：ObjIntconsumer、ObjLongConsumer、ObjDoubleConsumer

```java
@FunctionalInterface
public interface Consumer<T> { void accept(T t); }

public interface Iterable<T> {
    default void forEach(Consumer<? super T> action) {
	    Objects.requireNonNull();
        for (T t : this) action.accept(t);
    }
}

Arrays.asList("111", "222", "333").forEach(System.out::println);
```

#### Function apply map

* 接受类型 T，返回类型 R
  * 像数学函数，接受参数做了一些处理，然后返回处理结果
* 子接口有：UnaryOperator，接受 T，返回 T，类似于运算符重载（函数做运算符）
* 基本类型：IntFunction、LongFunction、DoubleFunction
  * IntToDoubleFunction、IntToLongFunction
  * LongToDoubleFunction、LongToIntFunction
  * DoubleToIntFunction、DoubleToLongFunction
* 两个参数，一个返回，三种类型：BiFunction\<T, U, R>
  * 子接口：BinaryFunction，两个参数，一个返回值，都是一个类型
  * 也有其基本类型：-BiFunction、-BinaryFunction 结尾的

```java
@FunctionalInterface
public interface UnaryOperator<T> extends Function<T, T> {}
```

#### Predicate test filter

* 接收一个参数，只返回 boolean 值：判断真假
* Bi-（两个类型参数，返回 boolean）、Int-、Long-、Double-

```java
long count = Stream.of(fileNames)
    .filter(name -> name.endsWith("txt"))
    .count();
```

#### Supplier get collect

* 不接收任何参数，返回值
* 返回值来源：提供容器、固定值、某时某物的状态、某个外部输入、某个按需（On-demand）索取的昂贵运算
* BooleanSupplier、DoubleSupplier、IntSupplier、LongSupplier

```java
<R> R collect(Supplier<R> supplier,
              BiConsumer<R, ? super T> accsumulator,
              BiConsumer<R, R> combiner) { // Stream 的 collect 方法
    R res = supplier.get();
    for (T e : this stream) accsumulator.accept(res, e);
    return res;
}
```

#### Optional 取代 null

* null 根本问题在于语义含糊不清
* 用 Optional 代替 null，可让人强制检查 null
  * 返回 Optional\<T>，包含值或者不含（null）
* 静态方法
  * of：传非 null 值创建实例
  * empty：传 null 值建立实例
  * ofNullable：传非 null 调用 of，否则调用 empty
* 实例方法
  * get：没有包含值，直接 java.util.NoSuchElementException（Fast fail）
  * isPresent：检查包含值，通过后再调用 get
  * orElse：不包含值，则指定替代值
  * map、flatMap

#### Stream 管道操作

* 函数式特性之一就是
  * 内部（Internal）迭代消灭外部（External）迭代（Iteration）
  * 内部迭代的实现是隐藏的，可以优化效率
  * 循环、迭代 ---> 每个状态转换对应一个 map
  * 循环中的 if ---> filter
* **Stream 只能迭代一次**，否则 IllegalStateException
  * 顶层父接口为 AutoClose
  * 直接父接口为 java.util.strean.BaseStream
    * 实现了 close 方法
    * 子接口：IntStream、LongStream、DoubleStream
* 大部分 Stream 无需 close
  * 除非输入输出：Files 的 lines、list、walk
  * 配合 try-with-resource 语法
* Stream API 带来了管道（Pipeline）操作风格
  * 来源（Source）：文件、数组、Set、Map、Generator
  * 零或多个中间操作（Intermediate）：也叫聚合操作（Aggregate）
    * 每个中间操作都返回 Stream 实例，但不会立刻处理
  * 一个最终操作（Terminal）
    * 才会让之前的 Stream 处理
    * 才是返回真正的结果
* 从来源进行一些运算，以求最终结果，是程序设计的常规操作
  * 所以 JDK8 在具有来源概念的 API 上
  * 增加了可返回 Stream 的方法
  * Files.lines、Stream.of、Arrays.stream、Collection.stream

```java
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Optional;
public class LineStartsWith {
    public static void main(String[] args) throws IOException {
        String fileName = args[0];
        String prefix = args[1];
        /*String firstMatchedLine = "no matched line";
        for (String line : Files.readAllLines(Paths.get(fileName)))
            if (line.startsWith(prefix)) {
                firstMatchedLine = line;
                break;
            }
        System.out.println(firstMatchedLine);*/
        Optional<String> firstMatchedLine = Files
                .lines(Paths.get(fileName))
                .filter(line -> line.startsWith(prefix))
                .findFirst();
        System.out.println(firstMatchedLine.orElse("no matched line"));
    }
}
```

* 管道操作的性能
  * Files.readAllLines 返回 List\<String>，包括文件中所有行
  * Files.lines 没有实际读一行，只返回 Stream
    * filter 没有过滤一行
    * findFirst，才会执行 filter
      * 进而要求 lines 返回的 Stream 读一行
      * 若第一行就符合，后续行就无需再读取
      * **惰性求值**（Lazy Evaluation）
* 管道操作也避免编写复杂的流程、运算

```java
import java.util.List;
import java.util.Arrays;
import java.util.stream.Collectors;
public class StreamDemo {
    public static void main(String[] args) {
        List<Player> players = Arrays.asList(
                new Player("YY", 23),
                new Player("JJ", 24),
                new Player("XX", 13)
        );
        /*for (Player player : players)
            if (player.getAge() > 15)
                System.out.println(player.getName().toUpperCase());*/
        players.stream()
                .filter(player -> player.getAge() > 15)
                .map(Player::getName)
                .map(String::toUpperCase)
                .collect(Collectors.toList())
                .forEach(System.out::println);
    }
    static class Player {
        private String name;
        private Integer age;
        public Player(String name, Integer age) {
            this.name = name;
            this.age = age;
        }
        public String getName() { return name; }
        public Integer getAge() { return age; }
    }
}

```

#### Stream reduce

* 从一组数据
  * 求一个数：累加和、平均值、最大最小值 ---> 范围缩减 ---> reduce
  * 按条件筛选到另一个容器 ---> collect
* IntStream 提供了 sum、average（double）、max、min、reduce
  * reduce：初值或初值加回调
  * 若无初值（identity value），默认是第一个元素
  * 若无初值，且返回 Optional 相关类（空数组的可能）

```java
import java.util.List;
import java.util.Arrays;
public class StreamrReduceCollectDemo {
    enum Gender {FEMALE, MALE};
    static class Employee {
        private String name;
        private Integer age;
        private Gender gender;
        Employee(String name, Integer age, Gender gender) {
            this.name = name;
            this.age = age;
            this.gender = gender;
        }
        public String getName() { return name; }
        public Integer getAge() { return age; }
        public boolean isMale() { return gender == Gender.MALE; }
        public boolean isFemale() { return gender == Gender.FEMALE; }
    }
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
                new Employee("Justin", 39, Gender.MALE),
                new Employee("Monica", 36, Gender.FEMALE),
                new Employee("Irene", 6, Gender.FEMALE)
        );
        streamStyle(employees);
        reduceStyle(employees);
    }
    public static void streamStyle(List<Employee> employees) {
        int sum = employees.stream()
                .filter(Employee::isFemale)
                .mapToInt(Employee::getAge)
                .sum();
        double average = employees.stream()
                .filter(Employee::isFemale)
                .mapToInt(Employee::getAge)
                .average()
                .orElse(0);
        int max = employees.stream()
                .filter(Employee::isFemale)
                .mapToInt(Employee::getAge)
                .max()
                .orElse(0);
        Arrays.asList(sum, average, max)
                .forEach(System.out::println);
    }
    public static void reduceStyle(List<Employee> employees) {
        int sum = employees.stream()
                .filter(Employee::isFemale)
                .mapToInt(Employee::getAge)
                .reduce(Integer::sum)
                .orElse(0);
        long average = employees.stream()
                .filter(Employee::isFemale)
                .mapToInt(Employee::getAge)
                .reduce(Integer::sum)
                .orElse(0) / employees.stream()
                .filter(Employee::isFemale)
                .count();
        int max = employees.stream()
                .filter(Employee::isFemale)
                .mapToInt(Employee::getAge)
                .reduce(0, Math::max);
        Arrays.asList(sum, average, max)
                .forEach(System.out::println);
    }
}
```

#### Stream collect

* Collections.toList，返回 Collector 实例
  * supplier：返回 Supplier，怎么建立容器
  * accumulator：BiConsumer，容器输入搜集元素
  * combiner：BinaryOperator，多个容器怎么合并
    * 并行 Stream，会使用多个容器分而治之（Divide and Conquer）
  * finisher：Function，转换为最后的结果容器（可选）

```java
List<Employee> males = employees.stream()
    .filter(Employee::isMale)
    .collect(Collections.toList()) // 返回 Collector
	.collect( // 具体实现
    	() -> new ArrayList(),
        (list, e) -> list.add(e),
        (list1, list2) -> list1.addAll(list2)
    )
    .collect( // 具体事项 用方法引用
		ArrayList::new,
    	ArrayList::add,
    	ArrayList::addAll
	)
;
```

#### Collections 静态方法

* java.util.stream.Collections
* groupingBy，指定字段分组
  * 返回 Map，键（Key）为字段，值（Value）为实例 List
  * 第二个参数，还可进一步操作
    * mapping，对每个实例的字段，进行 toList 操作
      * Map 值为实例某字段的 List
    * reducing，对每个实例进行 reduce 操作
      * 指定初值，指定字段，操作
      * 值为某字段的类型
    * averagingInt，对每个实例，指定 int 字段，进行平均值操作
      * 值为 Double

```java
import static java.util.stream.Collections.*;
Map<Gender, List<Employee>> males = employees.stream()
    .collect(groupingBy(Employee::getGender));
Map<Gender, List<String>> males = employees.stream()
    .collect(
		groupingBy(Employee::getGender,
                   mapping(Employee::getName, toList()))
	);
Map<Gender, Integer> males = employees.stream()
    .collect(
    	groupingBy(Employee::getGender,
                   reducinig(0, Employee::getAge, Integer::sum))
    );
Map<Gender, Double> males = employees.stream()
    .collect(
		groupingBy(Employee::getGender,
                   averagingInt(Employee::getAge))
	);
```

* joining：字符串连接
  * String.join 也可以（JDK8）
  * 接收 CharSequence 实现（如 String）
    * 反过来也可以让实现了 CharSequence 的对象，转为字符串
  * 也接收 Iterable 实现（Set 等）
    * 直接使用 StringJoiner（JDK8）

```java
String names = employees.stream()
    .map(Employee::getName)
    .collect(joining(", "));

String msg = String.join("-", "111", "222"); // "111-222"

List<String> s = Arrays.asList("111", "222");
String m = String.join("-", s);

StringJoiner j = new StringJoiner("-");
String m = j.add("111")
    .add("222")
    .toString();
```

* filtering，JDK9，指定过滤条件，返回 Collector 实例
  * 减少管道层次，建立可重用 Collector

```java
List<Employee> males = employees.stream()
    .filter(Employee::isMale)
    .collect(toList());
List<Employee> males = employees.stream()
    .collect(filtering(Employee::isMale));
```

#### flatMap

