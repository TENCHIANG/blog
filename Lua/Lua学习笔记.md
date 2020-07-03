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
  * 其实就是 单行注释 + 多行字符串

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
x = a and b or c -- 近似于 x = a ? b : c
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
  * **可以两个number比较两个string比较，但是不能单独比较**

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
    * 字符数字转换**最佳实践**
      * string -> number：**tonumber**（无法转则返回`nil`）
      * number -> string：**tostring**（类似`print`和`=`，就是没有打印出来）
        * 其实 any -> string 的最佳实践也是 **tostring**

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
    * 注意 lua5.3 删除了maxn
      * 但是新增了 table.pack（包含了nil 且添加字段 n 表示长度）
      * 所以 maxn 也没必要存在了
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

### 三元运算符近似

* `a and b or c` 不能完全等价于 `a ? b : c`
* 如果 b 为假
  * a为假，结果为c，符合三元运算符
  * a为真，结果也为c，不符合，所以起码得保证b为真
  * 用 if 更加稳

```lua
=true and 1 or 2 --> 1
=true and false or 2 --> 2 (应该为false的)
```

### 更自由的 table 初始化

```lua
k = '/'
t = { [-1] = -1, [''] = '空', [k] = 'k' }

t = { 1, 2, 3 }
-- 等价于
t = { [1] = 1, [2] = 2, [3] = 3 }

t = { a = 1, b = 2 }
-- 等价于
t = { ['a'] = 1, ['b'] = 2 }

a = 'c'
t = { a, a } -- { 'c', 'c' } 默认是数组!!!
```

### lua实现类似反向链表（栈）

```lua
for line in io.lines() do
	list = { prev = list, value = line }
end

l = list
while l.prev do -- 只有 l 的话 会打印最后的 nil
	print(l.value)
	l = l.prev
end
```

### 多重赋值

* `a, b = 1, 2`
* `a, b = b, a` 交换两个元素
* 如果两遍不相等：右边多了舍弃，少了赋 nil
* 函数也可以返回多个值

### 局部变量

* 用 local 声明的变量
  * `local a` 相当于 `local a = nil`
  * 局部变量**重复声明**，会被置 `nil`（未定义状态），不会报错
* 作用域只在当前 块（block）
  * 控制结构执行体
  * 函数执行体
  * 程序块（chunk）
* 交互式环境下的 chunk 局部变量
  * 一条完整的命令就是一个 chunk
  * 所以交互式环境 chunk 局部变量可能会没用
    * 显示界定一个块：`do end`
* 常用局部变量
  * 以免污染全局变量
  * 局部变量更快
  * 更有利于 GC
  * `local a = a` 把全局变量赋值到局部变量（加速访问）
  * 在变量要使用时才声明它
    * 初始化时就有个有意义的值
    * 代码可读性

```sh
> local a = 1
> =a --> nil 不同的块导致局部变量失效（使用的是全局变量）
> do
>> local a = 1
>> print(a) --> 1
>> end
> 
> # 局部变量重复声明
> do
>> local a = 1
>> local a
>> print(a)
>> end
nil
```

### 控制结构

* Lua不支持 `switch`，用 `if then elseif then end` 代替

### repeat until 循环

* 最少执行一次
* 直到条件为真才停止
* 局部变量作用域包括条件部分

```lua
repeat
    local a = true
    print(a)
until a --> true
```

### for 循环

* 数字型 for （numberic for）
* 泛型 for （generic for）
* 支持 break 不支持 continue

#### 数字型 for

```
--- nunberic for 格式
for v = n, m<, setp = 1> do end
```

* v 从 n 开始
  * v 称为 控制变量
  * 作用域只限于 for
* 以步长 step 递增
  * 每次 `v = v + setp`
  * 默认步长为 1（可省略步长）
* 到 m（包括 m）
  * m 只会被执行一次
  * `math.huge` 作为 m 相当于 无限

```lua
function f ()
    print('f')
    return 5
end

for i= 1, f() do
    print('for')
end

print(i) --> nil

--[[
f
for
for
for
for
for
]]
```

#### 泛型 for

```
--- generic for 格式
for k<, v> in iterator() do end
```

* generic for 通过 **迭代器 iterator** 函数遍历所有值
  * `pairs`：遍历 table 的所有 key（不保证顺序）
  * `ipairs`：遍历 table 的所有数值 key（从 1 开始，保证顺序）
  * `io.lines`：遍历 file 中的每一行
  * `string.gmatch`：迭代 字符串 中的 单词
  * 如果 in 前只有一变量，那就是 key （忽略 value）
  * 使用 泛型 for 迭代器 可以很方便的 **k v 对换**
  * `do return end`：方便调试（`return`只能放在`end`前面）

