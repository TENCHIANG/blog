### 一 REPL

* Read Eval Print Loop
* _ 上一个结果
* .help 帮助
* .exit ^D 退出
* .edit 多行模式
* node -e "片段"
  * -p 显示执行结果
  * *.js 执行脚本

### 二 数据类型

* 基本类型
  * Number（IEEE754 双浮点数）
  * String
  * Boolean
  * Symbol
* 复合类型 Object （可额外有方法和属性）
  * Array（可模拟出 List、Queue、Stack）
  * Set
  * Map
* 两个特殊值
  * null 表示没有对象，所以类型还是 object
  * undefined 表示没有值，所以类型是自己

### 三 number 类型

* 各种进制的表示：默认十进制、0x 十六进制、0o 八进制（零欧）、0b 二进制
* 科学技术法
* 大数基本类型 bigint
* 数字分隔符 numberic separators（1_000、0b1010_01）

#### 字符串转 number

* Number 构造器
* parseInt 方法
* parseFloat 方法
* *后两者只支持十进制且不支持科学技术法等特性*

### 四 string 类型

* UCS-2 ---> UTF-16 一开始 JS 字符是 2 字节，后来是 4 字节，ES6 开始支持更长
  * ES5 只能通过代理对（Surrogate pair）拆分表示超过 4 字节的字符，ES6 则可以完整表示

```js
"\ud834\udd1e" // ES5
"\u{1d11e}" // ES6
```

* ES6 用 UTF-16 码元作为字符串的元素单位（4 字节）
  * 如果字符属于 4 字节，那么码元码点（字符）一一对应
  * length 及一些老 api 还是以 4 字节为单位对字符串进行处理

```js
"\u{1d11e}".length === 2
"\u{1d11e}".charAt(0) === "\ud834"
```

* ES6 则对 Unicode 编码更好的支持

```js
Array.from("\u{1d11e}").length === 1 // length的替代方案
"\u{1d11e}".codePointAt(0) === 119070 // 十进制的输出 charAt的替代方案
String.fromCodePoint(0x1d11e) // 输出对应的字符
```

* 类可以模拟数组，字符串是不可变的类数组（Array-like）

```js
let a = { [0]: 0, [1]: 1, length: 2 }
for (let i = 0; i < a.length; i++) console.log(a[i])
```

#### 字符串转义符

* \xhh 十六进制表示字符（单字节）
* \uhhhh 十六进制表示字符（双字节）
* \u{...} 十六进制表示字符（多字节）
* \0 空字符，不是空字符串

```js
"".length === 0
"\0".length === 1
"\0\0".length === 2
```

### 五 包裹对象

* 基本类型没有方法和属性但有对应的复合类型
* 包裹对象就是让基本类型具有复合类型的特征

```js
"aa".toUpperCase() === "AA"
(4096).toExponential() === "4.096e+3"
```

### 六 变量声明

* 声明：创建变量，初始化：赋值
* ES6 变量声明的 6 种方法：var、function、let、const、import、class

#### Hoisting

* var 提升：在声明前可访问（初始化为 undefined）
  * 全局内 var：提升到全局顶部（函数也可访问）
  * 函数内 var：提升到函数顶部（全局无法访问，函数内算一个小全局）
* var 可提升**可重复**声明，最后的作数
* let const 不提升**不可重复**声明（SyntaxError）
* const 声明**同时**必须初始化，let 只声明默认初始化为 undefined

#### const

* const 只是无法改变其指向，所以指向的对象本身可以改变
* 想要让 const 对象本身也冻结，要用 Object.freeze 方法

```js
function constantize(obj) {
    Object.freeze(obj);
    Object
        .keys(obj)
        .map(k => obj[k])
        .filter(v => typeof v === "object")
        .forEach(v => constantize(v));
}

const obj = { a: 1, b: 2, c: 3 };
constantize(obj);
delete obj.a; // false
obj.a = 0; // 0 实际上没改变
```

#### 块级作用域

* ES5 作用域：全局（顶层）、函数
  * ES5 只能在这两个作用域声明函数
  * 函数作用域相当于一个小的顶层作用域，所以子函数可以访问父函数的变量
* ES6 通过 let const 创建了**块级作用域**
  * 也叫词法作用域，让生命周期更可控，避免全局污染（内覆盖外，内部泄露）
  * 如函数和代码块（花括号）内部
  * try-catch 好像是伪块级作用域
  * JS 的块级作用域不同于其它语言，因为有 TDZ
* ES6 规定，块级作用域**须有花括号**，否则不是块级作用域

```js
if (true) let x = 1; // Uncaught SyntaxError: Lexical declaration cannot appear in a single-statement context
```

#### 函数与块级作用域

* 函数可以在块级作用域声明
* 函数声明类似于 var 声明，会提升到全局或函数作用域的顶部
* 应避免在块级作用域声明函数，推荐使用函数表达式
* 在严格模式下，函数声明只能在当前作用域顶层

