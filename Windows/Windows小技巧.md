## Windows小技巧

### mintty 最佳实践

```sh
cat ~/.minttyrc
FontHeight=16
Language=zh_CN
MiddleClickAction=extend
RightClickAction=paste
Locale=zh_CN
Charset=UTF-8
Transparency=off

BoldAsFont=-1
CursorBlinks=yes
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
* 方便的管理文件：打开侧边栏 - 打开文件TAB - 右键选择文档树 - 再右上角打开文件夹

### Notepad++最佳实践

* 设置 - 首选项 - 新建 - 格式 - Unix
* 设置 - 首选项 - 新建 - 编码 - UTF-8（无BOM）
  * 应用于打开 ANSI 文件
* 设置 - 首选项 - 语言 - 替换为空格

### Windows 控制台编码 CHCP

* adb shell windows控制台支持上下键但是会乱码，git for windows 不乱码但是不支持上下键
* `chcp 65001`
* CHCP命令，能够显示或设置活动代码页编号（虽然只是暂时的，当前会话生效的）
* 65001  UTF-8代码页
* 950 繁体中文
* 936 简体中文默认的GBK
* 437 MS-DOS 美国英语
* [windows 控制台cmd乱码的解决办法_操作系统_taoshujian-CSDN博客](https://blog.csdn.net/taoshujian/article/details/60325996)

### Windows软硬链接

```cmd
@echo off

:: /e 复制目录和子目录，包括空目录
:: /h 也复制隐藏文件和系统文件
:: /k 复制属性。一般的 xcopy 会重置只读属性
:: /o 制文件所有权和 ACL 信息
:: /x 复制文件审核设置(隐含 /o)
:: /b 复制符号链接本身与链接目标
xcopy c:\ProgramData d:\ProgramData\ /e /h /k /x /b
if %errorlevel% EQU 0 rmdir /s /q c:\ProgramData
: mklink [/d|/h|/j] to from
if %errorlevel% EQU 0 mklink /j c:\ProgramData d:\ProgramData

xcopy c:\Users d:\Users\ /e /h /k /x /b
if %errorlevel% EQU 0 rmdir /s /q c:\Users
if %errorlevel% EQU 0 mklink /j c:\Users d:\Users

pause
```

### Everything

* 设置 - 结果 - 搜索关键词为空时不显示搜索结果
* 设置 - NTFS - 前三个都勾上
* 设置 - 排除列表 - 前三个都勾上

### FATAL:INT18 boot failure

* 虚拟机安装系统重启后报错
* 原因：没有设置活动分区

### 睡眠和休眠的区别

* 睡眠：数据还在内存，低功耗运行
* 休眠：内存数据保存到硬盘，开机后再加载恢复
* **开启休眠**

```cmd
powercfg -a :: 查看休眠是否已开启
powercfg -h on
```

### foobar最佳实践

* 文件 - 显示 - 默认用户界面
  * 主题管理 - 快速设置 - 播放列表布局 - Separate Album & Artist Columns
  * 后台与通知 - 最小化及关闭
* 文件 - 参数选项
  * DSD wasapi 推送（或者没有DSD也行）
    * 缓冲长度 2000
    * 输出格式 24-位
* 播放 - 光标跟随播放



