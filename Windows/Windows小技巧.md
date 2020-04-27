## Windows小技巧

### Windows下多tab的控制台应用

* MacOS和Linux都有天然的多tab控制台
* Windows下，mintty 很好用，但是不支持多tab

#### 方案一、mintty  + 快捷键

* mintty 虽然不支持多 tab，但是支持 CTRL+TAB 键切换 tab

#### 方案二、ConEmu

* `{Bash::Git Bash}`
* Interface language: `zh: 简体中文`
* Choose color: `<xtrerm>`
* 单实例模式
* 窗口大小：128 x 32
* 通用 - 任务栏：
  * 取消勾选 `自动最小化到任务状态区域（TSA）`
  * 选择 `仅活动控制台（ConEmu窗口）`
* 启动 - 自动保存/恢复打开的标签页（tab）
* 注意编码默认是 utf8了
* 已知**问题**：
  * git commit -m "" 在双引号内输入中文会出问题（建议先只打单个双引号，**不要用方向键**）

### CMD的注释

* :: 注释内容（第一个冒号后也可以跟任何一个非字母道数字的字符）
* rem 注释内容（不能出现重定版向符号和管道符号）
* %注释内容%（可以用作行间注释，不能出现重定向符号和管道符号）
* : 注释内容（可以用作标签下方段的执行内容）
* 注意 echo 后面跟注释没用，会把注释符号和注释都打印出来

### mintty 最佳实践

```sh
cat ~/.minttyrc
FontHeight=16
Language=@
MiddleClickAction=extend
RightClickAction=paste
Locale=zh_CN
Charset=UTF-8
Transparency=high
```

* 注意：做了操作最好重启一下 mintty 可能才生效