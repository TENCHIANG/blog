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

* 声明：创建变量，初始化：第一次赋值
* ES6 变量声明的 6 种方法：var、function、let、const、import、class

#### Hoisting

* var 提升：在声明前可访问（初始化为 undefined）
  * 全局内 var：提升到全局顶部（函数也可访问）
  * 函数内 var：提升到函数顶部（全局无法访问，函数内算一个小全局）
* var 可提升**可重复**声明，最后的作数
* let const 不提升**不可重复**声明（SyntaxError）
* const 声明**同时**必须初始化，let 只声明默认初始化为 undefined

#### const

* const 只是无法改变其指向（can't re-assignment）
* 并不是不可被改变的（immutable），所以指向的对象本身可以改变
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
  * **for 不可 const**，for-in for-of 可 const

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
* 要记住：
  * 任何变量都是引用，包括基本变量
  * 在函数内引用外部的变量，这是闭包，就算外部的环境没了，变量因为有引用还得以保留
  * ES6 的 for 循环，每次循环产生新的环境，把 i **拷贝**了一份，使之生成不同的副本给闭包

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

#### Declare = Create + Initialize + Assign

* 细分下来，变量的声明有 3 步骤
  * 创建 create，创建和声明是同义词
  * 初始化 initialize：第一次赋值，也叫绑定（binding）
  * 赋值 assign：初始化更强调是系统的，赋值更强调是人为的
  * 可以理解为，js 会把代码扫描两遍，第一遍生成环境创建好要用的变量，第二遍执行代码如赋值什么的
* var 声明的过程
  * 创建变量，将变量**初始化**为 undefined
  * 执行代码，如赋值
* function 声明过程
  * 创建函数名变量，将变量初始化为匿名的函数表达式 function() {}
  * 执行代码，如调用函数，或赋值
    * 则创建一个环境，进入环境进行 创建-初始化-运行 的操作
* let 声明过程
  * 创建变量，此时还没有初始化（死区）
  * 执行代码，如赋值，没有则**初始化为** undefined（此时才初始化完成，脱离死区）
    * 此时如果初始化失败则该变量**永远**在死区里，无法重新初始化
    * 不过问题不大，因为已经报错了，后面的代码不会执行

```js
> let x = x
Uncaught ReferenceError: Cannot access 'x' before initialization
> x
Uncaught ReferenceError: x is not defined
> let x
Uncaught SyntaxError: Identifier 'x' has already been declared
> var x
Uncaught SyntaxError: Identifier 'x' has already been declared
```

* 总结：function let var 都有提升
  * let 提升了创建（）
  * var 提升了创建初始化
  * function 提升了创建、初始化、赋值（不可能为 undefined）
  * var 类似于 function 但是优先级比 var 高

```js
var foo
function foo() {}
console.log(foo) // [Function: foo]
```

