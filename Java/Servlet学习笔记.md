## Servlet学习笔记

JSP本质上也是Servlet，因为最终会编译成Servlet

### Apache Tomcat Versions

| Tomcat | Servlet | JSP  | EL   | WebSocket | JASIC |
| ------ | ------- | ---- | ---- | --------- | ----- |
| 10     | 5.0     | 3.0  | 4.0  | 2.0       | 2.0   |
| 9      | 4.0     | 2.3  | 3.0  | 1.1       | 1.1   |



### 手动编译Servlet
```sh
javac \
-classpath tomcat/lib/servlet-api.jar \
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