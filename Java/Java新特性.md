### Java 新特性

* 1991年4月，由 James Gosling 博士领导的绿色计划（Green Project）开始启动
* 1995-5-23 Oak 语言改名为 Java，提出 Write Once,Run Anywhere 的口号

#### Java 1.0（JDK1.0 1996-01-23）

* Sun Classic VM（虚拟机）
*  Applet（java小应用程序）
* AWT（java图形设计）

#### Java 1（JDK1.1 1997-2-19）

* JAR（jar包）
* JDBC(Java DataBase Connectivity)（连接数据库）
* JavaBeans（java规范）
* RMI（远程调用）
* Inner Class（内部类）
* Reflection（反射）

#### Java 2（JDK1.2 1998-12-4）

* J2SE（改名为J2SE）
* J2EE（改名为J2EE）
* J2ME（改名为J2ME）
* JIT（即时编译技术）
* Java Plug-In（运行插件）
* EJB（J2EE的规范） 
* Java IDL（平台对象请求代理体系结构） 
* Collections（集合） 
* 字符串常量做内存映射
* 对打包的Java文件进行数字签名
* 控制授权访问系统资源的策略工具
* JDBC中引入可滚动结果集,BLOB,CLOB,批量更新和用户自定义类型
* 在Applet中添加声音支持

#### Java 3（JDK1.3 2000-5-8）

* 数学运算
* Timer API（时间）
* Java Sound API（声音）
* CORBA IIOP实现RMI的通信协议
* Java 2D新特性
* jar文件索引

#### Java 4（JDK 1.4 2002-2-13）

* 正则表达式 
* 异常链 
* NIO（高级流）
* Logging （日志功能）
* XML解析器
* XSLT转换器
* XML处理
* Java打印服务
* Java Web Start 
* JDBC 3.0（jdbc高级）
* 断言
* Preferences（可以操作系统的高级功能）
* IPV6
* Imgae I/O（图片流）

#### Java 5（JDK 1.5 2004-9-30）

* 自动装箱拆箱 
* 泛型 
* 元数据
* Introspector（内省）
* enum（枚举）
* 静态引入
* 可变长参数（Varargs）
* foreach（高级虚幻）
* JMM（内存模型）
* concurrent（并发包）

#### Java 6（JDK6 2006-12-11）

* 命名方式变更
* 脚本语言 
* 编译API和微型HTTP服务器API 
* 锁与同步 
* 垃圾收集 
* 类加载 
* JDBC 4.0（jdbc高级）
* Java Compiler （Java™ 编程语言编译器的接口）
* 可插拔注解 
* Native PKI(公钥基础设) 
* Java GSS （通用安全服务）
* Kerberos （ 一种安全认证的系统）
* LDAP （LDAP ）
* Web Services  （web服务）

#### Java 7（JDK7 2011-7-28）

* switch语句块中允许以字符串作为分支条件 
* 创建泛型对象时应用类型推断 
* try-with-resources（一个语句块中捕获多种异常） 
* null值得自动处理 
* 数值类型可以用二进制字符串表示 
* 引入Java NIO.2开发包
* 动态语言支持 
* 安全的加减乘除 
* Map集合支持并发请求 

#### Java 8（JDK8 2014-3-18）

* **Lambda 表达式** − Lambda允许把函数作为一个方法的参数（函数作为参数传递进方法中。
* **方法引用** − 方法引用提供了非常有用的语法，可以直接引用已有Java类或对象（实例）的方法或构造器。与lambda联合使用，方法引用可以使语言的构造更紧凑简洁，减少冗余代码。
* **默认方法** − 默认方法就是一个在接口里面有了一个实现的方法。
* **新工具** − 新的编译工具，如：Nashorn引擎 jjs、 类依赖分析器jdeps。
* **Stream API** −新添加的Stream API（java.util.stream） 把真正的函数式编程风格引入到Java中。
* **Date Time API** − 加强对日期与时间的处理。
* **Optional 类** − Optional 类已经成为 Java 8 类库的一部分，用来解决空指针异常。
* **Nashorn, JavaScript 引擎** − Java 8提供了一个新的Nashorn javascript引擎，它允许我们在JVM上运行特定的javascript应用。

#### Java 9（JDK9 2017-9-22）