```js
function f() { console.log('I am outside!'); }

(function () {
  if (false) {
    // 重复声明一次函数f
    function f() { console.log('I am inside!'); }
  }
  f();
}());
// Uncaught TypeError: f is not a function
// 如果为 true 则是不报错为 inside

// 块级作用域内部，优先使用函数表达式
{
  let a = 'secret';
  let f = function () {
    return a;
  };
}
```

#### Temporal Dead Zone 

* 临时死区（TDZ）：当前作用域顶部到 let const 声明处
* 排他性：变量与**整个**作用域绑定，外部重名不污染（另类提升）
* 严格性：TDZ 内，无法用**任何**操作访问（ReferenceError），包括 typeof（未声明变量返回 undefined）
* 隐蔽性：函数的头的变量是 let 的，使用默认值可能形成 TDZ
* TDZ 包括声明语句，只要还没声明完，都是 TDZ

```js
var tmp = 123;
if (true) { // let const 变量的另类提升 相当于该变量与该作用域绑定了
    tmp = "abc"; // ReferenceError
    let tmp;
}

typeof undeclared_variable // "undefined"
typeof x; // ReferenceError
let x;

function f(x = y, y = 2) { // x提前访问了y 后面又声明了y 形成TDZ
    return [x, y];
}
f(); // ReferenceError

var a = a; // 不报错 undefined
let x = x; // ReferenceError 因为TDZ包括声明语句
```

#### 总结在声明之前访问变量

* var --> undefined
* let const ---> Uncaught ReferenceError: Cannot access 'a' before initialization
* 未声明 ---> Uncaught ReferenceError: a is not defined
* 总结：var 提升可重复，let const 不提升不可重复，const 声明同时必须初始化
* 最佳实践：默认使用 const 只在确实需要改变时用 let

#### 循环与 var let const

* 函数头或循环头是父块级作用域，函数体或循环体是子块级作用域，子作用域可以访问父作用域
* 每次循环产生新的子块级作用域，所以也可以在循环体内 let const
* 循环头使用 const 也是可以的，只要不在循环内改变 i 的值即可
  * for 不可 const，for-in for-of 可 const

```js
for (let i = 0; i < 10; i++) {
    let a = i;
    console.log(a);
}
```

#### 函数与 var let const

* 循环中的函数保留着 i 相同的引用，循环结束后都是一样的最新值
* IIFE 的函数没有名字所以要用括号包起来（否则报错）然后调用执行，通过**传参**为每个值都创建了副本
* ES6 中，直接使用 let const 的块级作用域解决这个问题

```js
var a = [];
for (var i = 0; i < 10; i++) // 因为 i 是全局的，所以所有的函数都只向唯一的 i，也就是 10
    a.push(function() { console.log(i); });
a.forEach(function(f) { f(); }); // 十个10

var a = [];
for (var i = 0; i < 10; i++)
    a.push((function(v) { // ES5时代解决方案 匿名立即执行函数表达式 IIFE
        return function() { console.log(v); }
    }(i))); // (i) 放外面也可以
a.forEach(function(f) { f(); }); // 0到9

var a = [];
for (let i = 0; i < 10; i++) // i 是局部的，所有的函数都保留着不一样的 i
    a.push(() => console.log(i));
a.forEach(function(f) { f(); }); // 0到9
```

#### 顶层作用域与全局声明

* 顶层作用域也叫全局作用域
* 顶层对象：在浏览器环境是 window，在 Node 环境是 global 对象
* 顶层对象与全局变量的关系
  * var function 声明的全局变量，属于顶层对象的属性
  * let const class 声明的全局变量，不属于顶层对象的属性

```js
global.a = 1;
a; // 1

a = 2;
global.a; // 2
```

* 很难用统一的方法获取到顶层对象
  * 浏览器，顶层对象是 window，但 Node 和 Web Worker 不支持
  * 浏览器和 Web Worker，self 指向顶层对象，但 Node 不支持
  * Node，顶层对象是 global，但其他环境都不支持
  * 在全局环境中使用 this 获取顶层对象
    * Node 模块中，this 返回当前模块
    * ES6 模块中，this 返回 undefined
    * 函数不作为对象运行，this 返回顶层对象，但是严格模式下返回 undefined
    * new Function("return this")() 在严格模式下返回顶层对象
      * 但是启用了内容安全策略（CSP）则不支持 eval 和 new Function
  * ES2020 通过 globalThis 作为顶层对象

```js
// 方法一
(typeof window !== 'undefined'
   ? window
   : (typeof process === 'object' &&
      typeof require === 'function' &&
      typeof global === 'object')
     ? global
     : this);

// 方法二
var getGlobal = function () {
  if (typeof self !== 'undefined') { return self; }
  if (typeof window !== 'undefined') { return window; }
  if (typeof global !== 'undefined') { return global; }
  throw new Error('unable to locate global object');
};

// 方法三
(function (Object) {
  typeof globalThis !== 'object' && (
    this ?
      get() :
      (Object.defineProperty(Object.prototype, '_T_', {
        configurable: true,
        get: get
      }), _T_)
  );
  function get() {
    var global = this || self;
    global.globalThis = global;
    delete Object.prototype._T_;
  }
}(Object));
export default globalThis; // esm
module.exports = globalThis; // cjs
```

