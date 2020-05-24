## Shell笔记

### Shell分为内建命令和外部命令

* 内建命令
  * 凡是用 which 命令查不到程序文件所在位置的命令都是内建命令
  * 内建命令不创建新的进程（相当于执行**当前进程**的函数）
  * 有状态码 Exit Status
* 外部命令
  * 通过man可以查到的命令
  * 执行外部命令 Shell会 fork 并 exec 该命令（新建一个**子进程**执行）
  * 有状态码 Exit Status
* 上面都是在交互式模式说的

### Shell脚本执行的两种方式

* 在子进程执行

```sh
echo "#!/bin/sh" > script.sh
sh script.sh # 方法一

chmod +x script.sh
./script.sh # 方式二 其实相当于方法一
```

* 直接在当前进程执行

```sh
echo "#!/bin/sh" > script.sh
source script.sh
. script.sh
```

* source 和 . 都是内置命令
* 注意：在脚本文件里碰到外部命令也会生成一个子进程

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

* 脚本的 Exit Status：exit NUM（默认 exit 0）
* 函数的返回码：return NUM（默认 return 0）

#### exit与return的区别

* exit是命令级别的（外部命令），用来退出进程，在任意地方都可调用
* return是语言级别的（内部命令），调用堆栈的返回，用来退出函数，只能在函数中调用
* 其实还有一个系统调用级别的（编译型调用的，如外部命令本身调用的就是系统调用）

#### 退出状态码约定

| Exit Code Number | Meaning                                                    | Example                 | Comments                                                     |
| ---------------- | ---------------------------------------------------------- | ----------------------- | ------------------------------------------------------------ |
| 1                | Catchall for general errors                                | let “var1 = 1/0″        | Miscellaneous errors, such as ”divide by zero” and other impermissible operations |
| 2                | Misuse of shell builtins (according to Bash documentation) | empty_function() {}     | Seldom seen, usually defaults to exit code 1                 |
| 126              | Command invoked cannot execute                             |                         | Permission problem or command is not an executable           |
| 127              | “command not found”                                        | illegal_command         | Possible problem with `$PATH` or a typo                      |
| 128              | Invalid argument to exit                                   | exit 3.14159            | exit takes only integer args in the range 0 – 255 (see first footnote) |
| 128+n            | Fatal error signal ”n”                                     | kill -9 $PPID of script | $? returns 137 (128 + 9)                                     |
| 130              | Script terminated by Control-C                             |                         | Control-C is fatal error signal 2, (130 = 128 + 2, see above) |
| 255*             | Exit status out of range                                   | exit -1                 | exit takes only integer args in the range 0 – 255            |

* 参考：[exit(-1)或者return(-1)shell得到的退出码为什么是255_linux shell_脚本之家](https://www.jb51.net/article/73377.htm)

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

* 参考：[Linux 环境变量 - Creaink - Build something for life](https://creaink.github.io/post/Computer/Linux/Linux-env.html)

#### 删除已定义的环境变量或本地变量

* unset x
* x=

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

* -d DIR 存在目录
* -f FILE 存在普通文件
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

### while/do/done

```sh
COUNTER=1
while [ "$COUNTER" -lt 10 ]; do
    echo "Here we go again"
    COUNTER=$(($COUNTER+1))
done
```

### 特殊变量

* $? 上一条命令的 Exit Status
* $0 脚本文件名（argv[0]）
  * 如果是交互式那就是解释器的路径如 /usr/bin/bash
* $1、$2、... 传给脚本的位置参数（Positional Parameter） argv[1]...
* $# 参数的个数（argc - 1，不算 $0）
* $* 参数列表（双引号包起来是整体）
* $@ 参数列表（双引号包起来不是整体）
* $$ 当前Shell的PID
* $PPID 父进程PID
* $PS1 占位提示符

#### $* $@ 的区别

* 都是参数列表，都可以放在 for in 后面
* 但是被双引号包住时
  * $* 会将所有参数作为一个**整体** "$1 $2 ... $n"
  * $@ 会将参数**分开** "$1" "$2" ... "$n"
  * 只有在 for 循环里才体现的出来（循环一次和多次的区别）
    * echo、变量赋值都体现不出来（作为字符串的整体）

```sh
#!/bin/bash
echo "print each param from \"\$*\""
for var in "$*";do echo "$var"; done

echo "print each param from \"\$@\""
for var in "$@"; do echo "$var"; done

# script.sh 1 2 3 4
```

### shift 位置参数左移

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

* kill -l 列出所有可用的信号
* 常用信号：

| 信号编号 | 信号名  | 注释     |
| -------- | ------- | -------- |
| 1        | SIGHUP  | 挂起     |
| 2        | SIGINT  | Ctrl+C   |
| 9        | SIGKILL | 强制退出 |
| 15       | SIGTERM | 尝试退出 |
| 20       | SIGTSTP | Ctrl+Z   |

* 注意要先 SIGTERM 最后 SIGKILL，因为后者根本没有机会保存数据或者执行清理，直接就退出了
* kill -s SIGNAL PID 指定信号名或编号
  * 用 -s 是，信号编号直接就是数字
  * kill 后面也可以接信号编号，但是要加 - 前缀表示选项
  * -s 指定信号名可以忽略 SIG 前缀
* kill PID1 PID2 ... 终止进程（SIGTERM）

#### trap命令：脚本处理信号

* 格式：trap 'handler' signal_list
  * handler 信号处理函数名
  * signal_list 信号编号或信号名列表 空格分隔

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