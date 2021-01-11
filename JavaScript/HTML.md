## HTML 语言简介

* HTML，超文本标记语言，HyperText Markup Language
* 20 世纪九十年代由物理学家 Tim Berners-Lee 发明，最大的特点是超链接，点击就可以跳转到其它网页
* 1999，HTML 4.01 发布
* W3C，XHTML 1.0 ---> XHTML 1.0 ---> 语法太严格遂放弃
* 2004，几家公司创立 WAHTWG（网络超文本应用技术工作组，Web Hypertext Application Technology Working Group），创立新标准
* 2006，W3C 加入 WAHTWG
* 2009，W3C 放弃 XHTML，接纳 WAHTWG 标准 ---> HTML5
  * WAHTWG 维护的是 HTML 标准，但两者很接近
* 2014，HTML 5 发布

### 网页的基本概念

#### 标签

* 网页代码由许多标签（tag）组成，标签放在尖括号里
* 大多数标签是成对出现的，结束标签在标签名之前加斜杠，如 title
* 也有的标签是单独出现，只有开始标签（就够了），没有结束标签，如 meta
* 标签名大小写不敏感，一般习惯用小写
* HTML 忽略缩进和换行，网页的各种效果由 CSS 实现

#### 元素

* 浏览器渲染网页时，把 HTML 代码解析成一个标签树，每个标签都是树的节点（node）
* 这些节点也称为网页的元素（element）
* 所以标签，节点，元素是同义词
* 元素可以嵌套元素，外层的叫父元素，内层的叫子元素

#### 块级元素 行内元素

* 所有元素分为两大类：块级元素（block）、行内元素（inline），行内元素也叫内联元素
* 块级元素默认占用一行，占据 100% 宽度，然后另起一行，如 div p
* 行内元素不会换行，如 span

#### 属性

* 属性（attribute）是标签的额外信息，分为属性名和属性值，用等号连接
* 属性名不区分大小写，一般用小驼峰，如 onClick
* 属性值一般用双引号括起来，不是必须的，但推荐这么做
* 不同的标签有不同的多个属性，属性间用空格分隔

### 网页的基本标签

* HTML 5 的标准结构

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <title></title>
</head>
<body>
</body>
</html>
```

#### \<!doctype>

* 网页的第一个标签，表示文档类型，告诉浏览器如何解析网页
* \<!DOCTYPE html> 让浏览器按照 HTML 5 的规则解析网页
* doctype 使用大写是因为严格来说不算标签，更像一个处理指令

#### \<html>

* 网页的顶层容器，也叫根元素（root element），其它元素都是其子元素
* 一个网页只能有一个 \<html> 标签，有一个 lang 属性，表示网页内容的语言
* en 表示英文内容，zh-CN 表示中文简体

#### \<head>

* 该标签是一个容器，放置网页的元信息，不会显示在网页上，而是给网页渲染提供额外信息
* \<head> 是 \<html>  的第一个元素，如果没有也会自动创建一个
* 子元素一共有七个
  * \<meta> 网页元数据
  * \<link> 外部样式表
  * \<style> 内嵌样式表
  * \<title> 网页标题，一般显示在浏览器 tab 上，作为书签名字
  * \<script> 引入脚本
  * \<noscript> 浏览器不支持脚本时，要显示的内容
  * \<base> 网页内部相对 URL 的计算基准

#### \<meta>

* 一个 \<meta> 一个元数据，可以有多个，都要在 \<head> 标签里
* 有 5 个属性

#### charset

* 指定网页的编码方式，一般都用 utf-8
* 注意，charset 是网页渲染时的编码，如果 HTML 源代码使用其它编码保存，可能会乱码

#### name content

* 这个两个是成对出现的，指定一项元数据，name 指定元数据的名字，content 指定元数据的值
* 该类元数据有很多种，大部分涉及浏览器内部工作机制，或特定使用场景

```html
<head>
    <meta name="description" content="HTML 语言入门">
    <meta name="ketwords" content="HTML,教程">
    <meta name="author" content="张三">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="application-name" content="Application Name">
    <meta name="generator" content="program">
    <meta name="subject" content="your document's subject">
    <meta name="referrer" content="no-referrer">
