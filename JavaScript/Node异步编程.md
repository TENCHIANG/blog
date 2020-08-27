### 函数式编程

* 函数式编程是 js 异步编程的基础
* 函数在 js 是一等公民：可以自由灵活的作为参数，返回值（函数是普通的值）

#### 高阶函数

* 把函数作为参数，且返回值就是所传函数的返回值（把具体做的事再抽象）
* sort、forEach、map、reduce、reduceRight、filter、every、some

#### 偏函数

* 根据参数生成一个定制函数（函数工厂？）（还可结合闭包）

```js
function after (times, func) {
    if (times <= 0) return func()
    return function () {
        if (--times < 1) return func.apply(this, arguments)
    }
}
local f = after(3, console.log)
f("Hello")
f("Hello")
f("Hello") // Hello
f("Hello") // Hello
```

### 异步编程的难点

* **异常处理**
  * try-catch 只能作用与当前 tick，而可能发生异常的 I/O 操作可能在下一个 tick
  * 所以 Node 约定，回调的第一个参数为错误，第二个参数才是结果
  * 不要对回调函数进行异常捕获

```js
try {
	process.nextTick(callback) // 抓不到
} catch (e) {
	// TODO
}

const async = callback => {
    process.nextTick(() => {
        let res = xxx
        if (err) return callback(err)
        callback(null, err)
    })
}

async((err, res) => {
    // TODO
})

// 误：回调可能会被执行两次
try {
    req.body = JSON.parse(buf, options.reviver) // 本意是想处理JSON.parse的异常
    callback() // 应该把异步移到 异常处理外面
} catch (err) {
    err.body = buf
    err.status = 400
    callback(err)
}
```

* **回调地狱**
  * 网页渲染，数据、模板、资源文件，这几个异步互相并不依赖
  * 如果用回调嵌套，就造成了先后顺序，没有利用好异步带来的并发优势

```js
fs.readdir(path.join(__dirname, '..'), (err, files) => {
    files.forEach((filename, index) => {
        fs.readFile(filename, 'utf8', (err, file) => {
        	// TODO
        })
    })
})
```

* **阻塞代码**
  * 没有 sleep 类似的线程沉睡功能，定时器并不能阻塞后面代码的运行
  * 直接用循环会持续占用 CPU，破坏了事件循环，离真正的线程沉睡差远了
  * 解决：统一规划业务逻辑 + 定时器（代码结构上去解决）

```js
// 糟糕的sleep实现
var start = new Date()
while (new Date() - start < 1000) {
	// TODO
}
// 需要阻塞的代码
```

* **多线程编程**
  * 前端：Web Worker
  * Node：child_process、cluster
* **异步转同步**

### 异步编程的解决方案

* 事件发布/订阅模式
* Promise / Deferred 模式
* 流程控制库

#### 事件发布/订阅模式

* 事件侦听器模式是将回调函数事件化
  * 将不变的封装在组件内部，将容易变化的部分通过事件暴露给外部处理（接口设计）
    * 无需关注怎么实现和状态，只关注事件本身（黑盒）
  * 也类似钩子机制（hook），利用钩子导出内部的状态或数据给外部的调用者
* Node 提供了 events 模块，比 DOM 事件更轻量
  * 没有 preventDefault、stopPropagation、stopImmediatePropagation 等控制事件传递的方法
  * 具有 addListener/on、once、removeListener、removeAllListeners、emit 等基本事件监听模式的方法
  * 可以实现一个事件可关联多个回调函数（事件侦听器）
    * 侦听器很灵活的添加和删除（解耦业务逻辑，事件不变变的是侦听器和相应的业务逻辑）
  * 发布 emit 与事件循环结合使事件订阅/发布适合异步编程
* 事件侦听器的**健壮性**处理
  * 一个事件超过 10 个侦听器会警告，可能会内存泄漏、CPU 占用过多（Node 单线程有关），emitter.setMaxListeners(0) 可取消该警告
  * 如果 EventEmitter 实例没有对 error 事件做处理，那么发生真的 error 事件会导致**线程退出**

```js
emitter.on("event1", message => console.log(message)) // 订阅
emitter.emit('event1', "I am message!") // 发布
```

* 继承 events 模块

```JS
const events = require("events")

function Stream () {
    events.EventEmitter.call(this)
}
util.inherits(Stream, events.EventEmitter)
```

* 事件队列解决缓存雪崩
  * 缓存雪崩是高访问量、大并发下的缓存失效，大量请求涌入数据库，导致服务器响应速度变慢
  * 利用 once 方法，过滤重复性事件相应，侦听器只执行一次即移除
  * once 配合事件队列，保证每个回调只被执行一次（如数据库查询），一次成功后结果就可公用（缓存）

```js
let proxy = new events.EventEmitter()
let status = "ready"
let select = callback => {
    proxy.once("selected", callback)
    if (status == "ready") {
        status = "pending"
        db.select("SQL", res => {
            proxy.emit("selected", res)
            status = "ready"
        })
    }
}
```

* 多异步间协作
  * 事件与侦听器一般是一对多，但也会出现多对一的情况（如前面的回调地狱，需要多个异步事件促成一个回调）
  * 所以避免嵌套，计数即可
  * EventProxy.all 所有事件都触发才执行回调（只触发一次且不论次数）
  * EventProxy.tail 所有事件都出发时执行回调，之后任何时间刷新会再执行回调

```js
// 方案一、构造计数函数，缺点：要手动调用done函数
fs.readFile(template_path, "utf8", (err, template) => done("template", template))
db.query(sql, (err, data) => done("data", data))
l10n.get((err, resources) => done("resources", resources))
const after = (times, callback) => { // 数到times只执行一次
    let count = 0, res = {}
    return (key, val) => {
        res[key] = val
        if (++count == times) callback(res)
    }
}
const done = after(times, render)

// 方案二、利用一个事件绑定多个侦听器把done做成事件（多对多）
const emitter = new events.Emitter()
const done = after(times, render)
emitter.on("done", done)
emitter.on("done", other)
fs.readFile(template_path, "utf8", (err, template) => emitter.emit("done", "template", template))
db.query(sql, (err, data) => emitter.emit("done", "data", data))
l10n.get((err, resources) => emitter.emit("done", "resources", resources))

// 方案三、利用EventProxy
const proxy = new EventProxy()
proxy.all("templete", "data", "resources", (err, templete) => {})
fs.readFile(template_path, "utf8", (err, template) => proxy.emit("template", template))
db.query(sql, (err, data) => proxy.emit("data", data))
l10n.get((err, resources) => proxy.emit("resources", resources))
```

