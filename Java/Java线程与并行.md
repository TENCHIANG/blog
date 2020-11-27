### 并发编程

* 并发是提高**单核**性能，虽然增加了上下文切换的开销，但是避免了**阻塞**（通常是 I/O）
* 实现并发的方式
  * 事件驱动：轮询（底层还是单进程、多线程）
  * 多进程：一个系统运行多个进程，并由系统调度切换
    * 一个进程，一个程序，一个任务，多进程就是多任务
    * 缺点：开销大、操作系统不提供就不支持
  * 多线程：一个进程，多个线程，多个任务
    * 函数式编程：函数没有副作用，以此将任务彼此隔离不干涉（相当于只有常量）
    * 抢占式多线程（preemptive）：调度器中断线程，切换上下文到另一个线程（如 Java）
      * 线程有数量上的限制
    * 协作式多线程（cooperative）：自动放弃控制（让步语句），上下文切换比抢占式开销小
      * 理论上没有数量的限制（手动控制上下文切换）
* 并发的优缺点
  * 缺点：复杂度、容易出错
  * 优点：速度、易于编程（把交织在一起的逻辑分开，如仿真器）、负载均衡（Web）、方便用户（GUI）
* 多线程的机制
  * 一个线程就是在进程中一个单一的顺序控制流（子任务）
  * 底层机制是切分 CPU 时间，感觉上好像每个任务都有其单独的 CPU 一样
  * 多核是真能同时运行多个线程（一个物理核心对应一个线程），超线程的核心表示上下文切换代价更小
* CPU 只有数个核心，但是有很多个线程，如果一个核心的线程处于 Blocked，应该有一个机制（调度器）把该核心分配到另外的线程上，不让核心处于空闲状态
* 单核上的并发速度上不是很快（上下文切换），但是也能完成多任务（有些场景下并发会使代码也会得到简化）
  * 如果有的任务会时常被阻塞，那么单核并发也会提速（I/O 密集型）
  * 如果每个任务都不会被阻塞，那么单核并发反比顺序慢
* 在 CPU 密集型场景下（如破解加密），一个物理核心分配一个线程比较合理（因为每个线程都会极大的占用 CPU 而不会阻塞）

#### 并发的新定义

* 并发是一组性能技术，专注于减少等待
* 这是一组技术：包含很多个技术，互相差别可能很大（这也是并发难以定义的原因之一）
* 这是性能技术：目的就是让程序的速度更快（在 Java 中并发非常难，不到万不得已不要用，就算很简单的并发代码，也会带来很复杂的问题）
* 减少等待是重要且微妙的：程序的某些部分被迫等待，这就是使用并发的时机，而不同的等待对应着多种并发的方法
* 重点是等待，如果没有等待，也就没有提速的空间，只要有了等待，才有多种提速的方法（取决于系统配置，问题的类型等）

### 并发和并行的区别

