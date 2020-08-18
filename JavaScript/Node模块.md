### Node 模块 CommonJS

模块一般是一个 js 文件，都是一个对象

* 路径分析
* 文件定位
* 编译执行

#### 模块分类

* 核心模块（Node 提供二进制）
  * js 文件 + 內建模块（桥接和封装）
  * 纯 js 文件作为功能模块（不跟底层打交道但又很重要）
* 文件模块（用户编写）
  * js 模块
  * C/C++ 扩展模块（动态链接库）

#### 模块加载顺序

* 核心模块（不指定路径和扩展名，最优先）

* 指定路径的模块：绝对路径（`/`），相对路径（ `./`、`../`）

  * 文件模块加载原则
    * 已指定扩展名
    * 未指定扩展名
      * .js：fs 同步读取并编译（默认）
      * .json：fs 同步读取，JSON.parse 解析
      * .node：C/C++ 扩展，通过 process.dlopen 方法加载
  * 目录模块加载原则
    * package.json 有 main 属性
      * main 作为文件
      * main 作为目录
      * 没找到报错
    * 模块名作为目录下的 index 文件

* 未指定路径的模块

  * 以 `#` 开头的模块（ESM模块）

    * package.json 的 imports 字段

    * ```js
      url.fileURLToPath(ESM模块处理(模块名, url.pathToFileURL(路径))
      // pathToFileURL(__filename); // file:///...
      ```

    * 看起来 ESM 模块支持的是**网络模块**

  * 自引用模块

    * package.json 中有属性 exports 且属性 name 与模块的前缀一样
    * 用加载 node_modules 模块的方式加载 name

  * **node_modules 模块**

    * 从 ./node_modules 一直往上找到 /node_modules
    * 模块名以 @ 开头：加载子模块（package.json 的 exports 属性，也支持 ESM）
    * 在 node_modules 目录下以文件加载
    * 在 node_modules 目录下以文件夹加载

* 找不到模块报错

* 找到模块编译

#### 模块加载大概

* 检查 .js：fs 同步读取并编译（默认）
* 检查 .json：fs 同步读取，JSON.parse 解析
* 检查 .node：C/C++ 扩展，通过 process.dlopen 方法加载
* 目录作为模块（包）
  * 检查 package.json 中的 main 属性，然后重复之前的步骤
  * 检查 index，然后重复之前的步骤（index.js、index.json、index.node）
  * 当前目录都找不到，下一个模块路径（node_modules 模式查找）
* 没找到，抛出异常 MODULE_NOT_FOUND

#### 文件模块编译过程

* 新建一个模块对象 Module（核心模块是 NativeModul）
* 编译
* 将编译后的路径作为索引缓存到 Module.\_cache 对象（核心模块是 NativeModule.\_cache）

```js
function Module (id, parent) {
    this.id = id;
    this.exports = {};
    this.parent = parent;
    if (parent && parent.children) {
    	parent.children.push(this);
    }
    this.filename = null;
    this.loaded = false;
    this.children = [];
}

Module._extensions['.json'] = function(module, filename) {
    var content = NativeModule.require('fs').readFileSync(filename, 'utf8');
    try {
        module.exports = JSON.parse(stripBOM(content));
    } catch (err) {
        err.message = filename + ': ' + err.message;
        throw err;
    }
};

require.extensions['.json'] = Module._extensions['.json']
console.log(require.extensions); // { '.js': [Function], '.json': [Function], '.node': [Function] }
```

#### require、exports、module、__filename、__dirname

* 是编译的过程中，对模块**首尾包装**注入这五个变量

```js
(function (exports, require, module, __filename, __dirname) {
    var math = require('math');
    exports.area = function (radius) {
    	return Math.PI * radius * radius;
    };
});
```

* 然后通过 vm.runInThisContext（类似 eval，但是指定了上下文，不污染全局）
* 返回一个 function 对象，然后再将那五个参数的实参传进去，再运行这个函数
* 最后返回 exports 对象（exports 之外的不可访问）
* 注意：不能直接对 exports 赋值（**引入对象**），要使用 module.exports 直接赋值（不然只是该变了局部变量的引用）

