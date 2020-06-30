### ~/.bash_profile 和 ~/.bashrc

* `~/.bash_profile`：**login shell**
* `~/.bashrc`：**non-login shell**

### 命令行设置代理

* cmd

  * `set http_proxy=http://127.0.0.1:1080`
  * `set https_proxy=http://127.0.0.1:1080`
* sh

  * `export http_proxy=http://127.0.0.1:1080`
  * `export https_proxy=http://127.0.0.1:1080`
  * `cat ~/.bash_profile`
* git
  * `git config --global http.proxy http://127.0.0.1:1080`
  * `git config --global https.proxy http://127.0.0.1:1080`
  * `git config --global --unset http.proxy`
  * `git config --global --unset https.proxy`
  * `npm config delete proxy`
  * `cat ~/.gitconfig`

### 生成RSA密钥公钥

```ssh
ssh-keygen -t rsa -b 4096 -C "备注或署名"
```

* 一直回车就好了
* 如果看到 `Overwrite (y/n)? y` 则说明以前生成过，是否覆盖生成新的

### 使用ssh对github进行身份验证

本机公钥设置到github后，还可以验证一下

```sh
$ ssh -T git@github.com
Hi TENCHIANG! You've successfully authenticated, but GitHub does not provide shell access.
```

### Git-Windows中文乱码

```sh
git status # 中文乱码
git config --global core.quotepath false
```

参考：

* [Git for windows 中文乱码解决方案](https://www.cnblogs.com/ayseeing/p/4203679.html)

  [git- win10 cmd git log 中文乱码 解决方法](https://blog.csdn.net/sunjinshengli/article/details/81283009)

### Git配置

```sh
git config --list # 查看已有的配置
git config --global --list # 查看已有的全局配置

# 如果是刚下了 git 建议要初始化
git config --global user.name "TENCHIANG"
git config --global user.email "tenchaing@qq.com"

# 删除配置
git config --global --unset user.mail # 正确的应该是 user.email
```

### Git创建仓库

```sh
# 创建仓库
mkdir porj
cd proj
git init
echo "# proj" >> README.md
git commit -m "first commit"
git remote add origin https://gitee.com/xxx/proj.git
git push -u origin master

# 已有仓库
cd proj
git remote add origin https://gitee.com/xxx/proj.git
git push -u origin master
```

* `git push -u origin master`：-u 的意思是之后就可以直接 `git push` 了
* 创建仓库 push 的时候需要在GitHub上添加本机的公钥

### 撤销commit

```ssh
git reset --soft HEAD^
git push origin HEAD --force # 撤销远程push
```

* 只撤回 `commit` 操作，不该表代码本身
* `HEAD^` 的意思是上一个版本
  * 也就是 `HEAD~1`，撤回 n 次就是 `HEAD~n`，HEAD表示为当前提交
  * 也是  `<commit_id> `的简写
* `--soft` ：只撤销 commit
* `--mixed`：默认的可省略操作：撤销commit、撤销git add、不撤销工作空间（修改代码）
* `--hard`：撤销commit、git add、工作空间！
* 修改或重写commit：`git commit --amend`
* 撤销到第一个 commit 怎么办：`git reflog`

### 删除已commit的文件

* `.gitignore` 文件里面要添加新项，然后又已经commit，甚至push了咋办
* `.gitignore`只能忽略那些原来没有被track的文件，如果某些文件已经被纳入了版本管理中，则修改`.gitignore`是无效的

```sh
git rm -r --cached -n path/ # -n 只查看要删除的文件
git rm -r --cached path/ # --cached 只删除版本库的 不删除本地的
# 删除远程版本库中的文件
git commit --amend
git push origin dev --force
```

### 克隆私有仓库

```sh
git clone https://username:password@github.com/TENCHIANG/sdgs
```

### git换行符问题

* CR \r 0x0d
* LF \n 0x0a
* Windows CR LF
* Unix/Linux LF
* MacOS CR
* core.autocrlf false 不对换行符做任何特殊处理
* core.autocrlf true 提交时转换为LF，检出时转换为CRLF
* core.autocrlf input 提交时转换为LF，检出时不转换（LF）
* [Git中的core.autocrlf选项 - icuic - 博客园](https://www.cnblogs.com/outs/p/6909567.html)

### 个人常用配置

```sh
[user]
        name = TENCHIANG
        email = yy5209zz@gmail.com
[core]
        autocrlf = input # 交时转换为LF，检出时不转换（LF）
        safecrlf = false # 忽略拒绝提交混合换行符 改成自动转换
        quotepath = false # 防止windows中文乱码
[color]
        ui = auto
[http]
        proxy = http://127.0.0.1:1080
[https]
        proxy = https://127.0.0.1:1080
```

参考：

* [Git 忽略提交 .gitignore](https://www.jianshu.com/p/74bd0ceb6182)

* [Git 中文详细安装教程_git_谢宗南的博客-CSDN博客](https://blog.csdn.net/sishen47k/article/details/80211002)

### Github 仓库内的跳转

* 用斜杠 / 作为目录分隔符
* / 表示仓库根目录（无需加协议头）
* 文件如果有空格，则用 %20 代替
* 跳转到标题用 # 开头
  * 如果标题有空格，则用 - 链接
  * 如果有符号，则直接忽略
  * 可以直接去实际页面查看地址

```md
### a (b)
以上标题对应的链接就是 #a-b
```

### 查看commit

```sh
git show [commitId] [fileName] # 查看具体的修改内容
git log -p -2 # -p输出差异 -2只显示两个提交
git log --stat # 显示简略信息
```