</head>
```

#### http-equiv content

* http-equiv 用来设置 HTTP 响应头的信息字段，content 指定字段内容

```html
<meta http-equiv="Content-Security-Policy" content="default-src 'self'">
<meta http-equiv="Content-Type" content="Type=text/html; charset=utf-8">
<meta http-equiv="refresh" content="30">
<meta http-equiv="refresh" content="30;URL='http://website.com'">
```

#### \<title>

* 网页标题，显示在浏览器标题栏，搜索引擎也会以此来排序（SEO）
* \<title> 里不能再放标签，只能放纯文本

#### \<body>

* 也是个容器标签，放置网页的主体内容，是 \<html> 内第二个元素

### 空格和换行

* 标签内，首尾的空格一律忽略，中间的连续空格看成一个（包括 \t）
* 文本里的换行（\n）回车符（\r）替换为空格
* 所见不所得

### 注释

* 注释以 `<!--` 开头 `-->` 结尾，支持多行

## URL 简介

* URL，统一资源定位符，Uniform Resource Locator，又叫链接、地址、网址
* 资源就是可以通过网络访问的文件，如网页、图像、音视频，脚本等
* 通过 URL 就可以访问资源，一个 URL 对应一个资源，但一个资源可对应多个 URL

### 网址的组成部分

* <协议>://<主机>:<端口>/<路径>?<查询参数>#<锚点>
* URL 有的部分区分大小写，有的部分不区分

#### 协议

* scheme，是访问资源的方法，如 http https，后面跟着冒号双斜杠 ://
* 邮件协议后面只有一个冒号没有斜杠 mailto:username@example.com

#### 主机

* host，表示资源所在的服务器，用域名或者 IP 地址表示

#### 端口

* port，同一个主机下可有多个网站，主机 : 端口区分网站，用冒号连接

#### 路径

* path，是资源在网站的位置，可以是物理真实的位置，也可以是服务器模拟的位置（为了安全）
* 路径可以只包括目录名，服务器通常会补全目录下的文件
* 全看服务器的处理，如 index.html index.php

#### 查询参数

* parameter，是提供给服务器的额外信息，用问号分隔跟在路径后面
* 参数是 k=v 键值对（key-value pair），参数之间用 & 号连接

#### 锚点

* anchor，是网页内的定位点，# 号开头在 URL 最后
* 网页加载后，会自动跳转到锚点的位置
* 锚点名称通过网页元素的 id 属性命名，如 \<p id="锚点名">

### URL 字符

* URL 可以安全的用以下字符（当做纯文本）
  * 英文大小写
  * 数字
  * 连词号（`-`）
  * 句点（`.`）
  * 下划线（`_`）
* 此外还有 18 个特殊意义的保留字，只能出现在特定位置，有特定用法
* 否则会导致 URL 解析错误，或缺斤少两
* 若纯文本包含保留字，需要转义
* 转义的格式为 `%hh` 一字节也就是两个 16 进制（不分大小写），通常是 UTF-8 的编码
* 如果谋个字太长，直接拆按格式接在一起即可
  * `!`：%21
  * `#`：%23
  * `$`：%24
  * `&`：%26
  * `'`：%27
  * `(`：%28
  * `)`：%29
  * `*`：%2A
  * `+`：%2B
  * `,`：%2C
  * `/`：%2F
  * `:`：%3A
  * `;`：%3B
  * `=`：%3D
  * `?`：%3F
  * `@`：%40
  * `[`：%5B
  * `]`：%5D

### 相对 URL 和绝对 URL

* 绝对 URL 就指完整的 URL，本身就能定位到资源
* 相对 URL 则是省略了 URL 的一些部分，补全才能完整的定位资源
* 一般是省略了路径前面的部分，路径的补全根据相对 URL 的前缀来
  * `/` 根目录
  * `.` 当前目录
  * `..` 上级目录
  * 无前缀，当前目录下的文件或目录

#### \<base>

* 使用 \<base> 标签，只能有一个放在 \<head> 里，指定相对 URL 的行为
* 有两个属性 href 和 target，如果写了 \<base>，必须指定一个属性
* href 相对 URL 的前缀
* target 如何打开相对 URL

## 网页元素的属性

元素属性（attribute），以键值对的形式定制元素的行为；不区分大小写，键和值之间用等号 `=` 连接，值一般加双引号；有的属性没有值，相当于布尔值开关，只要属性名即可。

### 全局属性

就是所有元素都可以用的属性。

#### id

元素在网页内的唯一标识符，在 URL 最后，id 值前面加上 `#`，可以作为锚点，可以跳转到相应位置。

如果 id 值包含连接符 `-`，URL 不会做特殊处理。

#### class

对元素分类，表示属于同一个组件；一个元素可以同时具有多个 class 属性值，用空格分隔。

```js
document.body.firstChild.className; // 与元素的 class 属性值一样
document.body.firstChild.classList; // DOMTokenList 数组
```

#### title

元素的附加说明，鼠标悬浮其上时，会显示其属性值。

#### tableindex

网页也可用键盘进行操作，如允许 Tab 键遍历网页元素：元素可以通过 Tab 获得焦点，被称为**焦点元素**或当前元素；可以通过键盘对焦点元素进行操作，如对焦点元素进行回车，就是访问链接或者输入文字。

`tableindex` 属性决定了 Tab 的顺序，属性值是一个整数值

