### 数组静态方法

* isArray、of、from

#### Array.isArray

* 通过内部属性 **[[Class]]** 为 `'Array'` 判断
* 所以原型改为 Array 的原型没用
* extends 才有用，[[Class]] 也会被继承

```js
var o = {};
Object.setPrototypeOf(o, Array.prototype);
o instanceof Array; // true
Array.isArray(o); // false

class SubArray extends Array {}
Array.isArray(new SubArray()); // true
```

#### Array.of

* Array 构造函数不太好
  * 只传一个，是数组的长度，都是空元素
  * 传多个，才作为元素的值
  * 数组字面量很好用
* Array.of **代替**构造函数，传一个也是作为元素本身
  * 避免建立空元素
  * 空元素区别 undefined、null 元素
    * 但对空元素取值，还是为 undefined

#### Array.from

* 接收类数组、可迭代对象，返回数组

```js
class SubArray extends Array {}
SubArray.from("123"); // SubArray(3) [ '1', '2', '3' ]
```

#### 子类继承的方法 返回还是子类

* 如继承了 Array，用 of 生成的还是子类类型
* 但可用  **Symbol.species**，来控制

### 数组实例方法

* sort **排序**原数组，并返回
  * 参数一：可指定排序方式，默认为 (a, b) => a - b，**升序**
  * b - a 则为降序
* reverse **反转**原数组，并返回
* fill **填充**数组，并返回
  * 参数一：指定填充值，默认 undefined
  * 参数二：开始下标，默认 0
  * 参数三：结束下标。默认 length - 1
* Array.prototype 可以把类数组对象，当数组用
  * 一样也可自动更新 length，但又不是数组
    * instanceof、isArray 都为 false
    * arguments 同理
  * 所以，数组原型上的方法，具有通用性（维护 length）
  * 也可以直接把对象原型，设置为 Array.prototype

```js
Array(3); // [ <3 empty items> ]
Array(3).fill(0); // [ 0, 0, 0 ]

var a = Array.prototype.fill.call({ length: 3 }, 0);
a instanceof Array; // false
Array.isArray(a); // false

var o = {};
Object.setPrototypeOf(o, Array.prototype);
o.hasOwnProperty("length"); // false 继承自 Array，值为 0
o.length; // 0

o.push(3, 1, 2, 5); // 4
o; // Array { '0': 3, '1': 1, '2': 2, '3': 5, length: 4 }
o.hasOwnProperty("length"); // true

o.sort(); // Array { '0': 1, '1': 2, '2': 3, '3': 5, length: 4 }
```

* push 接受若干值，加到数组**后面**，返回新长度
* pop 移除**最后**一个元素，并返回它
* shift，反 push
* unshift，反 pop
* 在后端操作，可实现栈，先进后出
* 在后端操作，可实现队列，先进先出

```js
class Stack {
    empty() { this.length === 0; }
    push(...items) { return Array.prototype.push.apply(this, items); }
    pop() { return Array.prototype.pop.call(this); }
}
class Queue {
    empty() { this.length === 0; }
    offer(...elems) { return Array.prototype.shift.apply(this, elems); }
    poll() { return Array.prototype.unshift.call(this); }
}
```

#### 函数式风格 API

* JS 支持多范式（Paradigm）编程
  * 函数式提供：一级函数（函数作为值）
  * 无循环，用**递归**
    * 考虑边界条件（基础条件）
    * 一次只做一件事
    * 不管前面的和后面的状态
  * 不修改原值（无变量），故 sort 不算函数式 API
* indexOf 第一个找到的元素的索引，否则 -1
* lastIndexOf 最后一个找到的元素的索引，否则 -1
* includes 数组是否含有指定元素（ES7）
  * 以上对比皆为全等 ===，但**找不到 NaN**
  * 要用 Number.isNaN，**不要用全局的 isNaN**
    * 全局会有一个**转换**，相当于 `Number.isNaN(Number(n))`
    * 无法转成数字的值，都会被当成 NaN
    * 如 undefined、非数字非空字符串
  * Number.isNaN 则相当于 `n !== n`
* findIndex、find 返回符合条件的第一个**索引**、**元素**，指定比较函数（ES6）

