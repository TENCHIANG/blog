## SSH掉线问题
SSH经常会碰到一个问题，有段时间没有操作，会自动断开或者显示，其本质是防火墙关闭了连接
> NAT firewalls like to time out idle sessions to keep their state tables clean and their memory footprint low.

当然掉线显示` packet_write_wait: Connection to UNKNOWN port 65535: Broken pipe`也有可能是真的是因为网络问题而断开了连接

## 解决方案
通过设置ssh发送心跳包来保持ssh的连接
* ClientAliveInterval 服务端向客户端发送心跳包 默认为0
* ServerAliveInterval 客户端向服务端发送心跳包 默认为0
* TCPKeepAlive 服务端客户端都可以用的心跳包 默认为yes

`ClientAliveInterval`和`ServerAliveInterval`心跳包时间间隔要设置为小于防火墙的最小超时时间

只要设置服务端或者客户端就行了，推荐只设置客户端就行了，没有权限问题

## ClientAliveInterval、ServerAliveInterval和TCPKeepAlive的区别
相同点：都是发送心跳包的
不同点：TCPKeepAlive是服务端客户端都可以设置的
最大的不同点：TCPKeepAlive可能也会被防火墙拦住，意思是光TCPKeepAlive可能还是会掉线
> **TCPKeepAlive** operates on the TCP layer. It sends an empty TCP ACK packet. Firewalls can be configured to ignore these packets, so if you go through a firewall that drops idle connections, these may not keep the connection alive.
> **ServerAliveInterval** operates on the ssh layer. It will actually send data through ssh, so the TCP packet has encrypted data in and a firewall can't tell if its a keepalive, or a legitimate packet, so these work better.

`man sshd_config`里面有句话
> The default is yes (to send TCP keepalive messages), and the server will notice if the network goes down or the client host crashes. **This avoids infinitely hanging sessions.**

也就是说，TCPKeepAlive的目的不是为了保持连接，而是为了清除`ghost-user`，反而更容易断线
所以，根据最佳实践，应该在服务端设置TCPKeepAlive为yes，然后在客户端设置时间间隔低的心跳包

## SSH服务端配置文件
```sh
vi /etc/ssh/sshd_config
ClientAliveInterval 30 # 每30s向客户端发送心跳包
ClientAliveCountMax 5 # 5次没响应认为已断开 默认为3

# 重启ssh服务 RHEL、CentOS、Fedora、Redhat
/etc/init.d/sshd restart
service sshd restart
sudo systemctl restart sshd

# 重启ssh服务 Debian、Ubuntu
/etc/init.d/ssh restart # 推荐有提示
service ssh restart
service sshd restart # 也可以使用RHEL系风格
```

## SSH客户端配置文件
```sh
vi ~/.ssh/config # 用户级（当前用户生效）
vi /etc/ssh/ssh_config # 系统级（所有用户生效）
Host myhost
    HostName xx.xx.xx.xx
    User root
    Port xxxx
    ServerAliveInterval 60 # 每30s向服务端发送心跳包
    ServerAliveCountMax 5 # 默认为3

ssh myhost
```

## 通过代理访问SSH服务器（基于 nc 的代理转发）
打开代理软件，开启全局代理（SSH服务器的IP要经过代理）
```sh
# 方法一
ssh myhost -o 'ProxyCommand nc -X 5 -x 127.0.0.1:19181 %h %p' # 端口号看情况定

# 方法二
vi ~/.ssh/config
Host myhost
    ProxyCommand nc -x 127.0.0.1:19181 %h %p

ssh myhost
```

## nc命令解释
`netcat`一般简称为`nc`，直译为中文就是“网猫”，被誉为**网络上的瑞士军刀**，能够很方便、很灵活地操纵**传输层协议**（TCP ＆ UDP），如网络诊断、网络配置、系统管理、辅助入侵......
在这里，我们只用到了nc的一小部分功能：基于 nc 的代理转发（Proxy Forward）

nc整体的命令格式是：`nc 命令选项 主机 端口`

* `-X`指定代理的类型
原版nc没有该选项，有这个选项的是nc的`OpenBSD变种`，且这个选项带3个参数
    1. `4`(SOCKS v.4)
    1. `5`(SOCKS v.5)默认
    1. `connect` (HTTPS proxy)

