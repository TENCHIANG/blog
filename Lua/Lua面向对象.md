## Lua 面向对象

* Lua 用 table 表实现面向对象
* 两个具有相同值的对象不是同一个对象
* 一个对象可以具有多个不同的值
* 对象拥有独立的生命周期（与创建者和创建位置无关）（堆而不是栈）

### self 或 this

* 独立的生命周期

```lua
-- 冒号操作符隐藏 self 的定义和传入（也是方法的定义和调用）
Account = {}
function Account:winthdraw (v)
    self.balance = self.balance - v
end
Account:winthdraw(v)
```

### 类（class）、原型（prototype）

* 共同点
  * 实现面向对象
  * 创建具有多个相似行为的对象
* 不同点
  * 类：对象是类的实例
  * 原型：对象不属于类，但对象有原型，原型也是普通对象
    * 对象先查找自身，找不到再去原型找（包括方法和字段）
    * 如果有多个原型，就是**原型链**
* Lua 使用**元表**实现原型（用元表的 __index 元方法）
  * Lua 元表与类相似，但不要完全把元表当作类使用（后期的麻烦）
  * __index 在多继承的场景下，可以是一个方法
  * 不要修改原型上的东西，最好现在自身拷贝一份原型上的东西再去修改 `o.v = o.v`

```lua
-- B是A的原型
-- A是B的实例 B是A的类
-- A继承了B
-- 返回第一个参数A
setmetatable(A, { __index = B })

function Account:new (o)
	o = o or {}
    self.__index = self -- 把实例的元表设置为自己
    return setmetatable(o, self)
end
```
### 继承 Inheritance

* 用原型实现类之间的继承
  * 但是在原型里面，因为类和对象是等价的一样的东西，所以继承也可以说是类（原型）和对象（实例）之间的继承

```lua
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

function Account:new (o)
	o = o or {}
	self.__index = self
	return setmetatable(o, self) -- 把self本身作为元表
end

a = Account:new { balance = 2 }

print(Account:getBalance()) -- 0
print(a:getBalance()) -- 2

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

* 多继承就是一个类有多个父类或超类
* Lua 是用类的元表字段 __index 作为方法来实现多继承
  * 一般把创建新类写成一个单独的函数
  * 虽然是多重继承，但是每个实例仍然属于一个类

```lua
-- 公共的构造方法
function commNew (self, o)
	if self.__index ~= self then -- 把self本身作为元表
		self.__index = self
	end
	return setmetatable(o or {}, self)
end

-- 多重继承 创造新类
function createClass (...)
	local c = {} -- 新类（实例元表）
	local parents = {...} -- 父类们（类的元表）
	
	setmetatable(c, {__index = function (t, k)
		for i = 1, #parents do -- 在超类中找 k
            -- 尝试第i个超类有没有 k
            -- 疑问：如果没有会去找超类的原型吗
			local v = parents[i][k]
			if v then
                -- 把继承的东东缓存到子类中（提高性能）
                -- 但是再要修改父类的定义会继承不下来（不一致）
				t[k] = v
				return v
			end
		end
	end})
	
	-- 为新类定义构造函数
	-- 将新类本身作为其实例的元表
	function c:new (o)
		return commNew(self, o)
	end
	
	return c -- 返回新类
end

-- 测试2：超类能否继续往上搜原型
SuperPlus = {}
SuperPlus.x = "SuperPlus"

function SuperPlus:new (o)
	return commNew(self, o)
end

-- 超类 Account 又继承了另外一个超类 SuperPlus
Account = SuperPlus:new()

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

-- 测试1：在多继承下：一个类同时成为其实例和子类的元表
function Account:new (o)
	return commNew(self, o)
end

a = Account:new { balance = 2 }

print(Account:getBalance()) -- 0
print(a:getBalance()) -- 2

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

print(account:getName(), account.balance, account.x)

