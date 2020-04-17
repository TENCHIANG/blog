## Windows小技巧

### Windows下多tab的控制台应用

* MacOS和Linux都有天然的多tab控制台
* Windows下，mintty很好用，但是不支持多tab

### 方案一、ConEmu

* `{Bash::Git Bash}`
* Interface language: `zh: 简体中文`
* Choose color: `<xtrerm>`
* 单实例模式
* 窗口大小：128 x 32
* 通用 - 任务栏：
  * 取消勾选 `自动最小化到任务状态区域（TSA）`
  * 选择 `仅活动控制台（ConEmu窗口）`
* 注意编码默认是 utf8了
* 已知问题：
  * git commit -m "" 在双引号内输入中文会出问题（建议先只打单个双引号）