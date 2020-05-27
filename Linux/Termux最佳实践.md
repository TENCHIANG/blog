## Termux 最佳实践

### 基本设置

* 修改源（如果你是**模拟器**先不要 update upgrade）
* **$PREFIX** 相当于 termux 提供环境的根目录（安卓真正的根目录不要随便改）

```sh
vi ~/.bash_profile
alias ll='ls -lhA'

. ~/.bash_profile

# 修改源

sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list

# 申请内存卡权限
termux-setup-storage

```

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
* 默认用户为 root

```sh
pkg install openssh
sshd
pkill sshd
```

### 编译 Lua

* 没有 readline-static 也可以编译 liblua.a 但是 编译不出 lua 和 luac

```sh
pkg install -y curl clang make readline-static #libedit ncurses-static

curl -R -O http://www.lua.org/ftp/lua-5.1.4.tar.gz
tar zxf lua-5.1.4.tar.gz
cd lua-5.1.4

make linux test # Hello world, from Lua 5.1!

cd src
gcc stack.c -o stack.so -fPIC -shared -Wall -O2 #-L/sdcard/Download/lua-5.1.5/src
#gcc -O3 -Wall -Wextra -Werror -g -fPIC -c ./a.c -o a.o

./lua # 测试 require
```

* 飞天助手调用c模块（放在**资源**文件夹下）

```lua
package.cpath = getrcpath().."/?.so;"..package.cpath
lineprint(package.cpath)

require "func"
lineprint(func.isquare(2))
```

* require 底层

```lua
path = "/sdcard/Download/lua-5.1.4/src/func.so"
name = "luaopen_func"
initLib = package.loadlib(path, name)

print(func) -- nil
initLib()
print(func) -- table: 0xb6c83fe0

for k, v in pairs(func) do
    print(k, v)
end
--[[
alert   function: 0xb6cd9a00
isquare function: 0xb6c355a0
]]
```

* Lua交互环境（Lua5.1）
  * 一行语句就相当于一个 chunk ，= 号就相当于 return 语句（对于返回的会打印出来）
  * 如果没有 = 号或者 return ，就不会返回，也就不会打印输出

### 参考

[安卓手机的神器--Termux 个人使用全纪录_Python_a1246526429的博客-CSDN博客](https://blog.csdn.net/a1246526429/article/details/86564482)

[Termux 高级终端安装使用配置教程 | 国光](https://www.sqlsec.com/2018/05/termux.html)

[使用Termux把Android手机变成SSH服务器 | 《Linux就该这么学》](https://www.linuxprobe.com/termux-ssh-server.html)