--[[
getName搜索顺序：
1. account.getName 没找到
2. account.__index.getName 也就是 NamedAccount.getName 没找到
3. NamedAccount.__index 是函数
	1. 找第一个超类 Account.getName 没找到
	2. 找第一个超类的元表 Account.__index.getName 也就是 SuperPlus.getName 没找到 到头了 SuperPlus 没有元表了
	3. 找第二个超类 Named.getName 找到了！缓存 getName 到 NamedAccount 类
]]
```

* 总结就是：找不到，就找元表的 __index
  * 为 table：找 table 里面又没，没有就继续找 table 的 __index
  * 为 方法：调用方法
* 一个类可以同时是其实例和子类的元表，且超类找不到还可以再找超超类
  * 经测试，无论是单继承还是多继承，也不管继承的深度，都是如此

```lua
-- grandpaClass.lua

function commNew (self, o)
	self.__index = self
	return setmetatable(o or {}, self)
end

A = { a = "a" }
function A:new (o) return commNew(self, o) end

B = A:new { b = "b" }
function B:new (o) return commNew(self, o) end

C = B:new { c = "c" }
function C:new (o) return commNew(self, o) end

c = C:new()
print(c.a, c.b, c.c)

-- 在单继承下：一个类同时成为其实例和子类的元表
b = B:new()
print(b.a, b.b, b.c)

a = A:new()
print(a.a, a.b, a.c)
```

### 私有性 Privacy

* 每个对象的状态都应该由它自己控制
* 方案一：把公有的和私有的分成两个表，私有表放在闭包里面
  * 因为用了闭包，所以 self 不需要传了，也就不需要冒号运算符了

```lua
-- objectPrivacy.lua

function newAccount (initialBalance)
	local self = { -- 私有字段
		balance = initialBalance,
		LIM = 1000,
	}
	
	local function extra () -- 私有方法
		if self.balance > self.LIM then -- 大于 LIM 值的额外额度
			return self.balance * 0.1
		else
			return 0
		end
	end
	
	local function getBalance ()
		return self.balance + extra()
	end
	
	return { -- 不返回出去的都是私有的
		withdraw = withdraw,
		deposit = deposit,
		getBalance = getBalance,
	}
end

acc = newAccount(1024)
print(acc.getBalance()) -- 1126.4
```

### 单方法对象 Single-method Object

* 对象只有一个方法
* 不用创建接口表，将这个方法以对象的表示形式返回即可
* 类似于迭代器 io.lines、string.gmatch
* 单方法对象也可以是分发方法（dispatch method）：根据不同参数完成不同任务
  * 没错，又是闭包，有函数式编程内味了
  * 闭包比起表，速度更快开销更低，也可以保持私有性，就是不能实现继承
  * 类似于 Tcl/Tk 的窗口部件：
    * 窗口部件的名称就是一个函数（wudget command）
    * 该函数可以根据它的第一个参数完成所有针对该部件的操作 

```lua
-- dispatchMethod.lua

function newObject (value)
	return function (action, v)
		if action == "get" then return value
		elseif action == "set" then value = v
		else error("invalid action") end
	end
end

d = newObject(0)
print(d("get")) -- 0
d("set", 10)
print(d("get")) -- 10
d("print") -- invalid action
```

### 对偶表示 Dual Representation

* 对偶表示也可以实现私有性
* 可以把表当作键，同时又把对象本身当作这个表的键
  * 相当于，把数据拎出来放在表里，然后只和有访问权限的表绑定起来
  * 用内存地址绑定，等于是别人不知道数据具体在哪里，从而实现了私有性
  * 重大缺陷：没法被 GC 自动回收

* 把 余额 私有化，不放在账户表里了
  * 把拎出来放在 balance 表里，然后用账户本身作为索引（绑定）
  * 只要别人访问不到 balance 表，就安全

```lua
-- dualRepresentation.lua

local balance = {}

Account = {}

function Account:withdraw (v)
	balance[self] = balance[self] - v
end

function Account:deposit (v)
	balance[self] = balance[self] + v
end

function Account:balance ()
	return balance[self]
end

function Account:new (o)
	o = o or {}
	balance[o] = 0 -- 初始余额
	self.__index = self
	return setmetatable(o, self)
end

a = Account:new()
a:deposit(100)
print(a:balance()) -- 100
```

* 对偶表示无须修改即可实现继承
* 比标准实现方式稍微慢点
  * balance[self] 比 self.balance 慢
  * 外部变量和局部变量
  * 局部变量总是会快些的，而且对于 GC，局部变量也会更快