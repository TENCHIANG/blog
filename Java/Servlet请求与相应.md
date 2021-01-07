### Web 容器做了什么

* 创建 Servlet 实例，完成 Servlet 名称注册、URI 模式对应
* 请求 ---> HTTP 服务器 ---> Web 容器
  * 创建 HttpServletRequest，当前请求
  * 创建 HttpServletResponse，当前响应
  * 根据 @WebService 标注、web.xml，找到对应的 Servlet
  * 将请求、响应对象作为参数，调用其 service 方法
    * 根据 HTTP 请求动词，调用对应的 doXXX 方法（业务逻辑）
    * getParameter，取请求参数
    * getWriter，取响应输出的 PrintWriter
  * 容器将响应对象，转为 HTTP 响应，转发给 HTTP 服务器
  * 容器将请求、响应对象销毁

### 动词方法 doXXX

* 容器调用 Servlet 的 service 方法
* 但这个 service 声明的是 ServletRequest、ServletResponse（javax.servlet）
  * 容器创建的确实是 HttpServletRequest、HttpServletResponse（javax.servlet.http）的实现类
  * 所以做了一个转换，然后调用了另一个 service 方法，此时声明就对了
  * 这个 service 会根据动词，req.getMethod()，调用相应的 doXXX 方法
    * 所以要实现对应的动词方法
    * doGet、doPost、doPut、doDelete、doHead、doOptions、doTrace

```java
// HttpServlet
public void service(ServletRequest req, ServletResponse res)
    throws ServletException, IOException {
    HttpServletRequest request;
    HttpServletResponse response;
    try {
        request = (HttpServletRequest) req;
        response = (HttpServletResponse) res;
    } catch (ClassCastException e) {
        throw new ServletException("non-HTTP request or response");
    }
    service(request, response);
}
public void service(HttpServletRequest req, HttpServletResponse res)
    throws ServletException, IOException {
    String method = req.getMethod();
    if (method.equals(METHOD_GET)) {
        long lastModified = getLastModified(req);
        if (lastModified == -1) {
            doGet(req, res);
        } else {
            long ifModifiedSince;
            try {
                ifModifiedSince = req.getDateHeader(HEADER_IFMODSINCE);
            } catch (IllegalArgumentException e) {
                ifModifiedSince = -1;
            }
            if (ifModifiedSince < (lastModified / 1000 * 1000)) {
                maybeSetLastModified(res, lastModified);
                doGet(req, res);
            } else {
                res.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
            }
        }
    } else if (method.equals(METHOD_HEAD)) {
        long lastModified = getLastModified(req);
        maybeSetLastModified(res, lastModified);
        doHead(req, res);
    } else if (method.equals(METHOD_POST)) {
        doPost(req, res);
    }
}
```

* 对于 GET 请求，可以实现 getLastModified 方法，返回毫秒级时间戳
  * 默认返回 -1：不支持 if-modified-since 头
  * 返回的如果晚于浏览器的头，才执行 doGet
* 若在继承 HttpServlet 后，没有重新定义动词方法，则会收到错误消息

```java
protected void doGet(HttpServletRequest req, HttpServletResponse res)
    throws ServletException, IOException {
    String protocol = req.getProtocol();
    String msg = lStrings.getString("http.method_get_not_supported");
    if (protocol.endsWith("1.1")) {
        res.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, msg);
    } else {
        res.sendError(HttpServletResponse.SC_BAD_REQUEST, msg);
    }
}
```

### HttpServletRequest

* 可以在 Servlet 中，用该请求对象进行处理（请求参数、请求头）
* 也可以转发给另一个 Servlet 处理
* Servlet 间公用的数据，可设置为请求对象的属性

#### 处理请求参数

* getParameter，指定参数名，获取参数值，返回字符串否则 null
* getParameterValues，指定参数名，返回所有的值（字符串数组）
  * 查询字符串允许一个参数有多个值
* getParameterNames，全部参数名，Enumeration\<String>
  * hasMoreElements
  * nextElement
  * Enumeration 是 JDK1.0 就存在，类似 Iterator
    * 可用 Collections.list 将其转为 ArrayList
* getParameterMap，返回 Map\<String, String[]>
* 永远别假设请求者会按照期望提供请求信息
  * XSS（Cross Site Script）
  * SQL Injection
  * 将特殊符号转为，HTML 的实体名称（Entity name）
  * 拦截器（Interceptor）、过滤器（Filter）

```java
String name = Optional.ofNullable(req.getParameter("name"))
    .map(v -> v.replaceAll("<", "&lt;"))
    .map(v -> v.replaceAll("<", "&gt;"))
    .orElse("Guest"); // 默认
res.getWriter().print("<p><Hello, %s!/p>", name);
```

#### 处理请求头

* getHeader 指定名，返回值
  * getIntHeader 返回 int 否则 NumberFormatException
  * getDataHeader 返回 Date 否则 IllegalArgumentException
* getHeaders 指定名，返回所有值，Enumeration\<String>
* getHeaderNames 全部名，Enumeration\<String>

```java
PrintWriter out = res.getWriter();
Collections.list(req.getHeaderNames())
    .forEach(name -> {
    	out.printf("%s: %s<br>", name, req.getHeader(name)); 
    });
```

#### 请求参数编码

* 若浏览器没有设置 Content-Type 头
  * 如 Content-Type:text/html;charset=UTF-8
  * req.**getCharacterEncoding** 返回 null
  * 此时使用容器默认编码
    * web.xml 的 `<request-character-encoding>UTF-8</request-character-encoding>`
    * 整个应用程序的请求参数编码
* 也可以在**初次**取请求参数前 `req.setCharacterEncoding("UTF-8")` 之后就没效果了
  * 区别于 `res.setContentType("text/html;charset=UTF-8")`
  * 也可以写在 Filter 组件
  * 只针对请求体（POST）
  * GET 规范没确定，因为处理 URI 的毕竟是 HTTP 服务器

```java
java.net.URLEncoder.encode("林", "UTF-8"); // 浏览器
java.net.URLDecoder.decode("%E6%9E%97", "UTF-8");
```

#### 读取内容 getReader getInputStream

* req.getReader，可以读请求体，返回 BufferedReader

```java
private String bodyContent(BUfferedReader reader) throws IOException {
    String input = null;
    StringBuilder reqBody = new StringBuilder();
    while ((input = reader.readLine()) != null)
        reqBody.append(input).append("<br>");
    return reqBody.toString();
}
```

