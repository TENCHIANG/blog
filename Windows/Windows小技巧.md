## Windows小技巧

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

BoldAsFont=-1
Language=zh_CN
CursorBlinks=yes
FontHeight=16
MiddleClickAction=extend
RightClickAction=paste
BackspaceSendsBS=no
ClicksTargetApp=no
Font=Consolas
AllowBlinking=no
DeleteSendsDEL=no
```

* 注意：做了操作最好重启一下 mintty 可能才生效

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

### 完美解码小技巧

* 基本 - 基本 tab
  * 多重处理方式：新开一个播放进程播放
* 基本 - 快捷键 tab
  * 忽略默认快捷键：勾选？
* 播放 - 播放 tab
  * 记忆视频播放位置 ：勾选
  * 记忆音频播放位置 ：勾选
  * 鼠标指向进度条时显示缩略图 ：勾选
    * 在顶部输出书签/章节 ：勾选
    * 在底部显示时间 ：勾选
  * 鼠标在进度条上时显示时间 ：不勾选
* 播放 - 时间跨度 tab
  * 左/右 方向键：3秒
  * 如存在关键帧数据则以关键帧为移动单位 ：不勾选
    * 关键帧一般跳10多秒，好处就是跳的位置是可复现的

### CMD的注释

* :: 注释内容（第一个冒号后也可以跟任何一个非字母道数字的字符）
* rem 注释内容（不能出现重定版向符号和管道符号）
* %注释内容%（可以用作行间注释，不能出现重定向符号和管道符号）
* : 注释内容（可以用作标签下方段的执行内容）
* 注意 echo 后面跟注释没用，会把注释符号和注释都打印出来

### 批处理 Batch

* taskkill 终止进程
  * /f 强制关闭
  * /im 指定进程名1（可用通配符）
    * 一个 /im 搭配一个进程，可以有多个搭配
  * /t 关闭子进程

```batch
taskkill /f /im java.exe
```

* 参考：[tasklist 和 taskkill](/Lua/飞天助手学习笔记.md#总结是不是因为端口被占用)

### 小丸工具箱

压缩视频核心

* 降低码率
* 降低分辨率
* 压缩音频

#### 降低码率

* 降低码率可以使用 CRF 来控制，值越大码率越小，成反比（1~51）
* CRF 就是 constant ratefactor，就是保证“一定质量”
  * 值在18以下为无损，18-22为高质量，22-27为中等质量，51质量最差
  * 一般建议使用中等质量就可以了

#### 封装

封装成FLV或者MKV要比MP4清晰度高一些

在压制完后再封装，比直接用 flv  压制更加快

* 选择 封装 选项卡
* 点击 添加视频 按钮
* 选择 flv 下拉选项
* 点击 封装 按钮

在实际测试中，发现封装后的文件大小还大一些...

### Typora最佳实践

* 导出PDF：文件 - 导出 - PDF