### 原理

* 通过网络驱动，直接在网卡上面抓包（区别于Fiddler的代理模式， 代理和自定义证书很容易被检测到）
* 捕获引擎：Libcap（Linux）、WinPcap（Windows）、npcap（跨平台）
  * 都是对于 pcap（packet-capturing） API 的实现
    * capture raw packet data
    * apply filters
    * switch the NIC in and out of promiscuous mode
* USBPcap：从USB设备抓取数据

### 安装

* WiresharkPortable + npcap
* 打开 Wireshark，会弹出捕获接口列表（Ctrl+K）
* 在选项tab中，勾选解析网络名称、解析传输层名称
* 选择一个接口，点击开始按钮，开始捕获

### 数据包

* 数据包又被称为：帧、段、分组
* 双击数据包可以看到详细信息
  * Frame：物理层数据帧
  * Ethernet II：数据链路层以太网帧头部信息
  * Internet Protocol Version 4：互联网层IP包头部信息（IPv4）
  * Transmission Control Protocol：传输层数据段头部信息（当前为TCP协议）
  * Hypertext Transfer Protocol：应用层信息（当前为HTTP协议）

### OSI七层参考模型（ISO7498）

口诀：Please Do Not Throw Sausage Pizza Away.

1. 物理层 Physical（比特 Bits）集线器、网络适配器、中继器、线缆
2. 数据链路层 Data Link（数据帧 Frames）（Ethernet、Toking Ring、FDDI、AppleTalk）网桥、交换机
3. 网络层 Network（数据包 Packets）（IP、IPX）路由器
4. 传输层 Transport（数据段 Segments）（TCP< IP >、UDP< DNS >、SPX）防火墙、代理
5. 会话层 Session（数据 Data）（NetBIOS、SAP、SDP、NWlink）
6. 表示层 Presentation（数据 Data）（ASCII、MPEG、JPEG、MIDI）
7. 应用层 Application（数据 Data）（HTTP、SMTP、FTP、Telnet）
8. 用户层（如密码错误）

### 网络硬件

* 集线器 Hubs：半双工**广播**转发数据到所有端口（被交换机替代）
  * 同一时刻只有一个设备能通信（丢包、拥塞和碰撞）
  * 很多低端的交换机也会被声称为交换机
* 交换机 Switches：全双工转发数据到**特定**端口
  * 二层地址存CAM表（Content Addressable Memory 内容寻址寄存器）
  * 实现单播、多播和组播
* 路由器 Routers：网段与网段，内网与外网的数据转发（网关）

### 网络流量分类 Traffic Classifications

* 广播 Broadcast Traffic：一个网段上的所有端口（广播域）
  * 二层广播基于MAC地址：FF:FF:FF:FF:FF:FF
  * 三层广播基于IP地址：192.168.0.255（网段中最大的IP）
* 组播 Multicast Traffic：在减少网络带宽的前提下，一对多传输数据（一对所有就是广播了）
  * 将接收者分组（组播组）：224.0.0.0 ~ 239.225.225.225
* 单播 Unicast Traffic：一对一

### 网络嗅探的几种方式 tapping into the wire

* 支持混杂模式驱动的网卡（network interface card, NIC）：允许查看通过网卡的所有数据包
  * 一般接收到广播来的数据包会丢弃，混杂模式不会丢弃，而是直接传给CPU（混杂模式驱动）
* 集线器网络中的嗅探：能看到所有的流量
* 交换机网络中的嗅探：只能看到广播、和自己的流量
  * 端口镜像（配置交换机）
    * 思科 Cisco：`set span <src port> <des port>`
    * 海创 Enterasys：`set port mirroring create <src port> <des port>`
    * 北电 Nortel：`port-mirroring mode mirror-port <src prot> monitor-port <des port>`
    * 有的交换机还允许多个端口镜像到一个端口（注意负载）
  * 集线器输出 Hubbing out：目标设备和嗅探器在同一网段，然后插到集线器上
  * 网络分流器 Tap（类似于中间人攻击）
    * 聚合分流器 Aggregated Taps（一个监听端口监听双向流量）
    * 非聚合分流器 Nonaggregated Taps（两个监听端口分别监听，需要两块网卡）
    * 分流器搭配集线器可以监控所有流量
  * ARP缓存污染攻击
    * ARP查询：先查询本机ARP缓存，若没有目标IP对应的MAC，则发送二层广播（某某IP地址的MAC地址是什么），一般只有目标（某某IP）机器会回复
    * ARP缓存污染攻击：通过发送假的MAC地址来劫持目标机器的流量（冒名顶替）
    * 工具：[Cain & Abel](oxid.it)
* 在路由器上嗅探
  * 相似于交换机上的嗅探
  * 要注意的是，多个网段和路由器
    * 通过制作网络拓扑图决定在哪里嗅探（收集正确的网络数据）
    * 在不同的网段，对多个设备流量进行嗅探

### Wireshark主窗口

* 数据包列表 Packet List
  * 双击一个数据包打开的是单独的数据包细节和字节窗口
* 数据包细节 Packet Details
* 数据包字节 Packet Bytes

### 捕获浏览器的HTTPS流量

* 设置环境变量：SSLKEYLOGFILE=D:\sslkey.log
* 重启浏览器，Whireshark - 编辑 - 首选项 - Protocols - TLS - (Pre)-Master-Secret log filename 设置为 D:\sslkey.log
* Whireshark过滤器输入 `tcp.port == 443` 只看 https 协议

