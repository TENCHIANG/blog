### ~/.bash_profile 和 ~/.bashrc

* `~/.bash_profile`：**login shell**
* `~/.bashrc`：**non-login shell**

### 命令行设置代理

* cmd

  * `set http_proxy=http://127.0.0.1:1080`
  * `set https_proxy=http://127.0.0.1:1080`
* sh

  * `export http_proxy=http://127.0.0.1:1080`
  * `export https_proxy=http://127.0.0.1:1080`
  * `cat ~/.bash_profile`
* git
  * `git config --global http.proxy http://127.0.0.1:1080`
  * `git config --global https.proxy http://127.0.0.1:1080`
  * `git config --global --unset http.proxy`
  * `git config --global --unset https.proxy`
  * `npm config delete proxy`
  * `cat ~/.gitconfig`

### 生成RSA密钥公钥

```ssh
ssh-keygen -t rsa -b 4096 -C "备注或署名"
```

* 一直回车就好了
* 如果看到 `Overwrite (y/n)? y` 则说明以前生成过，是否覆盖生成新的

### 使用ssh对github进行身份验证
本机公钥设置到github后，还可以验证一下
```sh
$ ssh -T git@github.com
Hi TENCHIANG! You've successfully authenticated, but GitHub does not provide shell access.
```

### Git-Windows中文乱码

```sh
git status # 中文乱码
git config --global core.quotepath false
```

参考：

* [Git for windows 中文乱码解决方案](https://www.cnblogs.com/ayseeing/p/4203679.html)

  [git- win10 cmd git log 中文乱码 解决方法](https://blog.csdn.net/sunjinshengli/article/details/81283009)

### Git配置

```sh
git config --list # 查看已有的配置
git config --global --list # 查看已有的全局配置

# 如果是刚下了 git 建议要初始化
git config --global user.name "TENCHIANG"
git config --global user.email "tenchaing@qq.com"

# 删除配置
git config --global --unset user.mail # 正确的应该是 user.email
```

### Git创建仓库

```sh
# 创建仓库
mkdir porj
cd proj
git init
echo "# proj" >> README.md
git commit -m "first commit"
git remote add origin https://gitee.com/xxx/proj.git
git push -u origin master

# 已有仓库
cd proj
git remote add origin https://gitee.com/xxx/proj.git
git push -u origin master
```

* `git push -u origin master`：-u 的意思是之后就可以直接 `git push` 了
* 创建仓库 push 的时候需要在GitHub上添加本机的公钥

### 撤销commit

```ssh
git reset --soft HEAD^
git push origin HEAD --force # 撤销远程push
```

* 只撤回 `commit` 操作，不该表代码本身
* `HEAD^` 的意思是上一个版本
  * 也就是 `HEAD~1`，撤回 n 次就是 `HEAD~n`，HEAD表示为当前提交
  * 也是  `<commit_id> `的简写
* `--soft` ：只撤销 commit
* `--mixed`：默认的可省略操作：撤销commit、撤销git add、不撤销工作空间（修改代码）
* `--hard`：撤销commit、git add、工作空间！
* 修改或重写commit：`git commit --amend`
* 撤销到第一个 commit 怎么办：`git reflog`

### 删除已commit的文件

* `.gitignore` 文件里面要添加新项，然后又已经commit，甚至push了咋办
* `.gitignore`只能忽略那些原来没有被track的文件，如果某些文件已经被纳入了版本管理中，则修改`.gitignore`是无效的

```sh
git rm -r --cached -n path/ # -n 只查看要删除的文件
git rm -r --cached path/ # --cached 只删除版本库的 不删除本地的
# 删除远程版本库中的文件
git commit --amend
git push origin dev --force
```

### 克隆私有仓库
```sh
git clone https://username:password@github.com/TENCHIANG/sdgs
```

### git换行符问题

* CR \r 0x0d
* LF \n 0x0a
* Windows CR LF
* Unix/Linux LF
* MacOS CR
* core.autocrlf false 不对换行符做任何特殊处理
* core.autocrlf true 提交时转换为LF，检出时转换为CRLF
* core.autocrlf input 提交时转换为LF，检出时不转换（LF）
* [Git中的core.autocrlf选项 - icuic - 博客园](https://www.cnblogs.com/outs/p/6909567.html)

### 个人常用配置

```sh
[user]
        name = TENCHIANG
        email = yy5209zz@gmail.com
[core]
        autocrlf = input # 交时转换为LF，检出时不转换（LF）
        safecrlf = false # 忽略拒绝提交混合换行符 改成自动转换
        quotepath = false # 防止windows中文乱码
[color]
        ui = auto
[http]
        proxy = http://127.0.0.1:1080
[https]
        proxy = https://127.0.0.1:1080
```

参考：

* [Git 忽略提交 .gitignore](https://www.jianshu.com/p/74bd0ceb6182)

* [Git 中文详细安装教程_git_谢宗南的博客-CSDN博客](https://blog.csdn.net/sishen47k/article/details/80211002)

### Github 仓库内的跳转

* 用斜杠 / 作为目录分隔符
* / 表示仓库根目录（无需加协议头）
* 文件如果有空格，则用 %20 代替
* 跳转到标题用 # 开头
  * 如果标题有空格，则用 - 链接
  * 如果有符号，则直接忽略
  * 可以直接去实际页面查看地址

```md
### a (b)
以上标题对应的链接就是 #a-b
```

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

