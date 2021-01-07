### 模块化的 Tomcat

* Server（1）
  * Service（n）
    * Connector（n）
    * Container（1）
    * Jasper、Naming、Session、Loging、JMX ...
* Server 管理多个 Service
* 一个 Service 由多个 Connector 搭配一个 Container 组成
  * Connector 负责对外交流，可任意替换
  * Container 处理 Connector 过来的请求

### Service 接口

* 关联 Connector、Container，同时初始化其下其它组件
* 所有组件的生命周期由 Lifecycle 接口控制
* 标准实现类为 StandardService，同时实现了 Lifecycle
* setContainer
  * 当前服务取关老的容器 Engine.setService(null)
  * 传进来的新容器，设置为当前服务的容器，并关联 setService(this)
  * 开始新容器的生命周期 Lifecycle.start
  * 将每个连接器关联到新容器 setContainer
  * 关闭老容器
  * 通知事件监听
* addConnector
  * 关联到当前容器 setContianer
  * 关联到当前服务 setService
  * 加入到当前连接器组的后面
  * 当前服务已初始化，则初始化该连接器
  * 开始生命周期