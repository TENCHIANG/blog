## Lua协程

* 单进程：一个进程 + 一个主线程
* 协程为单进程非阻塞（类似 epoll 没有io等待）
* 协程只会利用单核（单核cpu利用率100%）
* 和 nodejs 很像
* **co = coroutine.create(f)** 创建协程并返回
* **status, ... = coroutine.resume(co, ...)**  启动协程并传入参数，当协程遇到 yield 时返回数据
  * 参数传给 create 那里的 f
  * 相当于 resume 在等待 yield
  * 成功返回 true 以及 yield 过来的参数
  * 失败返回 false 以及 错误信息
* **status = coroutine.status(co)** 返回协程状态
  * dead 结束
  * suspend 挂起
  * running 正在运行
* **coroutine.yield(...)** 挂起协程并返回 参数 给 resume
* **coroutine.running()** 返回正在运行的协程，如果由主线程调用则返回 nil
* **coroutine.wrap(f)** 另一种启动协程的方法

```lua
co = coroutine.create(function () -- 0
	for i = 1, math.huge do
		coroutine.yield(i) -- 2
	end
end)

for i = 1, 10 do
	print(coroutine.resume(co)) -- 1, 3
end

print("ok")

--[[
true    1
true    2
true    3
true    4
true    5
true    6
true    7
true    8
true    9
true    10
ok
]]
```

### 参考

* [lua coroutine(协程) - 戴磊笔记](http://www.daileinote.com/computer/lua/15)
* [Lua基础 coroutine —— Lua的多线程编程 - 冰尨 - 博客园](https://www.cnblogs.com/vagaband/p/4242624.html)
* [Lua 协同程序(coroutine) | 菜鸟教程](https://www.runoob.com/lua/lua-coroutine.html)