* 并发（Concurrency）：解决 I/O 密集型问题（I/O-bound）、同时执行多个任务（共享资源的访问控制）
* 并行（Parallelism）：解决 CPU 密集型（compute-bound）、同时在多个地方（处理器）执行一个任务的多个部分（利用额外资源）（分布式）
* Java 用线程（Thread）同时实现并发和并行
* 纯并发（Purely Concurrent）：在单核 CPU 上运行多个任务
* 并发-并行（Concurrent-Parallel）：使用并发技术，生成的程序可以利用更多的处理器并更快地生成结果
* 并行-并发（Parallel-Concurrent）：使用并行编程技术，就算只有单核也可运行（Java8 的 Stream）
* 纯并行：只能运行在多个处理器上
* 有漏洞的抽象（Leaky Abstraction）：
  * 抽象的目标是抽象掉那些对手头的想法不重要的部分以免受不必要的细节影响
  * 有的时候抽象会失效，会暴露出底层的细节，这就是抽象的漏洞
  * 比如 GC 下的内存泄漏：GC 本来是避免手动管理内存时容易发生的内存泄漏，如果自动内存管理下都有内存泄漏，那说明该 GC 是 Leaky Abstraction（除了 GC 就是并发了）
  * 并发的抽象泄露：必须得关注分配多个 CPU 物理核心（关注底层而抽象不起来）
  * [抽象泄漏(leaky abstraction) - Hejin.Wong - 博客园](https://www.cnblogs.com/egger/archive/2013/02/11/2910137.html)

### Risks of threads 线程的风险

#### Safety hazards 安全性风险

* Safety（安全性）：不会发生坏事
* 安全性风险之一就是竞态条件（Race Condition）
* 竞态条件原理：一条语句不是原子操作，分为多个步骤，一个线程读到了另一个线程修改前的值
  * 可能会导致重复操作，返回相同值（导致数据损坏无法预测）
  * 由于指令重排（reordering），实际情况可能更糟
* 解决方案：synchronized，对共享资源的访问进行协调（coordinate），防止线程之间互相干扰
* 如果没有同步（synchronization），就可以随便安排操作的时间和顺序
* 如为了提高性能，缓存变量到寄存器或高速缓存，这对于其它线程是不可见的
* 第十六章详细介绍了 JVM 的顺序保证（ordering guarantees）和同步如何影响这些保证
* 安全性不只是多线程要注意的，单线程也要注意，只是多线程带来了更多安全风险
* 同样的，多线程也带来了单线程不会发生的 liveness failure（活性失效）

#### Liveness Hazards 活性风险

* liveness（活性）：某件正确的事情最终会发生
* liveness failures（活性失效）：某个操作永远无法继续进行
  * 死循环，永远不会执行循环的后面的代码
  * A 等 B 的独占资源，B 永不释放，A 永远等待
  * deadlock（死锁 10.1）、starvation（饥饿 10.3.1）、livelock（活锁 10.3.3）
  * 活性失效取决于不同线程中时间的相对时序（timing）
* hazard：可能会发生的风险（冒险）
* risk：风险本身
* deadlock：互相等待对方先结束，结果永远不会结束（僵持）

#### Performance Hazards 性能风险

* 引入多线程会带来额外的性能风险，可能会造成性能降低：上下文切换的开销、同步机制的开销
  * 过多的线程和过多的 synchronized 会降低多线程的性能优势
* 上下文切换（Context Switch）：调度器（Scheduler）临时挂起（suspend）活动线程转而运行其它线程
* 上下文切换的开销：保存和恢复执行上下文、丢失本地性使 CPU 时间没有花在执行任务上
* 同步机制的开销：同步机制会抑制编译器优化，清除（flush）或使内存的缓存失效，在共享的内存总线上创建同步通信（traffic）
* 第 11 章介绍分析和减少多线程的开销

### Threads are everywhere

* 就算你不用多线程，那你调用的 API 或者库也会帮你用多线程（Timer、Servlet、JSP、RMI）
  * 远程方法调用（Remote Method Invocation, RMI）
  * 就是不同 JVM 之间的代码调用
  * 参数打包（Marshaled）成字节流，通过网络传输然后拆包（Unmarshaled）
* 如果多个线程都会访问到一个对象，要确保这个对象本身是线程安全的（如同步机制）
  * 要么确保代码是线程安全的，要么确保访问的对象是线程安全的
* 只要使用了多线程的 API 和库，一般就避免不了要注意线程安全
* 而 Java 应用大多都是多线程的，所以对于多线程的理解就是必须的

### Thread Safety

* 并发编程其实跟线程和锁关系不大，但这只是达到目的手段
* 本质上是对状态访问操作的管理，特别是 Shared 和 Mutable 的状态
* 对象的状态是对象的成员变量或静态变量
* 对象的状态可能还包括其它相关对象的字段
* 对象状态包含影响该对象外部行为的所有数据

### 进程与线程的概念

* 进程可以理解为一个个任务，线程是子任务，进程里至少有一个线程
* 线程是操作系统调度的最小任务单位，如何调度线程**完全**由操作系统决定
* 进程和线程都是为了实现同时运行多个任务
  * 多进程（每个进程只有一个线程）
  * 多线程（一个进程有多个线程）
  * 多进程多线程（复杂度最高）

#### 进程 vs 线程

* 创建进程比线程开销大
* 进程通信比线程慢
* 多进程比多线程更稳定（线程崩溃会导致整个进程崩溃）
* 进程间的数据是独立的，线程是共享的

### Java 多线程

* 一个 Java 程序是一个 JVM 进程
* JVM 用一个主线程来执行 main 方法
* 在 main 方法中可以启动多个线程
* 多线程模型是 Java 最基本的并发模型
* 网络、数据库、图形界面、Web 等都离不开多线程

### 线程的优先级

* 可对线程设定优先级 Thread.setPriority(int)
  * 范围 1 ~ 10，超出范围则 IllegalArgumentException
  * Thread.MIN_PRIORITY 1
  * Thread.NORM_PRIORITY 默认优先级为 5
  * Thread.MAX_PRIORITY 10
  * 线程的初始优先级与**创建**线程相同
  * getPriority 返回线程优先级
* 优先级越高，操作系统越优先分配 CPU，如果优先级相同，则轮流执行（Round-robin）
* 不能通过设置优先级来确保线程的执行顺序（操作系统决定） 

## 运行线程

* 本质上都是通过 Thread 类的实例 start 方法运行线程，线程再运行其中的 run 方法
  * 继承 Thread 类，重写 run 方法，新建实例并调用 start 方法
    * 可用匿名类直接重写 run 方法，不用新建类
  * 实现 Runnable 接口，实现 run 方法，新建 Thread 类实例并传入实现实例，调用 start 方法
    * 可用 Lambda 直接传入 Thread 构造器，不用新建实现
    * 这是在一个类已经写好无法修改的情况下，适合使用 Runnable
* 注意，不要直接调用 Thread 实例的 run 方法，只会在当前线程执行，不会有新建线程再执行的效果
* 只能通过调用 Thread 实例的 start 方法创建线程，且一个实例只能调用一次
  * java.lang.IllegalThreadStateException：Thread is already started

```java
public class Hare extends Thread { // 1-1 继承 Thread 类
    public void run() {
        for (int i = 0; i < 10; i++) System.out.println(i);
    }
}
new Hare().start();

new Thread(){ // 1-2 Thread 匿名类
    public void run() {
    	for (int i = 0; i < 10; i++) System.out.println(i);
	} 
}.start();

public class Hare implements Runnable { // 2-1 实现 Runnable 接口
    public void run() {
        for (int i = 0; i < 10; i++) System.out.println(i);
    }
}
new Thread(new Hare()).start();

new Thread(() -> { // 2-2 Lambda 传入 Thread 构造器
    for (int i = 0; i < 10; i++) System.out.println(i);
}).start();
```

* 并发把程序划分成多个单独运行的任务，每个任务通过执行线程驱动，执行线程简称线程
* 一个线程是操作系统进程中的单个顺序控制流，进程可以有多个并发执行的任务
* 在编程时，每个任务好像有一个单独的处理器
* 操作系统分配处理器的时间给每个线程
* Java 并发的核心机制是 Thread 类（最初）
* 后来又出现了 Executor 类，用来管理线程
* 后来出现了更好的机制：并行 Stream 和 CompletableFuture 类

#### 线程名称

* 获取当前线程名称 Thread.currentThread().getName()

```java
private static int createCount = -1;
private synchronized static String newName () { // 线程的默认名称
	if (createCount == -1) {
		createCount++;
		return "main"; // main是第0个线程
	} else {
		return "Thread-" + createCount++; // 从Thread-1开始
	}
}
```

#### 指定 Runnable 对象的五种方法

* new Thread(Runnable)
* Runnable, String（线程名）
* ThreadGroup, Runnable
* ThreadGroup, Runnable, String
* ThreadGroup, Runnable, String, long（线程栈大小建议值，取决于 OS）

## 线程状态

* 除了新建和终止，其它状态随时都可能改变的
* **NEW** （新创建）
  * new Thread 实例，但还没调用 start 方法时
* **RUNNABLE**（可运行）
  * 线程实例已调用 start 方法，不代表着能立刻运行，取决有操作系统有没有分配时间片
  * 就算已经在运行，也不代表始终运行，当时间片用完，就会失去运行权，把机会给别的线程
  * 同一时刻一个处理器只能执行一个线程，四核八线程的意思：
    * 物理处理器有 4 个，使用超线程技术扩展到 8 个（逻辑处理器）
    * 能同时执行两个线程，存储四个线程的信息，在这四个线程中互相切换的代价比较小
    * 所以对于操作系统来说，好像有 8 个处理器
    * [CPU：Chip、Core 和 Processor 的关系](/Linux/各种CPU架构.md#cpuchipcore-和-processor-的关系)
    * [请问CPU在同一时间内只执行一个线程吗?_已解决_博问_博客园](https://q.cnblogs.com/q/71113/)
* **BLOCKED**（被阻塞）
  * 被其它线程持有锁、Thread.sleep
* **WAITING**（等待）
  * 等待别的线程执行操作时的状态（被阻塞和等待是不同的）
  * Object.wait、Thread.join、并发包中的 Condition
* **TIMED_WAITING**（计时等待）
  * 有些方法有时间参数，导致进入计时等待，直到条件满足或者超时
  * Thread.sleep、Object.wait、Thread.join、Lock.tryLock、Condition.await 的计时版本
* **TERMINATED**（已终止）
  * run 方法返回，线程正常终止
  * 未捕获的异常导致终止，意外终止
  * 对线程实例调用 stop 方法，通过抛出 ThreadDeath 强行终止，不推荐，可能会损坏数据
  * 线程一旦新建并启动 start，对其调用 isAlive 都为 true，直到线程终止

### 线程的挂起恢复和停止

* suspend resume stop 都不要用
  * suspend 挂起线程，但不释放锁，其它的线程可能会死锁（等待该资源的锁）
  * resume 恢复线程，虽然无副作用，但是和 suspend 配套
  * stop 停止现场，会释放锁，但如果数据没改完，其它线程进来读取的就是损坏的数据
* 而是在 run 里，通过周期性的检查，确定是否应该挂起、恢复和停止，然后再执行相应的操作
* 通常是建立标志，描述线程的状态
* suspend  --> wait
* resume --> notify notifyAll
* stop --> interrupt isInterrupted

### 插入线程

* 一个线程调用另一个线程的 join，可使那个线程先执行完，再执行本线程的其它代码
* 就像把另一个线程加入一个线程的正常的顺序流程一样，保证了顺序，更符合直观
  * 还可以对 join 方法设置等待时间（毫秒），超时还未结束则不再等待
* 线程已结束，线程对象**不会**跟着消亡，还可以访问其状态
* 要在线程 start 后调用 join，否则不会有效果
* 对已经结束的线程调用 join 会**立刻**返回

```java
public class ThreadJoin {
    public static void main(String[] args) throws InterruptedException {
        Thread t = new Thread(() -> {
            System.out.println("222");
            try {
                Thread.sleep(2000); // 再慢也还是得等它先执行完
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
        System.out.println("111");
        t.start();
        t.join(); // 保证顺序1-2-3 保证t执行完
        System.out.println("333");
    }
}
```

* join 内部实现使用了 wait notifyAll 机制

```java
while (isAlive()) wait(); // 线程终止时，运行时调用notifyAll
```

* **调用实例的方法可以理解为对对象发送信号**

### 中断线程

* interrupt 发送中断（改变标志位）
* isInterrupted 检测线程是否已被中断
* interrupted （静态方法）检测并清除当前线程的中断状态

```java
public static boolean interrupted() {
	return currentThread().isInterrupted(true);
}
```

* 中断不会直接结束线程，但会中断阻塞或等待状态（wait、join、sleep、IO）

* 耗时的阻塞操作都应该允许 interrupt 来取消（wait、join、sleep 便是如此）
  * IO 阻塞操作一般是抛出 InterruptedIOException 为 IOException 子类
  * wait、join、sleep 会抛出 InterruptedException，且会**清除**中断状态
* 做这么多都是为了保证线程在阻塞状态时可以被取消

#### 调用 interrupt 方法结束进程

* interrupt  设置线程的中断状态，如果该线程处于阻塞状态，就会抛出 InterruptException
* 所以调用 Thread.sleep 方法的地方，都有可能抛出异常，需要处理
* 所以 interrupt  具有唤醒阻塞线程的效果

```java
public class ThreadInterrupt {
    public static void main(String[] args) {
        Thread t = new Thread(() -> {
            try {
                Thread.sleep(999); // 线程运行就休眠
            } catch (InterruptedException e) {
                System.out.println("被 interrupt 唤醒");
                //e.printStackTrace();
                throw new RuntimeException(e); // 报错更详细
            }
        });
        t.start(); // 主线程开启线程后，线程立刻休眠
        t.interrupt(); // 主线程唤醒线程thread，使之运行异常捕捉那一部分
    }
}
```

* 线程内可调用 **isInterrupted** 方法检查中断状态是否已被改变
  * 调用实例的方法可以理解为对对象发送信号
  * 对一个线程调用 interrupt 方法也可以理解为对那个线程发送中断信号
  * 所以线程内可用轮询的方式调用 isInterrupted 方法接手中断信号

```java
public class ThreadIsInterrupted {
    public static void main(String[] args) throws InterruptedException {
        Thread t = new Thread(() -> {
            while (!Thread.currentThread().isInterrupted()) {
                System.out.println("111");
                try {
                    Thread.sleep(250);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                    break;
                }
            }
        });
        t.start();
        Thread.sleep(1000); // 先让t运行一段时间
        t.interrupt();
        System.out.println("222");
    }
}
```

#### 设置标志位结束线程

* 可以通过设置一个 volatile 的标志位，从另一个线程把这个标志位设置为 false 中断该线程
  * volatile 变量：确保线程能读取到更新后的变量值（可见性）
* 或者通过实现 Runnable 的 stop 方法，在 stop 方法里，改变标志位使线程终止

```java
public class ThreadStop {
    public static void main(String[] args) throws InterruptedException {
        Thread t = new Thread(new Runnable() {
            private volatile boolean running = true;
            public void run() { while (running) System.out.println("111"); }
            public void stop() { running = false; } // 自定义 stop
        });
        t.start();
        Thread.sleep(3);
        t.stop();
        System.out.println("222");
    }
}
```

### 守护线程

* 主线程从 main 方法开始执行，main 方法结束后，一般情况下 JVM 也终止
* 线程分为两种：**用户线程**和**守护线程**，用户线程可以保持 JVM 运行，守护线程不会
* 最后一个用户线程结束时，所有守护线程也会被终止，JVM 随之终止
  * 所以守护线程是为其它线程服务的线程
  * 所以把定时器类的线程设置为守护线程即可
  * isDaemon 判断线程是否为守护线程
* 注意：
  * 主线程不是守护线程
  * 新建线程的类型继承自父线程的类型，在还未 start 之前，可用 isDaemon 判断 setDaemon 设置（否则报错 IllegalThreadStateException）
    * true 设置为守护线程，false 设置为用户线程
  * 如果父守护线程终止了，子守护线程也会终止
  * 守护线程的终止类似于调用 destroy，不会有任何清除的机会，所以守护线程不能持有资源（如打开文件）
* 如果要实现 main 结束 JVM 结束，那么把所有新建的线程设置为守护线程或 join
* 可以调用 System 或 Runtime 的 exit 方法强制结束 JVM，就像对每个线程调用了 destroy
  * 也可以设置在 JVM 关闭之前运行特殊线程（系统编程 - 关闭）
  * 因为 AWT、RMI 创建的线程不一定都是守护线程，所以 exit 方法自有其用处
  * AWT，抽象窗口工具集，Abstract Window Toolkit
  * RMI，远程方法调用，Remote Method Invocation

```java
public class DaemonThread {
    public static void main(String[] args) throws InterruptedException {
        Thread t = new Thread(() -> {
            //Thread.currentThread().setDaemon(true); // 线程已启动无法再设置
            while (!Thread.currentThread().isInterrupted())
                try {
                    System.out.println("111");
                    Thread.sleep(10);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
        });
        t.setDaemon(true);
        t.start();
        Thread.sleep(1000); // 主线程维持5秒
        System.out.println("222"); // 不一定是最后，所以是所有线程结束，守护线程才结束
    }
}
// 线程执行的时间刚好是main做了这一系列操作的时间
// main的操作 新建线程、设置为守护线程、开启线程
// main在执行完后这一些列操作之后就结束了
// 而守护线程在所有非守护线程执行完后也结束了，整个JVM停止
```

* 守护线程相关的内部实现

```java
private boolean daemon = false; // 最一开始默认为用户线程
Thread parent = currentThread();

// 可见线程类型和优先级都继承自父线程
this.daemon = parent.isDaemon();
this.priority = parent.getPriority();

public final void setDaemon(boolean on) {
    checkAccess(); // 检查当前线程是否有权限修改此线程
    if (isAlive()) { // 如果以运行，则报错
        throw new IllegalThreadStateException();
    }
    daemon = on;
}
```

* 而线程组一般也是继承自父线程，除非是 applet

```java
if (g == null) {
    /* Determine if it's an applet or not */
    /* If there is a security manager, ask the security manager what to do. */
    if (security != null) g = security.getThreadGroup();
    /* If the security doesn't have a strong opinion of the matter use the parent thread group. */
    if (g == null) g = parent.getThreadGroup();
}
```

## 同步

* 很多语句不是原子化的，如果多个线程同时执行不同部分，可能会导致**竞态条件**（Race condition）
  * 最基本的就是使用同步，通过监视器（monitor）实现，操作系统级叫互斥锁（Mutual lock）
  * 每个 Java 对象关联一个监视器，线程可以锁定（lock）和解锁（unlock）监视器
* 可以通过**同步语句**和**同步方法**锁定同步代码
  
  * **同步代码**：同步语句的代码块、同步方法的方法体
  * 只有锁定且锁定完成才能执行同步代码
  * 同步代码**执行完成或意外**结束，都会解除锁定
* 可重入：一个对象的同步方法，调用一个对象的另一个同步方法，无阻塞，最外层同步方法返回时才释放锁
  * 可重入是为了递归和避免死锁
  * 一个线程可以锁多次相同的对象，锁定操作和解锁操作一一对应
* 互斥：一个线程可以锁多个不同对象，但一个对象只能被一个线程持有锁
* 任何被不同线程所共享的可变量，都应同步地访问以防止干扰，然而同步需要代价，且有同步之外的方法防止干扰
* 线程要执行的第一个动作要同步
* 将线程最后执行的动作与检测是否已终止的动作同步（isAlive、join）
* 判断线程是否中断要同步：interruptedException、isInterrupted
* 对字段写入默认值也要同步

### 原子操作与内存模型

* 基本变量（long、double 除外，因为 JVM 一次操作是 4 字节 slot）是原子的
* 可以保证只会持有某一个变量写入的值。而不是和别的线程交叉混合的值（一个线程写，多个线程读）
* 但这对于获取 - 修改 - 设置序列（如 ++ -- 运算）没有任何帮助，只能选择同步
* Java **内存模型**：确定内存访问排序、何时确保他们可见的规则
  * 原子访问不保证可见性，线程读取的变量不代表最新的值
  * 不同的线程发现变量更新的顺序也可能完全不同
  * 编译器也可以优化代码

### 死锁

* **死锁**（Dead lock）：不同线程获取不同对象的锁可能会导致死锁（你等我我等你一直等）
* 各自持有不同的锁，各自试图获取对方已持有的锁
* 只要发生死锁就是**无解**，只能强制结束 JVM 解除死锁
* 避免死锁：线程获取锁的顺序要一致
* 资源排序（resource ordering）：对资源排序，线程须以该顺序获取资源的锁
* 把若干资源视为整体，只要涉及到互相调用，就把该整体锁住

```java
// add线程获取A的锁，dec线程获取B的锁（这一步也可能不发生，就是add一口气执行完了）
// add等待dec释放B，dec等待add释放A...
public void add(int m) {
    synchronized(lockA) {
        this.value += m;
        synchronized(lockB) {
            this.another += m;
        }
    }
}
public void dec(int m) {
    synchronized(lockB) {
        this.value -= m;
        synchronized(lockA) {
            this.another -= m;
        }
    }
}
```

* 读写操作**都要**同步，否则无法保证同步的作用
* 同步是重量级锁，代价大，太多同步拖慢速度

### 互斥性可见性和 volatile 变量

* 线程读取变量时，会先拷贝一个副本，然后进行操作，最后写入原处
  * 在此过程中，要是别的线程也在存取该变量，则可能导致**竞态条件**，导致脏读？
* **互斥性**（Mutual Exclusion）：synchronized 是避免同一时间多个线程访问同一个变量互斥性
  * 同步代码的互斥性**包括**可见性
* **可见性**（Visibility）：volatile 每次访问变量时（非数组），保证获取最新值
  * 如果对 volatile 变量有一些非原子操作，如自增自减，也会失去同步效果
  * 还是需要同步，但是都同步了 volatile 关键字也就没必要加了
  * 实现可见性最简单的就是线程**不保存**副本
* 在多线程共享资源的情况下，最佳办法是资源**不可变**（immutable）
  * 要不压根就**不共享**（互斥锁或资源独立），要么将可变限制在单个线程中（读写锁）
* volatile 变量无法代替同步，因为没有提供跨多个动作的原子性
  * 只用来作为简单的标记，如用来编写无锁（lock free）算法

### final 字段与线程安全

* 允许正常多线程访问 == 线程安全（Thread Safe）
  * 不变的类：String、Integer、LocalDate
  * 没有成员变量的类：Math
  * 正确使用同步的类：StringBuffer
* final 是不可变的，且是可见的（如 String）

* 一个类没有特殊说明，默认就不是线程安全的

### 之前发生 happens before

* 使用同步、volatile，可以为同步代码之外的变量读写提供保证（传递性）

```java
static Data data;
static volatile boolean dataReady; // 同步的 getter setter 也成立
// 线程1
data = new Data();
dataReady = true;
// 线程2
if (dataReady) Data d = data;
```

* 可以说线程 1 在线程 2 之前发生

### 同步语句

* 同步语句：synchronized (Expression) { Block }
* 注意同步语句的代码块**必须**加花括号
* 表达式（Expression）

  * 必须为某个**对象**的引用，否则 compile-time）错误
  * 如果为 null，则抛出 NullPointerException

  * 如果表达式求值意外终止，那么整个同步语句就此为止（代码块不执行也不锁定对象）
  * 如果一切正常，就会先获取表达式里对象的锁，然后执行代码块
  * 不管代码块有没有正常执行完，同步语句结束后都会**解锁**监视器
* 获取锁的操作，并不妨碍其它线程访问对象的字段和调用非同步的方法
* 其它锁也可以使用同步方法或语句实现**互斥**（mutual exclusion）
* 同步方法只能获取当前对象（或 Class 对象）的锁，同步方法可以获取**任何**对象的锁
  * 如数组对象应用同步方法直接锁定
* 同步影响性能的地方
  * 锁定对象时，别的线程被阻塞导致的性能下降
  * 锁定操作本身的代价
* 更细粒度的锁：只在共享资源的关键处使用锁，对象不同的方法访问不同资源可使用不同的对象锁
* 注意：同步代码一定是**先锁**定对象再运行
* 同步静态资源时，要锁定 Xxx.class 而不是 this.getClass()，前者一定是父类后者可能是子类的 Class 对象

```java
class Test {
    public static void main(String[] args) {
        Test t = new Test();
        synchronized (t) { // 如果单个线程不允许锁多次 则会造成死锁
            synchronized (t) { System.out.println("made it!"); }
        }
    }
}

public class Outer {
    private int data;
    private class Inner {
        void setOuterData() { // 与外部同步
            synchronized (Outer.this) { data = 12; }
        }
    }
}

public class Body {
    private static int nextID;
    private int idNum;
    public Body() { // 而不是 this.getClass()
        synchronized (Body.class) { idNum = nextID++; }
    }
}
```

### 同步方法

* 同步方法先获取一个监视器的锁才能执行
* 同步**静态**方法：监视器是对应的 Class 对象
* 同步**实例**方法：监视器是 this
* 构造器不能被声明为同步方法，也不需要，新对象只能在一个线程中被创建
* 为什么要用**存取器**（getter setter）而把字段设置为 private
  * 为了线程安全，把存取器同步化，一次只能一个线程读写
  * 如果是公共的字段，外部线程可以直接访问，可能会读取到无效值或者无法被修改
* 父类的同步方法，子类继承时可以是同步也可以是不同步的
  * 子类不同步方法，调用 super 时，对象锁被获取，返回的时候被释放（类似于同步语句）
  * 子类要看情况来是不是要用同步方法

```java
class CountA {
    int count;
    synchronized void bump() { count++; }
    static int classCount;
    static synchronized void classBump() { classCount++; } 
}
class CountB {
    int count;
    void bump() { synchronized (this) { count++; } }
    static int classCount;
    static void classBump() {
        try {
            synchronized (Class.forName("CountB")) { classCount++; }
        } catch (ClassNotFoundException e) { e.printStackTrace(); }
    }
}

public class Box { // 线程安全的 存对象
    private Object boxContents;
    public synchronized Object get() {
        Object contents = boxContents;
        boxContents = null;
        return contents;
    }
    public synchronized boolean put(Object contents) {
        if (boxContents != null) return false;
        boxContents = contents;
        return true;
    }
}
```

### 同步化

* 如果类本身不是同步的且无法修改源代码怎么办？
* 直接用同步语句调用其方法（自定义锁）
* 子类继承，然后同步其 super（稍微麻烦）
* 接口，创建同步化实现，非同步化实例传进去，在同步语句下调用原来的方法（同步包装器）
  * Collections.synchronizedXxx 很常见

## 线程等待集

* 同步只解决了多线程竞争，是不够的的，还需要多线程直接的协调（或互相通信）
* 每个对象，除了相关的监视器，还有**等待集**（线程集），对象最初创建时，等待集为空
* 等待集的操作：wait notify notifyAll（都是**原子**的，native 的，都应该在**同步**代码中使用）

```java
public synchronized void addTask(String s) {
    queue.add(s);
    notify();
}
public synchronized String getTask() {
    while (queue.isEmpty()) wait();
    return queue.remove();
}
```

* 条件测试应始终在循环中进行，被唤醒不意味着条件一定满足了
  * 一定要再检测，换句话说，不要把 while 改成 if

### Object.wait()

* 须在同步代码调用 wait 方法，让当前线程一直等待，直到：
  * 当前对象上调用 notify、notifyAll 方法
  * 或者 wait 给定的参数超时（无通知）
  * 该线程调用 interrupt 方法
  * 线程中断而等待结束，会抛出 InterruptedException
  * 也可能会**伪唤醒**（spurious wakeup），所以 wait 一定要放在测试条件的**循环**里
* 在等待过程中，释放当前对象锁，wait 返回时又重新获得锁，以便让线程继续
* wait()、wait(long millisecs)、wait(long millisecs, int nanosecs)
* wait() 等价于 wait(0)、wait(0, 0)，等待不会超时
  * 第一个参数为毫秒，第二个为纳秒，取值范围为 0 ~ 99w
* 注意：sleep 和 yield 是不会释放锁的，所以可在非同步方法里用

### Object.notify() Object.notifyAll()

* 会释放对应的锁，让 wait 重新获取锁以继续执行
* notify 只会唤醒一个线程（无法选择哪个），notifyAll 会唤醒所有等待的线程
* 多个线程可能等同一个对象，而条件或各不相同，所以应该使用 notifyAll
* 如果通知时没有要等待的线程，就会忽略

```java
import java.util.Queue;
import java.util.LinkedList;
public class WaitNotifyTest {
    private final Queue<String> queue = new LinkedList<>();
    public synchronized String getTask() throws InterruptedException {
        while (queue.isEmpty()) wait(); // 放在循环里保证queue不为空
        return queue.remove();
    }
    public synchronized  void addTask(String name) {
        queue.add(name);
        notifyAll(); // 唤醒全部等待的线程
    }
    public static void main(String[] args) throws InterruptedException {
        WaitNotifyTest task = new WaitNotifyTest();
        Thread t = new Thread(() -> {
            while (!Thread.currentThread().isInterrupted()) {
                String name;
                try {
                    name = task.getTask();
                } catch (InterruptedException e) {
                    break;
                }
                System.out.println("Hello, " + name + "!");
            }
        });
        t.start();
        task.addTask("Bob");
        Thread.sleep(1000);
        task.addTask("Alice");
        Thread.sleep(1000);
        task.addTask("Tim");
        Thread.sleep(1000);
        t.interrupt(); // 不再等待break进程
        t.join();
    }
}
```

## 线程调度

* 正在运行的线程将持续运行直到执行到**阻塞**操作（wait、sleep、I/O）或被**抢占**为止
  * 更高优先级线程被创建（处于可运行状态）
  * 时间片（tiime slicing）用完，**调度器**让另一个线程运行
* 线程的顺序、锁获取的顺序、收到通知的顺序都属于系统

### 主动重调度

* Thread 类的静态方法总是用于当前线程，因为无法从另一个线程占用 CPU
* sleep：睡眠**至少**指定时间，睡眠时线程被中断，则抛出 InterruptedException
* yield：提示调度器当前线程愿意放弃当前处理器（让步），调度器也可以选择**忽略**

```java
public class yieldTest {
	public static void main(String[] args) {
		for (String word : new String[] {"1", "2"})
			new Thread(() -> {
				for (int j = 0; j < 10; j++) {
					System.out.print(word + " ");
					Thread.yield();
				}
			}).start();
	}
}
```

## 线程组 未捕获异常 ThreadLocal

* 每个线程都属于某个线程组，每个线程组是由 ThreadGroup 的对象表示
  * Thread.currentThread().getThreadGroup().getName() 当前线程的线程组名
  * Thread.currentThread().getName()  当前线程名
  * main 函数的线程和线程组都叫 main
* 创建线程时，如果没有指定线程组，默认继承当前线程的线程组
  * 线程默认被线程组引用避免垃圾回收？
* 线程只能在创建时指定线程组，创建完之后就无法再更改
* [Java线程组](Java线程组.mm)
* [Java线程异常](Java线程异常.mm)
* [ThreadLocal](ThreadLocal.mm)
* 线程组常用法

```java
var group = new ThreadGroup("group");
var thread = new Thread(group, "group's member"); // 创建新进程并制定组和线程名（没有 runnable）
Thread[] threads = new Thread[group.activeCount()];
group.enumerate(threads);

new Thread(new ThreadGroup("group") { // 重写线程组的异常处理方法 uncaughtException（不推荐）
    @Override
    public void uncaughtException (Thread thread, Throwable throwable) {
        System.out.printf("%s: %s%n", thread.getName(), throwable.getMessage());
    }
}, () -> { throw new RuntimeException("测试异常"); }).start(); // Thread-1: 测试异常

{ // 设置线程的异常处理方法（推荐）
    var group = new ThreadGroup("group");
    var thread1 = new Thread(group, () -> { throw new RuntimeException("测试异常111"); });
    var thread2 = new Thread(group, () -> { throw new RuntimeException("测试异常222"); });
    thread1.setUncaughtExceptionHandler(
        (t, e) -> System.out.printf("%s: %s%n", t.getName(), e.getMessage()));
    thread1.start();
    thread2.start(); // 默认显示堆栈追踪
}
```

* JDK14源码

```java
public class Thread implements Runnable {
    private volatile UncaughtExceptionHandler exceptionHandler;
    private volatile static UncaughtExceptionHandler defaultExceptionHandler;
    @FunctionalInterface
    public static interface UncaughtExceptionHandler { 
        public void uncaughtException(Thread thread, Throwable throwable);
    }
    public UncaughtExceptionHandler getUncaughtExceptionHandler() {
        if (exceptionHandler == null) return getThreadGroup();
        return exceptionHandler;
	}
    public void setUncaughtExceptionHandler(UncaughtExceptionHandler handler) {
        exceptionHandler = handler;
    }
    public static UncaughtExceptionHandler getDefaultUncaughtExceptionHandler() {
        return defaultExceptionHandler;
    }
    public static void setDefaultUncaughtExceptionHandler(UncaughtExceptionHandler handler) {
        SecurityManager security = System.getSecurityManager();
        if (security != null)
            security.checkPermission(com.ibm.oti.util.RuntimePermissions
                                     .permissionSetDefaultUncaughtExceptionHandler);
        defaultExceptionHandler = handler;
    }
    void uncaughtException(Throwable e) {
        UncaughtExceptionHandler handler = getUncaughtExceptionHandler();
        if (handler != null)
            handler.uncaughtException(this, e);
    }
}

public class ThreadGroup implements Thread.UncaughtExceptionHandler {
    public void uncaughtException(Thread t, Throwable e) { // in ThreadGroup
        Thread.UncaughtExceptionHandler handler;
        if (parent != null) {
            parent.uncaughtException(t,e);
        } else if ((handler = Thread.getDefaultUncaughtExceptionHandler()) != null) {
            handler.uncaughtException(t, e);
        } else if (!(e instanceof ThreadDeath)) {
            // No parent group, has to be 'system' Thread Group
            // K0319 = Exception in thread "{0}" 
            // getString 第一个参数为格式化字符串对应的 key，第二个参数为格式化字符串中的实参
            System.err.print(com.ibm.oti.util.Msg.getString("K0319", t.getName())); // $NON-NLS-1$
            e.printStackTrace(System.err);
        }
    }
}
```

## 高级并发包

* 更高级的同步功能
* 简化多线程编写
* JDK >= 1.5
* 位于 java.util.concurrent 包

### ReentrantLock

* ReentrantLock 是一种 Lock，可代替 synchronized
* 可重入，一个线程可多次获取同一个锁
* lock 方法在 try 外，因为可能会失败
* tryLock 方法，获取锁并指定超时
* unlock 方法在 finally 里

```java
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
class Counter {
    final Lock lock = new ReentrantLock();
    public void inc() {
        lock.lock();
        try {
            n = n + 1;
        } finally {
            lock.unlock();
        }
    }
}
```

### ReadWriteLock

* 读写锁：允许多个线程同时读（提高性能），只允许一个线程写，其它线程必须等待
  * 在写代码里，使用写锁进行锁定和解锁
  * 在读代码里，使用读锁
* 适用于，大量线程读取，少量线程修改（读多写少）

```java
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;
public class ReadWriteLockTest {
    private final ReadWriteLock lock = new ReentrantReadWriteLock();
    private final Lock rLock = lock.readLock();
    private final Lock wLock = lock.writeLock();
    private int value = 0;
    public void add(int m) {
        wLock.lock();
        try {
            value += m;
        } finally {
            wLock.unlock();
        }
    }
    public void dec(int m) {
        wLock.lock();
        try {
            value -= m;
        } finally {
            wLock.unlock();
        }
    }
    public int get() {
        rLock.lock();
        try {
            return value;
        } finally {
            rLock.unlock();
        }
    }
    final static int LOOP = 100;
    public static void main(String[] args) throws InterruptedException {
        ReadWriteLockTest counter = new ReadWriteLockTest();
        Thread t1 = new Thread(() -> {
            for (int i = 0; i < LOOP; i++) counter.add(1);
        });
        Thread t2 = new Thread(() -> {
            for (int i = 0; i < LOOP; i++) counter.dec(1);
        });
        t1.start();
        t2.start();
        t1.join();
        t2.join();
        System.out.println(counter.get());
    }
}
```

### Condition

* Condition + ReentrantLock 可代替 synchronized + wait notify notifyAll
* Condition 对象必须从 ReentrantLock 对象的 newCondition 方法获取
  * await --- 代替 wait
  * signal --- 代替 notify
  * signalAll --- 代替 notifyAll

```java
import java.util.Queue;
import java.util.LinkedList;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
public class ConditionTest {
    private final Queue<String> queue = new LinkedList<>();
    private final Lock lock = new ReentrantLock();
    private final Condition condition = lock.newCondition();
    public String getTask() throws InterruptedException {
        lock.lock();
        try {
            while (queue.isEmpty()) condition.await(); // 放在循环里保证queue不为空
            return queue.remove();
        } finally {
            lock.unlock();
        }
    }
    public void addTask(String name) {
        lock.lock();
        try {
            queue.add(name);
            condition.signalAll(); // 唤醒全部等待的线程
        } finally {
            lock.unlock();
        }
    }
    public static void main(String[] args) throws InterruptedException {
        ConditionTest task = new ConditionTest();
        Thread t = new Thread(() -> {
            while (!Thread.currentThread().isInterrupted()) {
                String name;
                try {
                    name = task.getTask();
                } catch (InterruptedException e) {
                    break;
                }
                System.out.println("Hello, " + name + "!");
            }
        });
        t.start();
        task.addTask("Bob");
        Thread.sleep(1000);
        task.addTask("Alice");
        Thread.sleep(1000);
        task.addTask("Tim");
        Thread.sleep(1000);
        t.interrupt(); // 不再等待break进程
        t.join();
    }
}
```

