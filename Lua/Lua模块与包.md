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
  * 全局变量**继承**到模块：`setmetatable(M, { __index = _G })`
    * 缺点：模块包含了所有全局变量（类 Perl）
  * 全局变量保存到**局部**变量：`local _G = _G`
    * 缺点：每次使用全局变量时要加前缀
  * 把要要用的全局变量先保存为局部变量：`local sqrt = math.sqrt`

```lua
local name = ... -- 名字根据 require 来
local M = { __index = _G }
setmetatable(M, M) -- 把全局环境继承到模块
_G[name] = M
package.loaded[name] = M -- 不用 return 模块了
setfenv(1, M) -- 环境设置为模块

function hello () -- 相当于 M.hello
    print("hello") -- 继承了全局变量
end

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
module(..., package.seeall)

-- 相当于

local name = ... -- 名字根据 require 来
local M = { __index = _G }
setmetatable(M, M) -- 把全局环境继承到模块
_G[name] = M
package.loaded[name] = M -- 不用 return 模块了
setfenv(1, M) -- 环境设置为模块
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

### 经验之谈

* 使用了 module 函数就不需要冒号运算符了
* 如果你想用全局变量（外部库或者标准库），那么你必须使用 package.seeall