* **模块系统**：模块是一个包的容器，Java 9 最大的变化之一是引入了模块系统（Jigsaw 项目）。
* **REPL (JShell)**：交互式编程环境。
* **HTTP 2 客户端**：HTTP/2标准是HTTP协议的最新版本，新的 HTTPClient API 支持 WebSocket 和 HTTP2 流以及服务器推送特性。
* **改进的 Javadoc**：Javadoc 现在支持在 API 文档中的进行搜索。另外，Javadoc 的输出现在符合兼容 HTML5 标准。
* **多版本兼容 JAR 包**：多版本兼容 JAR 功能能让你创建仅在特定版本的 Java 环境中运行库程序时选择使用的 class 版本。
* **集合工厂方法**：List，Set 和 Map 接口中，新的静态工厂方法可以创建这些集合的不可变实例。
* **私有接口方法**：在接口中使用private私有方法。我们可以使用 private 访问修饰符在接口中编写私有方法。
* **进程 API**: 改进的 API 来控制和管理操作系统进程。引进 java.lang.ProcessHandle 及其嵌套接口 Info 来让开发者逃离时常因为要获取一个本地进程的 PID 而不得不使用本地代码的窘境。
* **改进的 Stream API**：改进的 Stream API 添加了一些便利的方法，使流处理更容易，并使用收集器编写复杂的查询。
* **改进 try-with-resources**：如果你已经有一个资源是 final 或等效于 final 变量,您可以在 try-with-resources 语句中使用该变量，而无需在 try-with-resources 语句中声明一个新变量。
* **改进的弃用注解 @Deprecated**：注解 @Deprecated 可以标记 Java API 状态，可以表示被标记的 API 将会被移除，或者已经破坏。
* **改进钻石操作符(Diamond Operator)** ：匿名类可以使用钻石操作符(Diamond Operator)。
* **改进 Optional 类**：java.util.Optional 添加了很多新的有用方法，Optional 可以直接转为 stream。
* **多分辨率图像 API**：定义多分辨率图像API，开发者可以很容易的操作和展示不同分辨率的图像了。
* **改进的 CompletableFuture API** ： CompletableFuture 类的异步机制可以在 ProcessHandle.onExit 方法退出时执行操作。
* **轻量级的 JSON API**：内置了一个轻量级的JSON API
* **响应式流（Reactive Streams) API**: Java 9中引入了新的响应式流 API 来支持 Java 9 中的响应式编程。

#### Java 10（JDK10 2018-3-20）

* JEP286，var 局部变量类型推断。
* JEP296，将原来用 Mercurial 管理的众多 JDK 仓库代码，合并到一个仓库中，简化开发和管理过程。
* JEP304，统一的垃圾回收接口。
* JEP307，G1 垃圾回收器的并行完整垃圾回收，实现并行性来改善最坏情况下的延迟。
* JEP310，应用程序类数据 (AppCDS) 共享，通过跨进程共享通用类元数据来减少内存占用空间，和减少启动时间。
* JEP312，ThreadLocal 握手交互。在不进入到全局 JVM 安全点 (Safepoint) 的情况下，对线程执行回调。优化可以只停止单个线程，而不是停全部线程或一个都不停。
* JEP313，移除 JDK 中附带的 javah 工具。可以使用 javac -h 代替。
* JEP314，使用附加的 Unicode 语言标记扩展。
* JEP317，能将堆内存占用分配给用户指定的备用内存设备。
* JEP317，使用 Graal 基于 Java 的编译器，可以预先把 Java 代码编译成本地代码来提升效能。
* JEP318，在 OpenJDK 中提供一组默认的根证书颁发机构证书。开源目前 Oracle 提供的的 Java SE 的根证书，这样 OpenJDK 对开发人员使用起来更方便。
* JEP322，基于时间定义的发布版本，即上述提到的发布周期。版本号为\$FEATURE.\$INTERIM.\$UPDATE.\$PATCH，分别是大版本，中间版本，升级包和补丁版本。

#### Java 11（JDK11 2018-9-25）

* 181:Nest-Based访问控制
* 309:动态类文件常量
* 315:改善Aarch64 intrinsic
* 318:无操作垃圾收集器
* 320:消除Java EE和CORBA模块
* 321:HTTP客户端(标准)
* 323:局部变量的语法λ参数
* 324:Curve25519和Curve448关键协议
* 327:Unicode 10
* 328:飞行记录器
* 329:ChaCha20和Poly1305加密算法
* 330:发射一列纵队源代码程序
* 331:低开销堆分析
* 332:传输层安全性(Transport Layer Security,TLS)1.3
* 333:动作:一个可伸缩的低延迟垃圾收集器 (实验)
* 335:反对Nashorn JavaScript引擎
* 336:反对Pack200工具和API