* 负整数：通常是 `-1`，该元素不参与 Tab，但是可以也获得焦点，JS 的`focus`方法
* 零：参与 Tab，但顺序由浏览器决定，通常按源码顺序
* 正整数：参与 Tab，若多个元素 `tableindex` 相同，则按源码顺序

设置为零是有意义的，元素若没有设置 `tableindex`，默认能 Tab 遍历的只有链接、输入框等。

#### accessKey

属性值需是单个可打印字符，只有配合功能键才能获取其焦点

* Windows、Linux：`Alt`
* Mac：`Ctrl + Alt`

注意优先级**低于**浏览器级别快捷键，若有冲突则不会有效。

#### style

元素 CSS 内联样式，语句之间用分号 `;` 分隔。

#### hidden

布尔属性，无元素值，表示该元素不在页面上渲染；但优先级**低于** CSS 的可见性。

#### lang dir

`lang` 指定元素使用的语言，须符合 BCP47 标准：

* zh：中文
* zh-Hans：简体中文
* zh-hant：繁体中文
* en：英语
* en-US：美国英语
* en-GB：英国英语

`dir` 指定改元素的文字内容阅读方向：

* ltr：从左到右，如汉语、英语
* rtl：从右到左，如阿拉伯语、波斯语、希伯来语
* auto：浏览器决定

#### contenteditable

元素的 textContent 是否可编辑，默认不可编辑，非布尔属性：

* true、空字符串：内容可以编辑
* false：不可编辑

JS 中，该属性名为 contentEditable。

```html
<p contenteditable="true">鼠标点击，该文字可以修改</p>
```

对于开关类型的属性，加属性值便于 JS，不加便于 HTML。

网页元素属性值，多个单词则直接或以连接符 `-` 连接，在 JS 则去掉符号，以小驼峰表示。

spellcheck 不是例外，本身只是一个单词而已。

#### spellcheck

是否打开拼写检查，默认打开：

* true：打开
* false：关闭

只有在拼写检查已打开，且可编辑时，错误的单词才会被提示

```html
<p contenteditable="true" spellcheck="true">separate 容易写错成 seperate</p>
```

#### data-

元素的自定义附加数据，也叫数据集（dataset），方便 CSS、JS 获取。

JS 通过元素的 dataset 属性访问，为一个 DOMStringMap 对象，其中的附加数据，其属性名去掉 `data-` 前缀、连接符变小驼峰。

CSS 则通过属性选择器和 attr 获取，本质上是访问网页元素的属性。

```html
<a href="#" class="tooltip" data-tip="tip">链接</a>
<div data-role-name="mobile">Mobile only content</div>
<style>
    .tooltip { display: inline-block; }
    .tooltip:after { content: attr(data-tip); }
    div[data-role-id="mobile"] { display: none; }
</style>
<script>
    document.querySelector("body > div").dataset.roleName;
</script>
```

