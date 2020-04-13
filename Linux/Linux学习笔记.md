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
  * `git config --global https.proxy http://127.0.0.1:1080`
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

参考：[Git 忽略提交 .gitignore](https://www.jianshu.com/p/74bd0ceb6182)