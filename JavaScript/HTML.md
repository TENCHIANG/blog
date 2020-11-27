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

* 注释以 \<!-- 开头 --> 结尾，支持多行

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