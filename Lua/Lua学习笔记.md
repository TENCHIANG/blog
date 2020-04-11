## Lua学习笔记

### 交互式环境和执行环境

* 执行环境打印变量需要使用`print`函数
* 交互式环境可以直接打印变量
  * lua5.3之前要在表达式（单个变量也算表达式）前加 = 号才能打印值
  * lua5.3开始会直接打印表达式，不需要加 = 号
  * 但是又会产生新的问题，如果不想要打印值，加分号

```lua
= a --> nil （lua5.3之前）
a --> nil （lua5.3开始）

-- lua5.3 不想打印值 加分号
io.flush() --> true
io.flush(); --> 变成语句而不是表达式，所以交互式环境下不输出值
```

### 注释

* 单行注释
```lua
print("Hello") -- 单行注释的最小版本
print("Hello") --> Hello （既是输出又是注释）
```

* 多行注释

```lua
--[[
print("Hello") -- 多行注释的最小版本
]]

--[[
print("Hello") -- 多行注释最佳实践：不启用代码
--]]

---[[
print("Hello") -- 这样就会很轻易的启用代码
--]]
```

### 全局变量

* 全局变量未经初始化也可以使用
* **未初始化的变量**和**赋值为 nil 的变量**是没有区别的（回收内存）
* 类似于js，lua的全局变量都是存在table里

### 类型和值

> Lua有**8种基本类型**：nil、boolean、number、string、userdata、function、thread、table

#### 使用全局函数type可以检测值的类型

```lua
type(nil) --> nil
type(true) --> boolean
type(type(true)) --> string
type(math.pi) --> number
type(io) --> table
type({}) --> table
type(io.stdin) --> userdata （实际上stdin是file）
type(type) --> function
```

#### Lua是动态类型语言，一个变量的类型是可变的（弱类型）

```lua
a = 0
type()
```

#### nil类型

> 类型nil只有一个值，就是nil，表示**non-value**

#### boolean类型

* 类型boolean有两个值：true、false
* **false 和 nil 之外的值都为真（0也为真）**
* lua的**逻辑运算符**：and（&&与）、or（||或）、not（!非）

```lua
-- not运算符永远返回boolean类型
not not 0 --> true（相当于 !!0）

-- or and 都遵循短路求值原则（Short-circuit evaluation）
1 or 2 --> 1
1 and 2 --> 2

-- 当x未被初始化时，设置默认值为v，一般x不是boolean类型
x = x or v

-- 三目运算符
x = a and b or c -- 相当于 x = a ? b : c
```

### 把lua文件当做脚本运行

> script.lua：

```lua
#!/usr/local/bin/lua
#!/usr/bin/env lua
```

```sh
chmod +x script.lua
./script.lua # 运行lua脚本 而不需要 lua script.lua
```

### Lua解释器的参数

>  Lua解释器（Stand-alone interpreter）的源代码为`lua.c`编译后为`lua`或`lua.exe`，其参数形式为：`lua [options] [script [args]]`

* -l：加载库
* -i：最终进入交互模式
* -e：直接在命令行输入代码

```sh
lua -e "print(10)" # 10

# 自定义命令提示符 默认为 '> '
# 进入交互式环境后无法修改
lua -i -e "_PROMPT='>>> '"
```

* 都可以有，也都可以没有（直接进入交互模式）

#### 环境变量LUA_INIT

> 解释器在处理参数前，会查找环境变量LUA_INIT，如果存在，有两种情况：

1. 文件以 @ 开头：运行相应的文件
2. 文件不以 @ 开头：尝试当做lua脚本解释运行

> 作用是**配置解释器**

* 加载程序包
* 修改路径
* 定义自定义函数
* 对函数进行重命名
* 删除函数

#### 获取脚本的参数

> 使用全局变量`arg`获取

```lua
-- getArgs.lua
print(type(arg), arg)
for i = -5, 5 do
	print(i, type(arg[i]), arg[i])
end
```
> 运行：