```lua
t = { [0] = 0, 1, 2, 3, 4 }

for k, v in pairs(t) do print(k, v) end
--[[
1       1
2       2
3       3
4       4
0       0
]]

for k, v in ipairs(t) do print(k, v) end
--[[
1       1
2       2
3       3
4       4
]]

-- k v 对换
days = { 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun' }
revDays = {}
for k, v in pairs(days) do revDays[v] = k end
print(days[3], revDays['Wed']) --> Wed     3

--- 插入 return 方便调试
function f ()
    return
    1
end
=f() --> 1
--[[ 报错
function f ()
    return
    return 1
end
--]]
function f ()
    do return end
    return 1
end
=f() --> 什么都不会输出
print(f()) --> 输出一个 \n
```

### 函数

* **parameter**（形式参数）
* **argument**（实际参数）
  * **多了舍弃，少了补 nil**
  * 所以参数，可变参数，多重值是差不多的东西
* Lua函数是 **第一类值（First-Class Value）**
  * 具有特定的 **词法域（Lexical-Scoping）**
    * 函数可以嵌套，内部的函数可以访问外部函数中的变量（特点）
      * 实现 **函数式编程**
      * **λ演算（Lambda Calculus）**
  * 完全可以把函数本身当成**普通的值**使用
    * 已函数作为参数的函数被称为 **高阶函数（higher-order function）**
    * 会涉及到 匿名函数

### 函数 return

* `return` 后面不要直接接括号（可能会导致只有一个值）
* 如果需要立刻终止函数：建议使用 `do return end`

#### 无返回值函数

* 函数里有 `return` 不代表一定就有返回值
* 函数如果不显示的加 `return` 则会隐式的加 `return`
  * 仅有 `return` 为 **无返回值函数**
  * 相当于什么也不返回（与返回 `nil` 有区别）
* 如果不是做函数参数的话和 `nil`区别不大
* 如果做函数参数的话：**无法做单个实参 **
  * 传 `type` 单个：会报错 `bad argument`
  * 如果在多重值里面（参数列表），则表现为 `nil`
  * 估计和 多重值，**可变参数 **有关
* **建议**：尽量不要使用无返回值函数做参数，做值

```lua
function f() end
function f() return end
function f() do return end end

function null () do return nil end

a = 1
a = f() -- 相当于 a = f() or nil
=a --> nil

=f() or 1 --> 1
=f() == nil --> true

print(f()) --> \n
type(nil) --> nil
type(f()) --> stdin:1: bad argument #1 to 'type' (value expected)

print(f(), 1, 2, 3) --> nil     1       2       3
type(f(), 1) --> nil

function foo (...)
    local t = { ... }
    print(type(...), ...)
    print(type(t), ...)
    for k, v in pairs(t) do
        print(k, v)
    end
end

foo(f()) --> stdin:3: bad argument #1 to 'type' (value expected)
foo(nil)
--[[
nil     nil
table   nil
]]

foo(1, f(), 2, f(), 3, f())
--[[
number  1       nil     2       nil     3
table   1       nil     2       nil     3
1       1
3       2
5       3
]]

=f() --> 
=null() --> nil
=1, 2, 3, f() --> 1       2       3
=1,2,3, null() --> 1       2       3       nil
=f(), 1, 2, 3 --> nil     1       2       3
```

#### 函数调用省略圆括号

* 传且只传一个参数
* 参数类型不能为变量，只有两种常量支持
  * `string` 字面值
  * `table` 字面值（构造式）

```lua
print "123" --> 123
print {} --> table: 006801B8

print true --> stdin:1: '=' expected near 'true'
print tostring(true) --> stdin:1: '=' expected near 'tostring'
```

#### 函数冒号操作符

* `o:f(x)` 等价于 `o.f(o, x)`
  * 相当于将 o 隐式的传了进去
* 一般用于面向对象

#### 多重返回值（multiple results）

* 多返回值函数调用做表达式只启用 **第一个**值
* 最佳实践：使用下划线做占位符，避免不想要的值
  * 下划线其实就是普通的变量（相当于垃圾桶）
  * 变量可以同时被赋值多次，但是只启用 **第一个值**
    * 相当于一个变量，同时被赋值多个值
* 迫使函数只返回一个值：用**括号包起**函数调用
  * **巨坑**：如果不是函数，后面就别加括号了，可能就只有一个值，虽然可以运行
    * `return`
    * `until`

```lua
s, e = string.find("Hello World!", "Wo")
print(s, e) --> 7	8

=string.find("Hello World!", "Wo") .. 0 --> 70

function f () return 1, 2, 3 end
_, res, _ = f()
=res --> 2
=_ --> 1 等价于 _ = 1, 3 那肯定是 1

res, res, res = f()
=res --> 1
--- 等价于
res = f()
=res --> 1

=(f()) --> 1 迫使函数只返回一个值

-- 巨坑！如果不是函数 后面就别加括号了
function foo () return(f()) end
=foo() --> 1
```

