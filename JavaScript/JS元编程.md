### meta-programming

* meta 源于希腊文，原本有，之后（After）、超越（Beyond）之意
* 也衍生出其他意义如，关于（About）
* metadata，元数据，关于数据的数据，data about data
  * 表格用来保存数据，而表格中各字段是什么类型等描述，就是元数据
* meta-programming，元编程，与程序设计有关的程序设计
  * 不同于静态的 data，programming 是动态的
  * 元编程的程序设计，能够影响别的程序设计
* 通过编程的手段，能够查看程序行为、影响程序行为、甚至修改语言默认行为

### 查看程序行为

#### 对象属性检测

* 如果不管属性是不是属于本身，参考 [Falsy Family](ES6笔记.md#Falsy-Family)
  * in、hasOwnPropert 比 typeof、void 0 好，可以检测本身为 undefined 的属性
* 否则，应用 hasOwnProperty，进一步缩小范围

#### 键值对列表

* for-in 只能访问本身的、继承来（原型链）的，可枚举（enumerable）的属性
* propertyIsEnumerable 方法，属性可枚举或不存在，返回真
* Object.keys，**本身且可枚举**的属性名
  * Object.values，属性值
  * Object.entries，[键, 值]
* Object.getOwnPropertNames 实例本身的**全部**属性名
* Object.getOwnPropertySymbols 本身的**全部**符号属性名

```js
Object.getOwnPropertyNames(Array.prototype);
/*[
  'length',      'constructor',    'concat',
  'copyWithin',  'fill',           'find',
  'findIndex',   'lastIndexOf',    'pop',
  'push',        'reverse',        'shift',
  'unshift',     'slice',          'sort',
  'splice',      'includes',       'indexOf',
  'join',        'keys',           'entries',
  'values',      'forEach',        'filter',
  'flat',        'flatMap',        'map',
  'every',       'some',           'reduce',
  'reduceRight', 'toLocaleString', 'toString'
]*/
Object.getOwnPropertySymbols(Array.prototype);
// [ Symbol(Symbol.iterator), Symbol(Symbol.unscopables) ]
```

#### 属性顺序

* EnumerateObjectProperties，只能从实例本身及其原型，取得可枚举属性
  * 如 for-in，但没有规范顺序，故每个引擎都可以不一样
* **[[OwnPropertyKeys]]**，规范了如何取得自身属性（包括不可枚举），同时**规范了顺序**
  * 优先数字 > 属性创建的顺序 > 符号创建的顺序
  * getOwnPropertyNames、getOwnPropertySymbols、Reflect.ownKeys

```js
function getOwnPropertiesOrder(o) { // 按顺序返回自身可枚举属性 否则返回 null
    Object.getOwnPropertyNames(o)
        .filter(k => o.propertyIsEnumerable(k))
    	.map(k => [k, o[k]]) || null;
}
```

#### 对象类型

* 动态语言，针对行为编程
* 若要检测 API，一般检测属性（Feature detection）
* 若要检测类型
* typeof：基本类型、函数、undefined、Function 实例，但对于对象就很模糊了
* instanceof：继承关系（原型链）、实例关系
* **Symbol.hasInstance** 类的 static 方法，自定义 instanceof
  * 调用右边类的 Symbol.hasInstance 方法
  * instanceof 会将左操作数，作参数传入
  * 返回值的真假作为 instanceof 的结果
  * 默认为 Function.prototpe 上的，为原型链查找，符合传统

```js
class ArrayLike {
    constructor() {
        Object.defineProperty(this, "length", { value: 0, writable: true });
    }
    static [Symbol.hasInstance](instance) { return "length" in instance; }
}
```

* constructor，实例的 constructor 属性，本质是类（构造函数）原型的属性
* Object.prototype.toString，返回格式为 [object class]
  * class 为具体类名：Object、Array、Function
  * 内部根据匿名属性 **[[Class]]** 判断
  * 注意，跟实例上的 toString 不一样
    * 实例上的 toString，一般指向最近的，具体类的原型
    * 如 Array，指向的是 Array.prototype 上的，默认为调用 join
  * 可以通过 **Symbol.toStringTag** 属性，修改 class 部分的值

```js
Object.prototype[Symbol.toStringTag] = "对象"; // 默认没有
({}).toString(); // [object 对象]
```

* Array.isArray 判断是否是“真”数组，而不是修改原型链的类数组
  * 通过类语法继承的 Array 的类，会继承其一切特性，算是真数组了
  * 内部根据匿名属性 **[[Class]]** 判断
  * ES6 前，通过调用 Object.prototype.toString 来实现 isArray
* Symbol.species，静态属性（static get）
  * 子类继承了父类，继承的方法，返回的还是子类
  * Symbol.species 可指定类，直接返回想要的类型即可

```js
class MyArray1 extends Array {}
class MyArray2 extends Array {
    static get [Symbol.species]() { return Array; }
}
new MyArray1(1, 2, 3).map(e => e); // MyArray1(3) [ 1, 2, 3 ]
new MyArray2(1, 2, 3).map(e => e); // [ 1, 2, 3 ]

// 内部类似于
class Immutable {
    slice(begin, end) {
        let res = Array.from(this).slice(begin, end);
        return new this.constructor[Symbol.species](...res);
    }
    static get [Symbol.species]() { return this; }
}
```

####  对象想等性

* \==、===、SameValue、SameValueZero
* ===
  * +0 等于 0、+0 等于 -0
  * NaN 不等于 NaN（对比不了 --- 区分不了）
  * switch、indexOf、lastIndexOf、includes
* SamValue，相似才相等
  * +0 等于 0（本身就等于）
  * +0 不等于 -0
  * NaN 等于 NaN（区分的了 --- 找得到 --- 去的了重）
  * Object.is、Object 的 defineProperty、defineProperties
* SameValueZero，相似才相等，除了零
  * Set、Map、对象的属性名

### Reflect

* 内部方法（Internal method）：[[SetPrototypeOf]]、[[isExtensible]]、[[OwnPropertyKey]]
* Reflect 用来管理语言的内部方法
  * 代替 Object
  * 进阶函数控制
  * 运算符对应函数
* Reflect 与 Proxy 的方法一一对应，以便内部代理
* apply、get、set
* getOwnPropertyDescriptor、defineProperty、ownKeys
* construct、deleteProperty、has
* isExtensible、preventExtensible
* getPrototypeOf、setPrototypeOf

#### 代替 Object

* Reflect 可完全代替 Object 上的方法，但又略有不同
  * Object 有的会返回对象本身，Reflect 返回布尔值
  * Object 会自动包裹基本类型，Reflect 不会（非对象则报错）

```js
Object.getOwnPropertyDescriptor("111", "length");
// { value: 3, writable: false, enumerable: false, configurable: false }
Reflect.getOwnPropertyDescriptor("111", "length");
/*
Uncaught TypeError: Reflect.getOwnPropertyDescriptor called on non-object
    at Object.getOwnPropertyDescriptor (<anonymous>)
*/
```

* Reflect 化，这是趋势，已经有 Reflect 有，而 Object 没有的方法了
  * Reflect.ownKeys = Object.getOwnPropertyNames + getOwnPropertySymbols
  * 返回对象本身的全部属性（包括不可列举、符号属性）

```js
Reflect.ownKeys(Array.prototype).length; // 35
Object.getOwnPropertyNames(Array.prototype).length; // 33
Object.getOwnPropertySymbols(Array.prototype).length; // 2
```

#### 进阶函数控制 apply get set

* **Reflect.apply**（无 call、bind）：控制函数中的 this：代替 apply、call、bind
  * 使用函数实例的 apply、call、bind，源于 Function.prototype
  * 所以隐含了一个假设，就是实例本身没有定义同名的函数
  * 更严格的形式是：`Function.prototype.apply.apply(f, [self, args])`，但不好理解
  * 可以用 `Reflect.apply(f, slef, args)`，无同名问题，也符合直觉
* 面向对象中
  * 对象：信息接收者
  * 属性：信息
  * this 可以变：接收者可以变
* **Reflect.get**、**Reflect.set**
  * 参数一：对象
  * 参数二：对象的属性，无则返回 undefined
  * 参数三：属性的 this（可选，若属性是函数的话）
  * 可间接访问对象的 getter、setter
    * 代替 Object.getOwnPropertyDescriptor(o, k).get、set
  * 也可用来存取对象的属性，访问的是内部的 [[GET]]、[[SET]] 方法

```js
var o = {
    x: 10,
    get doubleX() { return this.x * 2; }
};
o.doubleX; // 10 * 2 ---> 20
var getter = Object.getOwnPropertyDescriptor(o, "doubleX").get;
getter.apply({x: 20}); // 20 * 2 ---> 40

Reflect.get(o, "doubleX"); // 20
Reflect.get(o, "doubleX", {x: 20}); // 40

Reflect.get(Array, "of"); // [Function: of]
```

#### 运算符对应函数 has deleteProperty construct

* Reflect.has ---> in
* Reflect.deleteProperty ---> delete
  * 严格模式不会报错
* Reflect.construct---> new
  * 参数一：指定构造函数（保证会执行）
  * 参数二：参数数组
  * 参数三：指定实际构造函数 new.target
    * 实例的 \__proto__ 指向 new.target.prototype
    * 会确实的执行参数一的构造函数
  * Object.create：只是单纯的建立 Object 实例，然后改变其原型

```js
function C1() { console.log(new.target, this); }
function C2() {}
var a = Reflect.construct(C1, []); // 打印 [Function: C1] C1 {}
var b = Reflect.construct(C1, [], C2); // 打印 [Function: C1] C2 {}
a; // C1 {}
b; // C2 {}
a.__proto__ === C1.prototype;
b.__proto__ === C2.prototype;

class ArrayLike {
    constructor() {
        console.log("constructor");
        Reflect.defineProperty(this, "length", { value: 0, writable: true });
    }
    static [Symbol.hasInstance](instance) {
        return Reflect.has(instance, "length");
    }
}
var a = Reflect.construct(ArrayLike, [], Array); // constructor
var b = Object.create(Array.prototype);
a; // Array {}
b; // Array {}
a.push(1);
b.push(1);
a; // Array { '0': 1 } 确实运行了参数一的构造函数
b; // Array { '0': 1, length: 1 }
```

### Proxy

* 代替 getter、setter
  * 数组监听不到
  * 没有对象建立权（代码不可修改）
  * 难以重用
* Proxy 构造函数（两个参数都要指定）
  * 参数一：目标对象，[[Target]]
  * 参数二：handle 处理器对象，[[Handler]]
  * 返回，新增的 Proxy 实例，原对象不影响
    * 在不影响原功能的情况下，做一些别的操作
    * **针对所有属性**
* 操作 Proxy 实例时
  * 会捕捉（Trap）信号
  * 并调用处理器上对应的方法
  * Proxy 处理器的方法，与 Reflect 的方法一一对应
    * get，receiver 默认都是 target

```js
var a = [1, 2, 3];
var p = new Proxy(a, { // 代理一切 get、set
    get(target, prop, reveiver) {
        console.log("get", target, prop);
        return Reflect.get(target, prop);
    },
    set(target, prop, value, reveiver) {
        console.log("set", target, prop, value);
        return Reflect.set(target, prop, value);
	}
});

a[0]; // 1 原对象不影响
p; // Proxy [ [ 1, 2, 3 ], { get: [Function: get], set: [Function: set] } ]
p[0]; // get [ 1, 2, 3 ] 0 [ 1, 2, 3 ] \n 1
p[1] = 2; // set [ 1, 2, 3 ] 1 2 [ 1, 2, 3 ] \n 2
p.push(4);
/*
get [ 1, 2, 3 ] push [ 1, 2, 3 ]
get [ 1, 2, 3 ] length [ 1, 2, 3 ]
set [ 1, 2, 3 ] 3 4 [ 1, 2, 3 ]
set [ 1, 2, 3, 4 ] length 4 [ 1, 2, 3, 4 ]
4
*/
```

* 代理如果与原来的行为差别太大，则报错 TypeError
  * 本来返回 true，代理返回 false
  * 本来是常量（不可写），返回另外的值

```js
var p = new Proxy([], {
    deleteProperty(...args) {
        Reflect.deleteProperty(...args);
        return true;
    }
});
Reflect.deleteProperty(p, "0"); // true
Reflect.deleteProperty(p, "length"); // TypeError 本来应该返回 false

var XMath = {};
Reflect.defineProperty(XMath, "PI", { value: 3.14 });
var p = new Proxy(XMath, {
    get(target, prop, receiver) {
        if (prop === "PI") return 3.1415926;
        return Reflect.get(target, prop, receiver);
    }
});
p.PI; // TypeError 本来应该返回3.14
```

#### 代理的处理器方法

* 代理的处理器方法：this 指向处理器对象、接收者指向代理
* Reflect 方法：接收者指向目标对象
* 处理器若无方法，默认调用 Reflect 的对应方法
  * 指向代理的接收者，传给了 Reflect 的方法
  * 若为 Reflect.get、取出的又是函数
  * 则把取出函数的 this 绑定到代理了
* 故处理器中 get 方法
  * 若取出的属性为函数
  * 则应绑定到目标对象

```js
var obj = [];
obj.f = function(o) {
    console.log(o, this);
    return o === this;
};
var proxy = new Proxy(obj, {
    get(target, prop, receiver) {
        console.log(target, prop, receiver, this);
        return Reflect.get(target, prop, receiver);
    }
});

obj.f();
/*
undefined [f: ƒ]
false
*/
obj.f(obj);
/*
[f: ƒ] [f: ƒ]
true
*/
obj.f(proxy);
/*
Proxy{f: ƒ} [f: ƒ]
false
*/

proxy.f();
/*
[f: ƒ] "f" Proxy{f: ƒ} {get: ƒ}
undefined Proxy{f: ƒ}
*/
proxy.f(obj);
/*
[f: ƒ] "f" Proxy{f: ƒ} {get: ƒ}
[f: ƒ] Proxy{f: ƒ}
false
*/
proxy.f(proxy);
/*
[f: ƒ] "f" Proxy{f: ƒ} {get: ƒ}
Proxy{f: ƒ} Proxy{f: ƒ}
true
*/

var acct = new Account("YY", "123-4567", 1000);
var proxy = new Proxy(acct, {
    get(target, prop, receiver) {
        let propValue = Reflect.get(target, prop, receiver);
        if (propValue instanceof Function)
            return propValue.bind(target);
        return propValue;
    }
});
```

* Proxy 是 Function 和 Object 的实例
  * 但是没有 prototype
  * 所以也**不能做 instanceof 右值**
* Reflect 是个对象，非函数
  * 故不能做构造函数

```js
Proxy instanceof Function;
Proxy instanceof Object;
Proxy.__proto__ === Function.prototype;
Reflect.__proto__ === Object.prototype;
```

#### Proxy.revocable revoke

* 用法和 Proxy 构造函数一样，就是没有 new
  * 返回一个普通对象
    * proxy：代理本体
      * [[Handler]]、[[Target]]
      * [[IsRevoked]]：false
    * revoke：撤销该代理的方法
      * [[Scopes]] 闭包?
    * 都是可读可写可配置
* 已撤销的代理
  * 任何操作都是 TypeError
  * [[Handler]]、[[Target]] 都为 null
  * [[IsRevoked]] 为 true

```js
var revocable = Proxy.revocable({}, {});
revocable; // {proxy: Proxy, revoke: ƒ}
revocable.proxy.a = 1;
revocable.revoke();
revocable.proxy.a; // Uncaught TypeError: Cannot perform 'get' on a proxy that has been revoked
```

