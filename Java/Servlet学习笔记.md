## Web 应用程序基础

### Uniform Resource Locator

* URL（统一资源定位符）最早出现，目的是以文字的方式来说明互联网上的资源如何取得
* RFC1738 格式：\<scheme>:\<scheme-specific-part> 分为协议和协议特定部分
  * 协议（何种方式取得资源）
    * FTP：File Transfer Protocol 文件传输协议
    * HTTP：Hypertext Transfer Protocol 超文本传输协议
    * Mailto：电子邮件
    * File：特定主机文件
  * 协议特定部分：//\<username>:\<password>@\<host>:\<port>/\<path>

### Uniform Resource Name

* URN（统一资源名）代表某个资源唯一的名词
* RFC2141 格式：urn:\<NID>:\<NSS>
* 如国际标准书号（International Standard Book Number，ISBN）就可以用 URN 表示
  * urn:isbn:978-7-302-50118-3

### Uniform Resource Identifier

* URI（统一资源标识符）统一 URL 和 URN
* RFC3986 格式：\<scheme>:\<hier-part>\[?\<query>]\[#\<fragement>]
  * query 是问号打头的，fragment 是井号打头的
  * hierarchical part（分级的部分）：//\<authority>\<path>
  * authority：\<user information>@\<host>:\<port>
    * user information：\<username>:\<password>
  * path 也分很多种：
    * path-abempty 以 / 开头的路径或空路径
    * path-absolute 以 / 开头但不能以 // 开头
    * path-noscheme 以非 : 号开头的路径
    * path-rootless 在 noscheme 基础上，允许 : 号开头
    * path-empty 空路径
* [今天，彻底弄懂什么是URI_AdolphKevin的博客-CSDN博客_uri是什么](https://blog.csdn.net/AdolphKevin/article/details/100088586)

### URL 编码

* URL URN URI 都是 ASCII 码，如果超出了，则需要编码

* URL 编码也叫 URI 编码、百分比编码，RFC1738 规定

* > 只有字母和数字[0-9a-zA-Z]、一些特殊符号"$-_.+!*'(),"[不包括双引号]、以及某些保留字，才可以不经过编码直接用于URL

* 致命的是，RFC1738 没有规定具体的编码方法，导致了 URL 编码的混乱

1. 地址栏路径的编码是 UTF-8 编码，编码为 %hh 的形式（两个 16 进制**一字节**为一组 % 号打头）

2. 地址栏查询字串的编码是系统默认的编码

   * IE6：汉字编码是 GB2321，直接编码（看起来是乱码）
   * Firefox：汉字编码 GB2312，编码为 %ff 的形式

3. GET POST 发出的 URL，由网页本身的编码决定

   * <meta http-equiv="Content-Type" content="text/html;charset=xxxx">

4. Ajax 的查询字串，IE 总是采用系统默认编码 %hh，Firefox 总是采用 UTF-8 编码 %hh

* URI 和 HTTP 保留字的不同

   * URI 空格：%20
   * HTTP 空格：+（java.net.URLEncoder.encode）

#### 统一 URL 编码

* escape()  编码为 %uffff，解码是 unescape()
  * js 函数的输入输出都是 Unicode 编码
  * escape 不对 + 号编码，但服务器会处理成空格
* encodeURI 对整个 URL 编码，不会对 ` ~ ! @ # $ & * ( ) = : / , ; ? + '` 进行编码
* encodeURIComponent 对 URL 的部分编码（参数也是 URL），对特殊符号也编码

* [关于URL编码 - 阮一峰的网络日志](www.ruanyifeng.com/blog/2010/02/url_encoding.html)
* [【基础进阶】URL详解与URL编码 - ChokCoco - 博客园](https://www.cnblogs.com/coco1s/p/5038412.html)
* [字符编码笔记：ASCII，Unicode 和 UTF-8 - 阮一峰的网络日志](www.ruanyifeng.com/blog/2007/10/ascii_unicode_and_utf-8.html)

### scheme 和 schema 的区别

* 两个词现在已经几乎没有区别了
* 如果一定要区分的话，scheme 比 schema 更具体一些
* scheme 指的是一套方案，而 schema 则是概要（而且这个词和图表很有关系）
* [schema 与scheme的区别&联系？_百度知道](https://zhidao.baidu.com/question/131192166.html)

### HTTP 协议

* 超文本传输协议（Hyper Text Transfer Protocol，HTTP）的两个重要特性
  * 基于请求（Request）和响应（Response）的模型（没有请求就不会有相应）
  * 无状态（Stateless）的协议
    * REST（Representational State Transfer）是无状态的
    * 符合 REST 架构的系统成为 RESTful
  * 所以才需要从 MVC（Model-View-Controller Pattern）转为 Model 2
  * 所以才需要会话管理（Session management）
* HTTP 是万维网协会（World Wide Web Consortium，W3C）和因特网工作小组（Internet Engineering Task Force，IETF）的合作结果，发布了一些列 RFC（Request For Comments）
* RFC1945 定义了 HTTP1.0
* HTTP1.1（RFC2616） 支持 Pipelining，对服务器发出多次请求，服务器按顺序来响应
* HTTP2.0（RFC7540） 支持 Server Push，运行服务器收到请求后，主动推送必要的资源到浏览器，不用浏览器发出请求
  * HTTP/2 脱胎于谷歌的 SPDY 协议
  * HTTP/2 不强制基于 TLS，叫做 H2C（HTTP/2 Cleartext）
  * HTTP/2 基于二进制帧，不同于 HTTP/1 文本格式的报文
* HTML5 支持 Server Sent Event，在请求后，服务端的响应一直保持下载状态，客户端知道有哪些数据
* HTTP 是应用层协议，是标准的 B/S 模型，通常基于 TCP，也可基于 TLS SSL 协议上（HTTPS）

#### GET 还是 POST

* 敏感信息，如密码等，适合 POST
* GET 更适合书签
* GET 更适合缓存，当然指定 Cache-Control、Expires 头可用 POST 缓存
* GET HEAD PUT DELETE 是等幂（Idempotent）的，单次和多次的效果一样（最多怎么怎么样）
  * OPTIONS TRACE 本身不应该有副作用，所以也等幂
  * GET HEAD 语义在于**取得**，而不是去修改什么
* POST 的副作用在于非等幂，单次和多次不一样（起码怎么怎么样，如新建了多个）
  * POST：URI 不代表资源（附加的实体），资源在请求体
  * PUT：URI 代表资源，服务器不存在则新建，存在则更新（确保存在最新）
* 尊重 HTTP 动词的语义，就是语义化编程

### MVC Model 2

* Servlet 夹杂 HTML 和 JSP 加载 Java 代码都不好
* 所以把程序根据职责划分为了 MVC（Model-View-Controller）
  * 模型（数据）：模型通知视图数据已更改要改变视图
  * 视图 （面向用户）：用户通过视图通知控制器执行操作
  * 控制器（业务逻辑）：控制器更新模型的状态（更改数据）
* 然而因为 HTTP 的特性，没有请求就不会有响应，Web 应用不适合 MVC，优化为 Model 2
  * 模型：业务逻辑，数据存取，接受控制器的调用（模型对象也可以分几类），JavaBean、EJB
  * 视图：用户交互，接受控制器的调用，从模型取出结果，根据页面逻辑呈现所需画面，JSP
  * 控制器：取得并验证请求，转发到视图用来显示，或到模型用来处理，Servlet

### Web 安全

* [OWASP Top Ten Web Application Security Risks | OWASP](https://owasp.org/www-project-top-ten/)
  * 三年更新一次，上次更新 2017 年
  * 注入：未经验证的输入
  * XSS：未经过滤的输出
* [CWE - Common Weakness Enumeration](cwe.mitre.org) 通用软件的弱点
* [CVE - Common Vulnerabilities and Exposures (CVE)](cve.mitre.org) 特定软甲漏洞

### Java EE 简介

* JCP（组织） -> JSR（标准） -> RI（实现）
* JSR 366 -> Java EE 8
* JSR 369 -> Servlet 4.9
* JSR 245 -> JSP 2.3
* JSR 341 -> Expression Language 3.0
* JSR 52 -> JSTL 1.2
* https://jcp.org/en/jsr/detail?id=

## Servlet 学习笔记

* JSP、各种 Spring 框架，本质上都是 Servlet
  * Servlet ->  HTTPServlet <- HttpJspBase <- JSP
  * JSP 只能用于 GET POST HEAD 动词
* Web 容器是（Container）是运行 Servlet JSP 的 HTTP 服务器，也是用 Java 编写的
* 收到 HTTP 请求 -> HTTP 服务器 -> Web 容器处理 -> HTTP 服务器 -> 发送 HTTP 响应
  * 把请求解析为各种对象：HttpServletRequest、HttpServletResponse、HttpSession
  * 根据 URI 调用 Servlet 处理请求（程序员编写部分）
  * Servlet 根据请求对象 HttpServletRequest 决定如何处理，通过 HttpServletResponse 创建响应
* Web 容器为每个请求分配一个线程，可能会使用同一个 Servlet 处理多个请求（多线程共享一个对象）

### Apache Tomcat Versions

| Tomcat | Servlet | JSP  | EL   | WebSocket | JASIC | Java  |
| ------ | ------- | ---- | ---- | --------- | ----- | ----- |
| 10     | 5.0     | 3.0  | 4.0  | 2.0       | 2.0   | \>= 8 |
| 9      | 4.0     | 2.3  | 3.0  | 1.1       | 1.1   | \>= 8 |
| 8.5    | 3.1     | 2.3  | 3.0  | 1.1       | 1.1   | \>= 7 |

* [Apache Tomcat® - Which Version Do I Want?](https://tomcat.apache.org/whichversion.html)

### 手动编译 Servlet

```sh
javac \
-cp tomcat/lib/servlet-api.jar \
-d ./classes/src/org/example/Hello.java
```

### javax.servlet
* Servlet
	**接口Servlet定义了基本行为**，如与生命周期相关的`init()`、`destroy()`方法，提供服务时要调用的`service()`方法等
* GenericServlet
	**接口Servlet、ServletConfig的实现**，不限定具体的网络协议
* ServletRequest
* ServletResponse

### javax.servlet.http
Servlet不限定只能使用HTTP协议，所以单独拎出来
* HttpServlet
* HttpServletRequest
* HttpServletResponse

### HttpServlet.service()
这就是为什么要覆写doGet、doPost等方法的原因（但别覆写HttpServlet.service本身），因为请求来时，会先判断是什么HTTP动词，然后再调用对应的方法（设计模式的Template Method模式）
```java
protected void service (HttpServletRequest req, HttpServletResponse res) 
throws ServletException, IOException {
	String method = req.getMethod(); // 取得请求的方法
	if (method.equals(METHOD_GET)) {
        // ...
		doGet(req, res);
        // ...
	} else if (method.equals(METHOD_POST)) {
        // ...
		doPost(req, res);
        // ...
	} else if (method.equals(METHOD_PUT)) {
		// ...
	}
}
```
### @WebServlet：用标注定义Servlet
Servlet3.0（JavaEE6.0）之后，可以使用**标注（Annotation）**来告诉Web容器关于Servlet的一些信息，Servlet3.0之前用的是**web.xml**
```java
@WebServlet("/hello")
public class Hello extends HttpServlet {
// ...
}
```
只要Servlet上设置@WebServlet标注，容器就会自动读取其中的信息：如果请求的URI是/hello，则由Hello的实例提供服务。

#### @WebServlet还可以提供更多的信息
```java
@WebServlet(
	name="hello", // 指定Servlet的名称 默认为 类名
	urlPatterns={"/hello"}, // 指定URI 默认为 /类名
	loadOnStartup=1 // 程序启动时就初始化该Servlet类 默认为 -1 表示不会主动初始化
)
public class Hello extends HttpServlet {
// ...
}
```

#### loadOnStartup
Servlet类默认不会主动初始化（-1），只有在请求需要调用某个Servlet服务时，才将对应Servlet类载入、实例化、初始化，然后才真正的开始处理请求。
loadOnStartup如果设置大于-1的值，则表示程序启动后就初始化Servlet类。数字代表初始化的顺序，容器从较小的数字开始初始化，如果数字相同，容器实现厂商则可以自行规定（标准未定义）。

### 用web.xml定义Servlet
Servlet3.0（JavaEE6.0）之前，是在**WebContent/WEB-INF/web.xml**文件定义的（现在也可以）。
#### 用eclipse创建web.xml
假设项目名为`FirstServlet`，在右边`Project Explorer`，展开项目根节点，右键`Deployment Descriptor: FirstServlet`节点，在弹出的菜单里点击`Generate Deployment Descriptor Stub`，就会生成web.xml，里面默认内容为：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://xmlns.jcp.org/xml/ns/javaee" xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd" version="4.0">
  <display-name>FirstServlet</display-name>
  <welcome-file-list>
    <welcome-file>index.html</welcome-file>
    <welcome-file>index.htm</welcome-file>
    <welcome-file>index.jsp</welcome-file>
    <welcome-file>default.html</welcome-file>
    <welcome-file>default.htm</welcome-file>
    <welcome-file>default.jsp</welcome-file>
  </welcome-file-list>
</web-app>
```
这样的文件叫**部署描述文件（Deployment Description, DD文件）**。因为创建项目的时候，`Dynamic web module version`选择的是4.0（Servlet4.0），XSD文件为web-app_4_0.xsd，version为4.0。

`<display-name>`代表Web应用程序的名称，Tomcat默认会使用应用程序目录（项目名）作为**环境根目录（Context root）**如*localhost:8080/FirstServlet/*，也可以在`META-INF/context.xml`中设置环境根目录。

**用eclipse设置环境根目录**：右键项目，选择`Properties`，在`Web Project Settings`中设置环境根目录。

**Servlet4.0的`<default-context-path>`建议默认环境根目录**：为啥叫建议，因为得考虑向下兼容，容器实现可以不理会这个设置。

web.xml可以覆盖Servlet中的标注，所以可以**用标注做默认值，web.xml做更新值**：

```xml
<servlet>
    <servlet-name>Hello</servlet-name>
    <servlet-class>org.example.Hello</servlet-class>
    <load-on-startup>1</load-on-startup>
</servlet>
<serlvet-mapping>
    <servlet-name>Hello</servlet-name>
    <url-pattern>/helloUser</url-pattern>
</serlvet-mapping>
```

如果`<load-on-startup>`数字相同，则按照在web.xml的书写顺序来初始化Servlet。

`<url-pattern>`设置的**逻辑名称（Logical Name）**/helloUser覆盖了标注的/hello，所以必须得用/helloUser才能访问到该Servlet。

无论是标注还是xml，URI都只是逻辑名称，最终会由Web容器对应到实际处理请求的程序**实体名称（Physical Name）**或文件，甚至可以设置伪装后的名称，如/hello.jsp。

`<servlet-name>`：设置Servlet的名称
`<servlet-class>`：设置实体类名称（编译好的Servlet在`WEB-INF/classes`即可运行）
`<url-pattern>`：设置逻辑名称

### 文件组织和部署

部署在Web容器上的文件组织与IDE开发环境下的不太一样, 要求把**WEB-INF**从**WebContent**中弄出来, 位于程序根目录下

* FirstServlet
  * WEB-INF *应用程序内部资源, 客户端无法直接访问*
    * web.xml *部署描述文件*
    * lib *放置jar文件*
      * xxx.jar
    * classes *按包结构摆放的类文件*
      * com
        * example
          * HelloServlet.class
  * WEB-INF

再把整个项目放在tomcat的webapps文件下, 然后运行bin/startup命令启动就可以运行啦

* tomcat
  * webapps
    * FirstServlet

实际上的部署会把项目打包成**war(Web Archive)**文件, 可以用JDK的jar命令来生成

```sh
cd FirstServlet
jar cvf ../FirstServlet.war *
```

或者使用**eclipse**, 右键项目, `Export`, `WAR file`把项目导出成war文件. war文件本质就是打包好的**zip文件**, 放在tomcat/webapps目录下, 下次启动时, 容器检测到有war文件, 会将其**解压**, 并载入web程序

### URI模式设置

**requestURI = contextPath + servletPath + pathInfo**

#### requestURI

* 可以通过`HttpServletRequest.getRequestURI()`获取

#### contextPath（环境路径）

* 可以通过`HttpServletRequest.getContextPath()`获取

* **环境路径**的设置在Servlet4.0之前没有规范，容器决定使用哪个Web应用程序（一个容器可部署多个）
* 如果**环境路径 == 网站根目录**：环境路径为空字符串
* 如果**环境路径 != 网站根目录**：环境路径以**“/”**开头，但不以**“/”**结尾

#### servletPath（Servlet路径）

* 可以通过`HttpServletRequest.getServletPath()`获取

一旦决定是哪个是哪个Web应用程序来处理请求，接下来就是那个具体Servlet的事情了，Servlet必须设置URI模式：

* **路径映射（PATH）**
  * 以**“/”**开头，以**“/*”**结尾。如**/xxx/***（/xxx/a、/xxx/b）
* **扩展映射（EXTENSION）**
  * 以**“*.”**开头。如***.view**（以这个结尾的请求）
* **环境根目录（CONTEXT_ROOT）**
  * 空字符串也算URI模式，对应环境根目录**“/”**（这个Web应用程序的根目录）
  * 如http://host:port/app/，对于Servlet来说，路径就是**“/”**
  * **servletPath、pathInfo都为空**
* **预设Servlet（DEFAULT）**
  * 所有请求都**没有匹配**，就会用默认Servlet（比如404）
  * 默认的servlet是配置在`$catalina/conf/web.xml`里面
* **完全匹配（EXACT）**
  * 多了一个反斜杠都不行（pattern为/hello实际URI为/hello/都不行）
  * URI映射Servlet的原则是，先先精确后宽泛，先小后大，优先级最低的就是预设的Servlet
    * **EXACT > PATH > EXTENSION > CONTEXT_ROOT > DEFAULT**

#### pathInfo（路径信息）

可以通过`HttpServletRequest.getPathInfo()`获取**（注意：路径信息不包括请求参数）**

* 有额外的路径信息，返回**斜杠开头的字符串**
* 没有额外的路径信息，返回**null**
  * 扩展映射
  * 完全匹配
  * 预设Servlet

#### urlPatterns为"/servlet/*"的实例

访问`http://localhost:8080/FirstServlet/servlet/yy`

```text
requestURI: /FirstServlet/servlet/yy
contextPath: /FirstServlet
servletPath: /servlet
pathInfo: /yy
```

#### HttpServletMapping

Servlet4.0中，`HttpServletRequest`新增了`getHttpServletMapping()`方法，可以取得`javax.servlet.http.HttpServletMapping`对象

**HttpServletMapping对象**

* getMappingMatch()，返回 javax.servlet.http.MappingMatch 枚举值
  * EXACT
  * PATH
  * EXTENSION
  * CONTEXT_ROOT
  * DEFAULT
* getMatchValue()，返回实际上符合的值
  * 如果是PATH就是pathInfo
  * **没有反斜杠**
* getPattern()，返回Servlet设置的URI模式（urlPatterns）

**举个例子**

* urlPatterns ---> /mapping/*
  * URI ---> http://localhost:8080/FirstServlet/mapping/aaa
  * getMappingMatch ---> PATH
  * getMatchValue ---> aaa
  * getPattern --->  /mapping/*
* urlPatterns -> /hello
  * URI ---> http://localhost:8080/FirstServlet/hello
  * getMappingMatch ---> EXACT
  * getMatchValue ---> hello
  * getPattern --->  /hello

### Web文件夹结构

**Web引用程序的组成**

* 静态资源（网页相关文件）
* Servlet
* JSP
* 自定义类
* 工具类
* 部署描述文件（web.xml）
* 设置信息（Annotation）

根目录的文件基本都能下载，如index.html