### table 与 function

* 要区分函数与函数调用
* table 里直接放函数：数组形式保存函数地址
* table 里直接放函数**调用**：数组形式保存函数返回值
  * 函数调用作为最后一个：table 可以接收**多个值**（均匀 地分布在 table 里）
  * 函数调用不作为最后一个：只能接收第一个值

```lua
function f () return 1, 2, 3 end

t = { f }
=t[1] --> function: 00681288
=t[1]() --> 1	2	3

t = { f() } -- 相当于 t = { 1, 2, 3 }
=t[1] --> 1
=t[2] --> 2
=t[3] --> 3

function printTable (t)
    for k, v in pairs(t) do print(k, v) end
end

t = { f(), 4 }
=t[1] --> 1
=t[2] --> 4

t = { f(), [4] = 4 } -- 后空出来也没用 函数调用只要不是最后一个 就只有一个值
=t[1] --> 1
=t[2] --> 4

t = { [4] = 4, f() } -- 要空出来得先空出来
printTable(t)
--[[
1       1
2       2
3       3
4       4
]]

t = { [2] = 0, f() } -- 先空出来不够的话 后面的会覆盖前面的
printTable(t)
--[[
1       1
2       2
3       3
]]

t = { f(), f() } -- 第一个只有第一个值 第二个 依次均匀分布
printTable(t)
--[[
1       1
2       1
3       2
4       3
]]
```

#### unpack 函数：把数组转为多重值

* 具体用在函数的 反省调用（generic call）

```lua
t = { 1, 2, 3 }
=unpack(t) --> 1	2	3

--[[
@description 实现 unpack 函数，原本是C语言实现
@t {table} 数组
@i {number} 下标 从 i 开始 可选 默认从 1 开始
@return {numbers} 多重数值
]]
function unpack2 (t, i)
    assert(type(t) == 'table', '参数 t 类型应为 table 实为 ' .. type(i))
    local i = i or 1
    assert(type(i) == 'number', '参数 i 类型应为 number 实为 ' .. type(i))
    if t[i] then
        return t[i], unpack2(t, i + 1)
    end
end
```

#### 可变长参数（variable number number of argument）

* `...` 类型为第一个参数的类型（多重值取第一个）
* `pairs` 和 `ipairs` 的区别（处理 table）
  * `ipairs`：按顺序显示 数组 内容，**碰到**值为 `nil` 的就停止了
  * `pairs`：显示所有 table 内容，**跳过**值为 `nil` 的
* `select`：**更稳**的方法，不会跳过 `nil`（处理多重值）
  * `select('#', ...)` 返回总长度
  * `select(i, ...)` 从 i 起返回所有元素
  * 实际上也可以用来 多重值

```lua
function printArgs (iterator, ...)
	for k, v in iterator {...} do
		print(k, v)
	end
end

printArgs(ipairs, nil)
printArgs(pairs, nil)

printArgs(ipairs, nil, 1, 2, 3)
printArgs(pairs, nil, 1, 2, 3)
--[[
2       1
3       2
4       3
]]

printArgs(ipairs, nil, 1, nil, 3)
printArgs(pairs, nil, 1, nil, 3)
--[[
2       1
4       3
]]

printArgs(ipairs, 1, 2, 3, nil)
--[[
1       1
2       2
3       3
]]
printArgs(pairs, 1, 2, 3, nil)
--[[
1       1
2       2
3       3
]]

function prints (...)
	for i = 1, select('#', ...) do
		print(i, (select(i, ...)))
	end
end

prints(1, 2, 3, 4)
--[[
1       1
2       2
3       3
4       4
]]
prints(1, 2, 3, nil)
--[[
1       1
2       2
3       3
4       nil
]]
prints(nil, 2, 3, 4)
--[[
1       nil
2       2
3       3
4       4
]]
prints(1, nil, 3, 4)
--[[
1       1
2       nil
3       3
4       4
]]
```

#### 可变参数最佳实践

```lua
-- 追踪函数调用（调试）
function foo (...)
    print("调用 f: ", ...)
    return f(...)
end

-- 函数组装
function printf (fmt, ...)
	return io.write(string.format(fmt or "", ...))
end

printf() --> stdin:2: 参数 fmt 是必须的
printf("a\n") --> a
printf("%d%d\n", 3, 4) --> 34

--[[
模拟 Lua5.0 可变长参数
也是用 ... 作为最后一个参数
但是通过隐含的局部变量 arg 存储 可变长参数 有个 n 字段保存长度
缺点：每次调用函数都要创建一个 table 新版本只有用到时才创建
]]
function f (...)
	local arg = { n = select("#", ...), ... }
	for i = 1, arg.n do print(i, arg[i]) end
end
```

#### 具名实参（named arguments）

