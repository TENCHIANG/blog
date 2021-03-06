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
* 文件 - 偏好设置 - Markdown - Markdown 扩展语法
  * \$内联公式$（LaTeX 内联公式最有用，可完美代替下标上标）
  * \~下标~
  * \^上标^
  * \==黄色高亮==
  * 图表（默认已选）
* 文件 - 偏好设置 - Markdown - 代码块
  * 显示行号

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
* powercfg -h 表示休眠相关
  * -size 指定休眠文件 **C:\hiberfil.sys** 占内存的百分比，不得小于 50（默认 100）
  * -a 查看休眠是否已开启
  * on 开启休眠，会自动创建休眠文件
  * off 关闭休眠，会自动删除休眠文件

```cmd
powercfg -h -size 100 on
powercfg -h off
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

### 7-Zip 最佳实践

* 比官方 7-Zip 好用的叫 easy7zip
* FM.exe - 工具 - 选项 - 7-Zip
  * 添加 7-Zip 到右键菜单
  * 添加 7-Zip 到右键菜单（32 位）
  * 层叠右键菜单
  * 排除重复的根文件夹
  * 打开压缩包
  * 提取到当前位置
  * 提取到<文件夹>
  * 添加到压缩包...
* 7zG.exe - 添加到压缩包（右键菜单）
  * 压缩格式：7z
  * 压缩等级：极限压缩
  * 压缩方法：LZMA2
  * 字典大小：64 MB
  * 单词大小：64
  * 固实数据大小：固实
  * CPU 线程数：3（越大内存占用越多，也越快）
  * 参数：cu（UTF-8）
* [7zip如何设置极限压缩的参数？ - 知乎](https://www.zhihu.com/question/24517051)

### IDM 最佳实践

* 选项 - 常规 - 自定义浏览器中的 IDM 下载浮动条 - 对于网页播放器 - 不要从在线播放器中自动捕获并下载文件
* 选项 - 保存至 - 临时文件夹

### QTranslate 最佳实践

* 选项 - 基本
  * 文字大小：14
  * 第一语言：简体中文
  * 第二语言：English
  * 语音输入：简体中文
  * 启用历史记录：勾选
* 选项 - 快捷键：取消快捷键
* 选项 - 网络：超时 5 秒，不开启代理
* 选项 - 服务
  * Translation：有道、百度、微软、谷歌
  * Dictionary：有道
* 选项 - 语言：默认全选
* 选项 - 外观
  * 启用窗口风格：勾选
  * 主题：Photoshop Dark、默认、Outlook Gray、Brackets
  * 自动调整大小：勾选
  * 自动调整位置：勾选
  * 拖动时固定：勾选
  * 自动隐藏延迟：3 秒
  * 透明度：15
  * 边框厚度：2
* 选项 - 高级
  * 默认浏览器：Chrome
  * 复制动作：Ctrl + C
  * 首选域：cn（不用开代理）
  * 启用图形界面翻译（不太懂）
  * 允许以比较慢的速度朗读相同的文本（不太懂）
  * **删除换行符**：勾选（翻译 PDF 时很重要）
  * 仅当按下 Ctrl 键时启用鼠标模式：勾选
  * 点击通知区域图标时切换鼠标模式：不勾选
    * 先勾选，右下角图标点绿时再关闭这个选项
    * **用法**：
      * 按住 Ctrl 键，用鼠标选择要翻译的文字，即可弹出翻译
      * 或者先选择文字，鼠标不要松开，再按住 Ctrl 后松开鼠标
      * 按住 Ctrl 键，双击要翻译的单词
  * 仅当按下 Ctrl 键时启用鼠标模式：不勾选
  * 点击通知区域图标时切换鼠标模式：勾选
    * 右下角开启鼠标模式，鼠标选择文字直接翻译，不用时再点击右下角图标关闭即可
* 选项 - 更新：关闭自动更新
* 主界面
  * 拼写检查、即时翻译、回译模式（不一定）
  * Auto-Dectect 到 Auto-Dectect（Chinese（Simplified）-English）
* [QTranslate - Download](https://quest-app.appspot.com/download)

### MDict 最佳实践

* 文件 - 选项
  * 将最近打开的词典设置为词库列表的首项
  * 激活时自动查找剪贴板内容
  * 关闭窗口时最小化到托盘
  * 联合模式词典默认展开所有条目
  * 使用智能中文查找（自动使用简/繁体进行查找）
  * 最小化到托盘（点击最小化按钮时）
  * 启动后最小化窗口
  * 程序热键：Ctr + Alt + D
    * 用法：先复制单词，然后按热键打开主界面，就会自动翻译
* 使用词库
  * 词库 - 词库管理 - 导入词库
    * 一般在安装目录的 doc 文件夹下
  * 词库 - 选择词库
  * 推荐：简明英汉汉英词典、汉语大词典
* 使用 TTS
  * 一般在安装目录的 audiolib 目录下
  * 点击主界面的小喇叭朗读单词
  * 推荐：sound_us.mdd

### MarkDown 插入公式

* 上标：^
* 下标：_
* 乘号：\times
* 除号：\div
* 分号：\frac ab
* 换行：\\\
* 对齐：\begin{align} ... \end{align}（aligned 也行）
* 左对齐：\begin{array}{l} ... \end{array}（只是公式按左对齐，整体还在中间）
  * c 中 l 左 r 右
* 等号对齐：&=（用对齐包起来）
* 上画线：\overline（一般用作括号功能的扩线）
* 下画线：\underline
* 不等于：\\neq
* [markdown中公式编辑教程 - 简书](https://www.jianshu.com/p/25f0139637b7)
* [Markdown数学符号&公式_诗蕊的专栏-CSDN博客](https://blog.csdn.net/katherine_hsr/article/details/79179622/)
* [有道云笔记中，在Markdown下写公式时，如何让几行公式左对齐，而不是默认的居中对齐？ - 知乎](https://www.zhihu.com/question/60028634)

### git markdown 标题

* markdown 标题，在 git 作为锚点，实现目录跳转，怎么在 URL 表示
* 空格转为 `-`，其它符号移除
* 所以改标题为 `#git-markdown-标题`

### 快捷打开蓝牙服务

* 只要连接过蓝牙设备，但是打开蓝牙设备的服务很繁琐，其本质只是一条命令

```cmd
"D:\Program Files (x86)\Intel\Bluetooth\btmsrvview.exe" fc:58:fa:5e:08:a4
```

### netstat 查看端口占用

```cmd
netstat -ao # 查看服务状态
# -a 显示所有连接和侦听端口
# -b 显示程序名
# -o 显示PID
# -n 数字形式显示地址和端口号
# netstat 命令在 Windows 很慢 耐心等待
tasklist | findstr PID # 根据 PID 查看程序名

netstat -ano | findstr 5554
```

### 修改 DNS 后

```cmd
ipconfig /flushdns # 清空一下缓存
```