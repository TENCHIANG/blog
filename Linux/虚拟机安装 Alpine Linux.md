### 虚拟机安装 Alpine Linux

* 下载 extended 镜像（其它镜像在 Virtualbox 上打不开） 
* 设置**端口转发**（网络 - 高级）只要设置端口就行：主机端口填 22（随便填不占用即可），子系统端口选 22（启动 ssh 服务端时的端口）
  * 这里设置端口转发就可以不设置为桥接网络了

```sh
VBoxManage list vms
VBoxManage modifyvm "myandrovm_vbox86" --natpf1 "ssh,tcp,,22,,8022" # 主机访问loacalhost:22相当于虚拟机访问localhost:8022
```

* 进入 ISO 的系统后，输入 root 无密码登录进去，`setip-alpine` 安装 apline
* 键盘布局：us
* 主机名：localhost
* 网卡名：eth0
* ip地址：dhcp
* 设置代理：none
* 时区：Asia/Shanghai
* image 模式选择（仓库源）：1 先选择第一个
  * r 随机
  * f 一个个测试最快的
  * e 手动编辑
* ssh 服务器：dropbear（会自动生成 key 并启动服务）
* ntp 时钟同步：chronyd
* 选择磁盘格式化：sda
* 选择磁盘模式：sys
  * sys：直接将 alpine 安装到硬盘，与安装其他 linux 类似
  * data：仅使用硬盘作为数据存储，操作系统运行在内存中，硬盘无法单独启动
  * lvm：采用 lvm 管理磁盘,会再次询问 sys/data 模式
  * lvmsys：lvm + sys
  * lvmdata：lvm + data
* 覆盖磁盘选择：y
* 安装完毕后，弹出 ISO，关闭虚拟机

```sh
# 如果安装的是 openssh 还要做这一步操作
echo "PermitRootLogin  yes" >> /etc/ssh/sshd_config
service sshd restart
```

* 以无界面模式启动，然后用 `ssh root@127.0.0.1` 连接之

* 安装 docker 和 docker-compose

```sh
# 修改源
vi /etc/apk/repositories
# http://mirrors.aliyun.com/alpine/edge/main
# http://mirrors.aliyun.com/alpine/edge/community
apk update # 更新源

apk add docker-compose # 安装 docker-compose

apk add docker # 安装 docker
rc-update add docker boot # 设置开机启动
service docker start # 启动docker服务

# 测试
docker version
docker run hello-world
```

* [【Alpine Linux】用Vmware安装Alpine Linux - 简书](https://www.jianshu.com/p/476fb856d10c)
* [Windows10 virtualbox安装alpine+docker_weixin_43749777的博客-CSDN博客_virtualbox alpine](https://blog.csdn.net/weixin_43749777/article/details/95890812)
* [虚拟机安装alpine+docker环境_张林强的专栏-CSDN博客_alpine下配置docker环境](https://blog.csdn.net/u011411069/article/details/78546790)
* [adb shell和busyBox的使用_一片纯净的热土-CSDN博客](https://blog.csdn.net/sxsj333/article/details/6937470)
* 官方最新文档：
  * 安装 alpine：[Installation - Alpine Linux](https://wiki.alpinelinux.org/wiki/Installation)
  * 安装 docker：[Docker - Alpine Linux](https://wiki.alpinelinux.org/wiki/Docker)
  * alpine 使用大全：[Tutorials and Howtos - Alpine Linux](https://wiki.alpinelinux.org/wiki/Tutorials_and_Howtos)
  * [Install Alpine on VirtualBox - Alpine Linux](https://wiki.alpinelinux.org/wiki/Install_Alpine_on_VirtualBox)
  * [VirtualBox shared folders - Alpine Linux](https://wiki.alpinelinux.org/wiki/VirtualBox_shared_folders)