* Lua中的参数传递是**基于位置**的
* 也可以实现**基于参数名**传递参数
  * 用 table 实现：实参只传递一个 table ，在 table 里面指定参数名（可以省略函数的括号）
  * 特别是参数可选的情况下有用

```lua
function rename (arg)
    return os.rename(arg.old, arg.new)
end

rename { new = "a.lua", old = "b.lua" }
```

#### 匿名函数

```lua
function f () end
-- 其实完整版是，赋值号右边就是 匿名函数（函数构造式）
f = function () end

t = {
    { n = 2 },
    { n = 4 },
    { n = 0 },
    { n = 1 }
}
table.sort(t, function (a, b) return a.n > b.n end) -- 降序
for k, v in pairs(t) do print(k, v.n) end
--[[
1       4
2       2
3       1
4       0
]]

```

#### 闭包（closure）

* 也被称为 闭合函数
* 词法域：函数嵌套，内部可以访问外部的
  * **非局部变量（non-local variable / upvalue）**
    * 非全局变量
    * 也非局部变量（外部函数的局部变量）
* 第一类值：把函数当成普通值
* **闭包 = 函数 + 所用到的非局部变量 + 创建闭包的 factory 函数**
  * 返回内部函数 内部函数使用外部变量（非局部变量）
  * 每创建一个新的闭包 就会有一个新的内部函数 和 新的 非局部变量
  * 只有闭包置 nil 或者超出其作用域了
  * 其实函数也是一种特殊的闭包（没有非局部变量）
* 闭包的作用
  * 重新定义函数（封装函数）
    * 沙盒环境（sandbox）
    * 元机制（meta-mechanism）
      * 小而美 对应 大而全

```lua
function sortByGrade (names, grades)
    table.sort(names, function (name1, name2)
            return grades[name1] > grades[name2]
    end)
end

names = { "Peter", "Paul", "Mary" }
grades = { Mary = 10, Paul = 7, Peter = 8 }
sortByGrade(names, grades)

for k, v in pairs(grades) do print(k, v) end
--[[
Mary    10
Peter   8
Paul    7
]]

-- 闭包的典型用法 返回内部函数 内部函数使用外部变量（非局部变量）
-- counter 创建闭包的 factory 函数
function counter ()
    local i = 0
    return function ()
        i = i + 1
        return i
    end
end

tc = { counter(), counter() } -- 生成两个独立的闭包
tc[0]() --> 1
tc[0]() --> 2
tc[1]() --> 1

-- 重新定义库函数
do
    local oldSin = math.sin
    local k = math.pi / 180
    math.sin = function (x)
        return oldSin(x * k)
    end
end

-- sandbox
do
    local oldOpen = io.open
    local access = function (filename, mode)
    	-- 检查访问权限
        return false
    end
    
    io.open = function (filename, mode)
        if access(filename, mode) then
            return oldOpen(filename, mode)
        else
            return nil, 'access denied'
        end
    end
end
```

#### 非全局函数（non-global function）

* **非全局函数（non-global function）**：存在于局部变量或者 table 的字段中就是
* **局部函数（local function）**：存在于局部变量的函数
  * 易错点：用局部函数递归
    * 要先声明，再定义（**前向声明 Froward Decalration**）
      * 声明定义一起的话就报错了
        * 编译到递归的地方时，局部函数还没有声明的，调用的是全局的，全局没有则报错
      * 先声明的话，虽然没有定义的，但不会报错，而真正执行的时候已经有了正确的值（定义）
    * 或者用局部函数的语法糖
      * 其实语法糖展开就是先声明再定义
      * 但是这对于**间接递归**无效，还是显式的前置声明稳（声明两个）
        * 间接递归：我调你，你调我

```lua
-- 第一种方式
t = {}
t.f = function () end
t.g = function () end

-- 第二种方式
t = {
    f = function () end,
    g = function () end
}

-- 第三种方式
t = {}
function t.f () end
function t.g () end

-- 局部函数语法糖
local function f () end

-- 递归与局部函数
function fact (n)
    return n <= 0 and 1 or n * fact(n - 1)
end
=fact(3) --> 6 没毛病

do
    local fact = function (n)
        return n <= 0 and 1 or n * fact(n - 1)
    end
    print(fact(3))
end --> stdin:3: attempt to call global 'fact' (a nil value)

-- 1
do
    local function fact (n)
        return n <= 0 and 1 or n * fact(n - 1)
    end
    print(fact(3))
end

-- 2
do
    local fact
    fact = function (n)
        return n <= 0 and 1 or n * fact(n - 1)
    end
    print(fact(3))
end

-- 间接递归 用前置声明
local f, g

function f () g() end
function g () f() end
    
    
do
	local f
    function f () print("f") end -- 上面有前置声明 这里就是局部变量
    function g () print("g") end -- 上面没有前置声明 这里就是全局变量
end
f() --> attempt to call global 'f' (a nil value)
g() --> g
    
-- 由此可见
function f () end
-- 相当于
f = function () end
```

