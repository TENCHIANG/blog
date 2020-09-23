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

### credential.helper

* 访问私有仓库时，会提示输入密码，有几种方式避免

* **store**

  * `git config --global credential.helper store`
  * 以**明文**形式存在 ~/.git-credentials（`https://user:pass@github.com`）
  * 不加 --global 则存在项目目录下
  * 全局设置在 ~/.gitconfig 下
    * 输入 `git config --global -e` 直接编辑全局设置（不加 --global 则是编辑当前项目的配置）
    * /etc/gitconfig 也是全局设置
  * /etc/mingw64/libexec/git-core/git-credential-store

* **wincred**

  * Git Credential Manager for Windows（GCM）
  * /etc/mingw64/libexec/git-core/git-credential-wincred
  * 基于 Windows 本身的**密钥库**
    * 已过时，更新的替代方式时 manager
    * MacOS 上叫 **osxkeychain**

* **manager**

  * Git Credential Manager Core
  * 需要 .NET4.0 相当于在网页上登录，可以记住账号密码，可以**跨平台**
  * /etc/mingw64/libexec/git-core/git-credential-manager
  * [microsoft/Git-Credential-Manager-Core: Secure, cross-platform Git credential storage with authentication to GitHub, Azure Repos, and other popular Git hosting services.](https://github.com/microsoft/git-credential-manager-core)

* **cache**

  * 保存到内存里（Git 1.7.9 开始）

  * ```sh
    git config --global credential.helper "cache --timeout=3600" # --timeout 单位秒（可省略）
    ```

* 配置文件里的格式

```sh
[credential "helperselector"]
        selected = store
```

* 参考：[git - Is there a way to cache GitHub credentials for pushing commits? - Stack Overflow](https://stackoverflow.com/questions/5343068/is-there-a-way-to-cache-github-credentials-for-pushing-commits)

### git-for-windows 乱码问题

* 中文全部乱码

  * 设置 mintty 为 UTF-8，参见 [mintty 最佳实践](/Windows/Windows小技巧.md#mintty-最佳实践)
* git log 乱码（如 \344\270\212\347\）

  * `git config --global core.quotepath false`
* status 编码不显示八进制（反过来说就是允许显示中文了）
* 还是乱码

  * 建议安装 2.26.1，这是 2.27 之后的 BUG（经过反复测试，和系统无关）

```sh
$ git config --global core.quotepath false          # 显示 status 编码
$ git config --global gui.encoding utf-8            # 图形界面编码
$ git config --global i18n.commit.encoding utf-8    # 提交信息编码
$ git config --global i18n.logoutputencoding utf-8  # 输出 log 编码
$ export LESSCHARSET=utf-8 # /etc/profile
# 最后一条命令是因为 git log 默认使用 less 分页，所以需要 bash 对 less 命令进行 utf-8 编码
[core]
    quotepath = false
[gui]
    encoding = utf-8
[i18n]
    commitencoding = utf-8
    logoutputencoding = utf-8
```

* 参考：
* [Git中文显示问题解决](https://xstarcd.github.io/wiki/shell/git_chinese.html)	
* [解决git在Windows下的乱码问题--解决代码从git 拉下来之后中文乱码的问题 - Oscarfff的个人空间 - OSCHINA](https://my.oschina.net/u/2308739/blog/736179)
* [Git中的文件状态和使用问题解决 - 快鸟 - 博客园](https://www.cnblogs.com/kevin-yuan/p/4678248.html)
* [git status 显示中文和解决中文乱码_夏虫不可语冰-CSDN博客_git 中文乱码](https://blog.csdn.net/u012145252/article/details/81775362)

### git-for-windows 不要使用便携版

* 便携版针对安装在优盘，不支持软硬链接，所以解压后文件重复增大
* [安装Git For Windows时尽量不要使用Portable版本（安装体积过大问题） - Leading - 博客园](https://www.cnblogs.com/leading/archive/2012/03/02/better-not-use-git-for-windows-portable.html)

### 提交 pull request

* 速成提交一个 pr
* 先 fork 别人的项目
* 然后把 fork 后的 git clone 下来
* 自己改吧改吧，然后 commit 和 git push -f origin master
* 然后在自己 fork 的项目页面点击 Pull request
  * 旁边的 Compare 可以查看 pr 记录
  * 原项目的 Pull requests（/pulls）可以查看未并入的所有 pr
* 如果提交的 pr 未通过要再修改怎么办：直接修改再 commit、push 即可
* 和原项目同步（确保上次 pr 已被 merge，这次重新 pr）
  * git remote add update url
  * git remote -v
  * 先删除上次 pr 的 commit
    * git rebase -i id（此 id 是你 pr 前的 id，就是原仓库最新的 id）
    * 然后把你上一次 pr 的 commit 从 pick 改为 drop，wq 保存即可
  * git fetch update 更新 update/master（非 origin/master）
  * git rebase update/master（同步原仓库最新 merge 的 pr 代码）
    * 或者此时加个 -i 顺便就把删除上次 pr 的 commit 一起做了？
    * rebase 前要先 fetch 吗？
  * git stash：Stash the changes in a dirty working directory away
* 注意：如果有多个分支，也要注意多个分支
  * 查看所有分支 git branch -a
  * 切换分支 git checkout xxx
  * 新建分支 git checkout -b yyy
* [GitHub 的 Pull Request 是指什么意思？ - 知乎](https://www.zhihu.com/question/21682976/answer/79489643)
* [Github上fork项目后与原项目保持同步 - relucent - 博客园](https://www.cnblogs.com/relucent/p/6479213.html)
* [git删除指定commit - 奔跑的小龙码 - 博客园](https://www.cnblogs.com/lwcode6/p/11809973.html)
* [提交第二个PR(零基础参与开源软件项目开发系列_02) - 知乎](https://zhuanlan.zhihu.com/p/113007672)