参考：[jQuery.data() 的实现方式 - 裴小星的博客 - ITeye博客](https://www.iteye.com/blog/xxing22657-yahoo-com-cn-1042440)

#### 事件处理属性

event handler，用来响应用户的动作，属性名一般以 `on-` 开头，属性值都是 JS 代码：

> onabort, onautocomplete, onautocompleteerror, onblur, oncancel, oncanplay, oncanplaythrough, onchange, onclick, onclose, oncontextmenu, oncuechange, ondblclick, ondrag, ondragend, ondragenter, ondragexit, ondragleave, ondragover, ondragstart, ondrop, ondurationchange, onemptied, onended, onerror, onfocus, oninput, oninvalid, onkeydown, onkeypress, onkeyup, onload, onloadeddata, onloadedmetadata, onloadstart, onmousedown, onmouseenter, onmouseleave, onmousemove, onmouseout, onmouseover, onmouseup, onmousewheel, onpause, onplay, onplaying, onprogress, onratechange, onreset, onresize, onscroll, onseeked, onseeking, onselect, onshow, onsort, onstalled, onsubmit, onsuspend, ontimeupdate, ontoggle, onvolumechange, onwaiting

## 字符编码

通过网页的响应头：

```
Content-Type: text/html; charset=UTF-8
```

通过网页的 `<meta>` 标签：

```html
<meta charset="UTF-8">
```

### 码点

code point：每个字符的数字表示；因为不是所有字符都是可打印的：

* 控制字符：如换行、回车
* 有特殊意义的：如大于小于号，HTML 中用来包括标签
* 没有一种输入法，可以输入所有 Unicode 字符
* 网页不允许混合多种字符编码

HTML 使用码点：`&#` 开头的十进制，或 `&#x` 开头的十六进制；注意码点只能表示**文本内容**，不能表示标签会被当成文本内容，所以码点也有转义的效果。

```html
<p>hello</p> <!-- 等同于 -->
<p>&#104;&#101;&#108;&#108;&#111;</p>
<p>&#x68;&#x65;&#x6c;&#x6c;&#x6f;</p>
```

在 HTML 文本内容中，码点也叫实体编号，实体也叫实体名称，都比直接打字符强（如空格）。

不管是数字表示还是实体表示，都可以表示正常情况无法输入的字符，逃脱（escape）了浏览器的限制，也叫转义。

### 字符实体

entity：除了码点用数字表示字符，HTML 还可用 `&` 开头 `;` 结尾的若干字符，表示一个字符，相当于为字符取了别名：

* 连续空格：`&nbsp;`、`<` `&lt;`、`>` `&gt;`、`"` `&quot;`、`'` `&apos;`、`&` `&amp;`、`©` `&copy;`、`®` `&reg;`
* `#` `&num;`、`§` `&sect;`、`¥` `&yen;`、`$` `&dollar;`、`£` `&pound;`、`¢` `&cent;`、`%` `&percnt;`、`*` `&ast;`
* `@` `&commat;`、`^` `&Hat;`、`±` `&plusmn;`

参考：[Character Entity Reference Chart](https://dev.w3.org/html5/html-author/charref)、[HTML 字符实体](www.3wschool.com.cn/html/html_entities.htm)

## 网页的语义结构

每个 HTML 标签都是有语义（semantic）的，要根据其语义用，不要随便用，这样可维护性才高；所谓符合语义即：在恰当的位置使用恰当的标签。

```html
<body>
    <header> <!-- 页眉 -->
        <h1>公司名称</h1>
        <ul>
            <li><a href="/home">首页</a></li>
            <li><a href="/about">关于</a></li>
            <li><a href="/contact">联系</a></li>
        </ul>
        <form target="/search">
            <input name"q" type="search" />
            <input type="submit" />
        </form>
    </header>
    <main> <!-- 主体 -->
        <article>
            <header>
                <h1>文章标题</h1>
                <p>张三，发表于2010年1月1日</p>
                <aside>
                	<p>本段是文章的重点。</p>
                </aside>
            </header>
            <footer>
                <p>© 禁止转载</p>
            </footer>
        </article>
    </main>
    <aside>侧边栏</aside>
    <footer> <!-- 页尾 -->
    	<p>&copy; 2020 XXX 公司</p>
    </footer>
</body>
```

#### header

可用于多个场景，所以网页可以有多个 header 标签，但是一个具体场景只能有一个，如网页只能有一个页眉；同时 header 标签里也不能直接包含 header 或 footer 标签。

* 网页的头部（页眉）：可放网站导航和搜索栏
* 文章的头部：放文章标题、作者
* 区块的头部

#### footer

也可用于多个场景，但是内部不能放 footer、header，与 header 类似

* 网页尾部（页尾）：版权信息
* 文章尾部
* 章节尾部

#### main

表示页眉的主体，只能有一个；且是顶层标签，不能放在 header、footer、article、aside、nav 等标签中。

此外搜索栏等功能性区块不要放页面主体，除非当前就是搜索页面。

#### article

表示页面里面一段完整的内容，具有独立的意义，如一篇文章，一个页面可有多个。

#### aside

与网页或文章间接相关的部分：

* 侧边栏（不一定在侧边）
* 文章级别的 aside：评论、注释

#### section

一个含有主体的独立部分，如文章的章节、段落，一般不能只有一个；也适合表示幻灯片：一个 section 一页幻灯片；一般 section 都有标题（h1 ~ h6），一个 article 可以包括多个 section 反之亦然。

```html
<article>
	<h1>文章标题</h1>
    <section>
        <h2>第一章</h2>
    	<p>...</p>
    </section>
    <section>
        <h2>第二章</h2>
    	<p>...</p>
    </section>
</article>
```

#### nav

页面或文档的导航信息，一般在 header 标签里，不在 footer 里；可有多个：一个站点导航、一个文章导航。

```html
<nav>
  <ol>
    <li><a href="item-a">商品 A</a></li>
    <li><a href="item-b">商品 B</a></li>
    <li>商品 C</li>
  </ol>
</nav>
```

#### h1 ~ h6

标题，有六个等级，叫做标题几；下一级标题是上一级标题的子标题，同级标题可以有多个，但不要越级。

```html
<body>
  <h1>JavaScript 语言介绍</h1>
    <h2>概述</h2>
    <h2>基本概念</h2>
      <h3>网页</h3>
      <h3>链接</h3>
    <h2>主要用法</h2>
</body>
```

#### hgroup

如果主标题包含多级标题，如副标题；hgroup 只能包含 h1 ~ h6，不能包含其他标签。

```html
<hgroup>
  <h1>Heading 1</h1>
  <h2>Subheading 1</h2>
  <h2>Subheading 2</h2>
</hgroup>
```