#### 正确的尾调用（proper tail call）

* **尾调用（tail call）**：一个函数的调用，是另一个函数的最后一个动作
  * 类似于 `goto`，不会产生函数调用（函数栈的申请）
  * `function f (x) return g(x) end`
    * f 对 g 的调用就是 尾调用（已经是g 的最后一次调用，后面不需要再调用到 g）
    * 尾调用之后，不再需要尾函数的栈（stack）了
  * 执行控制权立刻返回到 f（return）
  * 什么不是尾调用：`function f (x) g(x) end`
    * 调用后 **不能立刻返回** 还得做一些 **操作**
* **尾调用消除（tail-call elimination）**：
  * 尾调用时不耗费栈空间
  * 理论上可以有无数嵌套的尾调用而不会**栈溢出（stack-overflow）**
* 尾调用的应用：
  * **状态机（state machine）**
    * 一个函数表示一种状态
    * 改变状态：调用（goto）到另一个函数

```lua
-- 什么是尾调用
function f (x) return g(x) end
function f (n)
    if (n > 0) then return f(n - 1) end
end

--[[ 伪代码
function f ()
    go()
    l:
end
function g () goto l end
]]

-- 什么不是尾调用
function f (x) g(x) end -- 还要丢弃返回的临时结果
function f (x) return g(x) + 1 end -- 还要做一次加法
function f (x) return x or g(x) end -- 还要调整为一个返回值
function f (x) return (g(x)) end -- 还要调整为一个返回值
```

#### 状态机（state machine）

* 利用尾调用实现状态机
* 数据驱动会更好：房间和移动记录在table

```lua
do
    local room
    room = {
        function ()
        	print("你现在第一间房，请行动：")
            local move = io.read()
            if move == "s" then return room[3]()
            elseif move == "d" then return room[2]()
            else
                print("撞墙了！") -- 要有输入才算 直接回车不算
                return room[1]()
            end
        end,
        function ()
        	print("你现在第二间房，请行动：")
            local move = io.read()
            if move == "s" then return room[4]()
            elseif move == "a" then return room[1]()
            else
                print("撞墙了！")
                return room[2]()
            end
        end,
        function ()
        	print("你现在第三间房，请行动：")
            local move = io.read()
            if move == "w" then return room[1]()
            elseif move == "d" then return room[4]()
            else
                print("撞墙了！")
                return room[3]()
            end
        end,
        function ()
            print("恭喜到达第四间房！游戏结束")
        end
    }
    print("从第一间房走到第四间房算成功，wsad表示上下左右，回车确认")
    room[1]() -- 开始游戏
end
```

#### 迭代器

* 一种可以遍历集合中所有元素的机制
* 迭代器可以用闭包实现
  * 每调用一次，返回集合中的下一个元素

```lua
function values (t)
    local i = 0
    return function ()
        i = i + 1
        return t[i]
    end
end

t = { 10, 20, 30 }

-- while 使用迭代器
iter = values(t) -- 创建迭代器
while true do
    local e = iter() -- 调用迭代器
    if e == nil then break end -- 迭代器返回 nil 时结束循环
    print(e)
end

-- for 使用迭代器
-- 内部对于迭代器自动做了以上的工作
for e in values(t) do print(e) end

-- 返回一行中的所有单词 空格间隔 字母 数字 都算
function allWords ()
    local line = io.read()
    local pos = 1
    return function ()
        while line do
            local s, e = string.find(line, "%w+", pos)
            if s then
                pos = e + 1
                return string.sub(line, s, e)
            else
                line = io.read()
                pos = 1
            end
        end
        return nil
    end
end

for word in allWords() do print(word) end
```

#### 泛型 for 的语义

##### 上述迭代器的缺点

* 要为每个新的循环创建闭包
* 所以 泛型 for 自身能保存迭代器状态（用不着闭包保存了，所以泛型 for 迭代器一般都不是闭包实现的？）
  * 迭代器函数
  * 恒定状态（invariant state）
  * 控制变量（control variable）
    * 初始化时的第三个变量（一开始可以为 nil）
    * 变量列表的第一个变量（循环时不能为 nil，为 nil 则代表循环结束）

````lua
-- 泛型 for 的语法
-- varList 若干变量名 逗号分隔 第一个变量为 控制变量 为空则结束循环
-- expList 若干表达式 逗号分隔 一般只有一个表达式（对迭代器工厂的调用）
for varList in expList do end
````

##### 泛型 for 的运行方法（迭代器）

* 对 in 后面的表达式列表求值（初始化）
  * 只保存最后一个表达式返回的前3个结果，多的丢弃少的 nil 补齐（类似多重赋值）
  * 表达式列表取三个值（这里有疑问!!!）
    * 迭代器函数
    * 恒定状态
    * 控制变量初值