#### Java 12（JDK12 2019-3-19）

* 189: Shenandoah: A Low-Pause-Time Garbage Collector (Experimental) ：新增一个名为 Shenandoah 的垃圾回收器，它通过在 Java 线程运行的同时进行疏散 (evacuation) 工作来减少停顿时间。
* 230: Microbenchmark Suite：新增一套微基准测试，使开发者能够基于现有的 Java Microbenchmark Harness（JMH）轻松测试 JDK 的性能，并创建新的基准测试。
* 325: Switch Expressions (Preview) ：对 switch 语句进行扩展，使其可以用作语句或表达式，简化日常代码。
* 334: JVM Constants API ：引入一个 API 来对关键类文件 (key class-file) 和运行时工件的名义描述（nominal descriptions）进行建模，特别是那些可从常量池加载的常量。
* 340: One AArch64 Port, Not Two ：删除与 arm64 端口相关的所有源码，保留 32 位 ARM 移植和 64 位 aarch64 移植。
* 341: Default CDS Archives ：默认生成类数据共享（CDS）存档。
* 344: Abortable Mixed Collections for G1 ：当 G1 垃圾回收器的回收超过暂停目标，则能中止垃圾回收过程。
* 346: Promptly Return Unused Committed Memory from G1 ：改进 G1 垃圾回收器，以便在空闲时自动将 Java 堆内存返回给操作系统。

#### Java13（JDK13 2019-9-17）

* 350:	Dynamic CDS Archives
* 351:	ZGC: Uncommit Unused Memory
* 353:	Reimplement the Legacy Socket API
* 354:	Switch Expressions (Preview)
* 355:	Text Blocks (Preview)

#### Java 14（JDK14 2020-3-17）

* 305:	Pattern Matching for instanceof (Preview)
* 343:	Packaging Tool (Incubator)
* 345:	NUMA-Aware Memory Allocation for G1
* 349:	JFR Event Streaming
* 352:	Non-Volatile Mapped Byte Buffers
* 358:	Helpful NullPointerExceptions
* 359:	Records (Preview)
* 361:	Switch Expressions (Standard)
* 362:	Deprecate the Solaris and SPARC Ports
* 363:	Remove the Concurrent Mark Sweep (CMS) Garbage Collector
* 364:	ZGC on macOS
* 365:	ZGC on Windows
* 366:	Deprecate the ParallelScavenge + SerialOld GC Combination
* 367:	Remove the Pack200 Tools and API
* 368:	Text Blocks (Second Preview)
* 370:	Foreign-Memory Access API (Incubator)

#### JDK15 2020-9-15

339:	Edwards-Curve Digital Signature Algorithm (EdDSA)
360:	Sealed Classes (Preview)
371:	Hidden Classes
372:	Remove the Nashorn JavaScript Engine
373:	Reimplement the Legacy DatagramSocket API
374:	Disable and Deprecate Biased Locking
375:	Pattern Matching for instanceof (Second Preview)
377:	ZGC: A Scalable Low-Latency Garbage Collector
378:	Text Blocks
379:	Shenandoah: A Low-Pause-Time Garbage Collector
381:	Remove the Solaris and SPARC Ports
383:	Foreign-Memory Access API (Second Incubator)
384:	Records (Second Preview)
385:	Deprecate RMI Activation for Removal

#### JDK16 2021-3

* 386:	Alpine Linux Port
* 338:	Vector API (Incubator)
* 347:	Enable C++14 Language Features
* 357:	Migrate from Mercurial to Git
* 369:	Migrate to GitHub
* 387:	Elastic Metaspace

### 参考

* [java所有版本的（新特性）更新详情 目前更新至2019-1_为什么坚持，想一想当初-CSDN博客](https://blog.csdn.net/qq_22194659/article/details/86134443)
* [Java9到Java13各版本新特性代码全部详解(全网独家原创)_lzw的专栏-CSDN博客](https://blog.csdn.net/lzw2497727771/article/details/104019737)
* [【JAVA各版本特性】JAVA 1.0 - JAVA 13_旋转跳跃后空翻中的阿喵 - 热爱，专注，精益求精-CSDN博客](https://blog.csdn.net/qq934235475/article/details/82220076)
* [JDK Project](https://openjdk.java.net/projects/jdk/)（从 JDK10 开始）