```sh
lua -e "_PROMPT='>>> '" getArgs.lua a b
```

> 结果：

    table   table: 0023B490
    -5      nil     nil
    -4      nil     nil
    -3      string  lua
    -2      string  -e
    -1      string  _PROMPT='>>> '
    0       string  getArgs.lua
    1       string  a
    2       string  b
    3       nil     nil
    4       nil     nil
    5       nil     nil
### 数值类型number

* lua5.3以前，所有 number 都以**64位浮点（双精度）**表示

  * 如果能用整数表示的话就用整数

* lua5.3开始，number 分为两种
  * integer（64位整形）
  
  * float（64位双精度浮点，不用 double 的原因是因为还有32位模式）
  
  * 源代码 `LUA_32BITS` 宏（编译为 Small Lua 模式，integer 和 float 都只用**32位**，其它一样）
  
  * 使用 `math.type` 函数区分 number 到底是 integer 还是 float
  

```lua
type(3) --> number
type(3.0) --> number

--- lua5.3之前 如果能用整数表示的话就用整数
1e3 --> 1000
1000.0 --> 1000
1000 --> 1000
2^1 --> 2

--- lua5.3开始 整数是整数 浮点是浮点
math.type(3) --> integer
math.type(3.0) --> float
1e3 --> 1000.0
1000.0 --> 1000.0
1000 --> 1000
2^1 --> 2.0

```

#### 十六进制数

```lua
0xff --> 255

-- lua5.2开始支持 16进制浮点数（小数部分 和 p/P开头的指数部分组成 2的p次方）
0x0.2 --> 0.125
0x1p1 --> 2.0 相当于 1 * 2^1
0x1p-1 --> 0.5
0xa.b --> 10.6875
0xa.bp2 --> 21.375

--- p后面就不支持 16进制了
0x1p10 --> 1024.0
0x1p0xa --> stdin:1: unexpected symbol near '0x1p0'
```

> 反查十六进制浮点数

```lua
-- lua5.1 不支持 %a 参数
string.format("%a", 1) --> 0x1p+0
string.format("%a", 0.1) --> 0x1.999999999999ap-4
string.format("%a", 10) --> 0x1.4p+3 （相当于1.25 * 8.0，估计是从小开始试的所以不是0xap+0）
```

#### Lua5.3中的加减乘除

* 一般规律：双方为整数，结果为整数，否则结果为浮点数（将整数转换为浮点数在运算）
* 出发不符合一般规律：强制把两边都转为浮点数，再进行运算，结果为浮点数
  * Lua5.3符合一般规律的除法：**floor除法**

```lua
-- lua5.3
1 + 1 --> 2
1 + 1.0 --> 2.0
1 / 1 --> 1.0

10 / 3 --> 3.3333333333333
10 // 3 --> 3
10 // 3.0 --> 3.3333333333333
```

#### Lua中的取模运算

* 对于任何k，x就算为负数，x % k 也永远在 [0, k - 1] 之间，如 x % 2 的值为 [0, 1]
* 保留 n  位小数：`x - x % 10 ^ -n`

```lua
-- lua5.3
a = 10
b = 3
a % b == a - (a // b * b) --> true（都为1）

10 % 3 --> 1
10 % 3.0 --> 1.0

.3 --> 0.3
3. --> 3.0 （lua5.1还是3）

-- 保留 x 的 n 位小数
x = math.pi
n = 2
x - x % 10 ^ -n --> 3.14
```

#### 关系运算

> 关系运算的结果都是 boolean 型

* `<`
* `>`
* `<=`
* `>=`
* `==` 相等性测试
* `~=` 不等性测试（相当于C的 !=）

### string 字符串

* 一字节为 8 位
* 字符串为不可变
* 字面字符串表示
  * 单引号
  * 双引号
  * 双方括号（**多行字符串**，不转义，忽略第一行的换行）
    * 多行字符串或多行注释里包含方括号的话 在**两个方括号间加等号**（只匹配数量相等等号的方括号）
