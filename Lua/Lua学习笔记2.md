### Lua学习笔记2

### 空字符串

```lua
print("" ~= "\0") -- true
print(#"", #"\0") -- 0       1

print(string.byte("")) -- 
print(string.byte("\0")) -- 0
```

### 可变长参数与 ipairs、pairs、select

* ipairs：碰到 nil 就终止
* pairs：跳过 nil（key也跳过）
* select：包括 nil

### 用Ldoc给Lua生成文档

* Luadoc太老了
* [stevedonovan/LDoc: A LuaDoc-compatible documentation generation system](https://github.com/stevedonovan/Ldoc)
* [使用Ldoc给Lua生成文档 | 晚晴幽草轩](https://www.jeffjade.com/2015/05/17/2015-05-17-lua-ldoc/)

```lua
--- 解决一个平方根问题
-- 这是其它的注释
-- @number a first coeff
-- @number b second coeff
-- @number c third coeff
-- @return first root, or nil
-- @return second root, or imaginary root error
-- @usage local r1, r2 = solve(1, 2, 3)
-- @usage local r1, r2 = solve(4, 5, 6)
function solve (a,b,c)
     local disc = b^2 - 4*a*c
     if disc < 0 then
         return nil,"imaginary roots"
     else
        disc = math.sqrt(disc)
        return (-b + disc)/2*a,
               (-b - disc)/2*a
     end
 end
```

文件拖入bat即可运行

```cmd
lua.exe path\ldoc.lua %* :: 表示第一个参数
```



### 迭代字符串

* `string.sub(s, i, 1) -- 返回一个字符`
* `string.bytes(s, 1, -1) -- 多重返回值`

### 文件操作

* `io.write()`（当作函数调用：操作当前的文件，默认为标准输入输出）（简单模式）
* `f:write()`（当作方法调用：操作文件 f ）（完整模式）
* 不只是 write 其它很多文件都同理
* `io.read(0)` 读取EOF，到了文件末尾返回空字符串 否则返回nil

### Luasocket网络操作

```lua

local socket = require "socket"

function removeHeader (str)
	--[[while true do
		local i, j = string.find(str, "\r\n")
		if i == nil then break end
		str = string.sub(str, j + 1)
	end
	return str]]
	return string.gsub(str, ".+\r\n", "") -- 去掉response头（交互式环境粘贴则为 ".+\n\n"）
end

function download (host, file)
	local c = assert(socket.connect(host, 80))
	local req = string.format("GET %s HTTP/1.0\r\nhost: %s\r\n\r\n", file, host)
	
	local f = assert(io.open(string.sub(file, 6), "w"))
	
	c:send(req)
	local count = 0
	while true do
		local chunk, status = receive(c)
		chunk = removeHeader(chunk)
		count = count + #chunk
		if status == "closed" then break end
		f:write(chunk)
	end
	c:close()
	f:close()
	print(file, count)
end

function receive (conn)
	conn:settimeout(0) -- 不会阻塞
	local chunk, status, parial = conn:receive(2^10)
	if status == "timeout" then
		coroutine.yield(conn)
	end
	return chunk or parial, status
end

local tasks = {} -- 所有活跃的任务列表

function get (host, file)
	local co = coroutine.wrap(function()
		download(host, file)
	end)
	table.insert(tasks, co)
end

function dispatch ()
	local i = 1
	local timeout = {}
	while true do
		if not tasks[i] then
			if not tasks[1] then break end
			i = 1
			timeout = {}
		end
		local res = tasks[i]()
		if not res then
			table.remove(tasks, i)
		else
			i = i + 1
			timeout[#timeout + 1] = res
			if #timeout == #tasks then -- 所有任务都阻塞
				socket.select(timeout)
			end
		end
	end
end

get("www.lua.org", "/ftp/lua-5.3.2.tar.gz")
get("www.lua.org", "/ftp/lua-5.1.4.tar.gz")
get("www.lua.org", "/ftp/lua-5.1.5.tar.gz")

dispatch()
```

## Lua模块与包

* 模块（module）
  * 本质上是 table
  * Lua语言或C语言编写的代码 chunk
  * **用 require 加载模块（用 module 创建）**
  * 创建并返回一个 table （命名空间）
    * 通常返回一个全局变量相当于 `math = require("math")`
  * 所有标准库都是模块（自动提前导入）
* 包（package）：一系列的模块

### require小技巧

* 加载模块的时候还可以改名：`local m = require "io"`
* 只引入特定函数
  * `local f = require "mod".f`
  * `local f = (require("mod")).f`

### require函数

* 一般返回 模块，也可以是别的
* require 的路径格式
  * 分号分隔
  * 问号代表模块名
  * 文件扩展名由路径本身定义
* 在表 package.loaded 检查模块是否已经加载
  * 如果已加载则直接返回（模块只会被运行一次）
* Lua启动时，环境变量 LUA_PATH 会初始化 package.path
  * 环境变量中两个分号 ;; 代表默认路径
  * 会将两个分号替换为默认路径
  * 先找 Lua file 再找 C library（LUA_CPATH 和 package.cpath 同理）
* 如果没有环境变量则用默认路径初始化（编译时定义）
* 加载 Lua file 时，用 loadfile
* 加载 C library 时，用 loadlib
  * luaopen_模块名（Lua模块很容易改名，C库不行）
  * 如果 require 时，C模块名包含连字符，则用连字符后的内容创建 luaopen_* 函数
    * `require "a-b" -- luaopen_b`

```lua
package.path = LUA_PATH or default path
package.cpath = LUA_CPATH or default path

function require (name)
    if not package.loaded[name] then -- module not loaded yet
        local loader = findloader(name)
        if not loader then 
            error("unable to load module "..name)
        end
        package.loaded[name] = true -- 避免循环加载
        local code = loader(name) -- only load it, without running it
        local res = code(name) -- initialize module
        if res then
            package.loaded[name] = res
        end
    end
   	return package.loaded[name]
end

function findloader (name)
    local loader = package.preload[name]
    if not loader
       if hasfile(package.path, name) then
            loader = loadfile
       elseif hasfile(package.cpath, name) then
            loader = loadlib
       end
    end
    return loader
end
```

* 避免循环加载 package.loaded[name] = true
  * 假设加载模块 a 的时候，a 又加载 b，这就是循环加载
  * 在加载 a 的时候，先设置为 true，然后再加载并运行a的代码
  * 运行到 b 的加载 a 的时候，会立刻返回，避免了循环加载

### 模块编写的基本方法

#### 最简单的方法

创建一个table，将函数都写在table里，然后返回这个table

```lua
complex = {}

function complex.new (r, i) return { r = r, i = i } end
complex.i = complex.new(0, 1)
function complex.add  (c1, c2) return complex.new(c1.r + c2.r, c1.i + c2.i) end

return complex
```

#### 给模块起别名

```lua
local M = {}
complex = M

function M.new (r, i) return { r = r, i = i } end
M.i = M.new(0, 1)
function M.add  (c1, c2) return M.new(c1.r + c2.r, c1.i + c2.i) end

return M
```

#### 避免写模块名

* require 会将模块名作为参数传给模块
* 模块改名：改文件名即可

```lua
local modname = ...
local M = {}
_G[modename] = M

function M.new (r, i) return { r = r, i = i } end
M.i = M.new(0, 1)
function M.add  (c1, c2) return M.new(c1.r + c2.r, c1.i + c2.i) end

return M
```

#### 消除 return 语句

* 如果模块没有返回值，require 就会返回 **package.loaded[modname]**

```lua
local modname = ...
local M = {}
_G[modname] = M
package.loaded[modname] = M
```

#### 基本方法创建模块的缺点

* 使用模块中的其它公共成员时，必须加模块前缀
* 成员公私有切换时，声明与调用都得改（local容易忽略）

### 使用环境创建模块

* 完全不需要前缀：setfenv（把模块设置为全局环境）
* 缺点：访问不了之前的所有全局变量
  * 全局变量**继承**到模块：`setmetatable(M, { __index = G })`
    * 缺点：模块包含了所有全局变量（类 Perl）
  * 全局变量保存到**局部**变量：`local _G = _G`
    * 缺点：每次使用全局变量时要加前缀
  * 把要要用的全局变量先保存为局部变量：`local sqrt = math.sqrt`

```lua
local modname = ...
local M = {}
_G[modname] = M
package.loaded[modname] = M
setfenv(1, M)

function new (r, i) return { r = r, i = i } end
i = new(0, 1)
function add  (c1, c2) return new(c1.r + c2.r, c1.i + c2.i) end
```

### 使用 module 函数创建模块

* module 函数默认不能访问外部全局变量
* 第二个参数 package.seeall 相当于 setmetatable(M, {__index = _G})
* module 函数可以
  * 复用模块：检查 package.loaded 有没有同名的
  * 预定义变量：
    * _M：代表模块自身（类似 _G）
    * _NAME：模块名（传给module函数的第一个参数）
    * _PACKAGE：包的名称

```lua
module(...)
-- 相当于
local name = ...
local M = {}
_G[name] = M
package.loaded[name] = M
setfenv(1, M)
```

### 子模块与包

* 一个包就是模块与子模块的集合
* 子模块用 点 分隔
  * 点没有特别的意义，只是作为一个key的一部分在package.loaded和package.preload中找
  * 但在搜索文件时，点就变成了目录分隔符
  * 在没有目录层级的系统中，点就变成了下划线
  * C函数名不能有点，也用下划线代替（a.b不能是luaopen_a.b而是luaopen_a_b）

```lua
-- require "a.b"
./a/b.lua
/usr/local/lua/a/b.lua
/usr/local/lua/a/b/init.lua
```

* C库作为子模块

```lua
-- c库a作为mod的模块
-- 改a为 mod/-a
require "mod.-a" -- luaopen_a
```

* 如果没有找到 lua文件 或 c库子包，则会再次找 C库路径（以包名而不是子模块的形式）
  * 如 a.b.c 找不到 a/b/c ，就会找 c库 a，如果找到，则找是否有 luaopen_a_b_c
  * 就是将多个子模块放在一个c库，且各有各的 open函数
* module 函数支持显式的子模块
  * 子模块之间，除了 table 时
  * 模块不会默认加载子模块

```lua
module("a.b.c")
-- 设置环境在 a.b.c 的c中
-- 如果中间没有则创建 有则复用
```

### 面向对象

```lua

Account = {}

Account.balance = 0

function Account:withdraw (v) -- 出账
	if v > self.balance then error "余额不足" end
	self.balance = self.balance - v
end

function Account:deposit (v) -- 进账
	self.balance = self.balance + v
end

function Account:new (o)
	o = o or {}
	self.__index = self
	setmetatable(o, self) -- 把self本身作为元表
	return o
end

a = Account:new { balance = 2 }

print(Account.balance) -- 0
print(a.balance) -- 2

-- 继承
SpecialAccount = Account:new()

-- 覆写
function SpecialAccount:withdraw (v)
	if v - self.balance >= self:getLimit() then -- 可透支
		error "余额不足"
	end
	self.balance = self.balance - v
end

function SpecialAccount:getLimit ()
	return self.limit or 0
end

s = SpecialAccount:new { limit = 1000 }

-- 单个对象的特殊行为 无须创建新类
function s:getLimit ()
	return self.balance * 0.1
end
```

### 多重继承

* 元表的 __index 字段还可以是方法

```lua
function createClass (...)
	local c = {} -- 新类
	local parents = {...} -- 父类列表
	
	setmetatable(c, {__index = function (t, k)
		for i = 1, #parents do -- parents 中找 k
			local v = parents[i][k] -- 尝试第 i 个超类
			if v then
				t[k] = v -- 缓存 缺点是运行后修改方法的定义就很难了
				return v
			end
		end
	end})
	
	--c.__index = c -- 将新类c作为其实例的元表
	
	function c:new (o) -- 为新类定义一个新的构造函数
		o = o or {}
		self.__index = self
		setmetatable(o, self)
		--setmetatable(o, c)
		return o
	end
	
	return c -- 返回新类
end


Account = {}

function Account:getBalance ()
	return self.balance or 0
end

function Account:setBalance (v)
	self.balance = tonumber(v) or 0
end

function Account:withdraw (v) -- 出账
	local balance = self:getBalance()
	if v > balance then error "余额不足" end
	self:setBalance(balance - v)
end

function Account:deposit (v) -- 进账
	self:setBalance(self:getBalance() + v)
end

Named = {}

function Named:getName ()
	return self.name
end

function Named:setName (n)
	self.name = n
end

NamedAccount = createClass(Account, Named)

account = NamedAccount:new()

account:setName("yy")
account:deposit(1000)

print(account:getName(), account.balance)

-- 搜索顺序 account -- （account.__index）NamedAccount -- （NamedAccount.__index是函数）Account -- Named
```

### 私有性

## C  API

* 应用代码：C 调用 Lua
* 库代码：C 被 Lua 调用
* 应用代码和库代码都使用相同的 API 与 Lua 语言通信（C API ）
  * **lua.h** 基础库（lua_*）
    * 基础库没有定义任何全局变量
      * 所有状态都保存在 lua_State 结构体
      * 所有函数都接受一个指向 lua_State 的指针作为参数（可重入、多线程）
    * 创建行 Lua 环境
    * 调用 Lua 函数（lua_pcall）
      * 从栈中弹出编译后的函数，并以保护模式运行
      * 没有错误返回 0，有则向栈中压入错误信息
    * 错误处理
      * `lua_string(L, -1)` 获取错误信息
      * `lua_pop(L, 1)` 错误信息出栈
    * 读写环境中的全局变量
    * 注册能被 Lua 调用的 C 函数
  * **lauxlib.h** 辅助库（luaL_*）
    * 辅助库不能访问 Lua 的内部元素（只是基础库的封装）
    * 编译 lua 代码段（luaL_loadstring）
      * 没有错误返回零，出错则向栈压入错误信息
      * 向栈中压入编译后的函数
    * 创建 lua_State 状态（luaL_newstate）
      * 不包含任何 Lua 标准库
      * **lualib.h** 包含了打开标准库的函数
      * luaL_openlibs 打开所有标准库

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

### 栈

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

* 输出整个栈的内容

```c
static void stackDump (lua_State *L) {
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
    print("\n");
}
```

#### 其它栈操作

* `int lua_gettop (lua_State *L);` 返回栈顶元素索引（元素个数）
* `void lua_settop (lua_State *L, int index);` 将栈顶设置为指定的值（修改元素数量）
  * 比之前少：丢弃
  * 比之前多：nil 填充
  * 为 0：清空栈 lua_settop(L, 0) 
  * 为负数：用于弹出栈
  * `#define lua_pop(L, n) lua_settop(L, -(n) - 1)` 弹出 n 个元素
    * 包起 n 不是多此一举，n 有可能是表达式
* `void lua_pushvalue (lua_State *L, int index);` 将索引上的元素副本压入栈
* 5.3新函数 `void lua_rotate (lua_State *L, int index, int n);`
  * 将指定元素移动 n 个位置
  * n为正数：往栈顶移动
  * n为负数：往栈底移动
* `#define lua_remove(L, i) (lua_rotate(L, (i), -1), lua_pop(L, 1))`

### Windows 下编写 Lua C 模块

* 安装 LuaForWindows（lua + 各种库）
* 安装 TDM-GCC （32位）
* Lua\5.1\makelib.bat
  * %~0 批处理文件本身的绝对路径
  * %~1 批处理文件的第一个参数的绝对路径（或者**拖动**文件到批处理文件）
  * %~nx1 只留文件名和扩展名
  * -fPIC 表示编译为位置独立的代码，不用此选项的话编译后的代码是位置相关的所以动态载入时是通过代码拷贝的方式来满足不同进程的需要，而不能达到真正代码段共享的目的
  * -shared 该选项指定生成动态连接库，不用该标志外部程序无法连接，相当于一个可执行文件

```bat
@if /i %~x1 == .c (
	echo 编译成功
	gcc %~nx1 -o %~n1.dll -fPIC -shared -Wall -O2 -Llib -llua51
)
@pause
```

* 检查是否编译完好 `nm xx.dll` （TDM-GCC 自带工具）

```cmd
gcc stack.c -o stack.dll -fPIC -shared -Wall -O3 -Lsrc -llua51
src\lua
os.execute("echo %cd%") -- 查看当前目录
require "stack"
stack.look()
```

### Windows 下编写 Lua C 模块（无需 LuaForWindows）

* 下载 [lua-5.1.4.tar.gz](https://www.lua.org/ftp/lua-5.1.4.tar.gz) 源代码并解压
* 安装 TDM-GCC
* 编译 Lua

```cmd
cd lua-5.1.4
mingw32-make mingw test
```

* 编写 C 模块

```c
// stack.c
#include <stdio.h>
#include "src/lua.h"
#include "src/lauxlib.h"
#include "src/lualib.h"

static int look (lua_State *L) {
	
	for (int i = 1; i <= 5; i++)
		lua_pushnumber(L, i);
	
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

static const struct luaL_Reg libs[] = {
    {"look", look},
    {NULL, NULL}
};

int luaopen_stack (lua_State *L) {
    luaL_register(L, "stack", libs);
    return 1;
} 
```

* 编译 C 模块并调用

```cmd
gcc stack.c -o stack.dll -fPIC -shared -Wall -O3 -Lsrc -llua51
nm stack.dll | findstr luaopen :: 查看

src\lua
os.execute("echo %cd%") -- 查看当前目录
require "stack"
stack.look()
```

* Linux 下编译 C 库参考 [Termux 最佳实践](/Linux/Termux最佳实践.md#编译-Lua)

  