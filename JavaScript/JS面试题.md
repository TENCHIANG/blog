### a == 1 && a == 2 && a == 3

* == 的自动类型转换，会把两边转为数字
* 对象协议
  * 优先级：Symbol.toPromitive > valueOf > toString
  * Symbol.toPromitive 默认没有
  * valueOf toString 都是继承类型的原型
  * 数组的 toString 内部调用了 join
* get 属性描述符
  * 有 get 就没有 value writable
  * get 优先级也比对象协议高
  * 全局对象上的属性（全局变量）是不可配置的（但可以写，可改 value 但不可 get）
  * 所以直接用 defineProperty **创建**全局变量

```js
var a = { // 1
	n: 1,
	valueOf() { return this.n++; },
	//[Symbol.toPrimitive]() { return this.n++; },
	//toString() { return this.n++; },
};

var a = (function() { // 2
    let n = 1;
    return function() { return n++; };
})();
a.valueOf = a;

var a = [1, 2, 3]; // 3
a.join = a.shift;

var a = { // 4
    n: 1,
    get getn() { return this.n++; },
    set setn(v) { this.n = v; },
    valueOf() { return this.getn; },
};

Object.defineProperties(globalThis, { // 5
    n: {
    	value: 1,  
        writable: true,
    	enumerable: true,
    	configurable: true
    },
    a: {
        get() { return this.n++; }, // 如此无法使用 a.join 因为返回数字
        set(v) { this.n = v; },
    	enumerable: true,
    	configurable: true
    }
});

a == 1 && a == 2 && a == 3;
```

* [(a\==1 && a\==2 && a\==3)能输出ture么？_个人文章 - SegmentFault 思否](https://segmentfault.com/a/1190000012921114)