```js
[1, NaN, 2, NaN, 3].filter(e => !Number.isNaN(e)); // [ 1, 2, 3 ]
[1, NaN, 2, NaN, 3].filter(e => e === e); // [ 1, 2, 3 ]

isNaN(undefined); // true
isNaN("a"); // true
Number.isNaN(undefined); // false
Number.isNaN("a"); // false

function isRealNaN(n) { return n !== n; } // 不等于自身的为 NaN
function indexOf(a, v, i = 0) { // 函数式 indexOf，支持查找 NaN
    if (i === a.length) return -1;
    if (a[i] === v || isRealNaN(a[i]) && isRealNaN(v)) return true;
    return indexOf(a, v, i + 1);
}
indexOf([NaN], NaN); // true

function map(array, mapper) {
    if (array.length === 0) return array;
    let head = array[0];
    let mapped = mapper(head);
    let tail = array.slice(1); // 去掉下标1开始取，不改变原数组，相当于去掉头元素
    return [mapped].concat(map(tail, mapper)); // 每次都新建并合并下一次产生的结果
}
```

* slice 复制数组
  * 参数一：起始下标，默认 0；可为负数，从 -1 开始
  * 参数二：结束下标，默认 length - 1
  * 都不指定，则是复制全部
* concat 合并数组
* every 都符合某个条件
* some 只要一个符合条件
* join 联结数组为字符串（toString）
  * 可指定**分隔符**，默认为逗号 `,`
* flat 数组降维，只降一维（ES10）
* flatMap 降维时，处理元素
  * 参数一：回调
    * 参数一：元素
    * 参数二：下标
    * 参数三：数组本身
  * **回调里还没降维**，元素是原值，回调之后才降维
  * 所以 flatMap 后面接 map
* reduce 从左到右，削减数组（为单一值）
  * 参数一：回调
    * 参数一：前面结果
    * 参数二：当前元素
    * 参数三：当前下标
    * 参数四：数组本身
    * 返回，作为下一次的结果
  * 参数二：初值
    * 默认为第一个元素，则从第二个元素开始迭代
    * 指定初值，则从第一个元素开始迭代
* reduceRight 从右到左，削减数组

```js
[1, 2, 3].join(); // '1,2,3'
[1, 2, 3].join("&"); // '1&2&3'
[[1, [2]], 3].flat(); // 只降一维
[[1, 2], 3].flatMap(x => typeof x); // [ 'object', 'number' ] 回调里 还没降维

[1, 2, 3].flatMap((...args) => console.log(args));
/*
[ 1, 0, [ 1, 2, 3 ] ]
[ 2, 1, [ 1, 2, 3 ] ]
[ 3, 2, [ 1, 2, 3 ] ]
*/
[1, 2, 3].reduce((...args) => { console.log(args); return args[0] + args[1] });
/*
[ 1, 2, 1, [ 1, 2, 3 ] ]
[ 3, 3, 2, [ 1, 2, 3 ] ]
6
*/
[1, 2, 3].reduce((...args) => { console.log(args); return args[0] + args[1] }, 0)
/*
[ 0, 1, 0, [ 1, 2, 3 ] ]
[ 1, 2, 1, [ 1, 2, 3 ] ][
[ 3, 3, 2, [ 1, 2, 3 ] ]]
6
*/
[1, 2, 3].reduce((x, y) => x >= y ? x : y); // max
[1, 2, 3].reduce((x, y) => x <= y ? x : y); // min
```

* 联结、求和是目的，消减是手段，太抽象，应该封装 reduce

```js
function sum(...values) { return values.reduce((acct, value) => acct + value); }
```

### 集合 Set

* 集合的特点：无序、不重复、无索引、无法直接取值（故无 get 方法）
* 集合构造函数，接收可迭代对象
* 集合也是可迭代对象，可以用解构、打散、余集、Array.from 转为数组
  * size 属性，取大小
  * values 方法，取迭代器
  * add 方法，加入元素
  * has 方法，是否存在指定值
  * delete 方法，删除指定值
  * clear 方法，清空集合
* 去重原理：SameValueZero
  * NaN 相等（对 NaN 去重）
  * 其它用 ===，故**对象不去重**
  * 因为每个对象都是不同的，数组同理

