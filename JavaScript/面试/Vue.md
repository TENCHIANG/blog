## Vue

**MVVM**分为Model、View、ViewModel三者。

Model 代表数据模型，数据和业务逻辑都在Model层中定义；这个倒是和MVC中的Model是有差别的

View 代表的是UI视图，负责数据的展示；

ViewModel ，处理用户交互操作；说白了就是简单的中间层；Model 和 View 只是通过 ViewModel 来进行联系的，Model 和 ViewModel 就是直白的双向数据绑定的关系。负责监听 Model 中数据的改变并且控制视图的更新

这种模式就实现了 Model 和 View 的数据自动同步，所以开发的时候只需要专注对数据的维护操作就可以了，而不需要自己操作 dom。

difineProperty

**双向绑定**：vue是通过数据劫持的方式来做的嘛，它核心的方法是用ES5的define()来实现对属性的劫持来实现的嘛，我以前也试着写过一个，但是写的不好。define()方法会直接在一个对象上定义一个新属性，或者修改一个现有属性，（就像是有则改之，无则加勉） ，然后返回这个对象嘛。这个对象里边又存在两种描述符。名字不记得了，其中一个主要的描述符**什么鬼描述符忘了**  是由 gette/setter 函数功能来描述的属性。然后用一个Watch方法来监听（也可以说订阅），来接收每个属性变动的通知，接受到了通知（收到电话了），我命令你立刻执行指令绑定的回调函数，回调函数执行完 从而更新页面视图。

**Vuex**：状态管理工具，由5个部分构成，state，getter，mutation，action，module

* State：用来存储数据啊，存储状态什么的；在根实例里面注册了store（存储） 后，用 `this.$store.state` 来访问；对应vue里面的data；这玩意儿存放数据方式是响应式的，也就是说vue组件从store中读取数据，只要数据发生了变化，组件也会对应的进行更新。
* getter：可以说是 store 的计算属性吧，它有个依赖值，它的返回值会根据它的依赖被缓存起来，也只有当它的依赖值发生了改变才会被重新计算吧
* mutation：提交mutation是更改 Vuex 的 store 中的状态的方法嘛，好像就是唯一方法。
* action：包含任意异步操作，好像也是可以提交 mutation 去更变状态
* module：将 store 分割成模块，每个模块都具有state、mutation、action、getter、甚至是嵌套子模块。

不过如果不打算开发大型单页应用，使用 Vuex 就停繁琐的。如果应用够简单，那最好不要使用 Vuex。杀鸡焉用宰牛刀是吧。



v-show是只是css切换显示隐藏而已，v-if是一个销毁和重新创建过程嘛，所以组件频繁切换显隐状态的时候就用V-show，否则就用v-if

**computed和 watch**：计算属性是自动监听依赖值的变化，动态返回内容，监听是一个过程，在监听的值变化时，就可以触发一个回调。如果需要监听值之后处理业务逻辑，就用watch。如果只需动态返回值就用计算属性啊。

**computed 和 methods**：methods是一个方法啊，它可以接受参数，但是computed不能啊

computed可以依赖其他computed，甚至是其他组件的data

**单向数据流**：这个是说的组件通信吧，父组件通过 prop 把数据传递到子组件，但是这个 prop 只能由父组件修改，子组件不能修改，不然就会报错。子组件想修改时，就只能通过 $emit 派发一个自定义事件，父组件接收到之后，再由父组件修改。

**生命周期**：

创建前后触发 beforeCreate/created  载入前后触发 beforeMount/mounted

更新前后 beforeUpdate/updated（这两个不常用，不推荐使用。）  销毁前后触发beforeDestory/destoryed

**跳转方式**：1.router-link标签跳转 2.router.push()跳转

**render**：vue一般都是用template来创建页面，然后在有的时候，需要使用js来创建html，就才用到

**keep-alive**：就有时候一些标签切换啊，就需要把原本标签里的内容在第一次创建的时候就缓存下来，这个主要是避免反复重渲染导致的性能问题。



vue 适合写移动端啊，易于修改，也比较容易上手，比较轻量级。都差不多。不过一个很简单同样功能的项目，vue可能小了一半。其余的不好说，毕竟Angular太久没用了，也不好评价。不过angular凭借 Typescript的加持，在团队开发的情况下面，angular开发效率会更高。毕竟vue对于TypeScript的支持还不全面，