* 以 恒定状态 和 控制变量 来调用迭代器函数（循环的开始 第一次循环）
* 然后将 迭代器函 数的返回值赋予变量列表（此时才到 in 的左边，变量列表跟初始化时的三个值没关系）
* 如果 控制变量为 nil （第一个返回值），则循环终止 （循环终止）
* 否则 for 执行 循环体，然后再次调用迭代函数（第 1 次循环结束）

``` lua
-- 设 迭代器函数f 恒定状态s 控制变量初值a0 （初始化）
-- 循环过程中 a1 = f(s, a0) a2 = f(s, a1) ... an = f(s, an-1) 直到 ai == nil 结束循环
-- 当然 f 返回的值 包括但不限于 a，还可以有其它的值，一律都在 a 之后

-- 泛型 for 的实现
do
    local t = { 10, 20, 30 }
    local f, s, a = pairs(t)
    while true do
        local k, v = f(s, a)
        a = k
        if a == nil then break end
        print(k, v) -- 循环体
    end
end

--[[
@description 泛型 for 实现
@varList {table} 变量列表
@expList {table} 表达式列表
@body {table} 循环体
]]
function genericFor (varList, expList, body)
    local f, s, a -- 迭代器函数f 恒定状态s 控制变量a
    for i = 1, #expList do f, s, a = expList[i]() end -- 初始化
    
    while true do -- 开始循环
        local varAll = { f(s, a) }
        
        a = varAll[1]
        if a == nil then break end -- 循环终止
        
        -- for i = 1, #varList do varList[varList[i]] = varAll[i] end -- 只取需要的
        
		-- body[i](varList)
    	for i = 1, #body do body[i](unpack(varAll)) end -- 执行循环体
        
    end
end

t = { 10, 20, 30 }
varList = { 'k', 'v' }
expList = {
    function () return pairs(t) end
}
body = {
	-- function (varList) print(varList.k, varList.v) end
    -- 循环体在函数体里 所以 print(v, k) 也是可以的
	function (k, v) print(k, v) end
}
genericFor(varList, expList, body)
-- 等价于
for k, v in pairs(t) do print(k, v) end
```

#### 无状态的迭代器

* 自身不保存任何状态的迭代器
* 可以在多个循环中使用同一个无状态迭代器，避免创建新闭包的开销
* 无状态迭代器：ipairs、pairs

```lua
function ipairs (a)
	return function (a, i)
        i = i + 1
        local v = s[i]
        if v then return i, v end
    end, s, 0
end

function pairs (t) return next, t, nil end

-- 所以 可以直接用 next
t = { 10, 20, 30 }
for k, v in next, t do
    print(k, v)
end

-- 遍历链表的迭代器
function traverse (list)
    return function (list, node)
        if node then
            return node.next
        else
            return list
        end
    end, list, nil
end

function createList ()
    local list = nil
    for line in io.lines() do
        if string.find(line, "\n") == nil then
        	list = { value = line, next = list }
        end
    end
    return list
end
    
function printList (list)
    for node in traverse(list) do
        print(node.value)
    end
end

printList(createList())

```

#### 具有复杂状态的迭代器

* 把所有状态放到 table 里，存成 恒定状态
  * 通常可以忽略控制变量
* 尽量使用 无状态迭代器 （状态都存在 for 里）
* 其次就是 闭包，优雅
  * 创建一个闭包比创建一个 table 更快
  * 访问 非局部变量 也比 访问 table 字段快
* 协同程序（coroutine）也可以写迭代器

```lua
function allwords ()
    local state = { line = io.read(), pos = 1 }
    return function (state)
        while state.line do
            local s, e = string.find(state.line, "%w+", state.pos)
            if s then
                state.pos = e + 1
                return string.sub(state.line, s, e)
            else
                state.line = io.read()
                state.pos = 1
            end
        end
        return nil
    end, state
end

for word in allwords() do print(word) end
```

#### 真正的迭代器

* 以上的迭代器，并没有做实际的迭代，实际做迭代的 时 for 循环
* 而迭代器只是为每次迭代提供一些成功后的返回值（应该叫 **生成器 generator**）
  * 生成器 更灵活
    * 允许多个并行的迭代过程
    * 允许在迭代体中使用 break 和 return 语句
* 真正意义上的迭代器
  * 做实际的迭代操作，无需循环
  * 迭代器接受一个函数作为参数，并在其内部循环中调用该函数
  * 开销和生成器差不多
    * 每次迭代都有一次函数调用
  * 比较容易编写
    * 协同程序编写迭代器更容易

```lua
function allwords (f)
    for line in io.lines() do
        for word in string.gmatch(line, "%w+") do f(word) end
    end
end

allwords(print) -- 直接把单词都打印出来

do -- 统计单词 hello 出现了几次
    local count = 0
    allwords(function (w)
    	if w == "hello" then count = count + 1 end
    end)
    print(count)
end

do -- 用以前的迭代器风格
    local count = 0
    for w in allwords() do
    	if w == "hello" then count = count + 1 end
    end
    print(count)
end
```

