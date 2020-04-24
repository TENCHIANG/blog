## Lua 面向对象

```lua

Account = {}

Account.balance = 0

function Account:withdraw (v) -- 出账
	if v > self.balance then error "余额不足" end
	self.balance = self.balance - v
end

function Account:deposit (v) -- 进账
	self.balance = self.balance + v
end

function Account:new (o)
	o = o or {}
	self.__index = self
	setmetatable(o, self) -- 把self本身作为元表
	return o
end

a = Account:new { balance = 2 }

print(Account.balance) -- 0
print(a.balance) -- 2

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

* 元表的 __index 字段还可以是方法

```lua
function createClass (...)
	local c = {} -- 新类
	local parents = {...} -- 父类列表
	
	setmetatable(c, {__index = function (t, k)
		for i = 1, #parents do -- parents 中找 k
			local v = parents[i][k] -- 尝试第 i 个超类
			if v then
				t[k] = v -- 缓存 缺点是运行后修改方法的定义就很难了
				return v
			end
		end
	end})
	
	--c.__index = c -- 将新类c作为其实例的元表
	
	function c:new (o) -- 为新类定义一个新的构造函数
		o = o or {}
		self.__index = self
		setmetatable(o, self)
		--setmetatable(o, c)
		return o
	end
	
	return c -- 返回新类
end


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

print(account:getName(), account.balance)

-- 搜索顺序 account -- （account.__index）NamedAccount -- （NamedAccount.__index是函数）Account -- Named
```

### 私有性