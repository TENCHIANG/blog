### 原理

* 通过代理（默认开启），拦截发送流量和接收流量（断点），并做中间人攻击
  * File –> Capture Traffic F12（捕获通信）

* 一般会自动设置系统代理和浏览器代理，如果浏览器代理没设置成功，要手动设置**12**
* fd断点：
  * Before response 发送拦截
  * After response 接收拦截
* 安装证书：http://localhost:8888/FiddlerRoot.cer
* 解密HTTPS原理
  * 通过伪造CA证书来欺骗浏览器和服务器
  * 浏览器面前Fiddler伪装成一个HTTPS服务器
  * 而在真正的HTTPS服务器面前Fiddler又装成浏览器

### 抓包工具对比

* Wireshark：七层协议全解码，不会漏（基于网卡，但是没有封包功能？）
* Fidder：抓HTTP、HTTPS更方便（基于C#，开源免费）
* Charles：类似Fidder（基于Java，收费）
* Chrome开发者工具、firebug：与JavaScript深度结合

### 主界面

* 主界面工具栏 - 取消勾选 数据流
* 主界面工具栏 - 勾选 解码
* 主界面底部
  * 捕获开关
  * 过滤器
  * 中断开关

### Tools-Options选项设置

* General
  * Enable hight-resolution timers（启用高分辨率计时器）
* HTTPS
  * Capture HTTPS CONNECTs（捕获HTTPS连接）
  * Decrypt HTTPS traffic（解密HTTPS通信）
  * ...from remote client only（从远程客户端）
  * Ignore server certificate errors (unsafe)（忽略服务器证书错误）
  * Check for certificate revocations（检查证书吊销状态）
* Connections
  * 取消 Capture FTP requests
  * 勾选 Allow remote computers to connect（手机模拟器抓包关键）
  * 取消 Use PAC Script

### 设置断点

* 主界面左下角
  * 箭头上：发送拦截
  * 箭头下：接收连接
* 规则 - 自动断点
  * 在请求之前 F11
  * 之后相应 Alt+F11
  * 已禁用 Shift+F11

### 左边面板

