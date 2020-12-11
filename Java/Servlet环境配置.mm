<map version="freeplane 1.8.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Servlet" FOLDED="false" ID="ID_1369726506" CREATED="1606954378734" MODIFIED="1606954385437" STYLE="oval">
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
<hook NAME="AutomaticEdgeColor" COUNTER="4" RULE="ON_BRANCH_CREATION"/>
<node TEXT="Tomcat" POSITION="right" ID="ID_492114448" CREATED="1606954393434" MODIFIED="1606954397547">
<edge COLOR="#ff0000"/>
<node TEXT="三个版本" ID="ID_1991367018" CREATED="1606956088710" MODIFIED="1606956091450">
<node TEXT="Core" ID="ID_705875662" CREATED="1606954671781" MODIFIED="1606954673401">
<node TEXT="核心标准版" ID="ID_1053630570" CREATED="1606955513011" MODIFIED="1606955516255">
<node TEXT="9.0 版" ID="ID_1581215377" CREATED="1606956251046" MODIFIED="1606956356024">
<node TEXT="Servlet 4.0" ID="ID_1029264083" CREATED="1606956331896" MODIFIED="1606956335826"/>
</node>
</node>
</node>
<node TEXT="Deployer" ID="ID_286781843" CREATED="1606954673765" MODIFIED="1606954675347">
<node TEXT="只是附加工具，不包括服务器本身" ID="ID_1302498095" CREATED="1606955500484" MODIFIED="1606955508607"/>
<node TEXT="只用于部署软件包到 Tomcat 服务器" ID="ID_891596131" CREATED="1606955548951" MODIFIED="1606955572775"/>
</node>
<node TEXT="Embedded" ID="ID_183587436" CREATED="1606954675670" MODIFIED="1606954681978">
<node TEXT="只有 jar 包" ID="ID_368210674" CREATED="1606955726584" MODIFIED="1606955919663" LINK="https://www.theserverside.com/definition/embedded-Tomcat"/>
</node>
</node>
<node TEXT="提供的是 Web 容器功能" ID="ID_1788101701" CREATED="1606956101769" MODIFIED="1606956117979">
<node TEXT="顺便附带个简单 HTTP 服务器" ID="ID_1463909751" CREATED="1606956117986" MODIFIED="1606956130280"/>
<node TEXT="正式上线会用别的 HTTP 服务器" ID="ID_998637001" CREATED="1606956140533" MODIFIED="1606956154131"/>
</node>
</node>
<node TEXT="Idea Community" POSITION="left" ID="ID_777773603" CREATED="1606956784289" MODIFIED="1606960416884">
<edge COLOR="#ff00ff"/>
<node TEXT="安装 Tomcat 插件" ID="ID_476561504" CREATED="1606956801734" MODIFIED="1606956955100">
<node TEXT="File - Settings - Plugins - Marketplace" ID="ID_1018854422" CREATED="1606956821094" MODIFIED="1606957133155"/>
<node TEXT="安装 Smart Tomcat" ID="ID_1588069462" CREATED="1606956864324" MODIFIED="1606957158653"/>
<node TEXT="Settings - Tomcat Server" ID="ID_252196425" CREATED="1606957073039" MODIFIED="1606957091782">
<node TEXT="配置 Tomcat 的安装目录" ID="ID_278106565" CREATED="1606957661531" MODIFIED="1606957696269"/>
</node>
</node>
<node TEXT="打开或新建一个 Maven 项目" ID="ID_660995714" CREATED="1606958224253" MODIFIED="1606958232580"/>
<node TEXT="设置 Tomcat 环境" ID="ID_736516496" CREATED="1606956941934" MODIFIED="1606956965100">
<node TEXT="Run -  Edit Configurations - Templates - Smart Tomcat" ID="ID_833029763" CREATED="1606956967129" MODIFIED="1606957638774"/>
<node TEXT="Configuration" ID="ID_981092466" CREATED="1606957645674" MODIFIED="1606957740572">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="200" DASH="3 3" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_278106565" STARTINCLINATION="249;17;" ENDINCLINATION="183;0;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
</node>
<node TEXT="Create Configuration" ID="ID_807698459" CREATED="1606957639305" MODIFIED="1606957640691">
<node TEXT="相当于根据模板创建一个配置" ID="ID_479146299" CREATED="1606957578722" MODIFIED="1606957822309"/>
<node TEXT="左上角 + 号同理" ID="ID_182469797" CREATED="1606957773563" MODIFIED="1606957835709"/>
<node TEXT="左上角 - 号删除一个配置" ID="ID_156322385" CREATED="1606957798102" MODIFIED="1606957840470"/>
</node>
</node>
<node TEXT="Maven 插件打包" ID="ID_1655901568" CREATED="1606957936304" MODIFIED="1606957941884"/>
</node>
<node TEXT="Eclipse Java EE" POSITION="left" ID="ID_912410075" CREATED="1606956756365" MODIFIED="1606960414682">
<edge COLOR="#00ff00"/>
<node TEXT="起码是 JDK11" ID="ID_890951452" CREATED="1606959076773" MODIFIED="1606959084491"/>
<node TEXT="配置 Tomcat" ID="ID_152748094" CREATED="1606959580655" MODIFIED="1606959584267">
<node TEXT="Window - Preference - Server - Runtime Environment - Add" ID="ID_900941400" CREATED="1606959085134" MODIFIED="1606959232453"/>
<node TEXT="勾选 Create a new local server" ID="ID_522823209" CREATED="1606959468832" MODIFIED="1606959518091">
<node TEXT="左边就有一个 Services 节点" ID="ID_550556203" CREATED="1606959519846" MODIFIED="1606959534125">
<node TEXT="相应在工作区有个 Services 文件夹" ID="ID_1770672640" CREATED="1606962106025" MODIFIED="1606962121404"/>
<node TEXT="项目运行过一次左边也会有" ID="ID_1226473580" CREATED="1606962732571" MODIFIED="1606962747524"/>
</node>
<node TEXT="其实不勾选也会创建本地配置，只是不再左边出现而已" ID="ID_1308868352" CREATED="1606962048802" MODIFIED="1606962069947"/>
<node TEXT="切记不要删了，否则服务器启动不了" ID="ID_1529447474" CREATED="1606962071324" MODIFIED="1606962083043"/>
</node>
</node>
<node TEXT="配置工作区编码" ID="ID_736671511" CREATED="1606959590321" MODIFIED="1606959594765">
<node TEXT="默认是操作系统编码" ID="ID_661164" CREATED="1606959595465" MODIFIED="1606959601429"/>
<node TEXT="Preference - General - Workspace - Text file encoding" ID="ID_290111451" CREATED="1606959604929" MODIFIED="1606959714141"/>
<node TEXT="Web - CSS Files - Encoding" ID="ID_1730592110" CREATED="1606959801772" MODIFIED="1606959824599"/>
</node>
<node TEXT="创建 Servlet 项目" ID="ID_579414636" CREATED="1606959982707" MODIFIED="1606959988664">
<node TEXT="File - New - Project - Web - Dynamic Web Project" ID="ID_488360096" CREATED="1606959990444" MODIFIED="1606960462783">
<node TEXT="输入项目名" ID="ID_795167324" CREATED="1606960023905" MODIFIED="1606960027799"/>
<node TEXT="确认 Target runtime 是指定 Tomcat" ID="ID_1177294993" CREATED="1606960031514" MODIFIED="1606960046458"/>
<node TEXT="会提示是否打开 EE perspective 同意" ID="ID_1989834457" CREATED="1606960549078" MODIFIED="1606960578577"/>
</node>
<node TEXT="Java Resources" ID="ID_932985464" CREATED="1606960053125" MODIFIED="1606960588598">
<node TEXT="右键 src - New - Servlet" ID="ID_876865769" CREATED="1606960594171" MODIFIED="1606960611113"/>
<node TEXT="设置 Java Package 和 Class Name" ID="ID_336225943" CREATED="1606960660213" MODIFIED="1606960711731"/>
</node>
</node>
<node TEXT="运行 Servlet" ID="ID_1386394595" CREATED="1606961247785" MODIFIED="1606961257864">
<node TEXT="右键 Servlet 源码 - Run As - Run on Server" ID="ID_1352389779" CREATED="1606961294999" MODIFIED="1606961365822"/>
<node TEXT="或在当前打开的源码" ID="ID_1397501846" CREATED="1606961321925" MODIFIED="1606961382768">
<node TEXT="Alt+Shift+X, R" ID="ID_1005853883" CREATED="1606961384267" MODIFIED="1606961415021"/>
</node>
<node TEXT="弹出 Run On Server 窗口" ID="ID_1457601174" CREATED="1606961462365" MODIFIED="1606961489400">
<node TEXT="确认 Tomcat 版本" ID="ID_1922247639" CREATED="1606961489848" MODIFIED="1606961497175"/>
<node TEXT="勾选 Always use this server when running this project" ID="ID_1889844988" CREATED="1606961497690" MODIFIED="1606961530259"/>
<node TEXT="默认会启动 Eclipse 内置浏览器" ID="ID_763064306" CREATED="1606961913504" MODIFIED="1606961928303"/>
</node>
<node TEXT="只要服务器已运行" ID="ID_1955390064" CREATED="1606966518611" MODIFIED="1606966529621">
<node TEXT="有什么修改直接刷新浏览器即可" ID="ID_669407540" CREATED="1606966531193" MODIFIED="1606966543485"/>
<node TEXT="无需再重启服务器" ID="ID_1628065583" CREATED="1606966544953" MODIFIED="1606966550466"/>
</node>
<node TEXT="此时还没有部署在 tomcat 的 webapps 目录下" ID="ID_596459748" CREATED="1606962239757" MODIFIED="1606962261453">
<node TEXT="只是在本项目下的 WebContent 目录" ID="ID_1782068718" CREATED="1606962291882" MODIFIED="1606962304937"/>
</node>
</node>
<node TEXT="设置默认浏览器" ID="ID_1833929221" CREATED="1606961931106" MODIFIED="1606961937579">
<node TEXT="Window - Web Browser" ID="ID_309427414" CREATED="1606961939270" MODIFIED="1606962013999"/>
</node>
</node>
</node>
</map>
