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

