## 刷机小米红米Note5A高配版

### 要准备的工具：

* 小米手机
* 刷机包
* twrp recovery img文件
* miflash_unlock 解锁
* UniversalAdbDriver adb驱动
* platform-tools adb fastboot工具
* Magisk root
* 注意：命令行工具要用系统自带的命令行窗口

### 1、解锁bootloader

去申请解锁，然后下载miflash_unlock工具，长按音量减+电源键进入fastboot（miflash_unlock自己会安装驱动）

### 2、刷入recovery
* 去twrp官网下载机型对应的recovery的img
* 下载adb https://developer.android.google.cn/studio/releases/platform-tools
* 在fastboot模式下
  * fastboot flash recovery twrp.img
  * fastboot boot twrp.img # 此行命令可以进TWRP的rec（或者刷入TWRP后重启前按音量加减和电源键进手机rec模式）
  * fastboot reboot重启
  * 到桌面​开启开发者模式，开启usb调试模式

### 3、刷机
* adb reboot recovery 进入recovery
* Advanced -> ADB sideload
* adb sideload local/filename.zip
* adb kill-server 刷入ROM后，结束adb服务

### 4、ROOT
* sideload方式同上

### 5、重置设备（格式化手机，恢复出厂设置） 必要
* 进入recovery模式，点击Wipe
* 点击Format Data，输入yes进行内存格式化，返回上一菜单（清空照片、媒体等文件）
* 滑动Swipe to Factory Reset恢复出厂设置（双清）

### 6、实用程序
* busybox
* 框架

[小米短接进9008模式（全型号小米手机进9008模式图解） - 3G行业新闻 - 电子发烧友网](www.elecfans.com/3g/news/20171221606091.html)

[【手把手教】红米note3全网通高通9008模式绕过BL锁强刷，救砖 - 小米社区](https://www.xiaomi.cn/post/1502839)