### 各种CPU架构

* x86 的意思：以 86 结尾的一系列 CPU（英特尔）代表一种 CPU 架构（也叫 80x86）
  * 4004 - 8008 - [8086]（x86开始） - 80186 - 80188 - 80286 - 80386 - 80486 - 80586（奔腾） - 80686 - x86-64（64位开始）
  * 可以把 80 替换为 i 表示 intel（如 80386 又叫 i386）
  * 8086 ~ 80286 都是 16 位处理器，从 80386 开始才是 32 位
    * 除非是字长的改变，其它都是小改变，加了一些新特性，但保持向下兼容
    * 比如 8086 是兼容性最好的 16 位架构，80386 是兼容性最好的 32 位架构
  * 如 x86-32 代表 32 位，也叫 IA-32
  * x86-64 代表 64 位
    * 英特尔先弄出 IA-64 安腾架构，由于不兼容 x86 所以凉了
    * AMD自行把32位x86（或称为IA-32）拓展为64位，命名为 Hammer - AMD64
      * 有意思的是，80386 最早也是 AMD 扩展 8086 搞出来的（AMD Yes!）
    * 英特尔扩展 AMD64，命名为 Clackamas Technology（CT） - IA-32e - EM64T - Intel 64
  * x86-64 代表 64 位，也叫 x64、EM64T、AMD64（最早的 64 位处理器是 AMD 搞的）
    * 英特尔搞的 IA-64 不是 x86 架构（64 位的安腾架构）
  * 为了不偏袒任何一方，64 位被叫做：x64、x86-64、x86_64
* i386 几乎适用于所有的 x86 平台，不论是旧的 pentum 或者是新的 pentum-IV 与 K7 系列的 CPU等等，都可以正常的工作！那个 i 指的是 Intel 兼容的 CPU 的意思
* i586 就是 586 等级的计算机，那是哪些呢？包括 pentum 第一代 MMX CPU， AMD 的 K5, K6 系列 CPU ( socket 7 插脚 ) 等等的 CPU 都算是这个等级；
* i686 在 pentun II 以后的 Intel 系列 CPU ，及 K7 以后等级的 CPU 都属于这个 686 等级！
* noarch 就是没有任何硬件等级上的限制。
* 查看 CPU 架构

```sh
uname -m # The machine (hardware) type
uname -a | awk '{print $13}'
cat /proc/cpuinfo
```

* [linux里面i386 i686 i486 i586代表什么？是什么意思_White_Lee的专栏-CSDN博客_i386, i486, i586](https://blog.csdn.net/White_Lee/article/details/84474596)
* [关于x86、x86-64、x64、i386、i486、i586和i686等名词的解释_ITPUB博客](blog.itpub.net/29734436/viewspace-2138006/)
* [x86 - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki/X86)
* [Intel 80386 - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki/Intel_80386)

### 安卓上的 CPU 架构

* aarch32表示32位架构，aarch64表示64位架构
  * arm64和aarch64的区别：arm64是苹果用LLVM，aarch64则是安卓用GCC（后面已经合并）
* armeabiv-v7a: 第7代及以上的 ARM 处理器。2011年15月以后的生产的大部分Android设备都使用它.
* arm64-v8a: 第8代、64位ARM处理器
* armeabi: 第5代、第6代的ARM处理器，早期的手机用的比较多。
* x86: 平板、模拟器用得比较多。
* x86_64: 64位的平板。
* 所有的x86/x86_64/armeabi-v7a/arm64-v8a设备都支持armeabi架构的.so文件
  * x86设备能够很好的运行ARM类型函数库，但并不保证100%不发生crash，特别是对旧设备
  * 64位设备（arm64-v8a, x86_64, mips64）能够运行32位的函数库，但是以32位模式运行，在64位平台上运行32位版本的ART和Android组件，将丢失专为64位优化过的性能（ART，webview，media等等）
  * 总结：armv5（armeabi）的兼容性是最好的，但是一般情况下，32位用 armv7，64位用 armv8 即可
* [Android 关于arm64-v8a、armeabi-v7a、armeabi、x86下的so文件兼容问题 - janehlp - 博客园](https://www.cnblogs.com/janehlp/p/7473240.html)
* [android - Differences between arm64 and aarch64 - Stack Overflow](https://stackoverflow.com/questions/31851611/differences-between-arm64-and-aarch64)

### ARMv7-A/R/M系列

* armv6 对应 arm11，在 arm11 之后的处理器家族，改采 Cortex 命名，并针对高、中、低阶分别划分为 A、R、M 三大处理器
* Coretex-A：高端手机
* Coretex-R：较高性能、或是实时处理（与A差距不大，主要在内存管理，A是MMU<支持virtual>，R是MPU<只支持protected>）
  * 内存的real、protected、virtual模式
    * real：早期，直接读写
    * protected：操作系统中介
    * virtual：在protected基础上，能够把硬盘模拟成内存
* Coretex-M：微控制器
* 其他后缀：
  * h(f)：hard-float 硬件浮点运算（armhf）
  * s(f)：baisoft-float 软件浮点运算
  * l：little-endian 小端
    * armel（EABI ARM），支持与 v5te 指令集兼容的小端序 ARM CPU
  * el：Exception Level(异常等级)
  * pl：Privilege Level(特权等级)

* [ARMv7-A/R/M系列 --- 简介_Amao_come_on 的专栏-CSDN博客_armv7-m](https://blog.csdn.net/maochengtao/article/details/39519439)
* [ARM 处理器：RISC与CISC 是什么？ - 云+社区 - 腾讯云](https://cloud.tencent.com/developer/article/1432825)
* [Debian -- 移植](https://www.debian.org/ports/#portlist-released)
* [ARM体系的EL演化史 - 知乎](https://zhuanlan.zhihu.com/p/21258997?refer=c_33701669)
