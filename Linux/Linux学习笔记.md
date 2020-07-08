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