* 长度运算符 **#**
  * #string
  * #table 返回最大的数值索引，以值为 nil 的元素截止（数组结尾的标志）
* 连接运算符 **..** （连接字符串或数字为字符串）
  * string1..string2
  * number1 .. number 2（类型转换）
    * 数字后面必须加空白符，以免误解为小数点，如果是变量则不需要
    * 最佳实践就是**连接符两边都加空格**
    * 数字可以转为字符串，反过来，字符串也可作为数字运算（仅限算术运算符）
    * 字符数字转换最佳实践
      * string -> number：`tonumber`（无法转则返回`nil`）
      * number -> string：`tostring`（类似`print`和`=`，就是没有打印出来）
```lua
a = "abc"
b = string.gsub(a, "b", "e")
=a --> abc
=b --> aec
=#a --> 3

-- 多行字符串 不转义
s = [[a\r\nb]]
=s --> a\r\nb

-- 忽略第一行的换行
-- 最后一行有换行
s = [[
a
b
c
d
]]
=s --[[
a
b
c
d

]]

-- 多行字符串和注释包含方括号需要加等号匹配
s = [=[
[===[]===]
]=]
-- 这种形式即便是 lua5.3 也要加等号以输出
=s --[=[
[===[]===]

]=]

-- 字符串连接
-- 最佳实践就是连接符两边都加空格
='a'..'b' --> ab
=1..2 --> stdin:1: malformed number near '1..2'
=1 ..2 --> 12
=1 ..'a' --> 1a
=math.pi..'π' --> 3.1415926535898π

-- 字符串也可以作为数字
='1' + 1 --> 2
='10' / 2 --> 5
='1' == 1 --> false 字符串作数字仅限算术运算符
```

### table 表

* 如果没有任何引用，则回收table的内存
* 元素没初始化时，值为 nil，反过来，想删除某个元素，赋值 nil 即可（全局变量的原理）
* 和 js 的 object 不要太像（关联数组）
  * `t['x'] == t.x` 
  * 注意：`t[0]` 和 `t['0']` 是两个不同的元素！

#### table做数组

* table 做数组，下标习惯上从**1**开始
  *  for 循环 会忠实的遍历 [n, m] （更方便）
  * 长度运算符：返回最后一个数值下标作为长度（下标从 0 开始就不准了）
  * 指定 value 初始化 table 时，下标从 1 开始
  * `select(1, ...)` 最低从 1 开始，0 就超出范围了，# 代表总数包括中间的 nil
* `#table`：返回最大的数值索引（数组长度），以值为 nil 的元素截止（数组结尾的标志）
  * **下标由 0 开始** +1
    * 从数值索引 1 的元素开始检查
    * 碰到 nil 元素结束
    * 等价于 `table.getn(t)`
    * 所以不会出现**负数**
  * 如果只想返回最大的数值索引，不管 nil 元素（逻辑上的空隙数组）
    * `table.maxn(t)`
  * **序列**：没有空隙的数组

```lua
a = {}
for i = 1, 10 do a[i] = i end
a.x = 'x'
a[99] = 99

=#a --> 10
=table.getn(a) --> 10
=table.maxn(a) --> 99

for i = 1, #a do print(a[i]) end -- 打印序列（ipairs）（!!!保证顺序!!!）

for k, v in pairs(a) do print(k, v) end -- 打印所有的键值对（!!!不保证顺序!!!）

function getn (...)
	local t = ...
	assert(type(t) == 'table', '期望的是 table 传过来的是 ' .. type(t))
	
	local i = 0
	while t[i + 1] do
		i = i + 1
	end
	
	return i
end
```

#### table 初始化赋值

* 指定空值：`t = {}`
* 指定 key：`t = {a = 1, b = 2}`（key 为非空字符串）
* 指定 value：`t = {1, 2, 3}`（第一个 value 从下标 1 开始）