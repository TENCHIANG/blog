Number、String、Boolean、Undefined(声明了变量，但未给变量初始化值)、null（空对象指针）

三大引用类型：Object、Array、Function

null和undefined的区别：函数没有返回值时，默认返回undefined，作为对象原型链的终点

**栈内存**主要用于存储各种**基本类型的**变量，包括Boolean、Number、String、Undefined、Null，**以及对象变量的指针，存取速度比较快。堆内存主要负责像对象Object这种变量类型的存储

强制转换（parseInt,parseFloat,number）隐式转换（== ===）

split：将字符串切割成数组的形式

join：将数组转换成字符串 

push()尾部添加； pop()尾部删除 ；unshift()头部添加 ；shift()头部删除

slice() 方法可从已有的数组中返回选定的元素

get 和post：一个get参数在url后面 ，post参数放在Request body中，get有长度限制(只能提交少量参数)，安全问题（参数直接暴露在url），请求数据和提交数据，get请求参数会被完整保留在浏览器历史记录里，而post中的参数不会被保留

ajax解析json ：JSON.parse

**事件委托**：利用事件冒泡，让自己的所触发的事件，让他的父元素代替执行

**闭包**就是能够访问其他函数内部变量的函数嘛；过多使用闭包，容易导致内存泄露；因为闭包使得函数不被JS 的垃圾回收机制GC回收嘛。1.希望一个变量长期驻扎在内存当中（不被GC回收）2.避免全局变量的污染  

javascript实现继承机制的核心就是  1  (原型)，因为它不是Java语言那样的类式继承。Javascript在读取一个Object（对象）的属性的值时，会沿着  2  (原型链)向上寻找，如果最终没有找到，则该属性值为 Null；不对，应该是undefined；如果最终找到该属性的值，则返回结果。

**怎么体现javascript的继承关系**：使用prototype原型来实现

**程序中捕获异常**：try catch

**Ajax**是页面无刷新请求数据操作

1.创建对象new XMLHttp...2.open()打开请求，里边的放的是你请求的方法及地址 3.send()发送请求 4.onreadystatechange()接受响应

**Json**只是一种轻量级的数据交换格式。简单值, 数组，对象，简单值包括(字符串，数值，布尔值，null)

**碾平多维**：var flat_entries = [].concat(...entries)

**减低页面加载时间**：1.压缩css、js文件；2.合并js、css文件，减少http请求；3.外部js、css文件放在最底下

**优化代码**：1.代码重用2.避免全局变量3.函数过于臃肿拆分函数4.注释

**跨域**：协议（http/https），主机（主域名/子域名）和端口号（port）有一项不同就构成跨域。跨域的根本原因就是受非同源限制嘛。无法读取非同源的cookie、localstoryge这些造成的。解决方法有jsonp啊，vue、jq、原生请求都支持的。 nodejs中间件代理跨域。nginx代理跨域。跨域资源共享（CORS）。document.domain+iframe(仅限主域相同，子域不同)

**session和cookie**：Session保存在服务器，只把Session ID暴露在外面，所以安全性要好于Cookie。Session保存在服务器的内存、硬盘（持久化）、数据库都可以。Cookie保存在客户端的内存或者硬盘。虽说Session要安全一些，但是session正因为保存在服务端，每个用户都会产生一个Session。假设并发用户非常多的情况下，会产生非常多的Session，耗费大量的内存。但是Cookie保管在客户端的嘛，不占用服务器资源。并发量很大的情况下，还是选择cookie要好点。

**this指向**：在一般函数方法中使用 this 指代**全局对象**。调用window内置函数时，比如setInterval，settimeout，还有匿名函数指向window。作为构造函数调用，this 指代 new **实例化的对象**。作为对象方法调用，this 指代上级对象，也就是说点前面是什么，this就是什么。

every()方法用于检测数组中所有元素是否都符合指定条件，若符合返回true，否则返回false；不会对空数组进行检测，不会改变原来的数组。

some()方法用于检测数组中的元素是否有满足指定条件的，若满足返回true，否则返回false；不会对空数组进行检测，不会改变原来的数组。

map() 方法返回一个新数组，新数组中的每一个元素为原始数组对应每一个元素调用函数处理后的值；不会对空数组进行编辑，不会改变原来的数组。

filter() 方法创建一个新的数组，新数组中的元素是通过检查指定数组中符合条件的所有元素。



**常见的BOM对象**
 window：代表整个浏览器窗口（window是BOM中的一个对象，并且是顶级的对象）
 Navigator ：代表浏览器当前的信息，通过Navigator我们可以获取用户当前使用的是什么浏览器
 Location： 代表浏览器当前的地址信息，通过Location我们可以获取或者设置当前的地址信息
 History：代表浏览器的历史信息，通过History我们可以实现上一步/刷新/下一步操作（出于
 对用户的隐私考虑，我们只能拿到当前的浏览记录，不能拿到所有的历史记录）
 Screen：代表用户的屏幕信息