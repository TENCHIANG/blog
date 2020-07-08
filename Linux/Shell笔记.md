## Shell笔记

### Shell分为内建命令和外部命令

* **内建命令**
  * 凡是用 which 命令查不到程序文件所在位置的命令都是内建命令
  * 内建命令不创建新的进程（相当于执行**当前进程**的函数）
  * 有状态码 Exit Status
* **外部命令**
  * 通过man可以查到的命令
  * 执行外部命令 Shell会 fork 并 exec 该命令（新建一个**子进程**执行）
  * 有状态码 Exit Status
* 上面都是在交互式模式说的

### Shell叫本执行的3种方法 fork source exec

重要区别就是是否创建了子进程

* **fork** 创建了子进程（继承父进程变量反之不然）：
  * 使用 sh 执行脚本或给 +x 属性直接执行脚本（等价于前者）
  * 在脚本里调用外部命令、使用了管道符、用括号包括了命令
* **source** 不新建子进程（变量共享）
  * `.` 和 `source` 命令等价，都是内置命令
* **exec** 不新建子进程（变量共享）
  * 与 source的区别：子脚本执行后，父脚本不会接着执行了
* [三种shell脚本调用方法(fork, exec, source)](https://xstarcd.github.io/wiki/shell/fork_exec_source.html)

### Shell调用子进程详解

*  fork 一个子进程
* 调用 exec 执行 ./script.sh
  * 通常情况：把子进程的代码段替换为 目标程序 的代码段，并从 _start 开始执行
  * 脚本情况：是文本，且第一行用Shebang指定了解释器
    * 则用解释器程序的代码段替换当前进程
    * 从解释器的 _start 开始执行
    * 而这个文本文件被当作命令行参数传给解释器
    * 相当于 /bin/sh ./script.sh
* 父进程等待子进程执行完毕后再执行

### 取命令返回值用 $() 包起来

* 内置命令用括号包起来会在子进程执行 (xxx; xxx; ...)
* 注意等号两边不能有空格
* 注意取的是标准输出，标准错误输出则忽略

```sh
timestamp=$(date +%s%3N)
```

### 退出状态码 Exit Status

* 命令运行完的返回值
* 退出状态码：成功为 0 为 真，失败为 非0 为假（错误码）
* 注意命令返回值和状态码是两码事（可以没有返回值 但是一定有状态值）
  * 命令的返回值其实是**标准输出**
  * 状态码才是正儿八经的返回码

```sh
echo $(date +%s%3N) # 毫秒级时间戳
echo $(test -e README.md) # 啥都没
```

* **脚本的退出码**：exit、return（.或source当作函数执行）、最后一条命令的退出码
* **函数的退出码**：return、最后一条命令的退出码

#### exit与return的区别

* exit是命令级别的（外部命令），用来退出进程，在任意地方都可调用
* return是语言级别的（内部命令），调用堆栈的返回，用来退出函数，只能在函数中调用
* 其实还有一个系统调用级别的（编译型调用的，如外部命令本身调用的就是系统调用）

#### 退出状态码约定

| Exit Code Number | Meaning                                             | Example                 | Comments                                                     |
| ---------------- | --------------------------------------------------- | ----------------------- | ------------------------------------------------------------ |
| 1                | 通用错误，任何错误都可能使用这个退出码              | let “var1 = 1/0″        | 如除零错误                                                   |
| 2                | shell内建命令使用错误                               | empty_function() {}     | Seldom seen, usually defaults to exit code 1                 |
| 126              | 命令调用不能执行                                    |                         | Permission problem or command is not an executable           |
| 127              | 找不到命令 “command not found”                      | illegal_command         | Possible problem with `$PATH` or a typo                      |
| 128              | exit参数错误，exit只能以整数作为参数                | exit 3.14159            | exit takes only integer args in the range 0 – 255 (see first footnote) |
| 128+n            | 信号"n"的致命错误                                   | kill -9 $PPID of script | 如kill -9 脚本的PID，则返回137（128+9）                      |
| 130              | 用Control-C来结束脚本，用Control-C是信号2的致命错误 |                         | Control-C is fatal error signal 2, (130 = 128 + 2, see above) |
| 255*             | Exit status out of range                            | exit -1                 | exit takes only integer args in the range 0 – 255            |

* 当返回的退出码大于255时，会将其对256取模。return只能返回大于0的整数。exit可以返回任意整数，但是超过有效范围的值会对256取模
* [exit(-1)或者return(-1)shell得到的退出码为什么是255_linux shell_脚本之家](https://www.jb51.net/article/73377.htm)
* [Shell获取退出码（返回码）_shell_荣耀之路-CSDN博客](https://blog.csdn.net/asty9000/article/details/86681890)

### 使用变量 $ 或 ${}

```sh
a=1
echo $a
echo ${a}
```

### echo命令

* echo -n 不换行输出（echo默认加换行）
* echo -e 处理转移符

```sh
$ echo "asdas\nd"
asdas\nd
$ echo -e "asdas\nd"
asdas
d
```

* **echo 把换行符替换为空格**

```sh
echo `ps | awk '{print $2}'` # 列出所有PID
echo `ps | awk '{print $2}'` # 列出所有PPID
cat hello.txt | xargs # 另外的方法 好像不能和grep连用
```

* 参考：[shell中将字符中换行符\\n替换为空格_shell_万里之书-CSDN博客](https://blog.csdn.net/guoyajie1990/article/details/73692526)

### 环境变量和本地变量是有区别的

* 环境变量可以从父进程传给子进程
* 本地变量只存在于当前Shell进程（包括函数）
*  set 命令可以显示当前Shell进程中定义的所有变量（包括本地变量和环境变量）
* 用 export 命令可以把本地变量导出为环境变量

```sh
export VARNAME=value # 1

VARNAME=value # 2
export VARNAME
```

* **删除已定义的环境变量或本地变量**：unset x 或 x=
* [Linux 环境变量 - Creaink - Build something for life](https://creaink.github.io/post/Computer/Linux/Linux-env.html)

#### 变量未定义和已定义的区别

* 变量未定义的结果时 null（unset）
* **变量已定义但不赋值的结果是空字符串**

#### 全局变量和局部变量

* **Shell 默认是全局变量**
* 只能在函数里定义局部变量：`local x=1`

### 文件名代换（Globbing）：* ? []

* 用通配符进行代换（Wildcard）
* 代换的工作是 Shell 进行的，传给命令的时候是已经代换后的值
* `*` 任意个字符
* `?` 一个字符
* `[]` 括号里的任意一个字符 

### 命令代换：`` $()

* 括起来的命令，Shell先执行命令，然后将输出结果立刻代换到当前命令行中

```sh
DATE=`date`
DATE=$(date)
```

### 算术代换：$(())

* $(()) 中只能用+-*/和()运算符，并且只能做整数运算（里面的变量先转为整数）
* 事实上Shell变量的值都是字符串，所以可以直接定义 3.14

```sh
res=$((3/2))
echo $res # 1 而不是 1.5
pi=3.14 # 
```

### 单引号和双引号

* Shell脚本中的单引号和双引号一样都是字符串的界定符
* 如果引号没有配对就输入回车，Shell会给出续行提示符，要求用户把引号配上对
* 单引号用于保持引号内所有字符的字面值，即使引号内的\和回车也不例外
* 双引号用于保持引号内所有字符的字面值（回车也不例外），但以下情况除外：
  * $加变量名可以取变量的值
  * 反引号``仍表示命令替换
  * \\$ \\\` \\" \\\ 表示 \$ \` \" \\ 的字面值
* 其它字符前面的\无特殊含义（会显示\）
  
* 可见，双引号比单引号更特殊

### Shell启动

* bash启动分为：交互登录、交互非登录、非交互启动、sh命令启动
* 交互Shell：有命令提示符
* 登录Shell：输入用户名和密码
  * 登录Shell就是交互Shell
  * 或者使用--login参数启动

* 交互非登录Shell：
  * 图形界面下开一个终端窗口
  * 或者在登录Shell提示符下再输入 bash 命令
* 非交互Shell：为**执行脚本**而 fork 出来的子Shell（执行脚本文件）
* sh命令启动：sh命令启动bash（模拟sh）

### login shell 和 non-login shell 的启动脚本

* shell在启动时会执行相应的启动脚本作为初始化
  * 而启动脚本又分为 login shell 和 non-login shell 的区别
  * 为什么要区分，还是因为环境变量和本地变量的特性所致
  * 登录脚本是之后所有的父进程，环境变量能被继承
  * 而本地变量就需要非登录脚本来设置了

### Shell的各个启动脚本

* 交互**登录**Shell
  * 所有用户： /etc/profile
  * 当前用户：~/.bash_profile、~/.bash_login、~/.profile、~/.bash_logout
* 交互**非登录**Shell：~/.bashrc（更加普适）
  * 一般登录Shell也会调用非登录Shell的启动脚本

```sh
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
```

* 非交互启动：$BASH_ENV

```sh
if [ -n "$BASH_ENV" ]; then . "$BASH_ENV"; fi
```

* 以sh命令启动（不认 bash_ 开头的启动脚本了）
  * /etc/profile（交互登录 全局）
  * ~/.profile（交互登录 当前用户）
  * $ENV（交互非登录）
  * sh没交互启动脚本

### 条件测试：test [

* test 命令或 [ 命令测试一个条件是否成立
  * 成立表达式为真 Exit Status 为 0
  * 不成立表达式为假 Exit Status 为 1
* 注意 [ 是命令名，而 ] 是它的参数

```sh
[ -e ~/.bash_profile ]
test -e ~/.bash_profile
```

* -e DF 文件或目录
* -d DIR 存在目录
* -f FILE 存在普通文件
* -s FILE 是文件且非空
* -z STR 空字符串
* -n STR 非空字符串（一定要用**双引号包起来$**不然 null 也为真）
* STR1 = STR2 等于（也可用于数值）
* STR1 != STR2 不等于（也可用于数值）
* ARG1 OP ARG2（整数）
  *  -eq 等于（也可用于字符串）
  * -ne 不等于（也可用于字符串）
  * -lt 小于
  * -le 小于等于
  * -gt 大于
  * -ge 大于等于
* ! EXP 逻辑非
* EXP1 -a EXP2 逻辑与 all
* EXP1 -o EXP2 逻辑或 other
* **注意**：上面都要加空格，因为都是**参数**
* 在测试**相等性**的时候，数值和字符串其实没有区别

### 坑：所有要取变量值的都用双引号包起来

* 包起来就表示变量展开后的值作为一个**整体**
* 如果没定义则是空字符串而不会报错
  * 如果变量展开包含空格就不会报错 too many arguments
  * 还是基于字符惹的祸（格外注意意识到Shell的每个东西都是字符）
* **不要偷懒**只在定义的时候赋值 双引号 没用（x=""），相当于 x=，相当于未定义
  * 还是要在每个使用 $ 的地方用双引号包起来
  * 换句话说，在取变量值的地方都用双引号包起来了，那么就不用初始化变量了
  * 但是可以在一些可以不接任何参数的命令后不加双引号（相当于没有参数）

### if : then elif else fi

* 条件头是 if 命令的参数
* 条件体是 then 的参数
* **命令（包括其参数）之间以分号或换行符分隔，除非命令也作为参数**
* **参数以空格分隔，命令以分号或换行符分隔**
* 冒号 : 命令总为真
  * 冒号是内置命令
  *  /bin/true（外部命令 可简写为 true）
  * /bin/false （外部命令 可简写为 false）
* 注意：如果 then 后面不执行任何语句，也不要空着，要用 : 代替（什么都不做状态码为 0）

### -a -n 和 && || 的区别

* && 和 || 用于连接两个命令（命令级）
* -a 和 -o 仅用于在测试表达式中连接两个测试条件（参数级）

```sh
test "$VAR" -gt 1 -a "$VAR" -lt 3
test "$VAR" -gt 1 && test "$VAR" -lt 3
```

### case in esac

* 可以匹配字符串和通配符（基于字符串）
  * C语言只能匹配整型或字符型常量表达式（基于跳表）
* 每个匹配分支可以有若干条命令**末尾必须以 ;; 结束**
* 无需 break，满足条件执行相应命令后直接跳出

```sh
case $1 in
	start|START)
		echo "start"
		;;
	stop)
		echo "stop"
		;;
	restart)
		echo "restart"
		;;
	*)
		echo "Usage: script start|stop|restart"
		exit 1
		;;
esac
```

* *) 也匹配未定义的变量

### for in do done

```sh
# FRUIT 为变量
for FRUIT in apple banana pear; do echo "I like $FRUIT"; done
# I like apple
# I like banana
# I like pear

# 将当前目录下的 chap0 chap1 chap2 等文件改为 chap0~ chap1~ chap2~（作为临时文件）
for FILENAME in chap?; do mv $FILENAME $FILENAME~; done
for FILENAME in `ls chap?`; do mv $FILENAME $FILENAME~; done
```

### while do done

```sh
COUNTER=1
while [ "$COUNTER" -lt 10 ]; do
    echo "Here we go again"
    COUNTER=$(($COUNTER+1))
done
```

### untile do done

```sh
# 直到条件为真才结束
until :; do sleep 1; done
```

### 特殊变量

* $? 上一条命令的 Exit Status
* $0 脚本文件名（argv[0]）
  * 如果是交互式那就是解释器的路径如 /usr/bin/bash
* $1、$2、... 传给脚本的位置参数（Positional Parameter） argv[1]...
* $# 参数的个数（argc - 1，不算 $0）
* $* 参数列表（双引号包起来是整体）（合并）
* $@ 参数列表（双引号包起来不是整体）
* $$ 当前Shell的PID
* $PPID 父进程PID
* $! 后台运行的最后一个进程的进程ID号
* $- 显示shell使用的当前选项，与set命令功能相同
* $PS1 占位提示符
* [linux shell中$0,$?,$!等的特殊用法 - Viviane未完 - 博客园](https://www.cnblogs.com/viviane/p/11101643.html)

#### $* $@ 的区别

* 只在加了双引号时才有区别
* **$*** 将所有参数当作一个**整体** "$1c$2c$3...c$n"（其中c为**IFS**第一个字符，一般为空格）
* **$@** 会将参数**分开** "$1" "$2" ... "$n"（用的多）
* 例子见：[内部字段分隔符 IFS](Shell笔记.md#内部字段分隔符-IFS)

#### 内部字段分隔符 IFS

* IFS是Shell自带的环境变量字符串，默认值为：空格符 32 0x20、制表符 9 0x09、换行符 10 0x0a
* IFS是Shell把文本分割为一个个字段的（如用逗号分隔CSV文件，空格分隔字符串）
* 使用IFS迭代一些文件的时候就无需额外对字符串进行处理了（IFSu也可以改变echo的行为）

```sh
# 查看IFS
echo $IFS | od -tu1 # ADB Shell的IFS只有一个换行符

f () {
    for var in "$*"; do echo "$var"; done # 将所有参数当成一个整体
    for var in "$@"; do echo "$var"; done # 单独处理每个参数
}
IFS=^$IFS
f 1 2 3 4
# 1^2^3^4 # 如果第一个字符不是可打印字符 默认为空格
# 1
# 2
# 3
# 4

# 反转IP地址
ip=220.112.253.111
bak=$IFS # 备份IFS
IFS="." # 用点分割字段
tmp=`echo $ip` # 220 112 253 111
IFS=" " # 用空格分割字段
echo $tmp | read a b c d # 通过管道传给4个变量
IFS=$bak # 恢复IFS
invert=$d.$c.$b.$a
```

* [Shell中的IFS解惑_shell_Simple life-CSDN博客](https://blog.csdn.net/whuslei/article/details/7187639)

#### shift 位置参数左移

* shift N（默认为1），相当于抛弃第 [1, N] 的参数，从 N+1 开始从新算（除了 $0）

```
shift # 抛弃 $1 $2变成$1
```

### 函数

* 不用定义返回值和参数列表
  * 左花括号后必须有空格或换行（参数）
  * 右花括号前必须有分号或换行（命令）
  * 定义函数时并不执行函数体中的命令
* 函数也有参数列表和返回值（类似于脚本）
  * return 也可以用于结束函数
  * 只能返回整数（Exit Status）
  * 不加返回值默认返回 0（甚至不加 return 同理）
* 函数的参数列表
  * 函数调用的时候不写括号，用空格传参数
  * 函数内也用位置参数（不是此函数外的位置参数）
  * 函数内 $0 还是脚本文件的路径
* 函数写在一行：`f () { echo "ok"; }`

### Shell代码粘贴到交互式环境下要注意

* 制表符会被解读成补全操作（直接补全就相当于所有项目，就很慢）
* 特别是制表符后面是 y 或者 n 开头时，就会被 `Display all 5190 possibilities? (y or n)` 捕获，然后显示相应的项目（此时n或y就会没有，然后继续粘贴，然后会碰到语法报错）
* 解决办法：把制表符改为空格（都是基于字符惹的祸、、、）
  * 如 notepad++：设置(T) ⇒ 首选项... ⇒ 语言 ⇒ 标签设置，勾选 "以空格取代"

### 让命令不打印输出

```sh
mkdir $DIR > /dev/null 2>&1
```

* 标准输出重定向到 /dev/null
* 标准错误重定向到标准输出（即 /dev/null）
  * 2 表示标准错误
  * 1 表示标准输出（加 & 为了和普通文件区分）
  * 2>&1 重定向符两边都不要有空格
* **不让命令输出错误信息**：`xxx 2>/dev/null`

### Shell脚本的调试方法

* -n 只检查语法，不执行
* -v 边执行，边将执行过的代码打印到标准错误输出
* -x 提供跟踪执行信息，将执行的每一条命令和结果依次打印出来
* 三种方式
  * 直接在命令行接上述参数：$ sh -x ./script.sh
  * 在脚本文件开头提供参数：#!/bin/sh -x
  * 在代码中用 set 命令开启和关闭参数（部分调试）

```sh
#! /bin/sh
if [ -z "$1" ]; then
	set -x # 禁用 -x 参数
	echo "ERROR: Insufficient Args."
	exit 1
	set +x # 启用 -x 参数
fi
```

### sleep的脚本实现

```sh
mSleep () {
    ms=$1
    start=$(date +%s%3N)
    while [ $(($start + $ms)) -gt $(date +%s%3N) ]; do :; done
}
```

* 这样当然会慢好多，因为要调用外部命令，还得 fork exec
* 毫秒级 sleep 0.3 不香吗（支持小数）

### 命令返回码和标准输出

* $ ${} 取的是变量的值
* $() 取的是命令的标准输出
* $? 取的是命令的返回码
* if 可以直接检测命令的返回码
* if + test 或 [] 可以检测命令的标准输出
* **reutrn 不可以直接返回命令的返回码**
  * 但可以返回数值的命令标准输出或变量的值
  * 变通的做法 return $?（相当于返回变量的值了）
  * **函数会自动返回最后一行命令的返回码，不用加 return，加 $() 也不影响**
* 通常不会用if + test [] 检测 $?，而是用冒号命令（ if 命令; then :; else xxx; fi）

### Shell特点：

* 基于字符串（字符优先）
* 标准输出优先（还是因为字符，真正的返回值屈居于 $?）
* 就算是脚本文件，也是一行行运行的，所以函数只能先定义再使用
* 先解释命令 再解释参数

### 同时获取命令的返回状态码和输出

```sh
# 获取错误码和错误信息
errMsg=$(command 2>&1) # 获取标准输出就不要加 2>&1
errCode=$?
```

### 查看和终止进程以及发送和响应信号

#### ps命令：查看进程

* 默认只显示**当前终端**的**当前用户**所启动的进程
  * 列：PID（进程号）、TTY（终端）、TIME（运行时长）、CMD（进程对应的命令）

#### kill命令：发送信号

* **kill 命令格式**：
  * `kill [-s sigspec | -n signum | -sigspec | -signum] pid | jobspec ...`
  * `kill -l | -L [sigsepc]`
* -s 指定信号名（或直接 `-信号名`）
* -n 指定信号ID（或直接 `-信号ID`）
* 不指定信号则默认为 -SIGTERM | -15 信号
* -l -L 查看所有信号
  * trap -l 也可以列出所有信号
  * **stty -a** 列出可以由键盘发出的信号

```
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>;
eol2 = <undef>; swtch = ^Z; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R;
werase = ^W; lnext = ^V; discard = ^O;
```

* 注意：
  * 信号名前缀SIG是可选的
  * 先 SIGTERM 最后 SIGKILL，因为后者根本没有机会保存数据或者执行清理，直接就退出了

#### 常用信号（**前缀SIG是可选的**）

| 信号编号 | 信号名  | 注释                      |
| -------- | ------- | ------------------------- |
| 1        | SIGHUP  | 挂起（终端退出）          |
| 2        | SIGINT  | Ctrl+C interrupt INTR字符 |
| 3        | SIGQUIT | Ctrl / QUIT字符           |
| 9        | SIGKILL | 强制退出（没办法trap）    |
| 15       | SIGTERM | 尝试退出 terminate        |
| 20       | SIGTSTP | Ctrl+Z                    |

#### trap命令：脚本处理信号

* trap是**内建命令**
* 格式：`trap [-lp] [[arg] signal_spec ... ]`
  * arg 表示命令或函数名
  * signal_spec ... 信号名列表（**空格分隔**）
  * -l 列出所有信号名和信号ID
  * -p 查看所有绑定命令的信号，也可指定信号名查看
* trap对信号处理的三种方式
  * 执行一段命令来处理这信号 `trap "commands" signal-list`
  * 接受信号默认的操作 `trap signal-list`（删除信号的命令绑定，单双破折号同理）
  * 忽略这一信号 `trap "" signal-list`
* 扩展的 signal_spec
  * **EXIT | EXIT（0）** 脚本退出时运行arg
  * **DEBUG** 简单命令，for语句，case语句，select命令，算法命令，在函数内的第一条命令
  * **RETURN** 用.或source执行脚本或函数结束后
  * **ERR** 任何简单命名执行完后返回值为非零值时
* [Trap命令详解_shell_u014089899的博客-CSDN博客](https://blog.csdn.net/u014089899/article/details/80690707)
* [Linux trap 命令用法详解-Linux命令大全（手册）](https://ipcmen.com/trap)

### 命令的参数风格

* Uinx：单破折线前缀
* BSD：不加任何前缀
* GNU：双破折线前缀

### Shell默认参数变量默认值（不用if）

* **-** 变量为 null 时取默认值
* **:-** 变量为 null 或空字符串时取默认值
  * 不只是参数列表，变量也同理
  * 有了默认值就无需双引号包裹 $ 号取变量了

```sh
# 变量1未定义时 为3
param=${1-3}
# 变量1空字符串或未定义 为3
param=${1:-3}
```

* **=** 变量为 null 时取默认值，同时改变变量本身
* **:=** 变量为 null 或空字符串时取默认值，同时改变变量本身
* **?** 变量为 null 或空字符串时报错并退出，默认值作为错误信息

```sh
echo ${xxx?:errmsg}
# bash: xxx: :errmsg
```

* **:+** 变量不为 null 或空字符串时使用默认值，与 **:-** 相反
* 总结：多加冒号代表空字符串，且冒号放在前面

* 参考：[[原创] Shell 参数传递 与 默认值 - 嘉兴Xing - 博客园](https://www.cnblogs.com/youjiaxing/p/10043063.html)

### 经验之谈

* Shell脚本里面的路径最好用绝对路径（除非就在本目录），因为 su 会改变当前路径为 /
* kill 配合 ps 可以追踪 ppid
* **三目运算符**：

```sh
res=`[ 1 == 2 ]` && echo 1 || echo 2
```

* `ls dir/` 只会显示文件夹下的文件
* `ls dir/*` 在显示文件的基础前面加上文件夹名
* 管道符是个好东西，使用管道符就无需临时文件了

### cat输入多行字符 here文档

* cat遇到EOF或STOP结束
* 输入多行至文件（>> 就是追加了）

```sh
cat > love.txt << EOF # 也可以是其他LABEL
> i love you
> i love you so much 
> i love you with all my heart
> EOF

echo '
> i love you
> i love you so much 
> i love you with all my heart ' > love.txt
```

* [cat echo 输入多行文字至文本中-Just do it !-51CTO博客](https://blog.51cto.com/wjpinrain/937408)

### 管道符、重定向、xargs

* **管道符**（程序到程序）
  * 只能处理标准输入输出
  * 右边的命令必须能够处理标准输入
  * 标准输出的命令 | 标准输入的命令
  * **管道会创建子进程（进程与进程）**
    * () 也会创建子进程
    * 进程相当于一个独立的命令了
* **重定向**（程序到文件）
  * <> 重写 <<>> 追加
  * 可以改变标准输入输出
  * 文件：普通文件、文件描述符（stdio stdout stderr）、文件设备
  * 标准输出命令 > 文件
  * 标准输入命令 < 文件
  * **重定向不会创建子进程（进程内部）**
* **xargs**
* [linux shell数据重定向(输入重定向与输出重定向)详细分析_linux shell_脚本之家](https://www.jb51.net/article/73397.htm)
* [linux shell 管道命令(pipe)使用及与shell重定向区别_linux shell_脚本之家](https://www.jb51.net/article/73398.htm)
* [xargs 命令教程 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2019/08/xargs-tutorial.html)
* [xargs - 通过管道运行命令](https://xstarcd.github.io/wiki/shell/xargs.html)
* [管道pipe](https://xstarcd.github.io/wiki/shell/pipe.html)

### Shell脚本加密

* **gzexe**
  * -d 解密文件
  * 优点：可直接执行加密后的文件、系统自带、运行加密后的脚本速度快
  * 缺点：加密太弱（本质就是压缩）

```sh
gzexe script.sh
ls
# script.sh加密后的文件 script.sh~源文件
```

* **tar**
  * 既然都是压缩的话 tar 不香吗
  * 优点：系统自带、tgz格式速度和压缩率都很不错
  * 缺点：但是也可以通过 file、stat 命令轻易知道文件格式从而解密

```sh
tar czf .script script.sh # 加密为 .script
tar xf .script # 解密
```

* **base64**
  * 优点：系统自带、不能轻易发现格式信息（只能人工看）
  * 缺点：加密后更大了

```sh
base64 script.sh > .script # 加密
base64 -d .script > script.sh # 解密
```

* **shc**
  * 优点：可直接执行加密后的文件、加密强度高
  * 缺点：需要安装、运行加密后的脚本速度慢

```sh
shc -T -f script.sh
ls
# script.sh.x加密后的文件 script.sh源文件
```

* [shell脚本加密经验分享_shell_编程杂记-CSDN博客](https://blog.csdn.net/qq_35603331/article/details/83793475)
* [Linux Shell-如何进行简单的加解密_shell_adamaday的专栏-CSDN博客](https://blog.csdn.net/adamaday/article/details/82085536)

### tar最佳实践

* 打包：`tar cf *.tar *`（无任何压缩）
* 压缩：`tar czf *.tgz *`
  * -c 创建
  * -z gzip格式 后缀为 tgz tar.gz
  * -j bz2
  * -f 指定文件（'-' for stdin/out）
* 查看：`tar tf *.tgz`
* 解压：`tar xzf *.tgz`
  * -C 指定解压到目录，不然可能会覆盖
  * -O 解压到标准输出，便于解压即改名
* 追加：`tar -rf *.tar *`（tar文件才能追加?）
* 查看过程：-v
* 查看内容：-t
* 追加：-u

```sh
tar xzf - 1.txt | tar xz -O

       c -> create      z -> gz
tar    x -> extract     j -> bz2    -f    file.tar   [files]
       t -> list        J -> xz
```

* [linux下tar.gz、tar、bz2、zip等解压缩、压缩命令小结_LINUX_操作系统_脚本之家](https://www.jb51.net/LINUXjishu/43356.html)

#### 各种压缩格式对比

* 综合起来，在压缩比率上： tar.bz2>tgz>tar
* 占用空间与压缩比率成反比： tar.bz2<tgz<tar
* 打包耗费时间：tar.bz2>tgz>tar
* 解压耗费时间： tar.bz2>tar>tgz
* 因此，Linux下对于占用空间与耗费时间的折衷多选用**tgz格式**，不仅压缩率较高，而且打包、解压的时间都较为快速，是较为理想的选择。
* [Linux下常用压缩 解压命令和压缩比率对比 - joshua317 - 博客园](https://www.cnblogs.com/joshua317/p/6170839.html)

### xz最佳实践

* xz 是基于 LZMA2 压缩算法的
* 压缩：`xz -k *`
  * -k -保留原文件
  * -z 强制压缩
* 解压：`xz -dk *.sh.xz`
  * -d 必须指定-d才解压
  * -k 保留压缩文件
* -c 输出到标准输出（不删除输入文件，不用加-k）
* -f 强制覆盖
* 查看
  * -l 查看压缩文件信息 如果不是xz压缩文件则返回 1 和打印错误信息
  * -t 是xz压缩文件则返回 0, 否则返回 1 并打印错误信息
  * -v -vv 查看详细输出
  * -H 比 -h 更详细的帮助
* 性能、压缩率相关
  * 0 ~ 9 压缩级别 默认6级
  * -e 更高的CPU优先级
  * -T NUM 使用 NUM 个线程，默认1个，0表示使用与CPU内核一样多的线程

### 临时文件 mktemp

* 不加参数 返回

```sh
tmpfile=`mktemp`
tmpdir=`mktemp -d`
```

### 在后台运行Shell脚本 Ctrl+Z jobs bg fg & nohup

* **&** 放命令最后，让命令在后台执行
* **Ctrl + Z** 暂停前台命令并放到后台
* **jobs** 查看后台运行的 job_spec
* **fg** 将任务放到**前台** 可以指定 job_spec 默认为 1
* **bg** 把任务放到**后台** 可以指定 job_spec 默认为 1
* **nohup** 放命令前，让命令忽略 SIGHUP 信号（通常和 & 连用）
* [前后台切换命令（ctrl+z jobs bg fg &）_操作系统_飘过的春风-CSDN博客](https://blog.csdn.net/u011630575/article/details/48288663)

### su最佳实践

* `su -c 'cmd &' -`

```sh
su root cmd # 这里不要省略 root 不然会把 cmd 当作用户
su -c 'cmd'

su -c 'nophup cmd &' - # 在后台以root权限，使用root环境变量运行命令
```

* su - root 相当于登录到 root
* [su - root -c 切换到root并获得root的环境变量及执行权限并执行命令_操作系统_打不死的小强lee的博客-CSDN博客](https://blog.csdn.net/wenqiangluyao/article/details/103776926)
* [用shell 脚本写守护进程_shell_guoyilongedu的专栏-CSDN博客](https://blog.csdn.net/guoyilongedu/article/details/42835931)

### Shell数组

* [shell 数组使用技巧](https://xstarcd.github.io/wiki/shell/shell_array.html)

### Shell后台运行函数

* 直接在函数调用后面加 `&`
* pid 与Shell文件相同
* 也可用后台运行代码段`{ ... } &`
* [shell中后台运行函数_mgxcool的专栏-CSDN博客](https://blog.csdn.net/mgxcool/article/details/50715864)

### shell获得子后台进程返回值的方法

```shell
#!/bin/bash
command1 &
command2 &
command3 &
for pid in $(jobs -p)
do
wait $pid
[ "x$?" == "x0" ] && ((count++))
done
```

* [shell获得子后台进程返回值的方法_奶牛_新浪博客](http://blog.sina.com.cn/s/blog_65a8ab5d0101fmnv.html)

### xargs最佳实践

xargs命令是可以补齐管道符`|`(标准输入)的, 因为不是所有命令都支持管道符如`echo`, xargs能接受标准输入(`Ctrl+D`结尾`EOF`) 并转换为后面命令支持的参数
xargs默认是空白符号(` `、`\t`、`\n`)作为分隔, 并把获取到的所有参数都作用在后面的命令上, 下面演示的是`-n`参数, 一次最多只接受2个参数作用一次命令, 调用多次命令直到参数用完
```sh
$ echo {0..9}
0 1 2 3 4 5 6 7 8 9

$ echo {0..9} | xargs -n 3 echo
0 1 2
3 4 5
6 7 8
9
```
下面演示的是每次只用一行`-L 1`
```sh
$ echo 'a\nb\nc'
a\nb\nc

$ echo -e 'a\nb\nc' # -e表示使用转宜符 这里echo只运行了一次(\n也输出了)
a
b
c

$ echo -e 'a\nb\nc' | xargs -L 1 echo # 这里echo运行了3次(\n作为分隔符已经消失了)
a
b
c
```
以上`-L`、`-n`都可以解决xargs所调用的命令接受不了太多参数会报错的问题(因为可以一个个参数来运行多次命令)

黄金搭档`find`命令, xargs怎么处理文件名包含空格(分隔符)的情况呢?
find默认每个找到的文件以`\n`分隔, 也就是一行一个, `-print0`表示find命令用`null`作为分隔符
而xargs的`-0`刚好可以用null作为分隔符~
```sh
$ find /path -type f -print0 | xargs -0 rm # 表示删除/path及其子目录下的所有普通文件
```
高级玩法
* `-I` 可以运行多个不同命令
* `--max-procs` 表示并行运行多少个命令 默认为1, 如果命令要执行多次, 必须等上一次执行完，才能执行下一次

```sh
$ cat foo.txt
one
two
three

$ cat foo.txt | xargs -I file sh -c 'echo file; mkdir file' # file代表foo.txt里面的参数
one 
two
three

$ ls 
one two three
```
参考: https://www.ruanyifeng.com/blog/2019/08/xargs-tutorial.html

### 方括与函数的坑

* 在方括号的函数必须加调用符（否则作为字符串恒为真） 
* 如果要比较函数的返回码，**就不要把函数写在方括号里**
* 尽量不要在方括号中调用函数，如果非要，要加**双引号**，把输出当作一个整体字符串

```sh
[ f ] # 恒为真 f当作字符串
[ -n `f` ] # 运行函数 检查输出
[ `f` ] # 未定义 不等于 [ -n `f` ]

[ "$(md5 .keepRun | awk '{print $1}')" == "$(md5 .keepRun | awk '{print $1}')" ] # 比较两文件的md5值
```

### 进制转换 数字判断

```sh
# 一、16进制转换成10进制
printf %d 0xF # 15
# 或者
echo $((16#F)) # 15

# 二、10进制转换成16进制
printf %x 15 # f
# 或者
echo "obase=16;15" | bc # F

# 三、10进制转换成8进制
printf %o 9 # 11

# 四、8进制转换成10进制
echo $((8#11)) 9

# 五、同理二进制转换成10进制
echo $((2#111)) # 7

# 六、10进制转换成二进制
echo "obase=2;15" | bc # 1111

# 判断是否为数字
isNumber () {
    expr "$1" + 0 > /dev/null 2>&1
}
```

### Shell 各种括号详解

* **单小括号 ()** 子进程、数组
  * 命令组：括号中的命令将会新开一个子进程顺序执行
  * 命令替换：等同于\`cmd\`，得到运行后的 stdout
  * 初始化数组：如 array=(a b c d)
* **双小括号 (())** 算术运算
  * 整数扩展：**不支持浮点**，**1 为真，0 为假**，如 `((a++))`
  * 进制转换：支持二进制、八进制、十六进制，结果为十进制，如 `echo $((16#5f))` 结果为 95
  * C 风格的语法：（变量可省略 $ 前缀）
    * `for((i=0;i<5;i++))`，否则为 `for i in $(seq 0 4)` 或 `for i in {0..4}`
    * `if ((i<5))`，否则为 `if [ $i -lt 5 ]`
* **单中括号 []**
  * 内部命令：[ 等价于 test，] 用来闭合，里面是比较字符串、整数或文件（直接用大于小于号需要转义如 `\<` ）
  * 正则表达式的一部分：作为 test 用途的中括号内不能使用正则
  * 引用数组中每个元素的编号
* **双中括号[[]]**
  * [[ 为 bash 关键字，非命令，里面所有字符只会发生参数扩展和命令替换
  * 字符串模式匹配：`[[ hello == hell? ]]` （右边是模式，无需引号）
  * 逻辑判断：无需加转义符，如 `[[ a < b ]]`
* **花括号{}** 也叫大括号
  * 文件名扩展：不允许直接出现空白符
    * 逗号分隔（扩展）：`ls {ex1,ex2}.sh` 相当于 `ls ex1.sh ex2.sh` 
    * 两个点（顺序省略）：`ls ex{1..3}.sh` 相当于 `ls ex1.sh ex2.sh ex3.sh`（等价于模式匹配的 `ls ex[1-3].sh`）
    * 花括号也可以嵌套

