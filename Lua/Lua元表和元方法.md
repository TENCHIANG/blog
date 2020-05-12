## Lua 元表和元方法

* 元表可以修改一个值在面对一个位置操作时的行为（重载？）
  * 如表 a + b
  * 先找它们之一有没有元表
  * 再找元表里面有没有元方法 __add
  * 如果有就调用元方法
* 元表有点像类（限制很多），定义的是实例的行为
* Lua 中的每个值都可以有元表
  * table 和 userdata 可以有**独立**的元表，其它类型值只能有**共享**的元表
  * 新建的值，除了字符串有默认的元表，其它默认没有元表
* getmetatable (object) 获取对象的元表
  * 如果没有返回 nil
  * 如果有元表
    * 包含 __metatable 字段则返回
    * 没包含则返回元表
* Lua 只能对 table 设置元表，其它类型只能用 C 代码或者 debug 库
  * 对某种类型设置其所有值都生效的元表，会导致**不可重用**的代码
  * 如覆盖了字符串的默认元表（滥用）
* **getmetatable 只能获取实例的元表（如 string）**
  * 所以元表是基于实例的，而不是基于类（有助于实例找到其类）
* **表的实例不是实例，是一个空的类**
  * 所以获取不了表实例的元表
  * 所以对表的扩展继承不到实例上去（包括标准库）
  * 只能把表实例当成一个类，在类的基础上扩展该类
  * 所以表只有类方法，静态方法，没有实例方法
* 字符串有默认元表，其它值没有
  * 字符串有默认元表，里面有个元方法 __index，用来给字符串添加方法（原型继承）
  * 参考：[Lua面向对象 类 原型](Lua面向对象.md#类class原型prototype)

```lua
s = ""
mt = getmetatable(s)
for k, v in pairs(mt) do print(k, v) end
--[[
__index table: 00A99310
]]
for k, v in pairs(mt.__index) do print(k, v) end
--[[
sub     function: 00A9ACC8
upper   function: 00A9AF48
len     function: 00A9A130
gfind   function: 00A9A0B0
rep     function: 00A9A1F0
find    function: 00A9A0D0
match   function: 00A99E90
char    function: 00A99E50
dump    function: 00A99F10
gmatch  function: 00A9A0B0
reverse function: 00A9AE88
byte    function: 00A99EB0
format  function: 00A9A050
gsub    function: 00A99E70
lower   function: 00A9A1B0
]]
```

* 给 string 添加新方法（链式调用，或实例方法）

```lua
function string:concat (str) -- 相当于 mt.__index.concat = function (self, str)
   return self..str
end
print(("a"):concat("b"):concat("c")) -- abc
```

* 给 string 添加新方法（非链式调用，类方法，静态方法）

```lua
string.concat = function (...) -- 扩展 table 也是同理
   return table.concat(each(tostring, ...), " ")
end
print(string.concat("a", "b", "c")) -- a b c
```

### 打包和拆包

* lua5.1 有拆包 unpack 却没有打包
* 实现 lua5.3 的打包和拆包

```lua
function table.unpack (t, i, j)
    i = i or 1
    j = j or #t
    if i < j then
        return t[i], table.unpack(t, i + 1, j)
    end
end

function table.pack (...)
    return {...}
end
```

### 扩展表 map some every

* 思考：
  * 如果 action 返回多个参数呢？
  * 优化尾递归

```lua
function table.map (action, ...)
	local res = {}
    local args = {...}
    for i = 1, table.maxn(args) do -- 最大限度包括 nil 参数
        res[i] = action(args[i]) -- 如果 action 也返回多个值呢
    end
    return res
end

t = table.map(tostring, 1, 2, nil, 3)
table.map(print, unpack(t))

-- 碰到 table 则拆包（支持多维数组）
function table.map (action, ...)
    local res = {}
    local args = {...}
    for i = 1, table.maxn(args) do
        -- 缺陷1：要是我就是想打印 table 的字面值怎么办呢？
        -- 缺陷2：调用 table.concat 报错
        -- invalid value (table) at index 1 in table for 'concat'
        if type(args[i]) == "table" then
            res[i] = table.map(action, unpack(args[i]))
        else
			res[i] = action(args[i])
        end
	end
    -- 缺陷：如果要传给 table.concat 的话 nil 会报错
	return #res > 0 and res or nil -- 如果没有一个返回则返回 nil
end

t = table.map(tostring, 1, 2, nil, 3)
table.map(print, t)

function table.some (action, ...)
    local res
    local args = {...}
    for i = 1, table.maxn(args) do
        if type(args[i]) == "table" then
            res = table.some(action, unpack(args[i]))
        else
            res = action(args[i])
			if res then return res end
        end
	end
    return false
end

print(table.some(function (x) return x > 0 end, 0, 0, 1))
print(table.some(function (x) return x > 0 end, 0, 0, 0))

function table.every (action, ...)
    local res
    local args = {...}
    for i = 1, table.maxn(args) do
        if type(args[i]) == "table" then
            res = table.every(action, unpack(args[i]))
        else
            res = action(args[i])
			if not res then return false end
        end
	end
    return res
end

print(table.every(function (x) return x > 0 end, 1, 1, 1))
print(table.every(function (x) return x > 0 end, 1, 1, 0))
```

* [通用型 some every（不限于 string table）](Lua学习笔记2.md#some-every-一次就好-和-我全都要)
  * 基于函数基于迭代器，传入与返回不对应（数量和类型）
  * 规范的 some every 基于值，传入什么返回什么