#### 核心模块编译过程

* 核心模块是 js 代码 + 内置模块（因为有 js 代码，所以还是需要编译的过程）
  * 把 js 代码转换为 C++ 的字符数组（node 的命名空间）
  * 标识符分析后直接定位到相应内存（process.binding）
  * 再导出 exports 对象前，也经历了首尾包装

```js
function NativeModule (id) {
    this.filename = id + '.js';
    this.id = id;
    this.exports = {};
    this.loaded = false;
}
NativeModule._source = process.binding('natives'); // 取js核心文件，转为普通字符串，然后以待编译和执行
NativeModule._cache = {}; // 编译成功后缓存
```

* 内置模块是纯 C/C++ 代码（一般是用户模块依赖核心模块，核心模块依赖内置模块）
  * 內建模块定义后，通过 NODE_MODULE 定义到 node 命名空间中
  * node_extensions.h 将內建模块放到 node_module_list 数组中
  * get_builtin_module 方法从 node_module_list 取出模块
    * 无需标识符定位、文件定位、编译等过程，直接可执行

```c
struct node_module_struct {
    int version;
    void *dso_handle;
    const char *filename;
    void (*register_func) (v8::Handle<v8::Object> target); // 模块的具体初始化方法
    const char *modname;
};

// 将內建模块定义到 node 命名空间
#define NODE_MODULE(modname, regfunc) \
    extern "C" { \
    NODE_MODULE_EXPORT node::node_module_struct modname ## _module = \
    { \
        NODE_STANDARD_MODULE_STUFF, \
        regfunc, \  // 模块的具体初始化方法
        NODE_STRINGIFY(modname) \
    }; \
}
```

#### 导出內建对象

* 先创建空 exports 对象
* 调用 get_builtin_module 方法取內建模块对象
* 通过 register_func 方法填充 exports 对象
* 将 exports 对象按模块名缓存
* 举例：os 模块引入流程
  * NODE_MODULE(node_os, reg_func)
  * get_builtin_module(node_os)
  * process.binding("os")
  * NativeModule.reuire("os")
  * require("os")
* 核心模块和內建模块都经过了 process.binding

#### 编写內建模块

* node_hello.h

```c++
#ifndef NODE_HELLO_H_
#define NODE_HELLO_H_
#include <v8.h>

namespace node {
    v8::Handle<v8::Value> SayHello(const v8::Arguments& args);
}
#endif
```

* node_hello.cc

```c++
#include <node.h>
#include <node_hello.h>
#include <v8.h>

namespace node {
    
    using namespace v8;
    // 实现预定义的方法
    Handle<Value> SayHello (const Arguments& args) {
        HandleScope scope;
        return scope.Close(String::New("Hello World!"));
    }
    // 给传入的目标对象添加 sayHello 方法
    void Init_Hello (Handle<Object> traget) {
        target->Set(String::NewSymbol("sayHello"), FunctionTemplate::New(SayHello)->GetFunction());
    }
}
NODE_MODULE(node_hello, node::Init_Hello); // 将注册方法定义到内存中
```

* 改 src/node_extensions.h，在 NODE_EXT_LIST_END 前添加 NODE_EXT_LIST_ITEM(node_hello)，使之加入 node_module_list 数组
* 改 node.gyp，在 target_name.node.sources 中添加 .h .cc 两个文件，重新编译 Node 整个项目

```js
local hello = process.binding('hello')
hello.sayHello()
```

#### node 扩展模块

* .node 文件本质上是 so 和 dll 文件，通过 process.dlopen 引用
* 编写扩展模块跟內建模块差不多，区别是不加入 node_module_list，而是通过 dlopen 动态加载

```c
Module._extensions['.node'] = process.dlopen
// process.dlopen("xxx.node", exports)
```

* libuv 对 process.dlopen 进行了封装
  * 先调用 uv_dlopen（LoadLibraryExW）打开动态链接库
  * 再调用 uv_dlsym（GetProcAddress）找到库中通过 NODE_MODULE 宏定义的地址