### 编译、执行与错误

* 区别**解释型语言**不在于能否编译源码，而在于编译器是否是运行时的一部分
  * 是否能够轻易的执行动态生成的代码
  * 因为解释型语言也可以编译源码
* Lua 有 `dofile`、`loadfile`，所以是解释型语言

#### 编译

* `dofile` 只是辅助函数，`loadfile` 才是核心
  * 从文件加载 lua代码块，但不运行，只是编译
  * 然后将编译结果作为一个函数返回
  * `loadfile` 不会引发错误，只是返回错误值而不处理错误
    * 发生错误时，会返回 nil 以及 错误消息（可自定义处理错误）
  * `loadfile` 非常灵活
    * 自定义错误处理
    * 多次运行只需要一次编译
* `loadstring` 与 `loadfile` 类似，只不过是从字符串中读取代码
  * 开销较大
  * 难以理解的代码
  * 如果有语法错误，直接返回 nil
    * `assert(loadstring(s))()`
  * 编译时不涉及词法域，是在全局环境中编译
    * 用到的更多是全局变量，除非是在字符串代码里面定义了 `local` 变量（匿名函数）
  * `loadstring` 一般是用来执行外部代码（位于程序之外的代码）
  * `loadstirng` 期望的是一个程序块，也就是一系列语句
    * 所以一般不返回值
    * 要想返回值，对一个表达式求值，就要在前面加 `return` （构成一条语句 返回表达式的值）
* `load`：`loadstring` 和 `loadfile` 的原始函数
  * 接收一个 **读取器函数（reader function）**
  * 并在内部不断调用获取程序块（可以分几次，知道返回 nil 表示程序块结束）
  * 一般很少用到 `load`
    * 当程序块不在文件中（无法使用 `loadfile`）
    * 当程序块太大而无法放入内存（无法使用 `loadstring`）
    * 所以，`load` 是跟通用的，它们两个只是特例而已
  * `load` 不会引发错误，如果出错，只会返回 nil 以及错误消息（这也是 `loadtring` 和 `loadfile` 的特性，可以自定义处理错误）

```lua
function dofile (filename)
    local f = assert(loadfile(filename))
    return f()
end

f = loadstring("i = i and i + 1 or 0") -- 不用初始化 i = 0 了
f(); print(i) --> 1
f(); print(i) --> 2

function dostring (s)
    return assert(loadstring(s))()
end

do -- loadstring 不涉及词法域 使用的都是全局变量
    i = 32
    local i = 0
    f = loadstring("i = i + 1; print(i)")
    g = function () i = i + 1; print(i) end
    f() --> 33
    g() --> 1
end

-- loadstring 使用局部变量需要加显式的 local
i = 99
f = loadstring [[
local i = 66
print(i)
]]
f() --> 66
print(i) --> 99

i = 99
dostring [[
local i = 66
print(i)
]] --> 66
print(i) --> 99

-- loadstring 表达式求值
i = 1
=dostring "i = i + 1" --> i = 2 了但啥都不会返回
=dostring "return i + 1" --> 3
```

* 程序块可以看成  **具有变长实参的匿名函数**
  * 所以在程序块中，可以定义局部变量，并且使用局部变量
* 加载代码块的误解：加载就是定义
  * 加载不是定义，加载只是编译，运行才是定义
  * 函数定义是一种赋值操作，是运行时才完成的操作，而不是编译时的操作
* 执行外部代码要注意的
  * 妥善处理加载程序块时报告的任何错误
  * 可能还会在一个保护的环境中执行代码（不可信任的代码）

```lua
loadstring "a = 1"
-- 等价于
function (...) a = 1 end

print(loadstring("i")) --> nil     [string "i"]:1: '=' expected near '<eof>'

-- 加载不是定义，加载只是编译，运行才是定义
-- foo.lua
function foo (x) print(x) end
-- foo.lua

f = loadfile("foo.lua") -- 完成编译 但还没有定义
f() -- 定义 foo
foo("ok") --> ok

```

#### C代码

* C代码需要在使用前先链接入一个应用程序（动态链接机制）
  * 但不是 ANSI C 标准的一部分（不可移植）
* Lua一般会严格按照标准 C，除了动态链接
  * 所有其它机制的母机制
  * 为几种平台实现了动态链接：`package.loadlib`
* `package.loadlib`
  * 加载指定库，链接入 Lua
  * 如果成功，将一个 C 函数 作为 Lua 函数返回
  * 如果失败：返回 nil 以及一条错误信息
  * 必须提供库的完整路径以及正确的函数名称
    * 有的编译前会在库函数前加下划线，则加载库时也要包含