```js
var set = new Set("112323")
set.size; // 3
set; // Set(3) { '1', '2', '3' }
[...set]; // [ '1', '2', '3' ]
set.values(); // [Set Iterator] { '1', '2', '3' }

var set = new Set();
set.add({}); // set.add({})
set.add({}); // Set(2) { {}, {} }
```

#### Equality Comparison Algorithm

* 相等比较算法

* ==：The **Abstract** Equality Comparison Algorithm

* ===：The **Strict** Equality Comparison Algorithm

  * 零相等、NaN 不相等
  * +0 等于 0、+0 等于 -0、NaN 不等于 NaN

* SameValue：**字面相同则相等**

  * NaN 等于 NaN
  * 0 等于 +0、+0 不等于 -0

  * Object.is、Object.defineProperty、Object.defineProperties

* SameValueZero，**字面相同则相等（除了零）**

  * NaN 等于 NaN（对 NaN 去重）
  * 0 等于 +0、+0 等于 -0

  * 集合的值、对象、Map 的键

```js
Object.is(+0, -0); // false
Object.is(NaN, NaN); // true

var set = new Set();
set.add(NaN); // Set(1) { NaN }
set.add(NaN); // Set(1) { NaN }
```

#### WeakSet

* **只能存对象**，不能存基本类型、undefined、null、NaN
* WeakSet 里面的对象，**会被垃圾回收**
  * 防止 Memory leak 内存泄漏
  * 因此无法迭代、没有 size 属性
  * 只有 add、has、delete 方法

### 映射 Map

* 键值对的映射
* 键可以是：基本类型、undefined、NaN、null、对象
  * 对键去重：SameValueZero（对 NaN 去重）
  * 对象的键也是如此
* Map 构造方法：接收可迭代对象
  * 每个元素也都是可迭代对象 `[key, value]`
  * Map 本身也可迭代，每次迭代的是 `[key, value]`
* has 是否包含指定**键**，默认指定 undefined
* clear 清空
* keys 所有键
* values 所有值
* entries 所有键值
* size 属性，键值对**数量**
* get 指定键返回值，默认返回 size 属性值
* set 指定键设置值，可以覆盖，默认都为 undefined，返回 Map 本身
* delete 指定键删除键值对，成功 true，失败 false
* forEach 方法
  * 参数一，值
  * 参数二，键
  * 参数三，映射本身
* Object.fromEntries 创建对象
  * 指定 Map
  * 指定可迭代对象（同 Map 构造方法）

```js
var map = new Map([["a", 1], [undefined, 2]]);
map; // Map(2) { 'a' => 1, undefined => 2 }
map.forEach(console.log);
/*
1 a Map(2) { 'a' => 1, undefined => 2 }
2 undefined Map(2) { 'a' => 1, undefined => 2 }
*/
```

#### WeakMap

* 只能用对象作为键（除了 null）
* 键对象会被垃圾回收，对应值也会被删除
* 无法迭代、无 size 属性，只有 delete、get、has、set 方法
* 可用 WeakMap 模拟私有属性
  * 以类实例作为键，管理其属性
  * 若类的实例没被其它引用，则垃圾回收该实例
  * WeakMap 管理的属性，自然也被回收

```js
const privates = new WeakMap();
class Account {
    constructor(name, number, balance) {
        privates.set(this, {name, number, balance});
    }
    get name() { return privates.get(this).name; }
    // ...
}
```

### 字节数组 ArrayBuffer

* 处理二进制数据
  * ArrayBuffer 构造方法，须指定其**字节长度**，填充 0
  * byteLength 属性，取其字节长度
  * slice 裁剪并创建新的
* 无法直接存取字节数组，只能通过 TypedArray 或 DataView

#### 类型数组 TypedArray

* 类型数组是泛指
  * Int8Array、Int16Array、Int32Array
  * Uint8Array、Uint8ClampedArray（超过 0 ~ 255 会置为 0 ~ 255）、Uint16Array、Uint32Array
  * Float32array，Float64Array

* TypedArray 构造方法
  * 指定字节数组实例
    * 其长度不能太少，报错  **RangeError**
    * 改类型数组，字节数组也会相应改动
  * 指定数组、类数组对象
  * 指定数字，就创建那么大的数组，填充零