* 然后再将 C/C++ 中定义的方法挂载到 exports 对象上（dlopen 的第二个参数）
* **扩展模块相当于动态链接库，內建模块相当于静态链接库**

#### gyp 项目生成工具

* C/C++ 扩展模块可通过 gyp 编译
* gyp 是 Generate Your Projects 的缩写，能够自动生成各平台下的项目文件
* node 自身就是通过 gyp 编译的，npm 也有基于 gyp 专为 node 提供的 node-gyp
* node-gyp 约定 binding.gyp

```json
{
    'targets': [{
        'target_name': 'hello',
        'sources': [ 'src/hello.cc' ],
        'conditions': [
            [ 'OS == "win"', { 'libraries': [ '-lnode.lib' ] } ]
        ]
    }]
}
// node-gyp configure
```

* node-gyp configure 在当前目录创建 build 目录，生成平台相关的项目文件
* node-gyp build 根据不同平台项目文件编译，在 build/Release 目录下生成 .node 文件
* const hello = require("./build/Release/hello.node")  引用该模块



#### 包的组织结构

* package.json 包描述文件
* bin 存放二进制文件的目录
* lib 存放 js 代码的目录
* doc 存放文档的目录
* test 存放单元测试用例代码目录

#### package.json 详解

* npm 实现和 CommonJS 标准还不太一样，以 npm 为准
* name 包名
* description 包简介
* version 语义化的版本号 major.minor.revision
* author 包作者
* maintainers 维护者列表（每个人由 name email 和 web 个人网址组成）
* contributors 贡献者列表
* dependencies 当前包所依赖的包列表
* devDependencies 开发时依赖的包
* keywords 关键词组（分类搜索）
* repository 源代码地址（repositories）
* main 模块引入方法，require 该包时，将 main 作为包中其余模块的入口
* bin 包作为命令行工具用（使包可以在命令行直接执行）（命令名称：充当命令的文件）
* scripts 设置 npm 的钩子，用来安装、测试和卸载包，如 npm install [packageName]
* engines ejs、flusspferd、gpsee、jsc、spidermonkey、narwhal、node、v8
* licenses 许可证列表（type 和 url）

#### npm 常用功能

* npm i -g xxx 代表把包作为全局命令行，而不是全局包
* 从非官方源安装
  * npm i --registry=url xxx
  * npm config set registry url
* npm init 交互式生成 package.json
* npm adduser 注册 npm 账号
* npm publish folder 上传包
* 管理包权限
  * npm owner ls pkg
  * npm owner add user pkg
  * npm owner rm user pkg
* npm ls 分析当前目录下的所有包

#### 前端模块 AMD

* Asynchronous Module Definition，此外，还有玉伯定义的 CMD

```js
// define(id?, dependencies?, factory)    
define(function () {
    let exports = {}
    exports.sayHello = function () { alert(module.id) }
    return exports
})
```

#### CMD 规范

* AMD 在定义的时候需要指定所有依赖作为参数传到模块中
* CMD 更像 CommonJS，随时用 require 进行导入

```js
// define(facoty)
define(function (require, exports, module) {
    // require("xxx")
})
```

#### 兼容多种模块规范

```js
;(function (name, definition) {
    // 检测上下文环境是否为AMD或CMD
    var hasDefine = typeof define === 'function',
    // 检查上下文环境是否为Node
    hasExports = typeof module !== 'undefined' && module.exports;
    if (hasDefine) {
        // AMD环境或CMD环境
        define(definition);
    } else if (hasExports) {
        // 定义为普通Node模块
        module.exports = definition();
    } else {
        // 将模块的执行结果挂在window变量中，在浏览器中this指向window对象
        this[name] = definition();
    }
})('hello', function () {
    var hello = function () {};
    return hello;
});
```

#### 参考

* [module | Node.js API 文档](nodejs.cn/api/modules.html)
* [深入浅出Node.js (豆瓣)](https://book.douban.com/subject/25768396/)

