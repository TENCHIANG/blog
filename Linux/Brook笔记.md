### Brook 无特征 TCP UDP 代理

* 下载服务端：[Releases · txthinking/brook](https://github.com/txthinking/brook/releases/)
* 下载客户端：[GUI(图形用户界面), Brook 图形客户端.](https://github.com/txthinking/brook/blob/master/docs/zh-cn/install-gui-client.md)
* 服务端配置，以 Linux x64 为例

```sh
curl -L https://github.com/txthinking/brook/releases/download/v20200909/brook_linux_amd64 -o /usr/bin/brook
chmod +x /usr/bin/brook
nohup brook server -l :9999 -p passwd & # 后台运行
killall brook # 停止运行

```

* 客户端配置

```sh
brook client -s 1.2.3.4:9999 -p passwd --socks5 127.0.0.1:1080
```

* 然后去 Internet 选项配置自动脚本 http://localhost:1093/proxy.pac （当然图形界面版本自动会代劳）
* 参考：
  * [TxThinking Talks](https://talks.txthinking.com)
  * [什么叫有特征和无特征](https://talks.txthinking.com/slides/brook-ss-v2ray.slide#5)
  * [Brook](https://txthinking.github.io/brook/#/)

