<map version="freeplane 1.8.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="web.xml" FOLDED="false" ID="ID_1586654480" CREATED="1607075813836" MODIFIED="1607075819257" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle">
    <properties fit_to_viewport="false" edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff"/>

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
<hook NAME="AutomaticEdgeColor" COUNTER="2" RULE="ON_BRANCH_CREATION"/>
<node TEXT="Annotation" POSITION="right" ID="ID_1541918273" CREATED="1606965179101" MODIFIED="1606965185043">
<edge COLOR="#00007c"/>
<node TEXT="标注开始于 Java EE 6，Servlet 3.0" ID="ID_911577401" CREATED="1606964976732" MODIFIED="1606965004809">
<node TEXT="告知容器哪些 Servlet 提供服务和额外信息" ID="ID_1224948975" CREATED="1606965011541" MODIFIED="1606965062247"/>
<node TEXT="之前用 web.xml" ID="ID_1211631086" CREATED="1606965739544" MODIFIED="1606965767340"/>
</node>
<node TEXT="@WebServlet" ID="ID_1833607686" CREATED="1606964953864" MODIFIED="1606965190754">
<node TEXT="属性" ID="ID_552366970" CREATED="1606965244446" MODIFIED="1606965246148">
<node TEXT="name" ID="ID_688300752" CREATED="1606965201480" MODIFIED="1606965202979">
<node TEXT="默认为类全限定名（包括包）" ID="ID_289596213" CREATED="1606965437432" MODIFIED="1606967407443"/>
</node>
<node TEXT="urlPatterns" ID="ID_1205870498" CREATED="1606965204114" MODIFIED="1606965208524">
<node TEXT="花括号包起来的 URI 序列" ID="ID_1694761172" CREATED="1606965942325" MODIFIED="1606965959314"/>
<node TEXT="只有一个 URL 可省略花括号" ID="ID_1357101570" CREATED="1606965961631" MODIFIED="1606965972339"/>
<node TEXT="必须指定，没有默认" ID="ID_993829157" CREATED="1606966172279" MODIFIED="1606967904713"/>
</node>
<node TEXT="loadOnStartup" ID="ID_815901353" CREATED="1606965208975" MODIFIED="1606965223191">
<node TEXT="默认首次请求才会初始化相应 Servlet" ID="ID_1635020884" CREATED="1606965494917" MODIFIED="1606965545520"/>
<node TEXT="默认 -1 表示事先不初始化" ID="ID_1819377681" CREATED="1606965548696" MODIFIED="1607066501213"/>
<node TEXT="0 开始表示优先级别" ID="ID_1631153980" CREATED="1606965588018" MODIFIED="1607066517850"/>
<node TEXT="越小越优先，数字相同容器自定" ID="ID_1558922807" CREATED="1606966037040" MODIFIED="1606966052706"/>
</node>
<node TEXT="格式" ID="ID_33634859" CREATED="1606965796124" MODIFIED="1606965799980">
<node TEXT="(k=v, k=v, ..., k=v)" ID="ID_203237283" CREATED="1606965806292" MODIFIED="1606965840531"/>
<node TEXT="只有一个属性可只写 urlPatterns 的值" ID="ID_636185823" CREATED="1606965846687" MODIFIED="1606967931809"/>
</node>
</node>
<node TEXT="如果请求 URI 匹配则由该 Servlet 提供服务" ID="ID_16580564" CREATED="1606965302826" MODIFIED="1606965369546"/>
</node>
</node>
<node TEXT="web.xml" POSITION="left" ID="ID_1076015635" CREATED="1607066655093" MODIFIED="1607066658958">
<edge COLOR="#007c00"/>
<node TEXT="部署描述文件" ID="ID_1678165169" CREATED="1607066704019" MODIFIED="1607067064978">
<node TEXT="WebContent/WEB-INF/web.xml" ID="ID_1850497705" CREATED="1607066675296" MODIFIED="1607067038564"/>
<node TEXT="Deployment Description" ID="ID_1788295564" CREATED="1607067066771" MODIFIED="1607067067567"/>
<node TEXT="DD 文件" ID="ID_1654447351" CREATED="1607067068003" MODIFIED="1607067076627"/>
</node>
<node TEXT="创建描述文件" ID="ID_1739537302" CREATED="1607067204069" MODIFIED="1607067210478">
<node TEXT="右键 Deployment Descriptor: 项目名" ID="ID_489346620" CREATED="1607067217463" MODIFIED="1607067252440"/>
<node TEXT="Generate Deployment Descriptor Sub" ID="ID_404107388" CREATED="1607067253940" MODIFIED="1607067278270"/>
</node>
<node TEXT="节点含义" ID="ID_1373791513" CREATED="1607067322397" MODIFIED="1607067329676">
<node TEXT="web-app" ID="ID_626458749" CREATED="1607067329941" MODIFIED="1607067350916">
<node TEXT="属性" ID="ID_1003640448" CREATED="1607068509055" MODIFIED="1607068514567">
<node TEXT="xmlns:xsi" ID="ID_764821158" CREATED="1607068515665" MODIFIED="1607068516310"/>
<node TEXT="xmlns" ID="ID_203447396" CREATED="1607068516641" MODIFIED="1607068521167"/>
<node TEXT="xsi:schemaLocation" ID="ID_1543217974" CREATED="1607068528175" MODIFIED="1607068528175">
<node TEXT="web-app_4_0.xsd" ID="ID_1722424310" CREATED="1607068631135" MODIFIED="1607068631942"/>
</node>
<node TEXT="version" ID="ID_1711271630" CREATED="1607068543030" MODIFIED="1607068543832"/>
</node>
<node TEXT="为根节点" ID="ID_530453793" CREATED="1607068570616" MODIFIED="1607068578206"/>
</node>
<node TEXT="display-name" ID="ID_37586027" CREATED="1607067352328" MODIFIED="1607067362799">
<node TEXT="Web app 名称" ID="ID_1437508156" CREATED="1607067367874" MODIFIED="1608110404947"/>
<node TEXT="Context Root" ID="ID_491450185" CREATED="1607067538857" MODIFIED="1607067969479">
<node TEXT="环境根目录" ID="ID_128411064" CREATED="1607067706686" MODIFIED="1608110401375"/>
<node TEXT="META-INFO/context.xml 也可设定" ID="ID_1786228310" CREATED="1607067549938" MODIFIED="1607067585836"/>
<node TEXT="Eclipse 设定" ID="ID_63738973" CREATED="1607067733514" MODIFIED="1607067796944">
<node TEXT="右键项目" ID="ID_1317787906" CREATED="1607067799595" MODIFIED="1607067800562"/>
<node TEXT="点击 Properties" ID="ID_1401590792" CREATED="1607067745836" MODIFIED="1607067757691"/>
<node TEXT="在 Web Project Settings" ID="ID_1253171731" CREATED="1607067758421" MODIFIED="1607067779358"/>
</node>
</node>
</node>
<node TEXT="default-context-path" ID="ID_1551551385" CREATED="1607067906617" MODIFIED="1607067914903">
<node TEXT="Servlet 4.0" ID="ID_960013416" CREATED="1607067916987" MODIFIED="1607067922736"/>
<node TEXT="建议默认环境路径" ID="ID_466917636" CREATED="1607067923333" MODIFIED="1607067938619"/>
<node TEXT="容器实现厂商为了兼容可忽略" ID="ID_837374095" CREATED="1607067939301" MODIFIED="1607068014210"/>
</node>
<node TEXT="welcome-file-list" ID="ID_1348301525" CREATED="1607068025409" MODIFIED="1607068033752">
<node TEXT="没有请求指定的文件" ID="ID_1815182397" CREATED="1607068050379" MODIFIED="1607068104128"/>
<node TEXT="就使用这些默认文件" ID="ID_507049787" CREATED="1607068104356" MODIFIED="1607068124602"/>
</node>
<node TEXT="servlet" ID="ID_1429054543" CREATED="1607068237428" MODIFIED="1607068240133">
<node TEXT="servlet-name" ID="ID_577133199" CREATED="1607068240141" MODIFIED="1607068837925">
<node TEXT="与标注相同时优先级比标注高" ID="ID_950231445" CREATED="1607068778619" MODIFIED="1607068825583"/>
<node TEXT="用标注做默认值 web.xml 做更新值" ID="ID_165699255" CREATED="1607068812239" MODIFIED="1607068836735"/>
</node>
<node TEXT="servlet-class" ID="ID_1244053848" CREATED="1607068245269" MODIFIED="1607068250819">
<node TEXT="类的全限定名" ID="ID_1703059421" CREATED="1607068274953" MODIFIED="1607068280087"/>
<node TEXT="实体类名称" ID="ID_1648036453" CREATED="1607075249058" MODIFIED="1607075252735"/>
</node>
<node TEXT="load-on-startup" ID="ID_1389651504" CREATED="1607068251054" MODIFIED="1607068258884">
<node TEXT="数字相同按顺序来" ID="ID_739338615" CREATED="1607068317006" MODIFIED="1607068347576"/>
</node>
</node>
<node TEXT="servlet-mapping" ID="ID_1937476451" CREATED="1607068284403" MODIFIED="1607068289408">
<node TEXT="servlet-name" ID="ID_1380529567" CREATED="1607068290731" MODIFIED="1607068295513">
<node TEXT="注册名称" ID="ID_1607547565" CREATED="1607075239232" MODIFIED="1607075242975"/>
</node>
<node TEXT="url-pattern" ID="ID_1244658827" CREATED="1607068295835" MODIFIED="1607068301634">
<node TEXT="逻辑名称" ID="ID_937340351" CREATED="1607075226631" MODIFIED="1607075391927"/>
</node>
</node>
</node>
<node TEXT="配置顺序" ID="ID_841488702" CREATED="1608114360055" MODIFIED="1608114368514">
<node TEXT="标准未定义" ID="ID_1105672432" CREATED="1608114368523" MODIFIED="1608114373809">
<node TEXT="web.xml 与标注" ID="ID_92051874" CREATED="1608114373818" MODIFIED="1608114381197"/>
<node TEXT="web-fragment.xml 与标注" ID="ID_1994418262" CREATED="1608114381606" MODIFIED="1608114394317"/>
</node>
<node TEXT="web.xml" ID="ID_843918061" CREATED="1608114396343" MODIFIED="1608115313769">
<node TEXT="&lt;absolute-ordering&gt;" ID="ID_1084623683" CREATED="1608114413848" MODIFIED="1608114428512">
<node TEXT="比片段的 &lt;ordering&gt; 都优先" ID="ID_926436594" CREATED="1608115124190" MODIFIED="1608115135837"/>
<node TEXT="&lt;name&gt;" ID="ID_642280032" CREATED="1608114440933" MODIFIED="1608114445120">
<node TEXT="Web 片段名" ID="ID_489588190" CREATED="1608114451988" MODIFIED="1608114461085"/>
<node TEXT="web-fragment.xml 定义的片段名不要重复" ID="ID_1403521033" CREATED="1608114496590" MODIFIED="1608114514298"/>
<node TEXT="否则会忽略重复的名称" ID="ID_961468184" CREATED="1608114515311" MODIFIED="1608114524619"/>
</node>
<node TEXT="&lt;others /&gt;" ID="ID_6081220" CREATED="1608115140834" MODIFIED="1608115146804"/>
<node TEXT="如果为空，则进制 app 所有片段" ID="ID_946574871" CREATED="1608115225125" MODIFIED="1608115234194"/>
</node>
</node>
<node TEXT="web-fragment.xml" ID="ID_64443015" CREATED="1608114538212" MODIFIED="1608114545100">
<node TEXT="&lt;ordering&gt;" ID="ID_1915291574" CREATED="1608114548483" MODIFIED="1608114556055">
<node TEXT="&lt;before&gt;" ID="ID_236315231" CREATED="1608114564109" MODIFIED="1608114570859">
<node TEXT="&lt;name&gt;" ID="ID_535790388" CREATED="1608114593909" MODIFIED="1608114596943"/>
<node TEXT="&lt;others /&gt;" ID="ID_1145357853" CREATED="1608114627847" MODIFIED="1608114645908">
<node TEXT="表示任何未指定的片段" ID="ID_594840219" CREATED="1608115003427" MODIFIED="1608115009640"/>
</node>
</node>
<node TEXT="&lt;after&gt;" ID="ID_1146373049" CREATED="1608114571099" MODIFIED="1608114573909">
<node TEXT="&lt;name&gt;" ID="ID_792932922" CREATED="1608114593909" MODIFIED="1608114596943"/>
<node TEXT="&lt;others /&gt;" ID="ID_1150465674" CREATED="1608114627847" MODIFIED="1608114643477"/>
</node>
</node>
</node>
<node TEXT="metadata-complete" ID="ID_379094445" CREATED="1608115326649" MODIFIED="1608115341579">
<node TEXT="根属性" ID="ID_1584782152" CREATED="1608115315233" MODIFIED="1608119985013">
<node TEXT="&lt;web-app&gt;" ID="ID_1483780351" CREATED="1608119985023" MODIFIED="1608120033829">
<node TEXT="不会扫描 web-fragment.xml 的配置" ID="ID_447694208" CREATED="1608115373282" MODIFIED="1608120373126"/>
<node TEXT="&lt;absolute-ordering&gt;、&lt;ordering&gt; 会被忽略" ID="ID_1944234806" CREATED="1608115418923" MODIFIED="1608115439490"/>
</node>
<node TEXT="&lt;web-fragment&gt;" ID="ID_632088025" CREATED="1608120050533" MODIFIED="1608120051578">
<node TEXT="只会处理 JAR 自身的注解" ID="ID_770991302" CREATED="1608120283906" MODIFIED="1608120313349"/>
<node TEXT="否则" ID="ID_1893716646" CREATED="1608120436014" MODIFIED="1608120437943">
<node TEXT="否则外部类本身有注解" ID="ID_461150646" CREATED="1608120373820" MODIFIED="1608120394868"/>
<node TEXT="且片段也定义该类为 Servlet" ID="ID_1730444530" CREATED="1608120400389" MODIFIED="1608120425856"/>
<node TEXT="会有两个 Servlet 实例" ID="ID_1364075385" CREATED="1608120426336" MODIFIED="1608120434003"/>
</node>
</node>
</node>
<node TEXT="默认为 false" ID="ID_738074939" CREATED="1608115341590" MODIFIED="1608115346016"/>
<node TEXT="true 表示禁止扫描和注解配置" ID="ID_1714254774" CREATED="1608115346305" MODIFIED="1608115372944"/>
</node>
</node>
</node>
<node TEXT="文件组织与部署" POSITION="right" ID="ID_897393380" CREATED="1607304845831" MODIFIED="1607304881403">
<edge COLOR="#ff0000"/>
<node TEXT="Web app" ID="ID_1376229297" CREATED="1607075945405" MODIFIED="1608110354451">
<node TEXT="WEB-INF" ID="ID_1825639749" CREATED="1607075948867" MODIFIED="1608108963826">
<node TEXT="浏览器无法直接访问" ID="ID_482013412" CREATED="1608111107981" MODIFIED="1608111125100">
<node TEXT="可以通过类访问" ID="ID_876221080" CREATED="1608111125108" MODIFIED="1608111140366"/>
<node TEXT="ServletContext" ID="ID_723471501" CREATED="1608111140829" MODIFIED="1608111149847">
<node TEXT="getResources" ID="ID_13228262" CREATED="1608111149856" MODIFIED="1608111154530"/>
<node TEXT="getResourceAsTream" ID="ID_1070977332" CREATED="1608111154828" MODIFIED="1608111165475"/>
</node>
<node TEXT="RequestDispatcher" ID="ID_697829611" CREATED="1608111170220" MODIFIED="1608111181785"/>
</node>
<node TEXT="classes" ID="ID_1970209079" CREATED="1607075992554" MODIFIED="1608108957386">
<node TEXT="META-INF" ID="ID_13991315" CREATED="1608109117245" MODIFIED="1608109128152">
<node TEXT="Application Resources" ID="ID_235909208" CREATED="1608109133499" MODIFIED="1608109142304"/>
<node TEXT="可以通过 ClassLoader 访问" ID="ID_1480853005" CREATED="1608109564678" MODIFIED="1608109579818"/>
<node TEXT="Java Persistence API" ID="ID_1513587157" CREATED="1608109670255" MODIFIED="1608109685076">
<node TEXT="persistence.xml" ID="ID_1215835060" CREATED="1608109685083" MODIFIED="1608109692809"/>
<node TEXT="orm.xml" ID="ID_1000731817" CREATED="1608109693102" MODIFIED="1608109696141"/>
</node>
</node>
<node TEXT="class 文件和资源" ID="ID_848639704" CREATED="1608108953998" MODIFIED="1608109166378">
<node TEXT="文件夹包结构" ID="ID_1777453655" CREATED="1608109377242" MODIFIED="1608109383467"/>
<node TEXT="找类顺序" ID="ID_726943631" CREATED="1608110986117" MODIFIED="1608110996322">
<node TEXT="/WEB-INF/classes" ID="ID_218294944" CREATED="1608110996330" MODIFIED="1608111012235"/>
<node TEXT="/WEB-INF/lib" ID="ID_1375400145" CREATED="1608111012622" MODIFIED="1608111041840"/>
<node TEXT="容器本身目录" ID="ID_1180576527" CREATED="1608111042179" MODIFIED="1608111052473">
<node TEXT="tomcat/lib" ID="ID_1995213434" CREATED="1608111055021" MODIFIED="1608111064848"/>
</node>
</node>
</node>
</node>
<node TEXT="lib" ID="ID_1337145338" CREATED="1607075979697" MODIFIED="1608108959628">
<node TEXT="Bundled JAR Files" ID="ID_80205467" CREATED="1608108950478" MODIFIED="1608109190237">
<node TEXT="里面也可以放资源文件" ID="ID_834774124" CREATED="1608112580165" MODIFIED="1608112590623"/>
<node TEXT="META-INF" ID="ID_1397220362" CREATED="1608112590952" MODIFIED="1608112597330">
<node TEXT="resources" ID="ID_1668509871" CREATED="1608112598472" MODIFIED="1608112605715"/>
<node TEXT="web-fragment.xml" ID="ID_127185185" CREATED="1608113823633" MODIFIED="1608113836315">
<node TEXT="Web 片段的部署描述文件" ID="ID_1225770378" CREATED="1608113843301" MODIFIED="1608113855761"/>
<node TEXT="类似 web.xml" ID="ID_819399900" CREATED="1608113864197" MODIFIED="1608113874976"/>
<node TEXT="根标签为 &lt;web-fragment&gt; 而非 &lt;web-app&gt;" ID="ID_1330884744" CREATED="1608113887073" MODIFIED="1608113946297"/>
<node TEXT="Web 片段指定的类" ID="ID_276997976" CREATED="1608113905967" MODIFIED="1608113972111">
<node TEXT="也可以是 webapp/WEB-INF/classes 的类" ID="ID_1356552688" CREATED="1608113972123" MODIFIED="1608113989539"/>
</node>
</node>
</node>
<node TEXT="JAR 也可做成组件或模块" ID="ID_467422414" CREATED="1608113722018" MODIFIED="1608113765086">
<node TEXT="Web 片段" ID="ID_1144849504" CREATED="1608113734576" MODIFIED="1608113746909">
<node TEXT="Servlet" ID="ID_474099154" CREATED="1608112739370" MODIFIED="1608112744691"/>
<node TEXT="监听器" ID="ID_191541673" CREATED="1608112745076" MODIFIED="1608112746746"/>
<node TEXT="过滤器" ID="ID_478441834" CREATED="1608112746950" MODIFIED="1608112756720"/>
</node>
<node TEXT="Eclipse" ID="ID_253905672" CREATED="1608114036942" MODIFIED="1608114040687">
<node TEXT="File - New - Other - Web - Web Fragement Project - Next" ID="ID_959565484" CREATED="1608114040699" MODIFIED="1608114105564"/>
<node TEXT="New Web Fragment Project 对话框" ID="ID_685685604" CREATED="1608114109395" MODIFIED="1608114135242">
<node TEXT="设置 Dynamic Web Project membership" ID="ID_780309948" CREATED="1608114135251" MODIFIED="1608114157650"/>
<node TEXT="JAR 文件部署于哪个 webapp/WEB-INF/lib" ID="ID_1033891973" CREATED="1608114158473" MODIFIED="1608114196452"/>
</node>
<node TEXT="右键 webapp 项目 - Properties - Deployment Assembly" ID="ID_409048355" CREATED="1608114230544" MODIFIED="1608114290700">
<node TEXT="可以看到 Web 片段 JAR" ID="ID_466298996" CREATED="1608114290710" MODIFIED="1608114298596"/>
</node>
</node>
</node>
</node>
</node>
<node TEXT="i18n" ID="ID_244192377" CREATED="1608109207173" MODIFIED="1608109212149">
<node TEXT="Internationalization Files" ID="ID_627069332" CREATED="1608109212157" MODIFIED="1608109242072"/>
<node TEXT="非规范" ID="ID_194292839" CREATED="1608113517988" MODIFIED="1608113546760">
<node TEXT="国际化 i18n" ID="ID_1739986377" CREATED="1608113547977" MODIFIED="1608113582168"/>
<node TEXT="本地化 L10n" ID="ID_1070759102" CREATED="1608113552313" MODIFIED="1608113574988"/>
</node>
</node>
<node TEXT="tags" ID="ID_950340608" CREATED="1608109246831" MODIFIED="1608109249945">
<node TEXT="JSP Tag Files" ID="ID_919077962" CREATED="1608109249953" MODIFIED="1608109259892"/>
</node>
<node TEXT="tld" ID="ID_474107954" CREATED="1608109261918" MODIFIED="1608109264741">
<node TEXT="JSP Tag Library Descriptors" ID="ID_1850506898" CREATED="1608109264748" MODIFIED="1608109287188"/>
</node>
<node TEXT="web.xml" ID="ID_279477112" CREATED="1607075974488" MODIFIED="1608108961230">
<node TEXT="部署描述文件" ID="ID_1960230333" CREATED="1608108945283" MODIFIED="1608108946202"/>
<node TEXT="定义" ID="ID_609548256" CREATED="1608109840441" MODIFIED="1608109849080">
<node TEXT="Servlet" ID="ID_412105757" CREATED="1608109849088" MODIFIED="1608109851687"/>
<node TEXT="监听器" ID="ID_1730651166" CREATED="1608109852749" MODIFIED="1608109856452"/>
<node TEXT="过滤器" ID="ID_1543839932" CREATED="1608109856773" MODIFIED="1608109859155"/>
</node>
<node TEXT="配置选项" ID="ID_1429765593" CREATED="1608109866528" MODIFIED="1608109869755">
<node TEXT="HTTP 会话" ID="ID_1456484054" CREATED="1608109869762" MODIFIED="1608109878317"/>
<node TEXT="JSP" ID="ID_472020461" CREATED="1608109880077" MODIFIED="1608109884167"/>
<node TEXT="Web app" ID="ID_60727300" CREATED="1608109884778" MODIFIED="1608110350553"/>
</node>
<node TEXT="Java EE 6、Servlet 3.0" ID="ID_951887752" CREATED="1608109921386" MODIFIED="1608109939884">
<node TEXT="Annotation" ID="ID_1965582895" CREATED="1608109939892" MODIFIED="1608110424174"/>
<node TEXT="Java Configuration API" ID="ID_1041595625" CREATED="1608109946374" MODIFIED="1608109972448"/>
<node TEXT="Web Fragment" ID="ID_720609401" CREATED="1608109973741" MODIFIED="1608110027676">
<node TEXT="Web 片段" ID="ID_1943313794" CREATED="1608110087880" MODIFIED="1608110093519"/>
</node>
</node>
</node>
</node>
<node TEXT="META-INF" ID="ID_1211617224" CREATED="1608109073970" MODIFIED="1608109130086">
<node TEXT="MANIFEST.MF" ID="ID_102169108" CREATED="1608109080564" MODIFIED="1608109092197">
<node TEXT="应用程序清单文件" ID="ID_1729615996" CREATED="1608109528576" MODIFIED="1608109536810"/>
</node>
<node TEXT="Contianer Resources" ID="ID_1588322620" CREATED="1608109094735" MODIFIED="1608109107130"/>
<node TEXT="不可通过 ClassLoader 访问" ID="ID_557387084" CREATED="1608109539332" MODIFIED="1608109556953"/>
<node TEXT="非标准的容器资源" ID="ID_669826339" CREATED="1608109599244" MODIFIED="1608109632159"/>
<node TEXT="recources" ID="ID_1072284424" CREATED="1608110698178" MODIFIED="1608110725345">
<node TEXT="环境根目录下找不到，往这里找" ID="ID_30475683" CREATED="1608110725354" MODIFIED="1608110738597"/>
<node TEXT="index.html" ID="ID_860179561" CREATED="1608110453752" MODIFIED="1608110459001">
<node TEXT="/webapp/index.html" ID="ID_42013743" CREATED="1608110459010" MODIFIED="1608110466239"/>
</node>
</node>
</node>
<node TEXT="Other Web-Accessible Files" ID="ID_1970287862" CREATED="1607075955878" MODIFIED="1608109311884">
<node TEXT="客户端可以直接访问" ID="ID_574484942" CREATED="1608109316072" MODIFIED="1608109321241"/>
<node TEXT="index.html" ID="ID_504296121" CREATED="1608110453752" MODIFIED="1608110459001">
<node TEXT="/webapp/index.html" ID="ID_1849828777" CREATED="1608110459010" MODIFIED="1608110466239"/>
</node>
</node>
</node>
<node TEXT="WAR 文件" ID="ID_728556634" CREATED="1607076448019" MODIFIED="1607304866452">
<node TEXT="Web Archive" ID="ID_1536149638" CREATED="1607076453928" MODIFIED="1607076471252"/>
<node TEXT="Web app 可以打包成 JAR 文件" ID="ID_919024437" CREATED="1608110497721" MODIFIED="1608110523208"/>
<node TEXT="建立 WAR 文件" ID="ID_565255196" CREATED="1607076581122" MODIFIED="1607076595585">
<node TEXT="jar cvf ../webapp.war *" ID="ID_1780576280" CREATED="1607076496325" MODIFIED="1608111234557"/>
<node TEXT="右键项目 - Export - WAR file" ID="ID_822724366" CREATED="1607076553124" MODIFIED="1607076573237"/>
</node>
<node TEXT="采用 zip 格式" ID="ID_238141644" CREATED="1607076599770" MODIFIED="1607076655396"/>
<node TEXT="可直接放在 tomcat 的 webapps 下" ID="ID_215603421" CREATED="1607076655761" MODIFIED="1607076657293"/>
</node>
<node TEXT="URL 结构" ID="ID_1050761671" CREATED="1608109332775" MODIFIED="1608109343171">
<node TEXT="http://服务器:端口/webapp/servlet/path" ID="ID_1239617077" CREATED="1607076269727" MODIFIED="1608110556813">
<node TEXT="path 不一定是真实的路径" ID="ID_171185718" CREATED="1608110565644" MODIFIED="1608110574920"/>
<node TEXT="某个符合 URI 模式的 Servlet" ID="ID_1193322740" CREATED="1608110587887" MODIFIED="1608110619691"/>
</node>
<node TEXT="如果 URL 最后以斜杠 / 结尾" ID="ID_902683141" CREATED="1608111303672" MODIFIED="1608111321917">
<node TEXT="存在该文件夹" ID="ID_700265807" CREATED="1608111322489" MODIFIED="1608111329538">
<node TEXT="该文件夹下的欢迎文件" ID="ID_1249920357" CREATED="1608111344728" MODIFIED="1608111359448">
<node TEXT="web.xml" ID="ID_194894501" CREATED="1608111359824" MODIFIED="1608111365810">
<node TEXT="&lt;welcome-file-list&gt;" ID="ID_128162187" CREATED="1608111365818" MODIFIED="1608111381242"/>
<node TEXT="&lt;welcome-file&gt;" ID="ID_230687668" CREATED="1608111381637" MODIFIED="1608111387011"/>
</node>
</node>
<node TEXT="找不到欢迎文件" ID="ID_1692880647" CREATED="1608111410075" MODIFIED="1608111414615">
<node TEXT="/META-INF/resources" ID="ID_1609538207" CREATED="1608111414625" MODIFIED="1608111434739"/>
</node>
</node>
<node TEXT="不存在该文件夹" ID="ID_1475026437" CREATED="1608111329948" MODIFIED="1608111334724">
<node TEXT="默认 Servlet" ID="ID_1837132671" CREATED="1608111438984" MODIFIED="1608111447018"/>
</node>
</node>
</node>
</node>
</node>
</map>