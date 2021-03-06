<map version="freeplane 1.8.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="CSS" FOLDED="false" ID="ID_1262215348" CREATED="1606742461350" MODIFIED="1606742463848"><hook NAME="MapStyle">
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
<node TEXT="渐进增强" POSITION="right" ID="ID_1214065717" CREATED="1606742465813" MODIFIED="1606742601800">
<node TEXT="Progressive Enhancement" ID="ID_1562330974" CREATED="1606742604272" MODIFIED="1606742609700">
<node TEXT="首先实现最小系统" ID="ID_1264532444" CREATED="1606742512357" MODIFIED="1606742522410"/>
<node TEXT="再为支持新特性的浏览器添加更多交互优化" ID="ID_1018309438" CREATED="1606742523846" MODIFIED="1606742557928"/>
<node TEXT="代码要分层" ID="ID_261751005" CREATED="1606742561011" MODIFIED="1606742581235">
<node TEXT="每一层增强代码只在适当的情况下生效" ID="ID_1642682166" CREATED="1606742581941" MODIFIED="1606742681796"/>
</node>
</node>
<node TEXT="浏览器自身策略" ID="ID_540227969" CREATED="1606742702231" MODIFIED="1606744038076">
<node TEXT="位置元素或属性不会报错" ID="ID_1583690601" CREATED="1606742729616" MODIFIED="1606742754169"/>
<node TEXT="对页面显示也不会有影响" ID="ID_1679015309" CREATED="1606742754462" MODIFIED="1606742762002"/>
<node TEXT="向后兼容" ID="ID_454212674" CREATED="1606742896528" MODIFIED="1606742899636"/>
</node>
<node TEXT="CSS 属性老前新后" ID="ID_121137813" CREATED="1606742954741" MODIFIED="1606743129632">
<node TEXT="浏览器不认识新属性忽略" ID="ID_900931954" CREATED="1606742971984" MODIFIED="1606742986463">
<node TEXT="认识老属性则显示" ID="ID_1520576655" CREATED="1606742987002" MODIFIED="1606743038947"/>
</node>
<node TEXT="支持新属性的浏览器覆盖前面的老属性" ID="ID_1230295720" CREATED="1606743054539" MODIFIED="1606743138293"/>
</node>
<node TEXT="浏览器厂商前缀" ID="ID_1254475601" CREATED="1606743172244" MODIFIED="1606743179209">
<node TEXT="-webkit-" ID="ID_875837660" CREATED="1606743184251" MODIFIED="1606743191632">
<node TEXT="Webkit" ID="ID_133301604" CREATED="1606743193029" MODIFIED="1606743301113">
<node TEXT="Safari" ID="ID_1345157154" CREATED="1606743303011" MODIFIED="1606743304048"/>
<node TEXT="Blink" ID="ID_1944746123" CREATED="1606743221656" MODIFIED="1606743238800">
<node TEXT="Chrome" ID="ID_536375520" CREATED="1606743240163" MODIFIED="1606743243874"/>
<node TEXT="Opera" ID="ID_257197876" CREATED="1606743244204" MODIFIED="1606743250394"/>
</node>
</node>
</node>
<node TEXT="-moz-" ID="ID_1322450822" CREATED="1606743207319" MODIFIED="1606743312800">
<node TEXT="Mozilla" ID="ID_1232687543" CREATED="1606743262558" MODIFIED="1606743270436">
<node TEXT="FireFox" ID="ID_1746182934" CREATED="1606743281754" MODIFIED="1606743290800"/>
</node>
</node>
<node TEXT="-ms-" ID="ID_255061109" CREATED="1606743314477" MODIFIED="1606743316827">
<node TEXT="Internet Explorer" ID="ID_393069517" CREATED="1606743319775" MODIFIED="1606743328934"/>
</node>
<node TEXT="再加上不带前缀的" ID="ID_1382114994" CREATED="1606743360514" MODIFIED="1606743604835">
<node TEXT="支持标准的浏览器" ID="ID_1277614481" CREATED="1606743382422" MODIFIED="1606743592730"/>
</node>
</node>
<node TEXT="条件规则" ID="ID_398349967" CREATED="1606743713625" MODIFIED="1606743717071">
<node TEXT="自身也很新可能不支持" ID="ID_432613103" CREATED="1606743718922" MODIFIED="1606743729128"/>
<node TEXT="检测某特性，若支持，则执行括起来的代码" ID="ID_944510269" CREATED="1606743729443" MODIFIED="1606743799217"/>
<node TEXT="@supports (display: grid) { /* 支持该特性时的代码 */ }" ID="ID_698699575" CREATED="1606743800230" MODIFIED="1606743958336"/>
</node>
<node TEXT="检测脚本" ID="ID_1852477793" CREATED="1606743878246" MODIFIED="1606743884510">
<node TEXT="Modernizr" ID="ID_1732090503" CREATED="1606743885143" MODIFIED="1606743899335"/>
</node>
</node>
<node TEXT="结构化" POSITION="left" ID="ID_1790130200" CREATED="1606744095370" MODIFIED="1606744170411">
<node TEXT="更利于搜索引擎爬虫" ID="ID_395057622" CREATED="1606744361726" MODIFIED="1606744405773"/>
<node TEXT="创建基础样式" ID="ID_97760960" CREATED="1606744584404" MODIFIED="1606744588979"/>
</node>
<node TEXT="语义化标记" POSITION="left" ID="ID_1758426361" CREATED="1606744171189" MODIFIED="1606744177491">
<node TEXT="在正确的地方用正确的元素" ID="ID_1664117704" CREATED="1606744179624" MODIFIED="1606744220426"/>
<node TEXT="使用标签本来的含义，通用法而不是怪用法" ID="ID_1667803596" CREATED="1606744220924" MODIFIED="1606744296838"/>
<node TEXT="使用场景更大化" ID="ID_1821428926" CREATED="1606744297300" MODIFIED="1606744316006">
<node TEXT="Lynx" ID="ID_1412335133" CREATED="1606744317664" MODIFIED="1606744321553"/>
<node TEXT="残障人士友好" ID="ID_1146187362" CREATED="1606744322192" MODIFIED="1606744347394"/>
</node>
</node>
<node TEXT="ID 和 class 属性" POSITION="left" ID="ID_551874314" CREATED="1607413348317" MODIFIED="1607413355538">
<node TEXT="上下文之外的元素样式接入点" ID="ID_1389839858" CREATED="1607413359775" MODIFIED="1607413403098">
<node TEXT="也就是给元素起名字" ID="ID_1468584680" CREATED="1607413619664" MODIFIED="1607413626822"/>
<node TEXT="《精通 CSS》第 12 章" ID="ID_2495433" CREATED="1607414382012" MODIFIED="1607414383157"/>
<node TEXT="ID 用于标识元素 class 用于样式" ID="ID_832909218" CREATED="1607414397536" MODIFIED="1607414417221"/>
</node>
<node TEXT="class 名" ID="ID_318407822" CREATED="1607413768628" MODIFIED="1607413774941">
<node TEXT="体现组件的类型而非样式" ID="ID_1250491255" CREATED="1607413774947" MODIFIED="1607414247248"/>
<node TEXT="是什么-怎么用" ID="ID_1771854870" CREATED="1607413715239" MODIFIED="1607414087960"/>
<node TEXT="product-list" ID="ID_1236133814" CREATED="1607413717829" MODIFIED="1607414096742"/>
<node TEXT="样式里只有 class 而无标签名" ID="ID_92034714" CREATED="1607415059621" MODIFIED="1607415076451"/>
</node>
<node TEXT="ID 名" ID="ID_543554699" CREATED="1607414163063" MODIFIED="1607414176098">
<node TEXT="标识模块的特定实例" ID="ID_1792042519" CREATED="1607414176103" MODIFIED="1607414204962"/>
<node TEXT="primary-product-id" ID="ID_274155884" CREATED="1607414214318" MODIFIED="1607415160695"/>
<node TEXT="额外的样式、交互或导航" ID="ID_1614558359" CREATED="1607414292441" MODIFIED="1607415164730"/>
</node>
</node>
<node TEXT="结构化元素" POSITION="left" ID="ID_104599618" CREATED="1607414472336" MODIFIED="1607414476612">
<node TEXT="HTML5 新增" ID="ID_1666166497" CREATED="1607414480737" MODIFIED="1607414484927">
<node TEXT="section" ID="ID_296392111" CREATED="1607414485930" MODIFIED="1607414490286"/>
<node TEXT="header" ID="ID_225409987" CREATED="1607414490466" MODIFIED="1607414493286">
<node TEXT="特定区块头部" ID="ID_930806703" CREATED="1607414556403" MODIFIED="1607414560240"/>
</node>
<node TEXT="footer" ID="ID_1005093267" CREATED="1607414493498" MODIFIED="1607414497241"/>
<node TEXT="nav" ID="ID_1172767450" CREATED="1607414497436" MODIFIED="1607414501297">
<node TEXT="导航组件" ID="ID_558624269" CREATED="1607414548378" MODIFIED="1607414555324"/>
</node>
<node TEXT="article" ID="ID_1764207071" CREATED="1607414501500" MODIFIED="1607414504841">
<node TEXT="独立内容" ID="ID_334905676" CREATED="1607414538489" MODIFIED="1607414541143"/>
</node>
<node TEXT="aside" ID="ID_135137388" CREATED="1607414505044" MODIFIED="1607414509577"/>
<node TEXT="main" ID="ID_864604925" CREATED="1607414509708" MODIFIED="1607414511289"/>
</node>
<node TEXT="除 main 外都可出现多次" ID="ID_1976216164" CREATED="1607414833903" MODIFIED="1607414846343"/>
<node TEXT="以前的 div+class 可改为语义标签" ID="ID_1460807222" CREATED="1607414897335" MODIFIED="1607415000808"/>
<node TEXT="但 class 名还是标识组件类型为妙" ID="ID_346660621" CREATED="1607415005943" MODIFIED="1607415023933"/>
</node>
<node TEXT="div 和 span" POSITION="left" ID="ID_1572293565" CREATED="1607415257758" MODIFIED="1607415269073">
<node TEXT="没有语义化标签对应之外的选择" ID="ID_362310431" CREATED="1607415269079" MODIFIED="1607415314636"/>
<node TEXT="额外添加无语义的 div 有时也利于代码的清晰和可维护" ID="ID_527626423" CREATED="1607415422621" MODIFIED="1607415463046"/>
<node TEXT="span 是文本级元素，用于在文本流中建立结构" ID="ID_185412087" CREATED="1607415463545" MODIFIED="1607415504237"/>
<node TEXT="span 的语义化替代" ID="ID_1363161814" CREATED="1607415534707" MODIFIED="1607415543996">
<node TEXT="time 标记时间和日期" ID="ID_526614375" CREATED="1607415552229" MODIFIED="1607415590856"/>
<node TEXT="q 标记引用" ID="ID_1002103278" CREATED="1607415556519" MODIFIED="1607415563859"/>
<node TEXT="em 强调（斜体）" ID="ID_1061409618" CREATED="1607415564047" MODIFIED="1607416181731"/>
<node TEXT="strong 重点强调（粗体）" ID="ID_1601394561" CREATED="1607415571663" MODIFIED="1607416178917"/>
</node>
<node TEXT="i（italic）和 b（bold）" ID="ID_868248008" CREATED="1607416952908" MODIFIED="1607416954832">
<node TEXT="就是块级的 em 和 strong" ID="ID_418566532" CREATED="1607416798239" MODIFIED="1607416950190"/>
<node TEXT="但已没有强调的语义" ID="ID_1981029953" CREATED="1607416957492" MODIFIED="1607416969658"/>
</node>
</node>
<node TEXT="扩展 HTML 语义" POSITION="right" ID="ID_131317755" CREATED="1607417020237" MODIFIED="1607417031523">
<node TEXT="ARIA" ID="ID_922026320" CREATED="1607417197284" MODIFIED="1607417200841">
<node TEXT="accessible rich Internet application" ID="ID_287237082" CREATED="1607417203084" MODIFIED="1607417203737"/>
<node TEXT="无障碍访问有语义化标签" ID="ID_495139843" CREATED="1607417204364" MODIFIED="1607417321130"/>
<node TEXT="还有 ARIA 的 role 属性（无障碍角色）" ID="ID_1969967084" CREATED="1607417321917" MODIFIED="1607417322736"/>
<node TEXT="banner" ID="ID_1574534411" CREATED="1607417248106" MODIFIED="1607417252111"/>
<node TEXT="form" ID="ID_889061057" CREATED="1607417252355" MODIFIED="1607417254009"/>
<node TEXT="main" ID="ID_1155407089" CREATED="1607417254979" MODIFIED="1607417256180"/>
<node TEXT="search" ID="ID_133952515" CREATED="1607417256498" MODIFIED="1607417258969"/>
<node TEXT="complementary" ID="ID_1862624969" CREATED="1607417259332" MODIFIED="1607417276200"/>
<node TEXT="application" ID="ID_567654400" CREATED="1607417278862" MODIFIED="1607417286612"/>
<node TEXT="《Using WAI-ARIA Landmarks》2013" ID="ID_892222937" CREATED="1607417328686" MODIFIED="1607417366263"/>
</node>
</node>
</node>
</map>
