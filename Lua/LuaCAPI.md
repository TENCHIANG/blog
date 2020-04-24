## Lua C  API

* Lua 更多的是一个库，可以被 C 调用（独立解释器），也可以调用 C（C 库）
* 提供 Lua 调用和被调用的就是 C API（基于栈的通信）

### Lua 独立解释器的简单实现（C 调用 Lua）

```c
// gcc interpreter.c -O3 -Wall -L. -llua53
#include <stdio.h>
#include <string.h>
#include "src/lua.h"
#include "src/lauxlib.h"
#include "src/lualib.h"

int main (void) {
	lua_State *L = luaL_newstate(); // 创建新状态，也可以理解为打开一个 lua
	luaL_openlibs(L); // 打开所有标准库
	
	char buff[256];
	while (fgets(buff, sizeof buff, stdin) != NULL) {
		int error = luaL_loadstring(L, buff) || lua_pcall(L, 0, 0, 0);
		if (error) {
			fprintf(stderr, "%s\n", lua_tostring(L, -1));
			lua_pop(L, 1); // pop error message from the stack
		}
	}
	
	lua_close(L);
	return 0;
}
```

* lua.h：提供基础函数（格式为 lua_*）
* lauxlib.h：提供辅助函数，只是对基础函数的封装（格式为 luaL_*）
* 所有状态都放在动态结构体 lua_State
* Lua 中所有函数起码有一个参数：指向 lua_State 的指针（可重入、多线程）
* luaL_openlibs：打开所有标准库（默认不打开任何标准库）
  * 打开标准库的函数都在 lualib.h
* luaL_loadstring：编译字符串中的代码并入栈（加载但不运行）
  * 正常返回零，错误返回错误代码并向栈压入错误信息
* lua_pcall：保护模式运行函数（下面会解释）

### lua_call、lua_pcall 详解

* void lua_call (lua_State *L, int nargs, int nresults);
  * 弹出栈顶的函数
  * 弹出 nargs 个元素作为函数参数
  * 函数返回时，压入栈的返回值数
    * nresults != LUA_MULTRET：返回值数严格等于 nresults
    * nresults == LUA_MULTRET：有多少算多少
* int lua_pcall (lua_State *L, int nargs, int nresults, int errfunc);
  * errfunc 为错误处理函数所在的栈索引
* 模拟 Lua 内部调用函数

```c
lua_State *L = NULL;

// f 内部调用 lua 函数
double f (double x, double y) {
    lua_getglobal(L, "f");    // 获取lua函数f
	
    lua_pushnumber(L, x);    // 压入参数x和y
    lua_pushnumber(L, y);

    if (lua_pcall(L, 2, 1, 0) != 0)
        luaL_error(L, "error running function 'f': %s", lua_tostring(L, -1));

    if (!lua_isnumber(L, -1))
        luaL_error(L, "function 'f' must return a number");
	
    double res = lua_tonumber(L, -1);
    lua_pop(L, 1);
	
    return res;
}

int main (void) {
    L = lua_open();
    luaL_openlibs(L);
    
    if (luaL_loadstring(L, "f = function(a, b) return a + b end") || lua_pcall(L, 0, 0, 0))
		luaL_error(L, "cannot run configuration file: %s", lua_tostring(L, -1));

    printf("%f\n", f(1.0, 2.0));

    return 0;
}
```

