<map version="freeplane 1.8.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Servlet 类图" FOLDED="false" ID="ID_848117786" CREATED="1606962418943" MODIFIED="1607305050458" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle" zoom="1.003">
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
<hook NAME="AutomaticEdgeColor" COUNTER="8" RULE="ON_BRANCH_CREATION"/>
<node TEXT="Servlet 包" POSITION="right" ID="ID_1152460241" CREATED="1606962509951" MODIFIED="1606962514715">
<edge COLOR="#ff0000"/>
<node TEXT="tomcat 安装目录\lib\servlet-api.jar" ID="ID_2332704" CREATED="1606962532322" MODIFIED="1606962559102">
<node TEXT="Eclipse Java EE 项目" ID="ID_551569470" CREATED="1606963066317" MODIFIED="1606964108932"/>
<node TEXT="Java Resources - Libraries 可见" ID="ID_510927907" CREATED="1606964109397" MODIFIED="1606964110400"/>
</node>
<node TEXT="手动编译 Servlet" ID="ID_1381853507" CREATED="1606962613363" MODIFIED="1606962621886">
<node TEXT="javac \&#xa;-cp tomcat/lib/servlet-api.jar \&#xa;-d ./classes/src/org/example/Hello.java" ID="ID_1135318284" CREATED="1606962621894" MODIFIED="1606962633947"/>
</node>
</node>
<node TEXT="" POSITION="left" ID="ID_978551254" CREATED="1606963692020" MODIFIED="1607305015088">
<edge COLOR="#0000ff"/>
<hook URI="Servlet类图.png" SIZE="1.0" NAME="ExternalObject"/>
</node>
<node TEXT="Servlet 接口" POSITION="right" ID="ID_1821255338" CREATED="1606963722997" MODIFIED="1606963727506">
<edge COLOR="#00ff00"/>
<node TEXT="定义了 Servlet 的基本行为" ID="ID_1083707581" CREATED="1606963731182" MODIFIED="1606963849528"/>
<node TEXT="Servlet 生命周期" ID="ID_140238289" CREATED="1608123313086" MODIFIED="1608123330133">
<node TEXT="未创建" ID="ID_587494468" CREATED="1608123330140" MODIFIED="1608123337800">
<node TEXT="destroy()" ID="ID_325480655" CREATED="1608123363490" MODIFIED="1608123389967"/>
</node>
<node TEXT="初始化" ID="ID_895839957" CREATED="1608123337978" MODIFIED="1608123340672">
<node TEXT="constructor()" ID="ID_1606625647" CREATED="1608123369066" MODIFIED="1608123388831"/>
<node TEXT="init()" ID="ID_1372804927" CREATED="1608123375650" MODIFIED="1608123387513"/>
<node TEXT="service()" ID="ID_799087179" CREATED="1608123377496" MODIFIED="1608123386294">
<node TEXT="提供服务" ID="ID_3282428" CREATED="1608123415381" MODIFIED="1608123420281"/>
</node>
</node>
</node>
<node TEXT="生命周期" ID="ID_42730232" CREATED="1608123462894" MODIFIED="1608123469458">
<node TEXT="加载" ID="ID_522673285" CREATED="1608123469464" MODIFIED="1608123472579">
<node TEXT="容器通过 ClassLoader 加载类" ID="ID_1069664149" CREATED="1608123485068" MODIFIED="1608123529091"/>
</node>
<node TEXT="创建" ID="ID_1091797604" CREATED="1608123472913" MODIFIED="1608123475211">
<node TEXT="调用构造函数" ID="ID_723839772" CREATED="1608123508732" MODIFIED="1608123525300"/>
</node>
<node TEXT="初始化" ID="ID_228404248" CREATED="1608123533660" MODIFIED="1608123535248">
<node TEXT="init()" ID="ID_486582012" CREATED="1608123535254" MODIFIED="1608123547462">
<node TEXT="只调用一次" ID="ID_1625759825" CREATED="1608123548463" MODIFIED="1608123563682"/>
</node>
<node TEXT="会在请求之前调用（缓存）" ID="ID_1661681460" CREATED="1608123564100" MODIFIED="1608123579864"/>
</node>
<node TEXT="处理请求" ID="ID_287277650" CREATED="1608123596039" MODIFIED="1608123618887">
<node TEXT="一个请求一个线程" ID="ID_1389442454" CREATED="1608123620236" MODIFIED="1608123645277"/>
<node TEXT="调用 service()" ID="ID_964599950" CREATED="1608123645566" MODIFIED="1608123656576"/>
<node TEXT="再根据不同的 method 调用不同的 doXXX 方法" ID="ID_1370363957" CREATED="1608123670251" MODIFIED="1608123719522"/>
</node>
<node TEXT="卸载" ID="ID_558847618" CREATED="1608123734999" MODIFIED="1608123743065">
<node TEXT="destroy()" ID="ID_345881046" CREATED="1608123743074" MODIFIED="1608123774494">
<node TEXT="只调用一次" ID="ID_1360105402" CREATED="1608123774831" MODIFIED="1608123780345"/>
</node>
<node TEXT="如果已卸载，只能从头开始i" ID="ID_439805796" CREATED="1608123792314" MODIFIED="1608123816946"/>
</node>
</node>
</node>
<node TEXT="GenericServlet 类" POSITION="right" ID="ID_1916349305" CREATED="1606963814505" MODIFIED="1606964017778">
<edge COLOR="#ff00ff"/>
<node TEXT="实现 Servlet 接口" ID="ID_484644743" CREATED="1606963831865" MODIFIED="1606964028317">
<node TEXT="没有实现 service()" ID="ID_1071883012" CREATED="1608120845265" MODIFIED="1608120855282"/>
<node TEXT="只是标记为 abstract" ID="ID_710439780" CREATED="1608120855616" MODIFIED="1608120912724"/>
</node>
<node TEXT="实现 ServletConfig 接口" ID="ID_119303051" CREATED="1606964044416" MODIFIED="1606964053524"/>
<node TEXT="没有 HTTP 相关" ID="ID_500798494" CREATED="1606964135072" MODIFIED="1606964176742">
<node TEXT="Servlet 设计之初不限于 HTTP 协议" ID="ID_282141417" CREATED="1606964205490" MODIFIED="1606964232491"/>
<node TEXT="HTTP 相关在其子类 HttpServlet" ID="ID_311417713" CREATED="1606964178250" MODIFIED="1606964201351"/>
<node TEXT="Servlet 包的设计也体现这一点" ID="ID_1216179454" CREATED="1606964358933" MODIFIED="1606964496359">
<node TEXT="javax.servlet" ID="ID_69815360" CREATED="1606964370014" MODIFIED="1606964383604">
<node TEXT="Servlet" ID="ID_234210099" CREATED="1606964396327" MODIFIED="1606964400436"/>
<node TEXT="GenericServlet" ID="ID_1481359776" CREATED="1606964400814" MODIFIED="1606964408732"/>
<node TEXT="ServletRequest" ID="ID_1232712027" CREATED="1606964427788" MODIFIED="1606964432882"/>
<node TEXT="ServletResponse" ID="ID_333778695" CREATED="1606964409389" MODIFIED="1606964427031"/>
</node>
<node TEXT="javax.servlet.http" ID="ID_793857913" CREATED="1606964383959" MODIFIED="1606964393884">
<node TEXT="HttpServlet" ID="ID_1661497951" CREATED="1606964437118" MODIFIED="1606964442231"/>
<node TEXT="HttpServletRequest" ID="ID_1250714817" CREATED="1606964443195" MODIFIED="1606964450681"/>
<node TEXT="HttpServletResponse" ID="ID_1981237361" CREATED="1606964451116" MODIFIED="1606964458478"/>
</node>
</node>
</node>
</node>
<node TEXT="HttpServlet 类" POSITION="right" ID="ID_791745638" CREATED="1606964239742" MODIFIED="1606964350575">
<edge COLOR="#00ffff"/>
<node TEXT="实现 service()" ID="ID_1929172462" CREATED="1606964517812" MODIFIED="1608120952116">
<node TEXT="定义 HTTP 相关服务流程" ID="ID_681151277" CREATED="1606964524233" MODIFIED="1606964617640"/>
<node TEXT="HTTP 请求来时 Web 容器会调用 Servlet 的 service 方法" ID="ID_66350317" CREATED="1606964724932" MODIFIED="1606964764711"/>
<node TEXT="protected void service (HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {&#xa;    String method = req.getMethod();&#xa;    if (method.equals(METHOD_GET)) {&#xa;        doGet(req, res);&#xa;    } else if (method.equals(METHOD_POST)) {&#xa;        doPost(req, res);&#xa;    } else if (method.equals(METHOD_PUT)) {&#xa;    }&#xa;}" ID="ID_1513671181" CREATED="1606964567807" MODIFIED="1606964663918"/>
<node TEXT="使用了 Template Method 设计模式" ID="ID_1410181402" CREATED="1606964805211" MODIFIED="1606964837912">
<node TEXT="不要在继承 HttpServlet 后" ID="ID_690222794" CREATED="1606964837920" MODIFIED="1606964851792"/>
<node TEXT="重写 service 方法" ID="ID_845054330" CREATED="1606964852822" MODIFIED="1606964867436"/>
</node>
</node>
<node TEXT="编写 Servlet" ID="ID_60945511" CREATED="1608120614420" MODIFIED="1608120625446">
<node TEXT="必须继承 HttpServlet" ID="ID_573496579" CREATED="1608120625451" MODIFIED="1608120632319"/>
<node TEXT="并重新定义 doXXX" ID="ID_1268881050" CREATED="1608120635559" MODIFIED="1608120670683"/>
<node TEXT="容器会自动建立" ID="ID_227845569" CREATED="1608120687173" MODIFIED="1608120701575">
<node TEXT="请求对象 HttpServletRequest" ID="ID_631870380" CREATED="1608120701588" MODIFIED="1608120735774"/>
<node TEXT="响应对象 HttpServletResponse" ID="ID_657692063" CREATED="1608120715738" MODIFIED="1608120733072"/>
</node>
</node>
<node TEXT="Servlet 至少有三个名称" ID="ID_597852106" CREATED="1608121064800" MODIFIED="1608121077633">
<node TEXT="类名称" ID="ID_1631685056" CREATED="1608121077637" MODIFIED="1608121082178"/>
<node TEXT="注册的名称" ID="ID_319688288" CREATED="1608121082334" MODIFIED="1608121090627"/>
<node TEXT="URI 模式名称" ID="ID_190199291" CREATED="1608121091775" MODIFIED="1608121097270"/>
</node>
</node>
</node>
</map>
