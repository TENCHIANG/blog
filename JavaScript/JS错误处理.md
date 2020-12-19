### 什么时候 throw

* 能够提前避免的，应该提前避免，否则**报错**
  * 不能提前避免的，**返回错误代码**
  * 参考：[错误处理原则](/Lua/Lua学习笔记.md#错误处理原则通用)
* 碰到无法继续的错误时，应该主动 throw 错误
  * 让调用者有机会捕捉和处理错误
  * 好比车体框架设计，让就算撞击时，也能以一个可预测的方式崩溃

### catch

#### 只能 catch 一个

* 处理特定错误，只能先 catch
* 然后用 instanceof 来区别

#### ES10 可省略 catch 括号

* 如果在 catch 错误后，用不到错误实例
* ES10 时，可以省略括号
* 但是无法**重抛**了，所以要用于错误最终处理的地方
* 不要**私吞**错误：catch 到，啥都不做

### finally

#### finally 必在 return 前

* 只要运行了 try，finally 必会**运行在 return 前**
* 所以 finally 用来做必须做的事情（关闭、清理）

```js
function f() {
    try { 
        return 2;
    } finally {
        console.log(1);
    }
}
console.log(f());// 1 2
```

### 错误类型

* 包括 Error，一共有 **6 个**错误类型
* 其它 5 个都是 Error 的子类

#### SyntaxError

* 无法 catch
  * **解析**时而非执行时抛出
* 除非是 eval、JSON.parse
  * 执行时抛出

```js
try {
    eval("Let x = 10");
} catch ({name, message}) {
    console.log("catch", name, message); // catch SyntaxError Unexpected identifier
}
```

#### ReferenceError

* 严格模式，使用**未声明**变量时

#### TypeError

* 调用对象**不存在的方法**

#### RangeError URIError

* 调用某些 API，指定**参数有误**时
* Number 报 RangeError
  * toExponential
  * toFixed
  * toPrecision
* encodeURI、decodeURI 报 URIError

#### EvalError

* 起于 ES3，止于 ES5 标准
* 标准里没有，但基于兼容性
* 实现里有，但没有任何 API 能够报出此错了

### 自定义错误

* Error 构造函数，接收 message
* Error 实例
  * 有 name 和 message 两个属性
  * 不建议直接 console.log 实例，还会打印调用栈

#### JS 错误类型少

* JS 最初基于浏览器，可用资源有限

* ECMA 规范着重语言本身，错误类型也是如此
  * 其它环境、功能，有另外的规范
  * XMLHTTPRequest 规范
    * DOMException
    * SecurityError
  * Node.js 环境
    * AssertionError
    * SystemError
* 所以，自定义错误，是可行之道

```js
class IllegalArgumentError extends Error {
    get name() { return IllegalArgumentError.name; } // 类本身也是函数
}
class InsufficientException extends Error {
    constructor(message, balance) {
        super(message); // 默认部分
        this.balance = balance;
    }
    get name() { return InsufficientException.name; }
}
class Account {
    constructor(name, number, balance) {
        this.name = name;
        this.number = number;
        this.balance = balance;
    }
    withdraw(money) {
        if (money <= 0) throw new IllegalArgumentError("提款金额只能大于零");
        if (money > this.balance)
            throw new InsufficientException("余额不足", this.balance);
        this.balance -= money;
    }
    deposit(money) {
        if (money <= 0) throw new IllegalArgumentError("存款金额只能大于零");
        this.balance += money;
    }
}
var a = new Account("YY", "123-456", 1000);
try {
    a.withdraw(5000);
} catch (e) {
    if (e instanceof InsufficientException) {
        console.log(`${e.name}: ${e.message}`);
        console.log("当前余额:", e.balance);
    } else
        throw e;
}
```

### 堆栈追踪 Stack Trace

* Error 实例会自动搜集
* 未捕获、console.log、stack
  * 第一行 `name: message`
  * 第二行 at 错误栈，**由深及浅**
  * 错误的根源，在第一次 throw 的地方，**重抛不算**
* 规范不包含，这么处理调用栈
  * console.log 直接打印调用栈，但非标准
  * Error 实例的 stack 属性，以字符串的形式
  * Node.js 的 Error.captureStackTrace

### 生成器错误处理

* 生成器的 return、throw 方法，都会让生成器直接 done 结束迭代
  * return，value 为指定的
  * throw，value 为 undefined
* throw 方法，指定错误，在生成器函数内部抛出
  * 生成器函数必须包含 try-catch
  * 流程刚好在 try 里面
    * 初始的流程永远在函数开头
    * 所以 throw() 前必须 next()
  * 否则就是**未捕获**错误，只报错，不返回

```js
function* range(start, end) {
    try {
        for (let i = start; i < end; i++) yield i;
    } catch (e) {
        console.log(e);
    }
}
var g = range(1, 10);
console.log(g.next()); // { value: 1, done: false }
console.log(g.throw(new Error("Shit happens")));
/*
Error Shit happens
{ value: undefined, done: true }
*/
console.log(g.next()); // { value: undefined, done: true }
```

#### 自定义 throw 方法

```js
function range(start, end) {
    let i = start;
    return {
        [Symbol.iteraor]() { return this; },
        next() {
            return i < end ? {value: i++, done: false} :
            	{value: undefined, done: true};
        },
        return(value) {
            i = end;
            return {value, done: true};
        },
        throw(e) {
            if (i === start || i === end) throw e;
            i = end;
            console.log(e.message);
            return {value: undefined, done: true};
        }
    };
}
var g = range(3, 8);
console.log(g.next());
console.log(g.throw(new Error("shit")));
/*
{ value: 3, done: false }
shit
{ value: undefined, done: true }
*/
```

### 异步错误处理

* try-catch 不到异步方法，因为会到**另外的流程**
* 异步方法，可把错误作为第一个参数，传给回调，没错则为 null

```js
function randomDivided(divisor, callback) {
    setTimeout(() => {
        let n = Math.floor(Math.random() * 10);
        let err = n === 0 ? new Error("除零") : null;
        callback(err, divisor / n);
    }, 1000);
}
randomDivided(10, (err, res) => {
    if (err)
        console.log(err.message);
    else
        console.log(res);
});
```

#### Promise 异步处理

* 如果 Promise 指定任务失败，可在 then 第 2 个，或 catch 方法回调中处理
* Promise 在创建时，在任务回调中，被传进 resolve、reject 两个函数
  * 用 resolve 使任务成功，并指定结果
  * 用 reject 使任务失败，并指定错误（不一定是 Error 实例）
  * 若回调默认报错，则默认调用 reject
* 如果不捕获 Promise 错误
  * Node.js：`UnhandlePromiseRejectionWarning`
  * 浏览器：`Uncaught (in promise) xxx` 或 `Error: xxx` （指定错误实例）
* 前面失败，后面还会执行

### Promise 内部属性

* Promise 实例有两个内部属性
* [[PromiseState]] 表示状态，报错或指定 reject 才失败
* [[*PromiseResult*]] 表示结果，不会突然消失
  * 状态为 fulfilled，则是成功结果
  * 状态为 rejected，则是失败结果
* 前面的成功，其结果
  * 无相应回调：还是成功，结果不变
  * 有相应回调：还是成功，结果为其返回值，或 undefined
* 前面的失败，其结果
  * 无相应回调：还是失败，结果不变
  * 有相应回调：状态成功，结果为其返回值，或 undefined
* 若无相应回调，其状态和结果都**不会变**
  * 若有相应回调，失败会变成成功
  * 在回调内，故意报错、或返回失败 Promise，结果会失败
* 失败的原因：有错误不处理、报错、返回失败 Promise、失败的 Promise 单独出现

```js
Promise.resolve(10)
.then(v => {
    console.log(v);
    throw new Error("shit");
})
.then(
    _ => console.log(1),
    e => console.log(e.message)
)
.then(_ => {
    console.log(2);
    throw new Error("shit 2");
})
.catch(e => console.log(e.message))
.then(_ => console.log(3)); // 返回 Promise {<fulfilled>: undefined}
/*
10
shit
2
shit 2
3
*/
```

#### Promise 的 finally 方法

* ES9 提供
* 无论前面的有无错误，都执行该方法的回调
* 新建的 Promise 状态和结果默认不改变，和前面的一样
* 很像 then，和 catch 相反

### async 函数错误处理

* 没用 await：与 Promise 一致
* 用了 await：用同步方式处理

### 异步生成器错误处理

* 跟生成器一样，也有 throw 方法，可以像生成器一样处理错误
* throw 返回 Promise，也可以用 Promise 的处理错误方法，函数内部就无需 try-catch 了