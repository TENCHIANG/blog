## html+css

文本的水平居中 ：text-align: center;

图片的水平居中： text-align: center;

块级元素水平居中： margin-right: auto; margin-left: auto; 

单行文本的竖直居中：让 line-height 和 height 相等

不确定高度的一段文本竖直居中：使 padding-top: ...; padding-bottom: ...; padding-top 和 padding-bottom 值相同。

知道高度的块级元素竖直居中 ：使用 position: absolute; top: 50%; margin-top: ...;(margin-top的值为自身高度的值的一半的负值); 

绝对定位实现**水平垂直居中**： position: absolute; top: 0; right: 0; bottom: 0; left: 0; margin: auto; 

css3伸缩布局实现元素水平垂直居中：使用 display:flex;  align-items: center; 让子元素垂直居中 ； justify-content: center;让子元素水平居中

**CSS优先级**：元素和伪元素：1；类选择器、属性选择器或伪类：10；id选择符：100；内联样式：1000；important最高

**清除浮动** ：添加空div，使用`clear: both;`父元素使用`overflow: hidden;`父级定义高度；父级div定义伪类:after（最好）

 display: none; 和visibility: hidden;区别：前者不占据文档流；后者占据文档流

position比float 优先级高  position最高的

:after`和`::after：   :表示伪类，::表示伪元素

**Flex**即：Flexible Box，弹性布局，用来为盒状模型提供最大的灵活性。可以实现类似**垂直居中**布局。display: flex;

图片自适应宽高：max-width: 100%;max-height: 100%;

BFC 即 Block Formatting Contexts (块级格式化上下文)，它属于普通流，即：元素按照其在 HTML 中的先后位置至上而下布局

offsetWidth （content宽度+padding宽度+border宽度）

offsetHeight（content高度+padding高度+border高度）

clientWidth（content宽度+padding宽度）

clientHeight（content高度+padding高度）

**语义化的HTML**：页面使用合适的标签，通过标签能大概了解整体的布局