```js
var buf = new ArrayBuffer(5);
var u8a = new Uint8Array(buf);
u8a[0] = 72;
u8a[1] = 101;
u8a[2] = 108;
u8a[3] = 108;
u8a[4] = 111;
String.fromCharCode.apply(null, u8a); // 'Hello' fromCharCode属于静态方法

var u8a = new Uint8Array([72, 101, 108, 108, 111]);
var u8a = new Uint8Array(Array.from("Hello").map(c => c.charCodeAt()));
```

* 实例属性
  * byteLength、length 属性，元素个数
  * buffer 属性，其 ArrayBuffer 形式
  * byteOffset 属性，字节偏移量，默认 0
  * 所以 TypedArray 既兼容数组，也兼容字节数组

#### DataView

* TypedArray、ArrayBuffer 元素长度固定（C 数组）
* DataView 元素长度，不固定（C **结构体**）
* buffer 属性，其字节数组形式
* byteLength 属性，字节长度
* byteOffset 属性，默认 0
* setXXX 方法
  * XXX 代表元素长度
  * 参数一：当前元素时的下标（index * elemSize）
  * 参数二：写入元素的值
* getXXX 方法
  * 参数一：当前元素时的下标
* 支持的类型
  * Float32、Float64
  * Int8、Int16、Int32、BigInt64
  * Uint8、Uint16、Uint32、BigUint64

```js
var buf = new ArrayBuffer(3);
var dv = new DataView(buf);
dv.setInt16(0, 72);
dv.setInt8();
```

### JSON

* JavaScript Object Notation，是一种文本数据格式
  * 2000，Douglas Crockford
  * 规范：ECMA 404、RFC 7158（废弃）、RFC 8259、[JSON](https://www.json.org/json-en.html)
* JSON 是 JS 对象字面量（literal）的子集
  * 对象字面量：键值对
  * 数组字面量：有序值
  * 一个对象字面量是一个 JSON
  * 一个 JSON 文件可不止一个 JSON
* JSON 可以无缝转为 JS 对象，反过来不行
  * 最后一个元素**无逗号**
  * 键、字符串值都用**双引号**括起来
  * 值类型：
    * 数字、true、false、null（Infinity、NaN）、字符串、数组、子 JSON（对象）
    * 不支持表达式、函数、符号等
  * 编码要用 UTF-8

#### JSON.Stringify

* 把对象转为 JSON 字符串
* 参数一：对象
* 参数二：**筛选**规则
  * 数组：属性名数组
  * 回调：接收键、值
    * 返回指定的属性值，undefined 表示排除
  * 递归顶层，键为**空字符串**，值为对象本身
  * 因为是递归访问，所以筛选规则覆盖子规则
    * 没选中的，子对象也忽略之
* 参数三：**缩进**规则，默认无缩进（空白符）、不换行
  * 数字：1 ~ 10，指定缩进空白数、自动换行
  * 字符串：自定缩进的字符串、自动换行
* 对象本身 **toJSON** 方法，返回的对象，优先转换
  * Date 原型内置了 toJSON 方法（等价 **toISOString**，console.log 同理）
    * 如 `'2020-12-20T15:08:20.353Z'`
  * 如果再 JSON.stringify 一下，就是把**字符串再转**一下
    * 如 `'"2020-12-20T15:08:20.353Z"'`
  * 事实上，Date 在 JSON 的表示就是 ISO 的字符串
    * 如 `'{"date":"2020-12-20T15:08:20.353Z"}'`

```js
var o = {
    name: "YY",
    age: 23,
    childs: [{name: "Irene", age: 11}]
};
JSON.stringify(o, ["name", "childs"]); // '{"name":"YY","childs":[{"name":"Irene"}]}'
JSON.stringify(o, (k, v) => {
    console.log(k, v);
    return (k === "age") ? undefined : v; // 忽略所有 age 属性
});
/*
 { name: 'YY', age: 23, childs: [ { name: 'Irene', age: 11 } ] }
name YY
age 23
childs [ { name: 'Irene', age: 11 } ]
0 { name: 'Irene', age: 11 }
name Irene
age 11
'{"name":"YY","childs":[{"name":"Irene"}]}'
*/
```

#### JSON.parse

* 解析 JSON 字符串为 JS 对象
* 参数一：字符串
* 参数二：**筛选**规则，接收键、值
  * 返回指定的属性值，undefined 表示排除

### 正则表达式 Regular Expression

* 1956，数学家 Stephen Kleene

