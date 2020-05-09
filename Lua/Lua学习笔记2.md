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

### 易错点

* 空字符串不为 false！
* 注意同名的变量！

### 再论 空隙数组

* 以前说过，但是没有深究：[table做数组]( Lua学习笔记.md#table做数组)
* pairs 跳过 nil
* ipairs nil 截止
* #等价于 table.getn（连续数组的长度）
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

```lua
function some (n, action, ...)
    n = tonumber(n) or 3
    for i = 1, n do
        if action(...) then return true end
    end
    return false
end

function every (n, action, ...)
    n = tonumber(n) or 3
    for i = 1, n do
        if not action(...) then
           break
		elseif i == n then
			return true
        end
    end
    return false
end

function iterator (list)
	local i = 1
	return function ()
		local res = list[i]
		i = i + 1
		return res
	end
end

list = {1, 2, 3, nil, 4}
length = table.maxn(list)
=some(length, iterator(list))
=every(length, iterator(list))
```

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

