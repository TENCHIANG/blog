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
* Lua 只能对table 设置元表，其它类型只能用 C 代码或者 debug 库
  * 对某种类型设置其所有值都生效的元表，会导致**不可重用**的代码
  * 如覆盖了字符串的默认元表（滥用）
* 字符串有默认元表，其它值没有
  * 字符串有默认元表，里面有个元方法 __index，用来给字符串添加方法（原型继承）
  * 参考：[Lua面向对象 类 原型](Lua面向对象.md#类class原型prototype)

```lua
s = ""
mt = getmetatable(s)
for k, v in pairs(t) do print(k, v) end
--[[
__index table: 00A99310
]]
for k, v in pairs(t.__index) do print(k, v) end
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



