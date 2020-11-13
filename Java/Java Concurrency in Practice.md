## 1 Introduction

### 1.3 Risks of threads 线程的风险

#### 1.3.1 Safety hazards 安全性风险

* Safety（安全性）：不会发生坏事
* 安全性风险之一就是竞态条件（Race Condition）
* 竞态条件原理：一条语句不是原子操作，分为多个步骤，一个线程读到了另一个线程修改前的值（资源共享）
  * 可能会导致重复操作，返回相同值（导致无法预测）
  * 由于指令重排（reordering），实际情况可能更糟
* 解决方案：synchronized，对共享资源的访问进行协调（coordinate），防止线程之间互相干扰（竞态条件）
* 如果没有同步（synchronization），就可以随便安排操作的时间和顺序
* 如为了提高性能，缓存变量到寄存器或高速缓存，这对于其它线程是不可见的
* 第十六章详细介绍了 JVM 的顺序保证（ordering guarantees）和同步如何影响这些保证
* 安全性不只是多线程要注意的，单线程也要注意，只是多线程带来了更多安全风险
* 同样的，多线程也带来了单线程不会发生的 liveness failure（活性失效）

```java
@NotThreadSafe
public class UnsafeSequence { // 多线程可能会返回相同值
    private int value;
    public int getNext () { return value++; } // 单线程返回唯一值
}

@ThreadSafe public class UnsafeSequence { // 解决方案
    @GuardedBy("this") private int value; // 同步策略
    public synchronized int getNext () { return value++; }
}
```

#### 1.3.2 Liveness Hazards 活性风险

* liveness（活性）：某件正确的事情最终会发生
* liveness failures（活性失效）：某个操作永远无法继续进行
  * 死循环，永远不会执行循环的后面的代码
  * A 等 B 的独占资源，B 永不释放，A 永远等待
  * deadlock（死锁 10.1）、starvation（饥饿 10.3.1）、livelock（活锁 10.3.3）
  * 活性失效取决于不同线程中时间的相对时序（timing）
* hazard：可能会发生的风险（冒险）
* risk：风险本身
* deadlock：互相等待对方先结束，结果永远不会结束（僵持）

#### 1.3.3 Performance Hazards 性能风险

* 引入多线程会带来额外的性能风险，可能会造成性能降低：上下文切换的开销、同步机制的开销
  * 过多的线程和过多的 synchronized 会降低多线程的性能优势
* 上下文切换（Context Switch）：调度器（Scheduler）临时挂起（suspend）活动线程转而运行其它线程
* 上下文切换的开销：保存和恢复执行上下文、丢失本地性使 CPU 时间没有花在执行任务上
* 同步机制的开销：同步机制会抑制编译器优化，清除（flush）或使内存的缓存失效，在共享的内存总线上创建同步通信（traffic）
* 第 11 章介绍分析和减少多线程的开销

### 1.4 Threads are everywhere

* 就算你不用多线程，那你调用的 API 或者库也会帮你用多线程（Timer、Servlet、JSP、RMI）
  * 远程方法调用（Remote Method Invocation, RMI）
  * 就是不同 JVM 之间的代码调用
  * 参数打包（Marshaled）成字节流，通过网络传输然后拆包（Unmarshaled）
* 如果多个线程都会访问到一个对象，要确保这个对象本身是线程安全的（如同步机制）
  * 要么确保代码是线程安全的，要么确保访问的对象是线程安全的
* 只要使用了多线程的 API 和库，一般就避免不了要注意线程安全
* 而 Java 应用大多都是多线程的，所以对于多线程的理解就是必须的

## 2 Thread Safety

* 并发编程其实跟线程和锁关系不大，但这只是达到目的手段
* 本质上是对状态访问操作的管理，特别是 Shared 和 Mutable 的状态
* 对象的状态是对象的成员变量或静态变量
* 对象的状态可能还包括其它相关对象的字段
* 对象状态包含影响该对象外部行为的所有数据

### 线程的三种方式

1. 实现 Runnable.start
2. 继承 Thread.run
3. Lambda（类似 1）

* 运行线程 Thread.start

```java
// for (int i = 0; i < 10; i++) System.out.println(i);

public class Hare implements Runnable { public void run() {} }
new Thread(new Hare()).start(); // 1-1

new Thread(){ public void run() {} }.start(); // 1-2

public class Hare extends Thread { public void run() {} }
new Hare().start(); // 2

new Thread(() -> {}).start(); // 3
```

* 并发把程序划分成多个单独运行的任务，每个任务通过执行线程驱动，执行线程简称线程
* 一个线程是操作系统进程中的单个顺序控制流，进程可以有多个并发执行的任务
* 在编程时，每个任务好像有一个单独的处理器
* 操作系统分配处理器的时间给每个线程
* Java 并发的核心机制是 Thread 类（最初）
* 后来又出现了 Executor 类，用来管理线程
* 后来出现了更好的机制：并行 Stream 和 CompletableFuture 类