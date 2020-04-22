## Termux 最佳实践

### 基本设置

* 如果你是**模拟器**先不要修改源！

```sh
vi ~/.bash_profile
alias ll='ls -lhA'
export EDITOR=vi

exit

# 修改源
apt edit-sources
vi  $PREFIX/etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/termux stable main

apt-get update
```

* **$PREFIX** 相当于 termux 提供环境的根目录（安卓真正的根目录不要随便改）
* **以下命令慎用！**（模拟器）

```sh
apt-get upgrade
pkg update
pkg upgrate
```

* 安装 tsu（su 的 termux 版本）

```sh
pkg install tsu
tsu
exit # 退出tsu
```

* 模拟 root 权限（是否必须？）

```sh
pkg install proot
termux-chroot # 进入模拟的 root 环境
```

### 安装 ssh 服务

* 如果是模拟器，先打开桥接网络
* 默认只能用公钥登录
* 默认端口号为 8022

```sh
pkg install openssh
sshd
pkill sshd
```

### 编译 Lua

```sh
pkg install clang make readline-static libedit ncurses-static
make linux
cd src
gcc stack.c -o stack.so -fPIC -shared -Wall -O2 -L/sdcard/Download/lua-5.1.5/src
```



### 参考

[安卓手机的神器--Termux 个人使用全纪录_Python_a1246526429的博客-CSDN博客](https://blog.csdn.net/a1246526429/article/details/86564482)