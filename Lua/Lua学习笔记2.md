### Lua学习笔记2

### 源代码提供了文档，太香了

* 简介、编译教程：doc/readme.html
* 目录索引：doc/contents.html
* 正文：doc/manual.html

### 空字符串

```lua
print("" ~= "\0") -- true
print(#"", #"\0") -- 0       1

print(string.byte("")) -- 
print(string.byte("\0")) -- 0
```

### 可变长参数与 ipairs、pairs、table.maxn、select

* ipairs：碰到 nil 就终止
* pairs：跳过 nil（也跳过v为nil的，所以这也是对象的极限了）
* table.maxn：忽略最后一个nil（数组也会忽略最后一个nil）
* select：包括所有 nil（数组的极限）
* unpack: 展开数组，行为很**诡异**，第一个为nil一般全部不展开（所以不要指望通过unpack获取数组里所有的nil）

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

### 易错点

* 空字符串不为 false！
* 注意同名的变量！

### 再论 空隙数组

* 以前说过，但是没有深究：[table做数组]( Lua学习笔记.md#table做数组)
* **pairs 跳过 nil**
* **ipairs nil 截止**
* #等价于 table.getn（连续数组的长度）
  * 标准 lua 没有 getn 可能只是外部库
* table.maxn 返回最大的数值索引
* 显式初始化的不会出现空隙数组（除非最后一个为 nil）
  * 初始化最后一个为 nil 时，在任何情况下都会被忽略且会造成空隙数组
    * {1, 2, 3, nil} 的长度为3
  * {1, 2, 3, nil, 4} 长度为 5
  * {nil, 2, 3, nil, 4} 长度为 5
* 空隙数组的出现是定义初始化之后 跳过很多位置再添加一个元素
  * 空隙数组能够让原来不空隙的 nil 也变得空隙（不再连续）
* 总体来说空隙数组就是：有 nil 在中间，且不连续
  * 初始化时，中间插 nil，最后一个元素为 nil
  * 在连续数组最后，再隔几个插入元素（也可以是 nil 虽然不作数）
    * 这种情况在少数情况下不会产生空隙数组（长度包含初始化时的nil）

```lua
function len (list)
	print(#list, table.getn(list), table.maxn(list))
end

len({1, 2, 3, nil, 5}) -- 5 5 5
len({1, 2, 3, nil, 5, nil}) -- 3 3 5
len({nil, 2, 3, nil, 5, nil}) -- 3 3 5
len({nil, 2, 3, nil, 5}) -- 5 5 5
len({nil, 3, nil}) -- 0 0 2
len({nil, nil, nil}) -- 0 0 0
```

### some every 一次就好 和 我全都要

* 类似于 js 中 Array.prototype 的 some 和 every
* some：多次中一次就好就返回真，都为假才为假，类似 or
* every：多次中所有都得为真，只要有一次为假就为假，类似 and
* 改进之处：如果我要返回多个结果呢？
  * 用表接收多重值，然后用 unpack 把表转为多重值返回
  * 再改进：就算返回 false 我也要看函数究竟运行到了哪里（仍然返回结果）
    * 把 res 提到循环外赋值 {}
    * 把 return false 改为 return false, unpack(res)

```lua
-- 运行到返回 true 时停止
function some (n, action, ...)
    n = tonumber(n) or 3
    for i = 1, n do
        local res = { action(...) }
        if res[1] then return unpack(res) end
    end
    return false
end

-- 运行到返回 false 时停止
function every (n, action, ...)
    n = tonumber(n) or 3
    for i = 1, n do
        local res = { action(...) }
        if not res[1] then
           break
		elseif i == n then
			return unpack(res)
        end
    end
    return false
end

function iterator (list)
	local i = 1
	return function ()
        if i < table.maxn(list) then
            local res = list[i]
            i = i + 1
            return res
        end
	end
end

-- 支持 可变参数 或者 表 两种形式
-- 只支持一维数组
function iterator2 (action, ...)
	local i = 1
    local list = {...}
    if type(list[1]) == "table" then list = list[1] end
    local maxn = table.maxn(list)
	return function ()
        if i < maxn then
            local res = action(list[i])
            i = i + 1
            return res
        end
	end
end

list = {1, 2, 3, nil, 4}
length = table.maxn(list)

=some(length, iterator(list)) -- 1
=every(length, iterator(list)) -- false

=some(length, iterator2(tostring, list)) -- 1
=every(length, iterator2(tostring, list)) -- false
```

* [更规范的 some every](Lua元表和元方法.md#扩展表-map-some-every)

### 冒号运算符定义的函数怎么作为值呢

* 其实冒号运算符只是**语法糖**，本质上还是**点运算符**，使用点运算符就可以赋值啦

```lua
DG = {}
function DG:f ()
	print(self == DG)
end

DG:f() -- true

g = DG.f
--DG:g() error
g(DG) -- true
```

* “扁平化”的冒号运算符使用起来很麻烦
  * 不如再用一个函数包起来（还可以做其它额外的操作）
  * 如果每次调用嫌麻烦的话，再封装起来

```lua
-- 假设有函数 DG:f 且要传参数 true
some(3, DG.f, DG, true) -- 麻烦
some(3, function () -- 岂不美哉?
	return DG:f(true)
end)
some(3, function () -- 做其它额外的操作
	--xxx()
    local res = DG:f(true)
    --yyy()
    return res
end)
function someF (...) -- 封装起来
    return some(3, function () -- 做其它额外的操作
        --xxx()
        local res = DG:f(true)
        --yyy()
        return res
    end)
end
```

### 可变参数的坑（只能放最后）

* 要把可变参数放在最后面，否则只会截取第一个

```lua
t = {1,2,3}
print(unpack(t)) -- 1 2 3
print(unpack(t), 4) -- 1 4
print(0, unpack(t), 4) -- 0 1 4
print(0, unpack(t)) -- 0 1 2 3

--- 两点之间的距离
function distance (x1, y1, x2, y2)
	local a = math.pow(x1 - x2, 2)
	local b = math.pow(y1 - y2, 2)
	return math.floor(math.sqrt(a + b))
end

-- 常见错误
-- stdin:3: attempt to perform arithmetic on local 'y2' (a nil value)
-- 只接受了 3个 参数 123 432 657
distance(unpack { 123, 456 }, unpack { 432, 657 })

-- 正确方法
x1, y1 = unpack { 123, 456 }
x2, y2 = unpack { 432, 657 }
distance(x1, y1, x2, y2) -- 368

-- 或者干脆就不用可变参数 用表不香吗？
```

### 没有返回值的函数要谨慎

* 类似于返回 nil 但是不能完全等价
* 不能传给 tostring 因为没有任何值传进去
* 函数里有 return 不代表一定会返回值
* **无返回值函数类似 nil 但是不可以做函数参数**

```lua
function f () end

=nil or 1 -- 1
=f() or 1 -- 1

=tostring(nil) -- nil
=#tostring(nil) -- 3

=tostring() -- bad argument #1 to 'tostring' (value expected)
=tostring(f()) -- bad argument #1 to 'tostring' (value expected)
```

### for循环的变量

* for循环的变量 i 不会在循环体改变，循环体的 i 只是 for i  的副本
* 想要修改 i 的值还得用 while

### Lua 通过 io.tmpfile os.tmpname 使用临时文件

* **io.tmpfile** 返回文件句柄，以**更新模式**打开临时文件，程序结束时自动关闭文件
  * **"r+":** update mode, all previous data is preserved; 
  * **"w+":** update mode, all previous data is erased; 
  * **"a+":** append update mode, previous data is preserved, writing is only  allowed at the end of file. 
* **os.tmpname** 只是返回在 /tmp 下的临时文件名，必须手动打开和关闭
* 窘境：
  * io.tmpfile 获取不到文件名
  * os.tmpname 在安卓下读写不了 /tmp/

### 多个返回值的坑

* 作为参数，只能放在最后（否则只有一个值）
* 不能用 or 连接两个返回多个值的函数（否则只有一个值）
* 用括号包起来，只有一个值（可以理解位括号只接收一个参数）

### 注意尽量用 table.insert

* 注意尽量用 table.insert 而不是直接赋值, 因为空数组长度为0, 反复写入0号单元，导致相当于没写东西

### select 也可以用来选择返回值

* local a = select(1, f()) -- 我只选择第2个返回值

### 冒号运算符的坑

* 文件可以用冒号运算符，字符串可以用冒号运算符
* 唯独表不行，因为空表被当作了空的对象