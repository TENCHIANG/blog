### 异步 I/O

* 单线程同步
  * 优点：简单，符合人的思维
  * 缺点：阻塞、硬件资源得不到有效利用（性能低下）
* 多线程异步：
  * 优点：硬件充分利用（效率高）
  * 缺点：死锁、状态同步
* 单线程异步（Node）：
  * 用单线程远离死锁、状态同步
  * 用异步 I/O 远离阻塞
  * 子进程充分利用多核（Cluster）
* 编程方式是同步和异步
* I/O的方式是阻塞和非阻塞
  * 费阻塞立刻返回文件描述符，之后通过文件描述符通过**轮询**获取数据
* 线程是比进程更细的单位

### 轮询

* read：最简单的重复调用检查状态
* select：通过文件描述符上的事件状态判断（最多同时检查 1024 个文件描述符<数组>）
* poll：用链表避免数量限制，但太多性能也慢
* epoll：先休眠，事件通知唤醒（Linux），缺点是休眠啥都不做
* kqueue：同上（FreeBSD）
* Event ports：Solaris
* 理想异步 I/O：一些线程异步 I/O（如用阻塞 I/O + 多线程模拟），其它线程做计算（线程池无需用户管理，只要管数据来了的**回调**即可，线程之间通过事件通知）
  * Windows：IOCP
  * *nix：自实现线程池 + epoll / kqueue / Event ports
  * 所以 js 的单线程只是执行在单线程（串行运行），Node 的 I/O 还是多线程（并行运行）
  * 同时，计算机的任何资源都抽象为文件，所以异步 I/O 也包括网络
  * 事件的本质：主循环（观察者） + 事件触发（生产消费者）

#### 事件循环、观察者、请求对象、I/O 线程池

* 整个 Node 进程就是一个循环（**事件循环**）
* 一次循环叫 tick，检查是否有事件待处理（询问观察者），**没有则退出**
* 有事件则取出事件和回调执行，进入下一个 tick
* 每个事件循环中可以有多个**观察者**，每个事件都有对应的观察者（事件分类）
* 请求对象是异步 I/O 的中间产物，所有状态都保存在请求对象（送入线程池、回调）

#### 异步 I/O 的流程

* 关键词：单线程、事件循环、观察者、请求对象、I/O 线程池
* 异步调用
  * 发起异步调用
  * 封装请求对象（挂载回调函数及其参数）
  * 将请求对象放入线程池等待执行（会立刻返回让 js 继续执行）
* 线程池
  * 如果线程可用则执行请求对象中的 I/O 操作，等待执行完成
  * 将结果挂载到请求对象中
  * 通知 IOCP 等调用完成并归还线程（事件）
* 事件循环
  * 创建主循环
  * 从 I/O 观察者取到已完成的请求对象
  * 从请求对象取出回调函数和结果执行（回调函数）

### 非 I/O 异步 API

* setTimout 单次、setInterval 多次、setImmediate、process.nextTick

#### 定时器

* 定时器与异步 I/O 类似，只是无需线程池
* 定时器的缺点：不是非常精确（单线程事件循环）
* 创建定时器（timer_handles）
  * 插入到定时器观察者内部的红黑树（handles）
  * 每次 tick 迭代红黑树，取出定时器检查是否超时
  * 超时则形成一个事件，执行回调，把该定时器删除（setTimout）

#### 将回调函数延迟执行

* setTimeout(f, 0) 代价太大（创建定时器、操作和迭代红黑树）
* setImmediate(f)
* process.nextTick(f)：将回调函数放入队列，在下一轮 tick 取出执行
* nextTick 和 setImmediate 的区别
  * nextTick 是最优先的（idle 观察者），比 setImmediate 还优先（check 观察者）
    * 观察者在每个 tick 的**优先级**：idle > I/O > check
  * nextTick 回调保存在数组，每次 tick 会**都执行完**
  * setImmediate 回调保存在链表，每次 tick **只执行一个**（保证每次 tick 能较快的完成，防止阻塞，尽量不要超过 10ms）

```js
process.nextTick = callback => { // process.nextTick实现
    if (process._exiting) return
    if (tickDepth >= process.maxTickDepth) maxTickWarn()
    nextTickQueue.push({ callback, domain: process.domain })
    if (nextTickQueue.length) process._needTickCallback()
}
```

### 服务器模型

* Node 是通过绑定事件实现高性能的服务器
* 同步式：一次处理一个请求，其余请求等待
* 进程式：每进程/每请求，扩展性差（系统资源有限）
* 线程式：每线程/每请求，比进程轻量，线程占用内存，操作线程，上下文切换也有代价
* 事件驱动：开销低
  * 一个请求不对应一个线程，减少线程创建和销毁的开销
  * 线程少，OS 任务调度时，上下文切换代价低
* Node 与 Nginx 的区别
  * Nginx 也是事件驱动， 不过是由 C 写的，在 Web 服务器上性能更高
  * Nginx 比较适合做 Web 服务器、反向代理、均很负载，处理具体业务较欠缺
  * Node 场景更广、性能也不错
* 其它语言的事件驱动
  * Ruby 的 Event Machine
  * Perl 的 AnyEvent
  * Python 的 Twisted
  * Lua 的 luavit（Lua 差点成为Node）
  * 没有成功的关键：
    * 标准 I/O 库都是阻塞式（异步不是主流）
    * 一旦事件循环中掺杂同步 I/O，会导致其余 I/O 无法立刻执行
    * 整个异步会失效，和阻塞同步没区别了
  * Node 的成功
    * js 在服务端的空白没有历史包袱，天生事件驱动
    * V8 引擎的性能