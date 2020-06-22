### GCC

* 普通编译：`gcc -Wall -O2 main.c -o main`
* 调试编译：`gcc -g main.c -o main`
  * 如果调试时显示`<optimized out>`说明该变量已被优化无法显示（不在内存中），建议不开优化-On

### GDB

* 神器：碰到段错误自动停止并定位到相关代码
* 打开GDB：`gdb main`
* set：
  * set args xxx：设置程序参数（最好是start之前）
  * set var 变量名=值：设置变量值
* show：
  * show args：显示程序的参数
* start：开始运行
* r（run）：从头开始运行（连续）
* c（continue）：继续运行（配合断点）
* help [子命令]：查看子命令（不用打完全，唯一确定即可）
  * 用 h x 去试探最短的命令名
* list：显示源码（二进制和源码在同一目录）
  * l n：从第n行显示源码
  * l 函数名：显示指定函数
  * l：接着显示源码
* q（quit）：退出gdb
* n（next）：执行一条语句（不进入函数）
* s（step）：单步运行（进入函数，配合断点）
  * 只能进入源码所在的函数，库函数进不去
* bt（backtrace）：查看函数栈帧，#0为当前函数
* frame：栈帧操作
  * f：查看当前栈帧（当前函数，类似 i f）
  * f 编号：切换栈帧
* fin（finish）：运行到当前函数返回（除了main）
* p（print）+ 变量名：打印变量（$1...$n保存中间值）
* x /nb + 数组起点：查看n个字节（可超出范围）
* disp（display）：跟踪显示变量（程序暂停时显示变量）
* und（undisplay）+ 编号：取消追踪变量（i d查看编号）

* info：显示信息
  * i lo（locals）：查看当前函数的局部变量
  * i b（breakpoints）：查看断点（观察点）
  * i f（frame）：查看当前栈帧（函数）
  * i d（display）：查看追踪的变量
  * i wat（watchpoints）：查看观察点
* disable / enable：禁用启用
  * dis d（display）[+ 编号]：禁用追踪变量（不指定则删除所有）
  * dis b（breakpoints）[+ 编号]：禁用追踪断点
* delete：删除比禁用更彻底
  * d + br [+ 编号]：删除指定断点（不指定则删除所有）
  * d + d [+ 编号]：删除追踪变量
* breakpoints：断点，运行到某行时中断
  * b + 行号/函数名：设置断点
  * b + 行号/函数名 + if 条件：按条件设置观察点（`b 1 if sum != 0`）
* watchpoints：观察点，访问某个变量时中断（断点的一种）
  * wa + 变量：观察变量
  * wa + arr[i]：观察数组中的i号元素
* tracepoints：追踪点，Tracing of program execution without stopping the program.

### 调试经验之谈

* 难点：数组越界，修改了别的变量
* 段错误：gdb会在段错误发生时中断，但是是函数级别的（函数返回时才抛出段错误，不会定位到具体行）