* 通常使用 `require` 加载 C 程序库
  * 搜索指定的库
  * 然后用 `loadlib` 加载，并返回初始化函数
  * 初始化函数将库中的函数注册到 Lua 中（就好像用 lua 代码定义的一样）

```lua
--[[
检查该平台是否有动态链接
第一个参数：动态库的完整路径
第二个参数：函数名称
如果有动态链接：找不到指定的模块
如果没有动态链接：不支持或未安装该机制
]]
print(package.loadlib("a", "b"))
```

#### 错误（error）

* 可以通过修改 **元表（metatable）** 让错误的操作合法化

```lua
-- error 函数
print "enter a number: "
n = io.read("*number")
if not n then error("invalid input") end

--[[
assert：if not <condition> then error end 的封装
第一个参数为 true，则返回该参数，否则引发一个错误
第二个参数：错误的信息，可选，默认为 assertion failed! 或者 第一个表达式的第二个结果（错误的信息提示）
]]
print "enter a number: "
n = assert(io.read("*number"), "invalid input")
```

* 当函数碰到了个异常情况
  1. 返回错误代码（通常是 nil）
     * 如果不能在之前就检查到错误
  2. 引发一个错误（调用 error）
     * 如果能在之前就可以轻易检测到错误

#### 错误处理原则（通用）

* 可以提前避免的，应该提前避免，否则**报错**
  * math.sin 就得提前检测 x 为数字
  * 如果参数还不是个数字（异常情况），可能就是程序出了问题，就应该报错
  * 一般能提前避免的，也不需要特别的错误检查和处理（程序会自动报出来）
* 不能提前避免的：**返回错误代码**（errCode 和 errMsg）
  * io.open 没办法提前知道一个文件是否存在，唯一的方式就是打开它
* 当然最重要的就是**根据实际**应用场景
* 错误处理的原则：**防呆不防傻**

```lua
do
    local file, msg
    repeat
        print("enter a file name: ")
        local name = io.read()
        if not name then return end
        file, msg = assert(io.open(name, "r"))
        if not file then print(msg) end
    until file
end
```

#### 错误处理与异常

* 一般无需在Lua代码中做错误处理：应用程序本身会处理
  * 所有Lua的活动都是基于应用程序的一次调用（如要求Lua执行一个程序块）
  * 如果发生了错误，此调用会返回错误码，程序就可以处理了
  * 如在解释器程序发生错误，主循环会打印错误信息，然后继续显示提示符
* 如果要在 Lua 代码中处理错误：用 `pcall` 函数调用（捕捉错误）
  * `pcall` 意思就是 受保护的调用（protected call）
  * 会以一种 保护模式（protected mode）来调用它的第一个参数（因此可以捕捉错误）
  * 没有错误：返回 true 以及 函数调用的返回值
  * 存在错误：返回 false 以及 错误消息
    * 错误消息不一定是字符串，任何类型的值都可以（也有可能是table）
      * 错误消息就是传递给 `error` 的值
      * 如果错误消息是字符串，Lua还会附加一些关于错误发生位置的信息（文件名:行号:错误消息）
* 用 `error` 抛出异常，用 `pcall` 捕捉异常

```lua
res = { pcall(function () error("错误") end) }
if res[1] then
    print("没有错误，函数返回：", res[2])
else -- 处理错误
    print("存在错误：", res[2])
end -- 存在错误：      stdin:1: 错误
```

#### 错误消息与追溯（traceback）

* error 函数的特性
  * 第一个参数：错误消息
    * 如果是字符串的话 会加上 `文件名:行号:错误消息`
  * 第二个参数：level（层，可选参数）
    * 应由调用层级中的那一层函数报告当前错误（为错误负责，错误的正确归因）
* error - pcall  的组合只能获取错误的位置，还需要更多的调试信息（如函数调用栈）
  * pcall 返回错误消息时，会销毁调用栈的部分内容（从 pcall 到错误发生点的这部分调用）
* `xpcall`：比 pcall 多了个参数，一个错误处理函数
  * 错误发生时，在调用 **栈展开（unwind）** 前调用错误处理函数
  * 错误处理函数中，可以调用 debug 库来获取错误的更多信息
* **debug 库**
  * `debug.debug`：提供 Lua 提示符，让用户自行检查错误原因
  * `debug.traceback`：根据调用栈构建一个扩展的错误消息（解释器程序用的这个）
    * 也可以在任何时候用该函数获取 当前执行的调用栈

```lua
function f (s)
    if type(s) ~= "string" then
        error("string expected", 2) -- 错误在第二层（第一层是读函数）
     end
end

-- 默认 stdin:3: string expected
-- 2 stdin:1: string expected
f({ x = 1 })

print(debug.traceback())
--[[
stack traceback:
        stdin:1: in main chunk
        [C]: ?
]]
```