* `-x` proxy_address[:port] 指定代理的位置
也是属于OpenBSD变种支持的选项，用于指定代理的ip地址和端口号，端口号可以省略，就会用默认的端口号（socks代理是1080，https代理是3128）

## ProxyCommand和%h %p的解释
ProxyCommand：在连接ssh服务端时运行指定命令
%h %p：SSH运行时的标记（tokens）
* %%    A literal `%'.
* %C    Hash of %l%h%p%r.
* %d    Local user's home directory.
* %h    The remote hostname.
* %i    The local user ID.
* %L    The local hostname.
* %l    The local hostname, including the domain name.
* %n    The original remote hostname, as given on the command line.
* %p    The remote port.
* %r    The remote username.
* %T    The local tun(4) or tap(4) network interface assigned if tunnel forwarding was requested, or "NONE" otherwise.
*  %u    The local username.

所以`%h %p`代表远程主机名和端口号，不同的ssh参数能用的标记也不尽相同：
* Match exec accepts the tokens %%, %h, %i, %L, %l, %n, %p, %r, and %u.
* CertificateFile accepts the tokens %%, %d, %h, %i, %l, %r, and %u.
* ControlPath accepts the tokens %%, %C, %h, %i, %L, %l, %n, %p, %r, and %u.
* HostName accepts the tokens %% and %h.
* IdentityAgent and IdentityFile accept the tokens %%, %d, %h, %i, %l, %r, and %u.
* LocalCommand accepts the tokens %%, %C, %d, %h, %i, %l, %n, %p, %r, %T, and %u.
* ProxyCommand accepts the tokens %%, %h, %p, and %r.
*  RemoteCommand accepts the tokens %%, %C, %d, %h, %i, %l, %n, %p, %r, and %u.

所以结合在一起看`ProxyCommand nc -X 5 -x 127.0.0.1:19181 %h %p`就是：通过nc把ssh的流量由代理服务器转发到ssh服务器(%h %p)
而`ssh myhost -o 'ProxyCommand nc -X 5 -x 127.0.0.1:19181 %h %p'`的`-o`意思就是把配置文件的字段写在命令行，`ProxyCommand`是配置文件格式的字段，而不是ssh命令的参数

## 其它解决方案`screen`
断线不可怕，可怕的是断线会把正在运行的程序都结束导致数据、工作状态丢失的麻烦，如果使用了`screen`，就算掉线也可以恢复之前的工作状态，当然配合之前的心跳包使用效果更佳

## 免登录

* 客户端生成公钥密钥 `ssh-keygen -t rsa`
* 给远程主机配置别名 `vi ~/.ssh/config`

```
Host 别名
    Hostname 主机名
    Port 端口
    User 用户名
```

* 把公钥发送给远程主机 `ssh-copy-id 别名`
* 修改远程主机的 /etc/ssh/sshd_config

```
Protocol 2 # 直接使用ssh协议2
PermitRootLogin yes # 允许root登录 默认是允许的
StrictModes yes # 当客户端的密钥改变了 则不允许登录
RSAAuthentication yes # ssh协议1的纯 rsa认证
PubkeyAuthentication yes # ssh协议2的纯 rsa认证
```

* 重启服务端 sshd：`service sshd restart`

## 参考

[解决SSH自动断线，无响应的问题](https://www.jianshu.com/p/92d60c6c92ef)
[How does tcp-keepalive work in ssh?](https://unix.stackexchange.com/questions/34004/how-does-tcp-keepalive-work-in-ssh)
[扫盲 netcat（网猫）的 N 种用法——从“网络诊断”到“系统入侵”](https://program-think.blogspot.com/2019/09/Netcat-Tricks.html)
[How To Restart SSH Service under Linux / UNIX](https://www.cyberciti.biz/faq/howto-restart-ssh/)
`man ssh_config`
`man sshd_config`
`man ssh`
`man nc`

### ssh超时问题解决：tmux

* [tmux 终端复用神器 - Creaink - Build something for life](https://creaink.github.io/post/Devtools/Tools/tmux.html)
* [Tmux 使用教程 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2019/10/tmux.html)