| **名称**                                                     | **含义**                                                   |
| :----------------------------------------------------------- | :--------------------------------------------------------- |
| #                                                            | 抓取HTTP Request的顺序，从1开始，以此递增                  |
| Result                                                       | HTTP状态码                                                 |
| Protocol                                                     | 请求使用的协议，如HTTP/HTTPS/FTP等                         |
| Host                                                         | 请求地址的主机名                                           |
| URL                                                          | 请求资源的位置                                             |
| Body                                                         | 该请求的大小                                               |
| Caching                                                      | 请求的缓存过期时间或者缓存控制值                           |
| Content-Type                                                 | 请求响应的类型                                             |
| Process                                                      | 发送此请求的进程：进程ID                                   |
| Comments                                                     | 允许用户为此回话添加备注                                   |
| Custom                                                       | 允许用户设置自定义值                                       |
| 图标                                                         | 含义                                                       |
| ![clip_image001[13]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234159468-1047137951.gif) | 请求已经发往服务器                                         |
| ![clip_image002[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234200047-1757509080.gif) | 已从服务器下载响应结果                                     |
| ![clip_image003[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234201406-1416873112.gif) | 请求从断点处暂停                                           |
| ![clip_image004[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234202375-1737717316.gif) | 响应从断点处暂停                                           |
| ![clip_image005[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234202812-1354392122.gif) | 请求使用 HTTP 的 HEAD 方法，即响应没有内容（Body）         |
| ![clip_image006[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234203515-1304170577.png) | 请求使用 HTTP 的 POST 方法                                 |
| ![clip_image007[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234204531-965189067.gif) | 请求使用 HTTP 的 CONNECT 方法，使用 HTTPS 协议建立连接隧道 |
| ![clip_image008[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234205547-1927498766.gif) | 响应是 HTML 格式                                           |
| ![clip_image009[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234206203-722749081.gif) | 响应是一张图片                                             |
| ![clip_image010[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234207000-575730385.gif) | 响应是脚本格式                                             |
| ![clip_image011[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234207625-740567358.gif) | 响应是 CSS 格式                                            |
| ![clip_image012[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234208297-916097140.gif) | 响应是 XML 格式                                            |
| ![clip_image013[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234209640-1298497869.png) | 响应是 JSON 格式                                           |
| ![clip_image014[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234210172-1709733575.png) | 响应是一个音频文件                                         |
| ![clip_image015[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234210703-1810906238.png) | 响应是一个视频文件                                         |
| ![clip_image016[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234211297-1181901939.png) | 响应是一个 SilverLight                                     |
| ![clip_image017[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234213515-1617989240.png) | 响应是一个 FLASH                                           |
| ![clip_image018[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234214140-838447913.png) | 响应是一个字体                                             |
| ![clip_image019[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234214828-810550242.gif) | 普通响应成功                                               |
| ![clip_image020[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234215406-1088186512.gif) | 响应是 HTTP/300、301、302、303 或 307 重定向               |
| ![clip_image021[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234216015-2008519780.gif) | 响应是 HTTP/304（无变更）：使用缓存文件                    |
| ![clip_image022[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234216531-1803780843.gif) | 响应需要客户端证书验证                                     |
| ![clip_image023[4]](https://images2015.cnblogs.com/blog/626593/201601/626593-20160118234217078-1617370921.gif) | 服务端错误                                                 |
| ![clip_image0244](https://images2015.cnblogs.com/blog/626593/201601/626593-20160119000324093-1538967179.gif) | 会话被客户端、Fiddler 或者服务端终止                       |

### 右边面板

* Statistics 请求的性能数据分析
* Inspectors 查看数据内容（上半部分是请求的内容，下半部分是响应的内容）
* AutoResponder 允许拦截指定规则的请求（代替服务器响应）
  * 字符串匹配（默认）：只要包含指定字符串（不区分大小写），全部认为是匹配（如 baidu）
  * 正则表达式匹配：以“regex:”开头，使用正则表达式来匹配，这个是区分大小写的（如 regex:.+.(jpg | gif | bmp ) $）
* Composer 自定义请求发送服务器
  * 可以手动创建一个新的请求，也可以在会话表中，拖拽一个现有的请求
  * Parsed模式下你只需要提供简单的URLS地址即可
  * 也可以在RequestBody定制一些属性，如模拟浏览器User-Agent
* Filters 请求过滤规则
  * Use Filters 启用过滤
  * Zone Filter 指定只显示内网（Intranet）或互联网（Internet）的内容
  * Host Filter 指定显示某个域名下的会话（如果框框为黄色表示修改未生效，点击Change not yet saved）
* Timeline 请求响应时间
  * 在左侧会话窗口点击一个或多个（Ctrl或Shift），Timeline 便会显示指定内容从服务端传输到客户端的时间

### 安卓模拟器苹果抓包

* 同一个局域网下
* 开启 Allow remote computers to connect
* 在无线设置里设置代理服务器（IP为电脑的，端口默认为8888）
* 一般还要直接访问 IP:8888 下载 FiddlerRoot certificate
* 如果碰到：`No root certificate was found. Have you enabled HTTPS traffic decryption in Fiddler yet?`，请打开Fiddler的证书解密模式（Decrypt HTTPS traffic）

### 内置命令

* 左侧界面底部有一个命令行输入栏

|   **命令**   | **对应请求项** | **介绍**                                                     | **示例**                             |
| :----------: | :------------- | :----------------------------------------------------------- | :----------------------------------- |
|      ?       | All            | 问号后边跟一个字符串，可以匹配出包含这个字符串的请求         | ?google                              |
|      >       | Body           | 大于号后面跟一个数字，可以匹配出请求大小，大于这个数字请求   | >1000                                |
|      <       | Body           | 小于号跟大于号相反，匹配出请求大小，小于这个数字的请求       | <100                                 |
|      =       | Result         | 等于号后面跟数字，可以匹配HTTP返回码                         | =200                                 |
|      @       | Host           | @后面跟Host，可以匹配域名                                    | @www.baidu.com                       |
|    select    | Content-Type   | select后面跟响应类型，可以匹配到相关的类型                   | select image                         |
|     cls      | All            | 清空当前所有请求                                             | cls                                  |
|     dump     | All            | 将所有请求打包成saz压缩包，保存到“我的文档\Fiddler2\Captures”目录下 | dump                                 |
|    start     | All            | 开始监听请求                                                 | start                                |
|     stop     | All            | 停止监听请求                                                 | stop                                 |
| **断点命令** |                |                                                              |                                      |
|   bpafter    | All            | bpafter后边跟一个字符串，表示中断所有包含该字符串的请求      | bpafter baidu（输入bpafter解除断点） |
|     bpu      | All            | 跟bpafter差不多，只不过这个是收到请求了，中断响应            | bpu baidu（输入bpu解除断点）         |
|     bps      | Result         | 后面跟状态吗，表示中断所有是这个状态码的请求                 | bps 200（输入bps解除断点）           |
|  bpv / bpm   | HTTP方法       | 只中断HTTP方法的命令，HTTP方法如POST、GET                    | bpv get（输入bpv解除断点）           |
|    g / go    | All            | 放行所有中断下来的请求                                       | g                                    |

### 实例：自定义百度云分享密码

* 开启自动拦截
* 开启发送拦截的断点
* 点击创建分享
* 点击 https://pan.baidu.com/share 的Web表单，修改pwd字段
* 点击绿色的 Run to Completion，放行
* 取消断点
* 点击 Go 转到，恢复断点的所有会话

### 参考

* [Fiddler抓包工具总结 - ﹏猴子请来的救兵 - 博客园](https://www.cnblogs.com/yyhh/p/5140852.html)

### 书籍推荐

* HTTP抓包实战, 2018, 194
* Fiddler调试权威指南, 2014, 282, Debugging with Fiddle