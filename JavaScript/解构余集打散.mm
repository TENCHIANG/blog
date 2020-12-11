<map version="freeplane 1.8.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="解构、余集、打散" FOLDED="false" ID="ID_927903481" CREATED="1606735588930" MODIFIED="1606735609111"><hook NAME="MapStyle">
    <properties edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" fit_to_viewport="false"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24.0 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ICON_SIZE="12.0 pt" COLOR="#000000" STYLE="fork">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10.0 pt" SHAPE_VERTICAL_MARGIN="10.0 pt">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11"/>
</stylenode>
</stylenode>
</map_styles>
</hook>
<node TEXT="Destructuring" POSITION="right" ID="ID_217952141" CREATED="1606735781865" MODIFIED="1606735809782">
<node TEXT="可迭代对象" ID="ID_1465626394" CREATED="1606737243637" MODIFIED="1606738566434">
<node TEXT="左边的变量写在方括号里" ID="ID_1725049092" CREATED="1606737318677" MODIFIED="1606737339878"/>
<node TEXT="拆解右边的" ID="ID_574023868" CREATED="1606735840637" MODIFIED="1606737316379">
<node TEXT="数组" ID="ID_1630058096" CREATED="1606735891426" MODIFIED="1606735893018"/>
<node TEXT="字符串" ID="ID_1509323540" CREATED="1606735893506" MODIFIED="1606735895531"/>
</node>
<node TEXT="多的值忽略，少的值覆盖为 undefined" ID="ID_205736530" CREATED="1606735899941" MODIFIED="1606737551185"/>
<node TEXT="左边可以使用空元素跳过一些值" ID="ID_307350731" CREATED="1606737050385" MODIFIED="1606737089341"/>
</node>
<node TEXT="对象" ID="ID_951512420" CREATED="1606737253916" MODIFIED="1606737256515">
<node TEXT="左边的变量写在花括号里" ID="ID_639342742" CREATED="1606737369589" MODIFIED="1606737390540"/>
<node TEXT="左边找右边同名的字段赋值，否则覆盖为 undefined" ID="ID_491375376" CREATED="1606737399799" MODIFIED="1606737538872"/>
<node TEXT="左边可用等号指定默认值，右边有则覆盖" ID="ID_1012895316" CREATED="1606737566382" MODIFIED="1606737636517"/>
<node TEXT="对象解构可以用冒号改名（可默认值）" ID="ID_608334689" CREATED="1606738738095" MODIFIED="1606738918403"/>
</node>
<node TEXT="等号左边也可不定义变量" ID="ID_1781292853" CREATED="1606736888629" MODIFIED="1606739159666">
<node TEXT="右边解构，左边赋值" ID="ID_1372293259" CREATED="1606736961182" MODIFIED="1606739204001"/>
<node TEXT="可以用作交换值" ID="ID_644515800" CREATED="1606737771129" MODIFIED="1606737778996"/>
<node TEXT="但是完全没有等号和右边也不行" ID="ID_908151647" CREATED="1606738884666" MODIFIED="1606739220534"/>
</node>
<node TEXT="可用于函数参数" ID="ID_1858724530" CREATED="1606737846610" MODIFIED="1606737853176"/>
<node TEXT="也可以嵌套，但会复杂化" ID="ID_705148862" CREATED="1606738373055" MODIFIED="1606738384089"/>
<node TEXT="左花括号右方括号不报错" ID="ID_933481397" CREATED="1606739444019" MODIFIED="1606739505828">
<node TEXT="只会覆盖为 undefined" ID="ID_815713620" CREATED="1606739505831" MODIFIED="1606739507280"/>
<node TEXT="反之报错（右边非数组）" ID="ID_955732745" CREATED="1606739507698" MODIFIED="1606739520922"/>
</node>
</node>
<node TEXT="Rest" POSITION="right" ID="ID_765842091" CREATED="1606735815593" MODIFIED="1606735824959">
<node TEXT="类似可变参数，只是括号变方括号" ID="ID_255928058" CREATED="1606736416472" MODIFIED="1606736437191"/>
<node TEXT="三个点标识数组" ID="ID_857680671" CREATED="1606737901801" MODIFIED="1606737922665">
<node TEXT="多的值收集到数组" ID="ID_1271321401" CREATED="1606736266900" MODIFIED="1606737932555"/>
<node TEXT="不够则为空数组" ID="ID_1228975011" CREATED="1606736793297" MODIFIED="1606736886498"/>
</node>
<node TEXT="对象的余集（ES9）" ID="ID_858431149" CREATED="1606738454146" MODIFIED="1606738676219">
<node TEXT="左边是花括号，三个点标识对象" ID="ID_983143883" CREATED="1606738560912" MODIFIED="1606738608103"/>
<node TEXT="多的键值收集到对象" ID="ID_1480918751" CREATED="1606738611054" MODIFIED="1606738648552"/>
<node TEXT="不够则为空对象" ID="ID_1420499002" CREATED="1606738650003" MODIFIED="1606738655801"/>
</node>
</node>
<node TEXT="Spread" POSITION="right" ID="ID_530598529" CREATED="1606735825505" MODIFIED="1606735835992">
<node TEXT="三个点在等号右边就是打散" ID="ID_1040975149" CREATED="1606737160265" MODIFIED="1606737887425"/>
<node TEXT="打散可迭代对象" ID="ID_1305251624" CREATED="1606737979268" MODIFIED="1606738447259">
<node TEXT="打散在数组里" ID="ID_1100616579" CREATED="1606738146817" MODIFIED="1606738404984"/>
<node TEXT="打散在对象里" ID="ID_973868255" CREATED="1606738180085" MODIFIED="1606738411446">
<node TEXT="键为 0 开始下标" ID="ID_328995507" CREATED="1606738186007" MODIFIED="1606738200814"/>
<node TEXT="值就是值" ID="ID_92203790" CREATED="1606738201744" MODIFIED="1606738208983"/>
</node>
</node>
<node TEXT="打散对象" ID="ID_890025668" CREATED="1606738701658" MODIFIED="1606738706252">
<node TEXT="对象只能打散在对象里" ID="ID_852393208" CREATED="1606738958438" MODIFIED="1606738968138"/>
<node TEXT="同名后面会覆盖前面" ID="ID_1227283868" CREATED="1606739005808" MODIFIED="1606739050334"/>
</node>
<node TEXT="不止固定在最后" ID="ID_1517633415" CREATED="1606738030811" MODIFIED="1606739104134"/>
</node>
</node>
</map>
