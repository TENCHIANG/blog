<map version="freeplane 1.8.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Object Protocol" FOLDED="false" ID="ID_490240611" CREATED="1606739699378" MODIFIED="1606739710180"><hook NAME="MapStyle">
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
<node TEXT="Duck Typing" POSITION="right" ID="ID_78650443" CREATED="1606739738488" MODIFIED="1606739752144">
<node TEXT="对象模拟数组" ID="ID_1375046095" CREATED="1606739754083" MODIFIED="1606739763868"/>
</node>
<node TEXT="在语法、API 上有特殊的行为" POSITION="left" ID="ID_1486964056" CREATED="1606739827821" MODIFIED="1606739856670"/>
<node TEXT="valueOf" POSITION="right" ID="ID_505052905" CREATED="1606739874667" MODIFIED="1606739881569">
<node TEXT="把对象当数值用" ID="ID_1082086761" CREATED="1606739957775" MODIFIED="1606740994951">
<node TEXT="-、*、/、&lt;、&gt;、&lt;=、&gt;=、** 等" ID="ID_1081355638" CREATED="1606740811864" MODIFIED="1606740849057"/>
<node TEXT="默认返回对象本身" ID="ID_1694685519" CREATED="1606739965990" MODIFIED="1606739970014"/>
</node>
<node TEXT="Date() 返回的是字符串 valueOf 返回字符串本身" ID="ID_566612965" CREATED="1606740722482" MODIFIED="1606740895768"/>
<node TEXT="new Date() 是返回的是对象 valueOf 返回时间戳（毫秒数）" ID="ID_1053273897" CREATED="1606740729674" MODIFIED="1606740935943"/>
</node>
<node TEXT="toString" POSITION="right" ID="ID_1469558273" CREATED="1606740960584" MODIFIED="1606740962838">
<node TEXT="把对象当字符串用" ID="ID_1028289395" CREATED="1606740964307" MODIFIED="1606741002756">
<node TEXT="+ 优先 valueOf 未自定义则 toString" ID="ID_1576526597" CREATED="1606741152371" MODIFIED="1606741206947"/>
<node TEXT="默认返回 &apos;[object Object]&apos;" ID="ID_1264616352" CREATED="1606741030154" MODIFIED="1606741035729"/>
</node>
</node>
<node TEXT="toLocalString" POSITION="right" ID="ID_799956258" CREATED="1606741431216" MODIFIED="1606741435620">
<node TEXT="默认引用到最近的 toString" ID="ID_1899641454" CREATED="1606741440961" MODIFIED="1606741474762"/>
<node TEXT="本地语言环境的字符串表示" ID="ID_370747708" CREATED="1606741481069" MODIFIED="1606741497983"/>
</node>
<node TEXT="console.log" POSITION="right" ID="ID_1384375113" CREATED="1606741360853" MODIFIED="1606741381629">
<node TEXT="不使用 valueOf 或 toString" ID="ID_1206651753" CREATED="1606741382896" MODIFIED="1606741383533"/>
<node TEXT="递归展示对象结构" ID="ID_773965966" CREATED="1606741383936" MODIFIED="1606741539242"/>
</node>
</node>
</map>
