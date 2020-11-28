### mv 命令无需两次键入文件名

```sh
touch file-aaa.txt
mv file-{aaa,bbb}.txt # file-bbb.txt
mv file-bbb{,-ccc}.txt # file-bbb-ccc.txt
mv file-bbb-ccc.{txt,pdf} # file-bbb-ccc.pdf
```

### 文件与目录查看：ls

* 隐藏文件：点 . 开头的文件（点文件）
* -a：全部文件
* -A：全部文件，不包括当前目录和上级目录
* -h：容量大小易读
* -R：子目录递归输出
* -f：不排序（默认名称排序）
* -r：反向排序
* -S：大小升序
* -t：时间排序
* -d：只列出目录本身，而不是列出目录内的文件数据

```sh
ls -d # 只列出目录本身
ls -d .* # 只显示当前目录下以点开头的文件
ls ~/*/ # 只列出 ~ 目录下的目录
```
* 只列出隐藏文件

```sh
ls -d .*
ls -a | grep "^\."
ls -A | grep "^\."
```

* -F 附加信息到文件或文件夹后面（git for windwos 的 ls 默认是加 -F 的）
  * 普通文件
  * 可执行文件 *
  * 目录 /
  * socket 文件 =
  * FIFO 文件 |
  * 链接文件 @
    * 如果是目录，@ 优先级大于 / * 
* 最佳实践（列表显示、易读文件大小、显示隐藏文件、显示文件信息）

```sh
alias ll="ls -lhAF"
```