* [理解ES6中的暫時死區(TDZ) | Eddy 思考與學習](https://eddychang.me/es6-tdz)

* [我用了两个月的时间才理解 let - 知乎](https://zhuanlan.zhihu.com/p/28140450)

* > In JavaScript, all binding declarations are instantiated when control flow enters the scope in which they appear. Legacy var and function declarations allow access to those bindings before the actual declaration, with a "value" of `undefined`. That legacy behavior is known as "hoisting". let and const binding declarations are also instantiated when control flow enters the scope in which they appear, with access prevented until the actual declaration is reached; this is called the Temporal Dead Zone. The TDZ exists to prevent the sort of bugs that legacy hoisting can create.

### 七 顶层作用域与全局声明

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

### 八 ES6 执行上下文

* ES6 的执行上下文中有三种组件
  * 词法环境 LexicalEnvironment
  * 变量环境 VariableEnvironment
  * this 绑定 ThisBinding
* ES6 执行上下文分为全局执行上下文和函数执行上下文
* this 全局执行上下文的含义（指向全局对象s）
  * 浏览器 ---> window
  * Node ---> global
* this 函数执行上下文的含义
  * 函数是对象的属性 ---> 对象本身
  * 默认 ---> 全局对象
  * 严格模式 ---> undefined

#### 词法环境

* 词法环境是一种规范类型，基于词法嵌套结构，来定义标识符与特定变量和函数的关联关系
  * 是一个标识符变量映射的结构，标识符是函数和变量名，变量是对实际值的引用
* 词法环境有两个部分：环境记录（record）、对外部环境的引用（可能为 null）
* 词法环境有两种类型
* 全局环境（在全局执行上下文中）：
  * 没有外部环境（null），有一个全局对象（如 window global）
  * 及其关联的方法和属性（全局变量和方法）
* 函数环境：
  * 函数定义的变量存在**环境记录**中，包含 arguments 对象
  * 外部环境的引用是全局环境，也可以是包含内部函数的外部函数环境
  * 函数只有在调用时才会创建其环境
* 环境记录也有两种
  * 声明性环境记录：存储变量、函数和参数（函数环境）
  * 对象环境记录：全局环境

```js
GlobalExectionContext = {  
  LexicalEnvironment: {  
    EnvironmentRecord: {  
      Type: "Object",  
      // 标识符绑定在这里 
    outer: <null>  
  }  
}
FunctionExectionContext = {  
  LexicalEnvironment: {  
    EnvironmentRecord: {  
      Type: "Declarative",  
      // 标识符绑定在这里 
    outer: <Global or outer function environment reference>  
  }  
}
```

#### 变量环境

* 变量环境是一种特殊的词法环境，它的环境记录维护了执行上下文中的 var 语句创建的绑定
* 词法环境保存 const let，变量环境保存 var
* [一文读懂var、let、const——从规范文档出发_随风丶逆风的博客-CSDN博客](https://blog.csdn.net/sinat_36521655/article/details/107960380)

### undefined 和 null

* var let 只声明时，默认值为 undefined
* undefined 只是一个全局变量，非保留字，可能被覆盖，void 0 产生稳定的 undefined 值
* null 表示没有对象，所以 typeof 是 object，但非 Object 的实例

### 严格模式

* ES5 在全局或函数顶部启用严格模式 "use strict"
* node --use_strict 用于 REPL
* 不允许直接声明全局变量，ReferenceError 提示未定义
* 不允许 07 表示八进制，SyntaxError，要使用 0o7
* delete 删除属性失败则 TypeError，正常模式是返回 false 没效果
  * 修改 freeze 对象的属性也会报 TypeError，正常模式是返回右值没效果
* 不能使用保留字（Reserved word）作为变量名，会报 SyntaxError
  * 如 implements、interface、let、package、private、protected、public、static
* 严格模式除了避免错误，还有助于提升性能

### 算数运算

* IEEE754 会用分数和指数表示一个数，有些分数除不尽是无限小数，所以造成浮点数误差
  * 0.1 = 1/16 + 1/32 + 1/265 + 1/512 + 1/4096 + 1/8192 + ...

```js
0.1 + 0.1 + 0.1 // 0.30000000000000004
0.1 * 3 // 0.30000000000000004
1 - 0.8 // 0.19999999999999996
1 - 0.9 // 0.09999999999999998
```

* ES7 新增了 ** 指数运算符（Exponentiation Operator）

#### 算术运算与字符串

* `+` 只要有一方是字符串，就是字符串连接操作符
* 首先把另一方尝试转为字符串，然后连接成新的字符串（不改变字符串）
* `-`、`*`、`/`、`**`、`%`尝试把两边转为数字
* 如果要做算数运算，先保证两边都是数字，用显式的转换

#### Infinity

* 1 / 0 就会得到 Infinity
* 只读全局变量 Infinity 代表正无穷
* Number.POSITIVE_INFINITY === Infinity
* Number.NEGATIVE_INFINITY === -Infinity

#### NaN

* NaN，表示不是一个数字，不等于任何值，也是唯一**不等于自身**的值
* 0 / 0 就会得到 NaN，但是 typeof NaN 得到是 number（类型相等 值不相等）
* 传统 NaN 是全局变量，ES6 是在 Number.NaN

```js
NaN === NaN // false 类型相等 值不相等
NaN !== NaN // true
```

* 应避免产生 NaN，比如避免没有把握的自动类型转换，避开不好的运算特性

### 比较运算

* 要用 !== 和 ===，先比较类型，再比较值
* ===：类型相同值相同才 true，否则 false
* !== ：类型不同或值不同才 true，否则 false
* 对象比较的是地址

#### Falsy Family

* 除了 `0`、`NaN`、`''`、`null`、`undefined`、`false` 是假的，其它都是真的

```js
function has(obj, key) { return typeof obj[key] !== "undefined"; }
var obj = { x: undefined, y: 0 };
has(obj, "x"); // false
has(obj, "y"); // true
has(obj, "z"); // false
```

* 属性不存在或为 undefined 返回 false，用 typeof 是避免 undefined 被覆盖
* 属性为 `0`、`NaN`、`''`、`null`、`false` 也返回 true

### 位运算

* `~`，不管符号位，直接反转
* `<<`，左边多的丢弃，右边补零，不保符号位
* `>>`，右边多的丢弃，但是符号位**保留**
* `>>>`，右边多的丢弃，左边补零，不保符号位（只有右右移，没有左左移）
* 正数最高位为 0，是原码无需转换
* 负数最高位为 1，位运算要把负数转为补码再运算，原码符号位外取反加一转为补码，反之亦然

```js
~15 // -16
// 0000 1111 单字节表示 是正数无需转换
// 1111 0000 取反运算符
// 1000 1111 取反
// 1001 0000 加一 得原码 -16
~-15 // 14
// 1000 1111 是负数得转为补码再运算
// 1111 0000 取反
// 1111 0001 加一 得补码
// 0000 1110 取反运算符 得原码 14
15 >> 1 // 7
// 0000 1111
// 0000 0111 右移一位
-15 >> 1 // -8
// 1000 1111
// 1111 0001 取反加一
// 0111 1000 右移一位
// 1111 1000 符号位保留
// 1000 1000 取反加一得原码 -8
-15 >>> 1 // 0111 1111 1111 1111 1111 1111 1111 1000
// 1000 1111
// 1111 0001 取反加一
// 0111 1000 右移一位 符号位不保留
-14
Number(0xbfff_ffff << 1).toString(16) // 0x7fff_fffe
// 1011 1111 bf
// 0111 1110 7e
```

### switch

* case 是用 === 严格比较的
* 不要在 case 使用 NaN

### for-of 迭代值

* 用来迭代数组不错
* 可迭代双字节之外的 UTF-8 字符，如 emoji，字串类似数组
* 只要对象实现了 Symbol.iterator 方法，返回迭代器（Interator），即可使用 for-of 迭代

### for-in 迭代键

* 键也叫属性名，或者叫特性
* 注意数组的 length 是不可列举的（non-enumerable）
* 规范不保证迭代的顺序，一般引擎会以键的建立顺序来的

#### in 运算符

* 用来检测对象是否包含某个属性
* for-in 中的 in 不是运算符，只是语法关键词

```js
'length' in [] // true
'toString' in {} // true
```

#### hasOwnProperty 方法

* 检测对象**本身**包含某个属性（而不是被继承）

```js
[].hasOwnProperty('length') // true
[].hasOwnProperty('toString') // false
({}).hasOwnProperty('toString') // false
```

* 可见数组的 length 属性是本身的
* 检测对象还要考虑对象的属性是否可列举、是否为继承而来、是否为 Symbol 以及顺序等

#### Object.keys array.keys 方法

* Object.keys 方法类似于 for-in 循环，且返回数组
* array.keys 是数组的方法，从 Array 继承而来，返回迭代器
* 但都无法返回所有属性值

```js
var o = [1, 2, 3];
for (const k in o) console.log(k); // 0 1 2
for (const k of Object.keys(o)) console.log(k); // 0 1 2
for (const k of o.keys()) console.log(k); // 0 1 2
"keys" in []; // true
"keys" in {}; // false
[].hasOwnProperty("keys"); // false
```

### break 标签

* 可以对区块使用标签，然后通过 break 跳出多重循环

```js
back: {
    for (let i = 0; i < 10; i++)
        if (i === 9) {
            console.log("break");
            break back;
        }
    console.log("END");
}
```

### continue 标签

* 只能放在 for 之前，就是可以选择跳到哪一层 for 循环

```js
back1:
for (let i = 0; i < 10; i++)
    back2:
    for (let j = 0; j < 10; j++)
        if (j === 9)
            continue back1;
console.log("END");
```

## 函数

* 如果没有返回值，默认返回 undefined
* js 代码也要加分号，左花括号**不要换行**（避免被当做另一行语句）

```js
function f() {
    return // 会被当做一条语句 之后的对象直接忽略
    {
        x: 10
    }
}
f() // undefined
```

* 函数中还可以定义函数，叫区域函数（Local function），也叫子函数
* 子函数的好处是，能直接访问父函数的变量和参数

### 不支持函数重载

* 如果定义两个名称一样的函数，就算参数不一样，后面也会简单**覆盖**前面的

```js
function sum(a, b) { return a + b; }
function sum(a, b, c) { return a + b + c; }
sum(1, 2); // 1 + 2 + undefined ---> NaN
```

### 默认参数

* 函数的默认参数实现类似重载的效果
* 默认参数每次函数调用都是新的，新运算的，避免默认值被持续持有
  * 防止这次函数的参数，还保持上次函数调用的状态
  * 相当于多个函数调用共享同一个参数，相当于一个外部变量或其它语言的 static 变量
* 默认参数也可用表达式指定，也可写在无默认参数之前，但不推荐
* ES6 之前，默认参数通过 Falsy Family 配合 || 运算符实现
  * 如果不传为 undefined，是假值，于是使用右边的默认值

#### ES6 对象字面量

* 新建对象时，直接放变量，属性名为变量名，属性值为变量值

```js
function account(name, number, balance = 100) {
    return { name, number, balance };
}

function f(a, b = []) {
    b.push(a);
    console.log(a, b);
}
f(1); // 1 [ 1 ]
f(1); // 1 [ 1 ] 而不是 1 [ 1, 1 ]
f(1); // 1 [ 1 ] 而不是 1 [ 1, 1, 1]
```

### 不定长参数 arguments instanceof

* ES6 新特性，在参数前加 `...` 即可
* 传入的参数放在类数组 arguments 里，然后按情况再赋给可变长参数
  * 一是可以更方便的迭代，而是不用从头开始迭代了
* 使用 instanceof 运算符判断左边（对象）是不是右边的实例（类）
* 可见可变长参数是纯数组，arguments 只是类数组
  * 本质上是对象，所以只能通过最原始的 for 和 length 属性迭代
* ES6 之前，可变长参数是通过迭代 arguments 实现的，定义函数的时候为**无参数**
  * 实参比形参多是可以的，因为 arguments  包括了**全部**参数
  * 也可以设置参数，但没必要，arguments 还是得从头开始迭代
  * 而可变参数，前面有变量的话，保存的就**不是**全部变量了

```js
function sum(...numbers) {
    let total = 0;
    console.log(numbers instanceof Array); // true
    console.log(arguments instanceof Array); // false
    for (const number of numbers) total += number;
    return total;
}
```

### Option Object

* 选项对象：如果参数太多，可以把参数都打包在一个对象里

```js
function ajax(url, option = {}) { // 选项对象配合默认参数完美
    const reealOption = {
        method: option.method || 'GET',
        contents: option.contents || '',
        dataType: option.dataType || 'text/plain',
        // ...
    };
    console.log(url, reealOption);
}
```

### First Class Function

* 一级函数，表示可以把函数当做普通的值或参数来用
* 每个函数都是一个对象，是 Function 的实例
* 函数被当做参数，叫**回调函数**（Callback function）
* 回调函数还可以再抽象，直接在参数上调用函数，通过参数返回一个函数，作为外面函数的参数

```js
function filter(arr, predicate) {
    const result = [];
    for (const elem of arr)
        if (predicate(elem)) result.push(elem);
    return result;
}

function map(arr, mapper) {
    const result = [];
    for (const elem of arr) result.push(mapper(elem));
    return result;
}

var arr = [1, 2, 3, 4];
filter(arr, x => x % 2 == 0); // 筛选偶数
map(arr, x => x.toString()); // 把里面的每一项转为字符串
```

* 其实数组內建了 filter（过滤，元素总数可能会变少）、map（映射，元素总数不变）、sort（排序）方法

### 数组的 filter map sort 方法

* filter、map 只新建数组，不改变原数组的值
* 只是传回新的数组，包含了操作的结果，再此上还可以再调用方法，**方法链**（Method chain）
* sort 不新建数组，只改变原数组并返回，排序是根据 Unicode 字符串升序（非字符串则先转）
* 也可自定义排序规则，传入一个函数，函数会接收两个参数，根据返回值排序
  * 返回正数，a 比 b 大，把 a 放到后面
  * 返回负数，a 比 b 小，把 a 放前面
  * 返回零，顺序不变（稳定排序，但 ES 标准没规定 sort 必须是稳定的）
  * 所以默认是升序，也就是 a - b，降序是 b - a

```js
var arr = [4, 3, 2, 1];
arr.filter(x => x % 2 == 0);
arr.map(x => x.toString());
arr.sort((a, b) => a - b); // 升序
```

### 函数的属性

* 函数作为 Function 实例，有一些属性
* name 就是函数名
* length 形参个数，可变参数和默认参数不计数

### 函数字面量和箭头函数

* 函数字面量（Function literal），是指作为值或参数的函数
  * 可以不指定名字，叫**匿名函数**，name 属性为空字符串
  * 也可以指定名字，用于递归
* 函数字面量只是一种表达式，并没有创建变量，和函数声明不一样
  * 函数声明只要在同一个上下文，就可以**先用**再写
  * 函数字面量只能**先创建**再使用
  * 因为是表达式要写**分号**，函数声明不要
* 匿名函数的另一种表示：**箭头函数**（Arrow function）
  * 形参只有一个可省略括号
  * 函数体只有一行表达式可省略花括号，**返回**语句的结果
  * 不能直接返回一个对象，因为会把花括号当做函数体而不是对象
  * 函数字面量和箭头函数的**区别**在于 this

#### 立即调用表达式

* IIFE，Immediately Invoked Functions Expression
* 直接把函数字面量用括号包起来然后执行
* 在 ES6 之前，通常作为名称空间管理之用（闭包也是）

```js
(() => {}).name // ''
(() => {}).length // 0
(() => 1)() // 1 去花括号具有返回功能
(() => { a: 1 })() // undefined 不要直接返回对象
(function name(){}).name // 'name'
```

### 闭包 Closure

* 闭包是函数与作用域环境（Lexical environment）的组合
* 作用域环境就是在**存取变量**时，决定如何使用哪个变量
* **自由变量**（Free variable）：函数本身环境里没有该变量是在**外部**
  * 如果这个函数被当做值到外面去了（如返回），按理说自由变量应该被销毁
  * 但是因为还持有所以没有销毁，相当于**捕捉变量**而不是值
  * 这个函数和这个变量统称为闭包
* 闭包有很多种用处
  * 闭包是一种捕捉了外部变量的函数
  * 闭包可以作为名称空间管理之用
  * 闭包可以很容易的模拟出类的效果
* 可以把原型和闭包当做是最基本的类和函数（如 Lua）
* 闭包的缺点：浪费内存，闭包引用的变量不会被 GC

```js
function Counter() {
    let x = 10;
    return () => ++x;
}
var counter1 = Counter();
var counter2 = Counter();
counter1(); // 11
counter1(); // 12
counter2(); // 11
```

### Generator

* function 关键字后面加个 `*` 符号，就是生成器**函数**，返回生成器**对象**（不管有没有 yield）
  * 生成器函数不能表示为箭头函数，但是匿名函数可以，因为要有 `function*`
* 生成器里面用 yield 关键字**产生值**，但不会结束函数，只是把**流程控制**权交给调用者
  * 调用生成器对象的 next 方法，才会返回到生成器函数，运行并暂停到 yield 处
  * next 方法返回一个对象 `{ value, done }`，yield 指定 value 的值，done 设置为 false
  * 生成器函数如果执行完，value 为 undefined，done 为 true
* 生成器对象实现了 Symbol.iterator 方法（返回迭代器），可直接使用 for-of 迭代生成器对象
  * 内部不断调用 next，直到 done 为 true
  * 所以生成器函数的 return 值不会体现在 for-of 里
* Gnerator 把整个流程**片段化**
  * next 运行生成器函数，直到 yield 处
  * yield 右边有值则使用，否则使用 next 传过来的值，否则为 undefined
  * 并返回值和控制权到调用者

```js
function* range(start, end) {
    for (let i = start; i < end; i++) yield i;
}
var g = range(1, 3);
for (const n of g) console.log(n); // 1 2 3
g.next(); // { value: undefined, done: true }

range instanceof Function; // true
g instanceof Object; // true

function* f() {
    yield 111;
    console.log("f");
}
var gg = f();
gg.next(); // { value: 111, done: false }
gg.next(); // f { value: undefined, done: true }
gg.next(); // { value: undefined, done: true }
```

#### yield 的双向用法

* yield 不仅可以给 next 方法值（生产），也可以从 next 传值过来（消费）

```js
function* producer(n) {
    for (let data = 0; data < n; data++) {;
        console.log("产生了 ", data);
        yield data;
    }
}
function* consumer(n) {
    for (let i = 0; i < n; i++) {
        let data = yield; // next传过来的
        console.log("消费了 ", data);
    }
}
function clerk(n, p, c) {
    console.log("执行了", n, "次生产与消费");
    p = p(n);
    c = c(n);
    p.next(); // 生产者运行至 yield 处 生产了 0
    c.next(); // 消费者运行至 yield 处 消费了 undefined
    for (const data of p)
        c.next(data); // 将值传给消费者
}
clerk(5, producer, consumer);
```

#### 生成器函数 return

* 其实生成器函数**第一次** done 之后，value 的值是函数的返回值
* 如果没有显式的 return 值，自然就是返回 undefined
* 所以生成器函数里也可以 return 值
* 只要生成器函数已经 done 了，后面再怎么调用 next 也不会运行生成器函数且结果都一样

```js
function* f() {
    console.log("f");
    return 111;
}
var g = f();
g.next(); // f { value: 111, done: true }
g.next(); // { value: undefined, done: true }
```

#### 生成器的 return 方法

* 就像是在生成器函数里运行 return 语句一样
* 会使其直接 done，value 为方法的参数，不会使其实际运行

```js
function* f() {
    console.log("f");
    return 111;
}
var g = f();
g.return(222); // { value: 222, done: true }
g.return(); // { value: undefined, done: true }
```

* 生成器还有个 throw 方法，有关异步处理

#### 生成器嵌套

* 当需要从某个生成器取得数据，来创建另一个生成器时，可直接用 `yield*` 衔接
* 可通过 `yield*` 把 for-of 循环给简化了

```js
function* range(start, end) { // [start, end)
    for (let i = start; i < end; i++)
}
function* np_range(n) { // [-n, n] 除了0
    for (const i of range(0 - n, 0)) yield i;
    for (const i of range(1, n + 1)) yield i;
}
function* np_range(n) {
    yield* range(0 - n, 0);
    yield* range(1, n + 1);
}
    
for (let i of np_range(3)) console.log(i)
```

### 模板字符串 Template String

* 用重音符 \` 括起字符串，叫模板字符串
* 换行、空白符得以保留；`${}` 用作值替换
* 模板字符串其实是特殊形式的**函数调用**
* 函数调用不加括号且参数为模板字符串时
  * 把 `${}` 之外的字符串切分组合成**数组**，之内的**求值**后跟着数组一起传给函数
    * 该数组有个特殊属性 raw，是个只有一个元素的数组
    * 使用 raw 直接返回原始字符串（第一个元素），而不是数组
  * `${}` 即使在两端也可从更两端切出**空字符串**出来
* 注意，模板字符不会被转译（所见即所得）

```js
function f(...args) { for (const arg of args) console.log(arg); }
f(`${1} + ${2}`); // 1 + 2
f`${1} + ${2}`; // [ '', ' + ', '' ] 1 2
f`1`; // [ '1' ]
```

* 实际上 String.raw 函数就是**只能**不能加括号传模板字符串的
* 可以把模板字符串转为不会被转译的形式的字符串
* 难点：原始字符串和转义后的字符串

```js
console.log("AAA\tBBB"); // AAA     BBB 字符串默认会转译
console.log("AAA\\tBBB"); // AAA\tBBB 在特殊字符前再加转义符才不会被转译
console.log(String.raw`AAA\tBBB`); // AAA\tBBB 所以raw返回的是 "AAA\\tBBB"
`AAA\tBBB`; // AAA\tBBB
"AAA\tBBB"; // AAA\tBBB 可见 REPL 默认的字符串是模板字符串 是所见即所得、不会发生转译的原始字符串

function f(s) {
    console.log(s); // 转移后的字符串数组
    console.log(s.raw); // 该数组特有属性 取得原始字符串
    return s;
}

f`AAA\\BBB`; // [ 'AAA\\BBB' ] [ 'AAA\\\\BBB' ]
var arr = f`AAA\tBBB`; // [ 'AAA\tBBB' ] [ 'AAA\\tBBB' ]

typeof arr // 'object'
'raw' in arr // true
arr.hasOwnProperty('raw') // true
arr.raw instanceof Object // true
arr.raw instanceof Function // false

0 in arr.raw // true
1 in arr.raw // false
'length' in arr.raw // true
typeof arr.raw[0] // 'string'

Object.keys(arr) // [ '0' ]
for (const k in arr) k // '0'

for (const k of arr.keys()) k // 0 迭代器只能用for-of
for (const v of arr) v // 'AAA\tBBB' 原始字符串
for (const v of arr) console.log(v) // AAA     BBB 转码后字符串
```

## 使用对象

### 属性与 undefined

* 取对象不存在的属性，返回 undefined
* 如果有个属性值为 undefined，也会返回 undefined，但值确是存在的
* 所以要验证一个属性是否存在于对象，应用 in 运算符，删除则用 delete

### 数组别产生空项目

* 修改数组的 length 值不会实际增加值
* 不要修改 length 也不要产生空项目（empty item），因为不同 API 对待空项目不一样
  * forEach 会跳过空项目，回调函数不收空项目
  * filter 跳过，不收，也会过滤掉空项目
  * map 跳过，不收，结果保留空项目

```js
[undefined, undefined].length; // 2
[,,].length; // 2
0 in [undefined, undefined]; // true
0 in [,,]; // false
0 in [,,1]; // false
2 in [,,1]; // true
[undefined, undefined, 1].forEach(() => console.log("1")); // 1 1 1
[,,1].forEach(() => console.log("1")); // 1 跳过空项目
[,,].filter(x => true); // []
[,,].map(x => true); // [ <2 empty items> ]
```

### 函数与 this

* 函数作为对象的属性，其 this 指向该对象（只是语法糖）（用点号运算符）

```js
var obj = {
    '0': 111,
    '1': 222,
    '2': 333,
    length: 3,
    forEach(cb) {
        // 不要使用 for-of
        for (let i = 0; i < this.length; i++)
            cb(this[i]);
    }
};

obj.forEach(console.log);
```

### call apply bind

* Function 实例都有 call、apply、bind 方法
* this 指向的对象依函数**调用方式**而定，跟函数在不在对象里无关
  * 只是 `obj.f(...)` 恰好是 `f.call(obj, ...)` 或 `f.apply(obj, [...])` 的语法糖
  * 使用 call、apply、bind 也可以强心改变对象上函数的 this 指向
* call 第一个参数指定 this，其后指定若干参数（参数是单独的）
* apply 第一个参数指定 this，其后指定一个参数**数组**（参数是一个整体）
  * 如果指定，则需是数组，数组后再有参数则**忽略**
* bind 参数类似 call，返回一个**函数**绑定了 this 和参数
  * 调用返回的函数传参的话，作为绑定参数的追加
  * bind 可以实现**部分函数**（Partial function）
* 对于单纯是函数，无需使用 this 的情况下，设置为 undefined 即可

```js
function f(...args) { console.log(this, args); }

f.call({}, 1, 2, 3); // {} [ 1, 2, 3 ]
f.apply({}, [1, 2, 3]); // {} [ 1, 2, 3 ]

var g = f.bind({}, 1, 2, 3); // this和call的参数一起绑定
g(); // {} [ 1, 2, 3 ]
g(4, 5); // {} [ 1, 2, 3, 4, 5 ]

// {} [] 可变参数没传参默认就是空数组
f.apply({});
f.call({});
f.bind({})();

// 部分函数
function plus(a, b) { return a + b; }
var addTwo = plus.bind(undefined, 2);
addTwo(3); // 2 + 3 = 5
```

### 获取全局对象

* 纯函数中的 this（不使用点号运算符、call、apply、bind）
  * 严格模式，指向 undefined
  * 普通模式，指向全局对象
* `Function("return this")()` 直接返回全局对象
* 用 Function 构造函数时，需使用字符串指定函数体
* globalThis

### 箭头函数的 this

* 箭头函数可以看成函数字面量，但在 this 上还是不太一样
* 箭头函数的 this 与调用者一致，一旦绑定则无法再改变（除非调用者改变）
  * `.`、call、apply、bind 改变不了
  * 视调用时的词法环境而定

```js
this.x = 1; // 全局变量
var o = { x: 2, f1() { console.log(this.x); }, f2: () => console.log(this.x) };
o.f1(); // 2
o.f2(); // 1

// 函数字面量模拟箭头函数
// 这也是 ES5 之前的常规操作（拷贝 this），也是 ES6 为什么有箭头函数的原因
var self = this;
self.x = 1;
var o = { x: 2, f1() { console.log(self.x); } };
o.f1(); // 1
```

### 对象字面量增强

* 属性名和变量名一样，则可**省略**属性名和冒号（属性名为变量名，性值为变量值）
* 属性名和函数名一样，省略属性名、冒号和 function 关键字（类的用法）
  * 只写函数名、参数、函数体（箭头函数除外）
  * 此形式函数还可用 super 关键字
  * 指向对象的父类（原型），如无父类则为 undefined（无法单独使用）

```js
var x = 111;
var obj = { x, f() { console.log(super.keys); }, };
obj.f(); // undefined
```

#### 对象字面量与方括号

* 指定属性名时，方括号内可用表达式
* 最常用的其实是结合 ES6 符号（Symbol）来使用
* 在定义 getter、setter 时也更方便
  * ES6 在方法名之前标识 set 或 get 指定设值取值方法
  * 对象使用属性时，就会调用 getter、setter 方法
  * ES5 只能通过 Object 的 defineProperty、defineProperties 方法

```js
var o = { ["prefix" + 1]() {} }; // ES6
var o = {};
o["prefix" + 1] = function() {}; // ES5

function Person() {
    let privates = {};
    return {
        set name(v) { privates.name = v.trim(); },
        get name() { return privates.name.toUpperCase(); }
    };
}
var person = Person();
person.name = " YY ";
console.log(`[${person.name}]`); // [YY]
```

### 解构、余集、打散

* [解构余集打散.mm](解构余集打散.mm)

### 对象协议 Object Protocol

* [对象协议.mm](对象协议.mm)

## 符号 Symbol

* 符号是**基本类型**，可用符号表示一个**独一无二**的值
* 可以对符号指定说明，但不是一一对应的，指定同样的说明返回不同的符号（说明默认为 undefined）
* Symbol() 根据说明返回不同的符号，符号是分散管理的
* symbol.description 根据符号返回说明，负责所有符号（ES10）

```js
var s1 = Symbol("s");
var s2 = Symbol("s");
s1 !== s2;
s1.description === s2.description;
Symbol() !== Symbol();
```

* [Symbol.mm](Symbol.mm)

### 统一管理的符号

* Symbol.for() 根据说明返回相同的符号，有则返回无则创建，符号是统一管理的（说明默认为 undefined）
* Symbol.keyFor() 根据符号返回说明，只负责统一管理的符号
* 统一管理的符号和分散管理的符号**互不干扰**
* 统一管理的符号可以理解为，说明和符号**一一对应**

```js
var s1 = Symbol("s");
var s2 = Symbol.for("s");
s1 !== s2;
Symbol.for() === Symbol.for();
Symbol.keyFor(s1); // undefined
Symbol.keyFor(s2); // 's'
```

### 内置标准符号

* 内置符号是直接挂载到 Symbol 上的，不是通过 Symbol.for 统一管理
* 内置符号的说明也是 Symbol.xxx
* 在使用 Symbol.for 建立自定义协议前，先看看有没有相似的标准符号

```js
Symbol.iterator !== Symbol.for("Symbol.iterator");
Symbol.iterator.description; // 'Symbol.iterator'
```

* JavaScript 没有规范 equals 方法比较对象的想等性，只能自定义，因为标准 API 本身的都不一致

### Symbol.iterator

* **可迭代对象**：实现了 Symbol.iterator 方法，使之返回迭代器的对象
  * 可使用 for-of 迭代
  * 可用 `...` 运算符**打散**
    * 在方阔号里：初始化数组
    * 在括号里：参数
  * 也可用作解构赋值
* 迭代器：是拥有了 next 方法的对象（大多数內建迭代器同理）
* 数组是迭代器对象，但不是迭代器

```js
var arr = [1, 2, 3];
Symbol.iterator in arr; // true
arr.hasOwnProperty(Symbol.iterator); // false
"next" in arr; // false

var iter = arr[Symbol.iterator]; // 数组的迭代器
typeof iter; // 'function'
iter.name; // 'values'
iter.toString(); // 'function values() { [native code] }'
```

* 自定义迭代器

```js
function range(start, end) {
    let i = start;
    return {
        [Symbol.iterator]() { return this; },
        next() {
            return i <= end ? 
                {value: i++, done: false} :
            	{value: undefined, done: true};
        }
    };
}
for (let n of range(1, 3)) console.log(n); // 1 2 3
[...range(1, 3)]; // [1, 2, 3]
```

#### 生成器和迭代器

* 生成器是实现了  throw 和 return 方法的迭代器
* reutrn 方法是为了**停止迭代**，指定 value 字段强行迭代完成
* for-of 中 break 会调用 return() 方法，参数 value 为空

```js
function range(start, end) {
    let i = start;
    return {
        [Symbol.iterator]() { return this; },
        next() {
            return i <= end ? 
                {value: i++, done: false} :
            	{value: undefined, done: true};
        },
        return(value) {
            console.log(value);
            i = end + 1; // 迭代结束的条件
            return {value, done: true};
        }
    };
}
var r = range(1, 3);
for (let n of r) {
    console.log(n); // 1
    break;
}
console.log(r.next()); // { value: undefined, done: true }
```

* 类数组对象，使用生成器无需使用闭包即可生成可迭代对象，可用 for-of 迭代、解构赋值、打散

```js
var arrayLike = {
    "0": 1,
    "1": 2,
    "2": 3,
    length: 3,
    *[Symbol.iterator]() {
    	for (let i = 0; i < this.length; i++)
            yield this[i];
	}
};
for (let n of arrayLike) console.log(n); // 1 2 3
var [a, b, c] = arrayLike;
console.log(a, b, c); // 1 2 3
[...arrayLike]; // 1 2 3

var iter = arrayLike[Symbol.iterator];
iter.name; // '[Symbol.iterator]'
```

### Symbol.toPrimitive

* 运算过程若须从对象上取得基本类型
* ES6 用 Symbol.toPrimitive 符号代替，默认是没有的，valueOf、toString 继承自类型的原型
* 优先级 get > Symbol.toPrimitive > valueOf > toString
* 可以使用 `.`、`in` 运算符检测对象的符号属性名，**但 `for-in`、`Object.keys` 不行**

```js
var o = {
    valueOf() { return 1; },
    [Symbol.toPrimitive]() { return 2; }
};
+o; // 2
for (let k in o) console.log(k); // valueOf
```

* 符号因为可以当做属性，所以也可以用 getter、setter

```js
var o = {
    get [Symbol.for('x')]() { return 10; }
};
o[Symbol.for('x')]; // 10
```
