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
<node TEXT="生命周期" ID="ID_28222662" CREATED="1606963757021" MODIFIED="1606963770209">
<node TEXT="init()" ID="ID_1390987759" CREATED="1606963778796" MODIFIED="1606963797871"/>
<node TEXT="destroy()" ID="ID_793757138" CREATED="1606963781319" MODIFIED="1606963801357"/>
</node>
<node TEXT="提供服务" ID="ID_523623588" CREATED="1606963774180" MODIFIED="1606963776379">
<node TEXT="service()" ID="ID_1234576284" CREATED="1606963788223" MODIFIED="1606963794077"/>
</node>
</node>
<node TEXT="GenericServlet 类" POSITION="right" ID="ID_1916349305" CREATED="1606963814505" MODIFIED="1606964017778">
<edge COLOR="#ff00ff"/>
<node TEXT="实现 Servlet 接口" ID="ID_484644743" CREATED="1606963831865" MODIFIED="1606964028317"/>
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
<node TEXT="service 方法" ID="ID_1929172462" CREATED="1606964517812" MODIFIED="1606964874063">
<node TEXT="定义 HTTP 相关服务流程" ID="ID_681151277" CREATED="1606964524233" MODIFIED="1606964617640"/>
<node TEXT="HTTP 请求来时 Web 容器会调用 Servlet 的 service 方法" ID="ID_66350317" CREATED="1606964724932" MODIFIED="1606964764711"/>
<node TEXT="protected void service (HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {&#xa;    String method = req.getMethod();&#xa;    if (method.equals(METHOD_GET)) {&#xa;        doGet(req, res);&#xa;    } else if (method.equals(METHOD_POST)) {&#xa;        doPost(req, res);&#xa;    } else if (method.equals(METHOD_PUT)) {&#xa;    }&#xa;}" ID="ID_1513671181" CREATED="1606964567807" MODIFIED="1606964663918"/>
<node TEXT="使用了 Template Method 设计模式" ID="ID_1410181402" CREATED="1606964805211" MODIFIED="1606964837912">
<node TEXT="不要在继承 HttpServlet 后" ID="ID_690222794" CREATED="1606964837920" MODIFIED="1606964851792"/>
<node TEXT="重写 service 方法" ID="ID_845054330" CREATED="1606964852822" MODIFIED="1606964867436"/>
</node>
</node>
</node>
</node>
</map>