* 参考：[利用ls只查看隐藏文件_huage_新浪博客](http://blog.sina.com.cn/s/blog_716844910100qneb.html)

### Linux 与 Windows 链接文件（快捷方式）

### 已知私钥生成公钥

```sh
ssh-keygen -yf id_rsa > id_rsa.pub
```

### 监控文件事件 inotify

* inotify，监控文件和目录变化的一种机制（inotify事件） >= Linux 2.6.13
  * 打开、关闭、创建、删除、修改以及重命名等操作
  * inotify 取代老旧的 dnotify，两者都是 Linux 专有机制
* 一个用户可以创建多个inotify实例
* 一个inotify实例可以有多个监控描述符，一个监控描述符对应一组监控项 max_user_instances 
* 监控项分为路径和掩码 max_user_watches
  * pathname 文件文件夹
  * mask 事件
* inotify会消耗内存，所以要做限制 /proc/sys/fs/inotify/下的三个文件
  * max_queued_events inotify实例监听的事件数量上限 （16384）
  * max_user_instances 每个用户能创建inotify实例数量的上限（128）
  * max_user_watches 每个用户的监控项数量的上限（8192）
* 参考：《Linux/Unix系统编程手册》第19章

### NDK编译程序运行出现 unused DT entry 错误

* 使用 [android-elf-cleaner](https://github.com/kost/android-elf-cleaner) 工具修复
* [【错误笔记】NDK编译程序运行出现unusedDTentry错误_追火车-CSDN博客_unuseddtentry:type](https://blog.csdn.net/TMT123421/article/details/84798207)

### can't execute: Permission denied

* 二进制文件在 /sdcard 没有**执行权限**
* mv 到 /data/local/tmp/ 下，然后 chmod 777
* [Android之提示can't execute: Permission denied解决办法](https://blog.csdn.net/u011068702/article/details/68065451/)

### Transport endpoint is not connected

* cd /sdcard 时报的错，**重启**一下就好了
* [Doesn't work on Nexus 5 after upgrade to Android 7.0: Transport endpoint is not connected · Issue #14 · spion/adbfs-rootless](https://github.com/spion/adbfs-rootless/issues/14)

### diff命令

* [linux命令大全之diff命令详解(比较文件内容)_c_z_w的博客-CSDN博客_diff-c](https://blog.csdn.net/c_z_w/article/details/56279581)

### /proc/$pid/

* cmdline 执行进程的命令行参数
* cpu 在SMP系统中近程最后的执行CPU (2.4)(smp)
* cwd 到当前工作目录的符号链接
* environ 环境变量
* exe 链接到进程对应的源可执行文件
* fd 包含所有进程打开的文件描述符的子目录
* maps 进程内存映射，包含进程执行空间以及动态链接库信息 (2.4)
* mem 进程内存空间
* root 连接到进程执行时的 / (root)目录
* stat 进程状态
* statm 进程内存状态信息
* status 进程状态总览，包含进程名字、当前状态和各种信息统计

```sh
killall -CONT com.tencent.mobileqq # 恢复游戏进程
killall -STOP com.tencent.mobileqq # 暂停游戏进程
```

* 读取pkg的pid `pidof -s $pkg`
* 查看pid的maps `pmap -x $pid`
* [/proc/$pid/maps文件中各个空间段的意义 - tsecer - 博客园](https://www.cnblogs.com/tsecer/p/11376415.html)
* [使用/proc/${pid}/mem访问其他进程的内存变量_一头雾水的Blog-CSDN博客_/proc/pid/mem](https://blog.csdn.net/guojin08/article/details/9454467)
* [安卓Android调用C语言实现其他进程应用app的内存变量读取修改与利用BusyBox实现应用暂停和恢复（Native层）_Zcode的博客-CSDN博客_c4droid内存读写](https://blog.csdn.net/a480694856/article/details/104183261)
* [kernel - How do I read from /proc/$pid/mem under Linux? - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/6301/how-do-i-read-from-proc-pid-mem-under-linux)
* [游戏安全实验室 游戏漏洞 外挂分析](https://gslab.qq.com/article-21-1.html)
* [Linux proc详解 - - ITeye博客](https://www.iteye.com/blog/luckyclouds-675711)

### 访问内存的三种方式

* **memcpy** 只能访问自己的 访问别人会导致段错误
* **ptrace** GDB的调试原理
* **pread64** 目前的方案
  * 先解析 /proc/pid/maps
  * 再 open /proc/pid/mem
  * 再 pread64 pwrite64
* [Android 使用ptrace查看其它进程的内存数据_muzhengjun的博客-CSDN博客](https://blog.csdn.net/muzhengjun/article/details/46925209?utm_source=blogxgwz9)

### 命令行选项解析 getopt

* getopt 可以解析**短选项**（单横杠单字母如 -h xxx）
  getopt_long 支持**长选项**（双斜杠多字母如 --hex xxx）
* const char *optstring 定义选项和参数的格式
  * 以 "ab:c::" 举例
  * a 选项a没有参数，-a 即可
  * b: 选项b有参数，-bxxx 或 -b xxx（getopt_long 支持 -b=xxx）
  * c:: 选项c有参数，-cxxx （选项和参数必须贴着，否则参数 optarg 为 0）
* extern char *optarg 当前选项的参数（字符串，没有参数则为 0）
* extern int optind argv的索引，从1开始（跳过 argv[0]）
* extern int optopt 第一个未知选项（ASCII码值，getopt 碰到未知选项会返回 -1），默认为 63（'?'）
* extern int opterr 如果不希望 getopt 打印出错信息，设为 0 即可，默认为 1
  * 一般设置为 0（自己处理）
  * 处理 `case '?'`，且报错（因为此时返回-1结束了循坏，可能有正确的选项没有被读取）
* 选项成功找到，返回选项**字母**（忽略横杠）
* 找到的选项不在 optstring 内，返回 '?'
* 如果所有选项解析完了或碰到未知选项，返回 -1
* 如果遇到丢失参数，那么返回值依赖于 optstring 中第一个字符，如果第一个字符是 ':' 则返回 ':'，否则返回 '?' 并提示出错误信息

```c
#include <unistd.h>
#include <getopt.h>          /* 所在头文件 */
int getopt(int argc, char * const argv[], const char *optstring);
int getopt_long(int argc, char * const argv[], const char *optstring,
                          const struct option *longopts, int*longindex);
int getopt_long_only(int argc, char * const argv[],const char *optstring,
                          const struct option *longopts, int*longindex);
extern char *optarg;         /* 系统声明的全局变量 */
extern int optind, opterr, optopt;
```

* getopt示例

```c
#include <stdio.h> // sscanf fprintf stderr
#include <unistd.h> // getopt

unsigned long addr = 0;
int count = 4; // 字节数
int offset = 0; // addr偏移
char *pkg = 0;

int opt = -1;
opterr = 0; // 自己处理错误
while ((opt = getopt(argc, argv, "a:c:o:p:")) != -1)
    switch (opt) {
        case 'a':
            sscanf(optarg, "%lx", &addr); // 加不加0x前缀都可以
            break;
        case 'c':
            sscanf(optarg, "%d", &count);
            break;
        case 'o':
            sscanf(optarg, "%d", &offset);
            break;
        case 'p':
            pkg = optarg;
            break;
        case '?':
            fprintf(stderr, "Unknown option: %c\n", (char)optopt);
            exit(1); // 可能有选项没读到
    }
if (optind < 5) {
    fprintf(stderr, "Usage: %s -a addr [-c count] -p pkg [-o offset]\n", argv[0]);
    exit(1);
}

printf("optind = %d opterr = %d optopt = %d optarg = %s opt = %d\n", optind, opterr, optopt, optarg, opt);
```

* [命令行选项解析函数(C语言)：getopt()和getopt_long() - 陈立扬 - 博客园](https://www.cnblogs.com/chenliyang/p/6633739.html)
* [使用 getopt() 进行命令行处理](https://www.ibm.com/developerworks/cn/aix/library/au-unix-getopt.html)

### 运行Shell命令并获取结果

* system() 只返回状态码，不返回结果，通过管道 popen() 可以获取命令的执行结果

```c
#include <stdio.h> // sscanf fprintf stderr popen pclose perror
#include <string.h> // memset

#define BUFSIZE 128

/**
 * 运行Shell命令并获取结果
 * 返回命令的状态码 失败返回 -1
 */
int shell (char *cmd, char *buf, int len) {
    
    if (!cmd || !buf || len < 0) {
        fprintf(stderr, "cmd = %s buf = %s len = %d\n", cmd, buf, len);
        return -1;
    }

    memset(buf, 0, len);
    FILE *fp = popen(cmd, "r");
    if (!fgets(buf, len, fp))
        fprintf(stderr, "获取Shell命令 %s 结果失败\n", cmd);
    
    int res = pclose(fp);
    if (res == -1) perror("关闭管道失败");
    return res % 255; // 0 ~ 254
}

/**
 * 获取指定包名的PID
 * 失败返回 -1
 */
int getPid (char *pkg) {
    char cmd[BUFSIZE] = { 0 };
    
    sprintf(cmd, "pidof -s %s", pkg);
    
    char pid[BUFSIZE] = { 0 };
    int code = shell(cmd, pid, sizeof(pid));
    if (code != 0) {
        fprintf(stderr, "获取 %s PID失败 状态码 %d\n", pkg, code);
        return -1;
    }
    
    return atoi(pid);
}
```

### 大端与小端

* 内存的单位是1字节，大端和小端是指多个字节在内存的两种放置方法
* 举例：1234
* 0x04d2 Big-Endian: 低字节在高地址(对内存是反的)
* 0xd204 Little-Endian: 低字节在低地址(对于人是反的)
* 字节字符的操作如 stdlib.h 的 memcpy memcmp

### 分割字符串 strtok strtok_r strtok_s

* strtok 会改变原字符数组
* strtok_r 不会改变字符数组（Linux）
* strtok_s 不会改变字符数组（Windows）
* 它们都会写原字符数组，所以不能给常量

```c
#include <string.h>
/**
 * 把str用delim分割成若干份，分别保存到save里，保存n个
 * 返回保存了几份 i < cnt 其实直接save[i]也行
 * 也可以直接传一个函数
 */
int split (char *str, char *delim, char **save, int n) {
    char *next;
    char *sub = strtok_r(str, delim, &next);
    
    int cnt;
    for (cnt = 0; cnt < n && sub; cnt++) {
        save[cnt] = sub;
        sub = strtok_r(NULL, delim, &next);
    }
    return cnt;
}
```

* [到处是“坑”的strtok()—解读strtok()的隐含特性_梦想专栏-CSDN博客](https://blog.csdn.net/vevenlcf/article/details/100582959)
* [字符串分割利器—strtok_r函数_烟花易冷-CSDN博客](https://blog.csdn.net/zhouzhenhe2008/article/details/74011399)

### 浮点数 IEEE 754

* 单精度32位 **-1^S * 2^(E-127) * 1 + M**
  * S 符号位 1bit
  * E 指数位 8bit，减一个固定值127（正负）
    * **2^(n-1)-1** = 2^(8-1)-1 = 2^7-1 = 128-1 = **127**
  * M 分数位 23bit
    * 隐藏始终为1的高位，所以要加1（1.xxx * 2^n 表示而不是 0.1xxx * 2^n-1）
  * 精度：小数点后 **6~7** 位
* 双精度64位 **-1^S * 2^(E-1023) * 1 + M**
  * S 符号位 1bit
  * E 指数位 10bit
  * M 分数位 52bit
  * 精度：小数点后 **15 ~ 16** 位
* 特殊值

|    形式    |    指数     |    小数部分    |
| :--------: | :---------: | :------------: |
|     零     |      0      |       0        |
| 非规约形式 |      0      |   大于0小于1   |
|  规约形式  | 1 ~ 2^e - 2 | 大于等于1小于2 |
|    无穷    |   2^e - 1   |       0        |
|    NaN     |   2^e - 1   |      非0       |

* 规约形式的浮点数
  * 指数部分非0，使用科学表示法，分数为 1.xxx 的形式（因为高位固定为1所以省略只存小数部分）
  * “规约”是指用唯一确定的浮点形式去表示一个值
* 非规约形式的浮点数
  * 指数部分的为0，分数部分非零（某个数字**相当**接近零时的表示）
* [浮点数的二进制表示 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2010/06/ieee_floating-point_representation.html)
* [IEEE 754 - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki/IEEE_754#非规约形式的浮点数)
* [float和double的精度 - A_C_PRIMER - 博客园](https://www.cnblogs.com/c-primer/p/5992696.html)
* [从科学记数法到浮点数标准IEEE 754](https://mp.weixin.qq.com/s/mf1mH-aGWgcC6v2R8ijE8A)
* [IEEE-754 浮点数 - 知乎](https://zhuanlan.zhihu.com/p/108142465)
* [IEEE754标准 单精度(32位)/双精度(64位)浮点数解码_jocks的专栏-CSDN博客](https://blog.csdn.net/jocks/article/details/7800861)

### main函数的启动

* 内核使用 exec 函数启动 c 程序
* exec 调用 main 前，先调用启动程序（连接器添加的程序的真正起始）
  * 启动程序调用 main：`exit(main(argc, argv));`
  * 启动程序一般是由汇编实现的
* 从内核获取命令行参数和环境变量

### 进程的 termination

* 从 main 返回
  * return 和 sizeof 一样不是函数，故括号可以省略
* 调用 exit（先清理再返回内核）
  * 调用**终止处理程序**（exit handler）
  * 关闭所有打开的流（fclose）
    * flush 缓冲中的数据（写入文件）
    * 包括标准I/O（标准输入、输出、错误）
  * POSIX.1 扩展：若程序调用 exec 函数族，则清理所有 exit handler
  * 调用 _exit 或 _Exit 返回内核
* 调用 _exit 或 _Exit（直接返回内核）
  * void exit(int status)、void _exit(int status) 由 ISO C 定义，所以头文件为 stdlib.h
  * void _Exit(int status) 由 POSIX.1 定义，头文件为 unistd.h
  * 其中，参数 status 为整数型 **exit status** （终止状态或退出状态）
* 最后一个线程从其启动程序返回
* 最后一个线程调用 pthread_exit
* 调用 abort（异常abnormal终止）
* 接到一个信号（异常终止）
* 最后一个线程接收到取消请求（异常终止）

### 进程的 exit handler

* 终止处理程序或退出处理程序
* 只有在程序正常终止时自动执行（exit）
  * 异常结束的程序（信号处理程序）
  * 也会因异常结束的 exit handler 而中断
  * 不要在 exit handler 里调用 exit（未定义，Linux则会正常执行后面的）
* C89规定能有32个，不过实际可能不止 sysconf(_SC_ATEXIT_MAX)（unistd.h）
* 用 int atexit(void (*func)(void)) 注册 exit handler（头文件为 stdlib.h，成功返回 0，出错返回非 0）
* exit 调用 exit handler 的顺序与注册的顺序相反（栈）
* 同一个 exit handler 如果被注册多次，就会被调用多次（不去重）
* fork 创建的子进程会继承父进程注册的退出处理函数
* 而 exec 会移除所有已注册的退出处理程序
  * 替换包括退出处理程序在内的所有原程序代码段
  * 也是内核调用程序的方式
* 无法知道终止处理程序已注册数量，也无法取消已注册的（但是可以屏蔽）
* 终止处理程序无法知道 exit status，也没有参数
  * 解决 glibc 的 `int on_exit (void (*f)(int, void *), void *arg)`
  * 使用 atexit 和 on_exit 注册的函数位于同一函数列表，混用无影响
* 在创建子进程的应用中，典型情况下仅有一个进程（一般为父进程）应通过调用 exit()终止
* 而其他进程应调用 _exit 终止，从而确保只有一个进程调用退出处理程序并刷新 stdio 缓冲区（以免输出多次）
*  write 会将数据立即传给内核高速缓存，而 printf 的输出则需要等到调用 exit 刷新 stdio 缓冲区时

### 进程的 exit status

* 退出码为int型，但是只有16位是有效的
  * 高8位：为退出值
  * 低8位：为退出信号
  * system返回-1：
    * 创建子进程失败或无法获取子进程状态时
    * system() 在处理信号失败时
    * 调用 signal(SIGCHLD, SIG_IGN) 时（忽略了SIGCHLD）
      * 凡父进程不调用 wait 函数族获得子进程终止状态的子进程在退出时都会变成**僵尸进程**
      * SIGCHLD 信号可以异步的通知父进程有子进程退出
* exit status 翻译为退出状态或终止状态（成功返回 0，失败返回非 0）
* exit status 未定义的三种情况（C99标准，未定义时 exit status 取决于栈或特定 CPU 寄存器中的随机值）
  * 调用 exit、\_exit、_Exit 时，参数为空
  * main 函数执行了无返回值的 return 语句
    * exit(status) 等价于 return status，因为启动程序用 exit 调用 main
  * main 没有声明返回值为 int
    * 如果 main 返回值未指定，默认为 int
    * 如果 main 返回值为 int，没有 return 语句，默认 `return 0`
* 在 Shell 编程中，退出状态很常见：[退出状态码 Exit Status](Shell笔记.md#退出状态码-Exit-Status)
* [使用exit(-1)为什么得到255退出码? - 风雪之隅](https://www.laruence.com/2012/02/01/2503.html)
* [system调用总是返回-1_Flashing-C的博客-CSDN博客_system返回-1](https://blog.csdn.net/weixin_33398032/article/details/78983727)
* [signal(SIGCLD,SIG_IGN)_少想多做-CSDN博客_sig_ign](https://blog.csdn.net/u012317833/article/details/39253793)

### grep小技巧

```sh
grep -r "xx" # 在当前目录及其子目录下的文件里找 xx
```

### VI小技巧

```sh
:%s/vivian/sky/g # 等同于 :g/vivian/s//sky/g 替换每一行中所有 vivian 为 sky
```

### 各种libc实现

* 同一个平台下，不同的库编译的二进制文件也有区别
* 为什么有这么多库实现：为了体积和侧重点等
* glibc 最全的，缺点是太大（大部分 Linux）
* bionic 安卓上的实现（采用BSD许可证，很多POSIX特性不支持）
* Newlib （Cygwin）
* BSD libc（大部分Unix）
* uClibc（适合嵌入式，不支持很多特性）
* musl 支持挺多的（如 alpine）Linux内核开发和史诗鲁棒性都很不错
* dietlibc（应该是最精简的）
* msvcrt 微软的实现
* [uclibc,eglibc,glibc,Musl-libc之间的区别和联系](http://www.kumouse.com/?p=1051)
* 直观的图表对比：[Comparison of C/POSIX standard library implementations for Linux](https://www.etalabs.net/compare_libcs.html)
* [Cygwin系列（一）：Cygwin是什么 - 知乎](https://zhuanlan.zhihu.com/p/56692626)

### Linux挂载

```sh
mount -l # 查看挂载情况
df -h # 显示目前在Linux系统上的文件系统的磁盘使用情况统计
lsblk # 列出块设备信息（df -h不能看到的卷）

# 挂载光盘 卸载光盘
mkdir -p /mnt/cdrom
mount -t is09660 /dev/cdrom /mnt/cdrom
umount /mnt/cdrom

# 挂载ISO文件
mount -o loop /tmp/linux.iso  /mnt/linux
mount -o loop,ischarset=gb2312 /tmp/linux.iso /mnt/linux

# 挂载软盘
mount /dev/fd0 /mnt/floppy

# 挂载U盘
fdisk -l # 查看外挂闪存的设备号 一般为/dev/sda1
mkdir -p /mnt/usb
mount -t msdos /dev/sda1 /mnt/usb # 挂载FAT格式U盘
mount -t vfat /dev/sda1 /mnt/usb # 挂载FAT32格式U盘
```

* [linux挂载光盘 - gd_无痕 - 博客园](https://www.cnblogs.com/gd-luojialin/p/9216059.html)
* [Linux的硬盘使用情况、挂载、SSD挂载（查看df -h不能看到的卷） - 低调人生 - 博客园](https://www.cnblogs.com/lemon-flm/p/7597403.html)

### Linux改密码

* passwd 用户名

```sh
passwd root # 改root密码
```

* Linux 系统密码破解
  * 在grub选项菜单按e进入编辑模式
  * 编辑kernel那行 /init 1 (或/single)，按b重启
  * 进入后执行下列命令

```sh
passwd root
init 6
```

* Debian 系统密码破解
  * 在grub选项菜单’Debian GNU/Linux,…(recovery mode)’,按e进入编辑模式
  * 编辑kernel那行面的 ro single 改成 rw single init=/bin/bash，按b重启
  * 进入后执行下列命令

```sh
mount -a
passwd root
reboot
```

* [Linux下如何修改root密码以及找回root密码 - dy9776 - 博客园](https://www.cnblogs.com/nucdy/p/5642309.html)
* [Linux下用于查看系统当前登录用户信息的4种方法_newdriver2783的专栏-CSDN博客_linux中显示当前登录用户详细信息的是](https://blog.csdn.net/newdriver2783/article/details/8059368)

### Debian换源

```sh
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

vi /etc/apt/sources.list
deb http://mirrors.ustc.edu.cn/debian stable main contrib non-free
# deb-src http://mirrors.ustc.edu.cn/debian stable main contrib non-free
deb http://mirrors.ustc.edu.cn/debian stable-updates main contrib non-free
# deb-src http://mirrors.ustc.edu.cn/debian stable-updates main contrib non-free
# deb http://mirrors.ustc.edu.cn/debian stable-proposed-updates main contrib non-free
# deb-src http://mirrors.ustc.edu.cn/debian stable-proposed-updates main contrib non-free

apt-get update
```

* 更多镜像
  * 中科大：http://mirrors.ustc.edu.cn/
  * 阿里云：http://mirrors.aliyun.com/
  * 搜狐：http://mirrors.sohu.com/
  * 网易：http://mirrors.163.com/
  * 原版：http://deb.debian.org

```sh
# wheezy Debian7
deb http://deb.debian.org/debian wheezy main
deb-src http://deb.debian.org/debian wheezy main

deb http://deb.debian.org/debian-security/ wheezy/updates main
deb-src http://deb.debian.org/debian-security/ wheezy/updates main

deb http://deb.debian.org/debian wheezy-updates main
deb-src http://deb.debian.org/debian wheezy-updates main
```

#### source.list详解

* source.list格式

```sh
deb http://site.example.com/debian distribution component1 component2 component3
deb-src http://site.example.com/debian distribution component1 component2 component3
```

* 档案类型 Archive type
  * deb 预编译包
  * deb-src 源码包
* 仓库地址 Repository URL
* 发行版 Distribution
  * 发行版有两种分类方法，一类是发行版的具体代号，如 xenial,trusty, precise 等
  * 还有一类则是发行版的发行类型，如 oldstable, stable, testing 和 unstable
  * 另外，在发行版后还可能有进一步的指定，如 xenial-updates, trusty-security, stable-backports 等

| **Version** | **Code name**                                      | **Release date**                                             | **End of life date**                                         | **EOL [LTS](https://wiki.debian.org/LTS)**              | **EOL [ELTS](https://wiki.debian.org/LTS/Extended)** |
| ----------- | -------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------- | ---------------------------------------------------- |
| 12          | [Bookworm](https://wiki.debian.org/DebianBookworm) |                                                              |                                                              |                                                         |                                                      |
| 11          | [Bullseye](https://wiki.debian.org/DebianBullseye) |                                                              |                                                              |                                                         |                                                      |
| 10          | [Buster](https://wiki.debian.org/DebianBuster)     | [2019-07-06](https://www.debian.org/News/2019/20190706)      | ~2022                                                        |                                                         |                                                      |
| 9           | [Stretch](https://wiki.debian.org/DebianStretch)   | [2017-06-17](https://www.debian.org/News/2017/20170617)      | 2020-07-06                                                   | ~2022                                                   |                                                      |
| 8           | [Jessie](https://wiki.debian.org/DebianJessie)     | [2015-04-25](https://www.debian.org/News/2015/20150426)      | [2018-06-17](https://www.debian.org/News/2018/20180601)      | ~2020-06-30                                             | ~2022-06-30                                          |
| 7           | [Wheezy](https://wiki.debian.org/DebianWheezy)     | [2013-05-04](https://www.debian.org/News/2013/20130504)      | [2016-04-25](https://www.debian.org/News/2016/20160425)      | [2018-05-31](https://www.debian.org/News/2018/20180601) | ~2019-12-31                                          |
| 6.0         | [Squeeze](https://wiki.debian.org/DebianSqueeze)   | [2011-02-06](https://www.debian.org/News/2011/20110205a)     | [2014-05-31](https://www.debian.org/security/2014/dsa-2907)  | [2016-02-29](https://www.debian.org/News/2016/20160212) |                                                      |
| 5.0         | [Lenny](https://wiki.debian.org/DebianLenny)       | [2009-02-14](https://www.debian.org/News/2009/20090214)      | [2012-02-06](https://lists.debian.org/debian-security-announce/2011/msg00238.html) |                                                         |                                                      |
| 4.0         | [Etch](https://wiki.debian.org/DebianEtch)         | [2007-04-08](https://www.debian.org/News/2007/20070408)      | [2010-02-15](https://www.debian.org/News/2010/20100121)      |                                                         |                                                      |
| 3.1         | [Sarge](https://wiki.debian.org/DebianSarge)       | [2005-06-06](https://www.debian.org/News/2005/20050606)      | [2008-03-31](https://www.debian.org/News/2008/20080229)      |                                                         |                                                      |
| 3.0         | [Woody](https://wiki.debian.org/DebianWoody)       | [2002-07-19](https://www.debian.org/News/2002/20020719)      | [2006-06-30](https://www.debian.org/News/2006/20060601)      |                                                         |                                                      |
| 2.2         | [Potato](https://wiki.debian.org/DebianPotato)     | [2000-08-15](https://www.debian.org/News/2000/20000815)      | 2003-06-30                                                   |                                                         |                                                      |
| 2.1         | [Slink](https://wiki.debian.org/DebianSlink)       | [1999-03-09](https://www.debian.org/News/1999/19990309)      | [2000-09-30](https://lists.debian.org/debian-security-announce/2000/msg00043.html) | 2000-10-30                                              |                                                      |
| 2.0         | [Hamm](https://wiki.debian.org/DebianHamm)         | [1998-07-24](https://www.debian.org/News/1998/19980724)      | -                                                            |                                                         |                                                      |
| 1.3         | [Bo](https://wiki.debian.org/DebianBo)             | [1997-07-02](https://www.debian.org/News/1997/19970602)      | -                                                            |                                                         |                                                      |
| 1.2         | [Rex](https://wiki.debian.org/DebianRex)           | [1996-12-12](https://lists.debian.org/debian-announce/1996/msg00026.html) | -                                                            |                                                         |                                                      |
| 1.1         | [Buzz](https://wiki.debian.org/DebianBuzz)         | [1996-06-17](https://lists.debian.org/debian-announce/1996/msg00021.html) | -                                                            |                                                         |                                                      |
| 0.93R6      |                                                    | [1995-10-26](https://lists.debian.org/debian-announce/1995/msg00007.html) | -                                                            |                                                         |                                                      |
| 0.93R5      |                                                    | [~1995-03-01](https://lists.debian.org/debian-announce/1995/msg00004.html) | -                                                            |                                                         |                                                      |
| 0.91        |                                                    | ~1994-01-01                                                  | -                                                            |                                                         |                                                      |

* 软件包分类 Component
  * 软件包的具体分类，可以有一个或多个
  * Debian
    * mian：包含符合 DFSG 指导原则的自由软件包，而且这些软件包不依赖不符合该指导原则的软件包。这些软件包被视为 Debian 发型版的一部分
    * contrib：包含符合 DFSG 指导原则的自由软件包，不过这些软件包依赖不在 main 分类中的软件包
    * non-free：包含不符合 DFSG 指导原则的非自由软件包
  * Ubuntu
    * main：官方支持的自由软件
    * restricted：官方支持的非完全自由的软件
    * universe：社区维护的自由软件
    * multiverse：非自由软件

* [Debian更换软件源_Jomesm的博客-CSDN博客_debian换源](https://blog.csdn.net/jomesm/article/details/88374156)
* [SourcesList - Debian Wiki](https://wiki.debian.org/SourcesList)
* [/etc/apt/sources.list 详解_gong_xucheng的专栏-CSDN博客_/etc/apt/sources.list.d/](https://blog.csdn.net/gong_xucheng/article/details/53886271)
* [DebianReleases - Debian Wiki](https://wiki.debian.org/DebianReleases)

### vi方向键乱码退格键用不了

* Debian、Ubuntu下使用vi编辑模式，方向键乱码，甚至退格键都用不了
* 原因：vim 预装的是 tiny 版本，默认开启了兼容模式

```sh
vi /etc/vim/vimrc.tiny
set uncompatible # 改为不兼容模式
set backspace=2 # 解决退格键用不了
```

* 或者安装完整版vim

```sh
dpkg -l | grep vim # 查看所有已安装的vim相关包
apt-get remove vim-common
apt-get install vim
```

* [ubuntu 下使用vi时方向键乱码，退格键不能使用 - 一个运维的日常 - 博客园](https://www.cnblogs.com/yunweis/p/7727024.html)

### U 盘安装 Ubuntu 提示 Not a COM32R image

* 按 tab 键，会显示可用的命令，输入 live 进入体验界面
* [如何在Ubuntu系统中重新安装不同版本的Ubuntu！（……Not a COM32R image ……“错误的解决办法！_刀刀的专栏-CSDN博客](https://blog.csdn.net/zyz511919766/article/details/7553221)

### 修改 PATH

* 修改 ~/.bashrc，参考 [Shell的各个启动脚本](Shell笔记.md#Shell的各个启动脚本)

```sh
export PATH=\
$GOPATH/bin:\ # go env
$PATH
```

* [Linux PATH 作用以及查看和修改方法_haozhepeng的专栏-CSDN博客](https://blog.csdn.net/haozhepeng/article/details/100584451)

### 安装 VirtualBox 增强插件

* 

```sh
sudo mkdir -p /mnt/cdrom
sudo mount -t iso9660 /dev/cdrom /mnt/cdrom/
cd /mnt/cdrom
sudo apt install gcc make perl # 可选
sudo sh ./VBoxLinuxAdditions.run
sudo umount -l /dev/cdrom
reboot
```

* [如何安装VirtualBox增强功能插件(linux)?超详细-百度经验](https://jingyan.baidu.com/article/fdbd42770ccc83f99f3f4804.html)

### mount umount 挂载光驱

* -t 指定文件系统类型，通常无需指定
  * DOS fat16文件系统：msdos 
  * Windows 9x fat32文件系统：vfat 
  * Windows NT ntfs文件系统：ntfs 
  * Mount Windows文件网络共享：smbfs 
  * UNIX(LINUX) 文件网络共享：nfs 
* -o 挂载选项
  * loop：用来把一个文件当成硬盘分区挂接上系统 
  * ro：采用只读方式挂接设备 
  * rw：采用读写方式挂接设备 
  * iocharset：指定访问文件系统所用字符集 
* 制作 iso 文件

```sh
cp /dev/cdrom /root/mydisk.iso
dd if=/dev/cdrom of=/root/mydisk.iso
mkisofs -r -J -V mydisk -o /root/mydisk.iso /root/mydir # mydisk为光盘卷标
```

* [linux mount (挂载命令)、umount （卸载命令）详解_sweetfather的博客-CSDN博客](https://blog.csdn.net/sweetfather/article/details/79988995)
* [Linux挂载光盘（使用mount命令）](c.biancheng.net/view/3327.html)

