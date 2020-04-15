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