* 参考：[C中调用Lua函数 - 斯芬克斯 - 博客园](https://www.cnblogs.com/sifenkesi/p/3873720.html)

### C API 中的错误处理

* C API 提供的函数一般**不检查参数错误**：一旦出错，程序会直接崩溃
* 错误处理一般通过压栈出栈的方式实现
  * Lua核心不会向输出流写入数据，只返回错误代码错误信息
  * 把错误处理的具体方式留给程序员

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

// 简单的错误处理示例
void error (lua_State *L, const char *fmt, ...) {
    va_list argp;
    
    va_start(argp, fmt);
    vfprintf(stderr, fmt, argp); // 打印错误
    va_end(argp);
    
    lua_close(L); // 关闭 Lua 状态
    exit(EXIT_FAILURE); // 退出程序
}
```

### Stack 栈

* Lua 和 C 之间的数据交换基于 stack
* 栈可以存运算结果、函数、错误消息

#### Lua 栈和 C 栈的区别

* Lua 栈：严格按照 LIFO（Last In First Out），只有栈顶改变
* C 栈：使用 index 更灵活，能对任意位置的元素操作

#### Lua 和 C 通信的两个问题

* 动态类型和静态类型
  * 用能够存 Lua 所有类型的联合体
    * 可能与其它语言不兼容
    * 可能会被 lua垃圾回收
  * 使用栈交换数据，栈的每个元素都能保存 lua 任意值
    * 压栈出栈有多个 C 函数来适配 Lua 不同的类型（避免组合爆炸）
    * 栈是 Lua 状态的一部分（避免垃圾回收）
* 自动管理内存和手动管理内存

#### 压入元素

```c
void lua_pushnil	(lua_State *L);
void lua_pushboolean(lua_State *L, int bool);
void lua_pushnumber	(lua_State *L, lua_Number n);
void lua_pushinteger(lua_State *L, lua_Integer n);
void lua_pushlstring(lua_State *L, const char *s, size_t len);
void lua_pushstring	(lua_State *L, const char *s);
```

* lua_Number 默认为 double
* lua_Integer 默认为 long long（64位有符号整型）
* Small Lua：
  * lua_Number 为 float
  * lua_Integer 为 int
  * **luaconf.h**
* Lua 字符串不以 \0 结尾，所以要提供其长度，但是也兼容 \0 结尾的字符串
* Lua 不会保留任何指向外部字符串或对象的指针（除了静态C函数）
  * 要么生成一个内部副本，要么复用已有的
  * 一旦 lua_pushlstring、lua_pushstring 返回，即可立刻释放或修改缓冲区

#### 栈的空间大小

* 一般栈有20个空位（lua.h 中的 LUA_MINSTACK）
* `int lua_checkstack (lua_State *L, int sz);`
  * 增加 sz 个空位，否则返回 0
* `void luaL_checkstack (lua_State *L, int sz, const chat *msg);`
  * 不会返回错误代码，而是用给定的错误信息报错

#### 查询栈元素

* C API 使用 index 操作栈元素
  * 压栈：从 1 开始（正数）
  * 出栈：从 -1 开始（倒数，-1表示栈顶）
* 检查栈元素的类型：`int lua_is* (lua_State *L, int index);`
  * lua_isnumber 不检查类型是否为number，而是检查能否转换为 number
  * lua_isstring 同理，特别的，任何数字都为真
* 返回栈元素的类型：`lua_type`（每种类型都对应常量表示）
  * LUA_TNIL、LUA_TBOOLEAN、LUA_TNUMBER、LUA_TSTRING...
  * 一般与 switch 连用 
* 指定类型从栈中获取一个值：`lua_to*`（类型错误也不会报错，返回 0 或 NULL）
  * `int lua_toboolean(lua_State *L, int index);`
    * Lua nil、false 转为 0
    * 其它转为 1
  * `const char *lua_tolstring(lua_State *L, int index, size_t *len);`
    * 返回字符串的内部副本指针
      * 内部副本无法修改
      * 对应字符串还在栈中，指针就是有效
      * 当 Lua 调用的一个 C 函数返回时，对应的栈会被清空
      * 所以不要把 Lua 字符串指针放到获取该指针的函数外
    * 字符串长度存到 len 所指向的位置
    * lua_tolstring 返回的所有字符串末尾有个额外的 \0
    * 但是无法保证中间就没有 \0 所以还是得 len 表示长度

```c
size_t len;
const char *s = lua_tolstring(L, -1, &len); // 栈顶存在字符串
assert(s[len] == '\0'); // 最后一个字符肯定是 \0
assert(strlen(s) <= len); // 中间可能包含 \0
```

* 遍历栈：取 top 下标（栈长度）
  * lua_type 函数取类型
  *  lua_to* 函数取值

#### 其它栈操作

* int lua_gettop (lua_State *L);  返回栈顶元素索引（元素个数）
* void lua_settop (lua_State *L, int index);  将栈顶设置为指定的值（修改元素数量）
  * 比之前少：丢弃
  * 比之前多：nil 填充
  * 为 0：清空栈 lua_settop(L, 0) 
  * 为负数：用于弹出栈
* #define lua_pop(L, n) lua_settop(L, -(n) - 1)  弹出 n 个元素
  * 给 n 打括号不是多此一举，n 有可能是表达式
* void lua_pushvalue (lua_State *L, int index); 将索引上的元素副本压入栈
* void lua_rotate (lua_State *L, int index, int n); Lua 5.3 引入
  * 将指定元素移动 n 个位置，空缺的补上
    * index 从 1 开始就相当于整体上的循环位移
    * index不从 1 开始相当于局部的循环位移
  * n为正数：往栈顶移动，栈顶元素超出的从index开始补
  * n为负数：往栈底移动，index超出的从栈顶开始补

```lua
stack = require "stack"
stack.rotate(1, -1, 'a', 'b', 'c') --> -1 'a' 'b' 'c' 1
stack.rotate(1, 1, 'a', 'b', 'c') --> 'c' 1 1 'a' 'b'
stack.rotate(3, -1, 'a', 'b', 'c') --> 3 -1 'b' 'c' 'a'
stack.rotate(3, -2, 'a', 'b', 'c') --> 3 -2 'c' 'a' 'b'
stack.rotate(3, 1, 'a', 'b', 'c') --> 3 1 'c' 'a' 'b'
```

* #define lua_remove(L, i) (lua_rotate(L, (i), -1), lua_pop(L, 1))
  * 移动指定元素到栈顶，然后弹出栈顶（删除元素）
* #define lua_insert(L, i) lua_rotate(L, (i), 1)
  * 移动栈顶元素至指定位置（插入元素）
* void lua_replace (lua_State *L, int index); 弹出栈顶的值，赋值给指定位置（不移动）
* void lua_copy (lua_State *L, int fromidx, int toidx); Lua 5.2 引入

### Windows 下编写 Lua C 模块

* 安装 TDM-GCC（建议使用32位，因为64位编译后的文件太大）
* 下载 Lua 源代码并解压、编译
  * curl 参数解释
    * -R 按照服务器文件的时间下载文件
    * -O 按照服务器文件的名称下载文件
  * tar 参数解释
    * z 设置压缩格式为 gzip（可省略）
    * x 解压
    * f \<fillename\> 指定文件
  * mingw32-make 参数解释（TDM-GCC 自带的 make）
    * mingw 编译平台参数（源代码提供）
    * test 运行测试用例（源代码提供）

```cmd
curl -R -O https://www.lua.org/ftp/lua-5.3.5.tar.gz
tar zxf lua-5.3.5.tar.gz
cd lua-5.3.5
mingw32-make mingw test
```

* 编写 C 模块

```c
#include <stdio.h>
#include "src/lua.h"
#include "src/lauxlib.h"
#include "src/lualib.h"

// C 函数统一类型 typeof int (*luaCFunction) (lua_State *L);
// 返回的整数表示返回值的数量（入栈的）
// 函数返回后 Lua 会自动删除结果之下的内容（无需自行清空）
static int look (lua_State *L) {
	
    int top = lua_gettop(L);
    for (int i = 1; i <= top; i++) {
        int t = lua_type(L, i);
        switch (t) {
            case LUA_TSTRING:
                printf("'%s'", lua_tostring(L, i));
                break;
            case LUA_TBOOLEAN:
                printf(lua_toboolean(L, i) ? "true" : "false");
                break;
            case LUA_TNUMBER:
                printf("%g", lua_tonumber(L, i));
                break;
            default:
                printf("%s", lua_typename(L, t));
                break;
        }
        printf(" ");
    }
    printf("\n");
	
    return 1;
}

// stack.rotate(3, 1, 'a', 'b', 'c') --> 3 1 'c' 'a' 'b'
static int rotate (lua_State *L) {
	int i = (int)lua_tonumber(L, 1);
	int n = (int)lua_tonumber(L, 2);
	
	printf("rotate(L, %d, %d)\n", i, n);
	lua_rotate(L, i, n);
	
	look(L);
	
	return 1;
}

static const struct luaL_Reg libs[] = {
    {"look", look},
    {"rotate", rotate},
    {NULL, NULL}
};

int luaopen_stack (lua_State *L) {
    luaL_newlib(L, libs); // luaL_register(L, "stack", libs); Lua 5.1
    return 1;
} 
```

* 编译 C 模块
  * %~0 批处理文件本身的绝对路径
  * %~1 批处理文件的第一个参数的绝对路径（或者**拖动**文件到批处理文件）
  * %~nx1 只留文件名和扩展名
  * -f 后面跟一些编译选项，PIC 是其中一种，表示生成位置无关代码（Position Independent
    Code）
  * -shared 该选项指定生成动态连接库，不用该标志外部程序无法连接，相当于一个可执行文件
  * -L 库查找路径
  * -l 库文件

```cmd
:: makelib.bat start
@if /i %~x1 == .c (
	echo 编译成功
	gcc %~nx1 -o %~n1.dll -fPIC -shared -Wall -O2 -Lsrc -llua51
)
@pause
:: makelib.bat end

nm stack.dll | findstr luaopen :: 检查是否编译完好（TDM-GCC 自带工具）

src\lua :: 进入 lua
```

* 调用 C 模块

```lua
os.execute("echo %cd%") -- 查看当前目录
stack = require "stack" -- 5.3 必须显式指定
stack.look()
```

* Linux 下编译 C 库参考 [Termux 最佳实践](/Linux/Termux最佳实践.md#编译-Lua)

### C 语言调用 Lua

* 注意 Lua 有自动垃圾回收，但是 C 调用 Lua 还是 C
  * 要注意类型检查 、 错误恢复、内存分配错误等
* 把 lua53.dll 放在同目录
* 编辑 stackDump.c

```c
#include <stdio.h>
#include "src/lua.h"

void stackDump (lua_State *L) {
    int top = lua_gettop(L);
    for (int i = 1; i <= top; i++) {
        int t = lua_type(L, i);
        switch (t) {
            case LUA_TSTRING:
                printf("'%s'", lua_tostring(L, i));
                break;
            case LUA_TBOOLEAN:
                printf(lua_toboolean(L, i) ? "true" : "false");
                break;
            case LUA_TNUMBER:
                printf("%g", lua_tonumber(L, i));
                break;
            default:
                printf("%s", lua_typename(L, t));
                break;
        }
        printf(" ");
    }
    printf("\n");
}
```

* 编辑 stackExample.c

```c
#include <stdio.h>
#include "src/lua.h"
#include "src/lauxlib.h"

int stackDump (lua_State *); // stackDump.h

int main (void) {
	lua_State *L = luaL_newstate();
	
	lua_pushboolean(L, 1);
	lua_pushnumber(L, 10);
	lua_pushnil(L);
	lua_pushstring(L, "hello");
	stackDump(L); // true 10 nil 'hello'
	
	lua_pushvalue(L, -4); stackDump(L); // true 10 nil 'hello' true
	
	lua_replace(L, 3); stackDump(L); // true 10 true 'hello'
	
	lua_settop(L, 6); stackDump(L); // true 10 true 'hello' nil nil
	
	lua_rotate(L, 3, 1); stackDump(L); // true 10 nil true 'hello' nil
	
	lua_remove(L, -3); stackDump(L); // true 10 nil 'hello' nil
	
	lua_settop(L, -5); stackDump(L); // true
	
	printf("%d\n", lua_gettop(L)); // 1
	
	lua_close(L);
	return 0;
}
```

* 编译链接运行（编译为 a.exe 或 a.out）

```sh
# 动态链接
gcc stackDump.c -o stackDump.dll -Wall -shared -fPIC -L. -llua53
gcc stackExample.c -O3 -Wall -L. -llua53 -lstackDump

# 静态链接
gcc -c stackDump.c -Wall
gcc stackDump.o stackExample.c -O3 -Wall -L. -llua53
```