<map version="freeplane 1.8.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="volatile" FOLDED="false" ID="ID_1494781614" CREATED="1607245465496" MODIFIED="1607245547013" STYLE="oval">
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
<hook NAME="AutomaticEdgeColor" COUNTER="8" RULE="ON_BRANCH_CREATION"/>
<node TEXT="使用前提" POSITION="right" ID="ID_1763102533" CREATED="1607245614921" MODIFIED="1607245706130">
<edge COLOR="#ff0000"/>
<node TEXT="只用于成员变量" ID="ID_988812967" CREATED="1607245617645" MODIFIED="1607245625410">
<node TEXT="本地变量其它线程访问不到" ID="ID_1674028906" CREATED="1607245638795" MODIFIED="1607245646856"/>
</node>
<node TEXT="大于 4 字节的变量" ID="ID_967840510" CREATED="1607245627160" MODIFIED="1607245637976"/>
<node TEXT="同时被多个线程读，至少一个先读再写" ID="ID_161663225" CREATED="1607245648531" MODIFIED="1607245667765">
<node TEXT="一个线程写，其它线程只是读，无需 volite" ID="ID_791423344" CREATED="1607292077041" MODIFIED="1607292161570"/>
<node TEXT="多个线程先读再写，则需同步" ID="ID_1314923075" CREATED="1607292164405" MODIFIED="1607292183697">
<node TEXT="除非多个线程只写不读" ID="ID_887341725" CREATED="1607292183706" MODIFIED="1607292193653"/>
</node>
<node TEXT="故读老值是可以的，需非根据老值创造新值" ID="ID_29557297" CREATED="1607292199225" MODIFIED="1607292238112"/>
</node>
<node TEXT="不使用同步或并发包" ID="ID_1479641362" CREATED="1607245670167" MODIFIED="1607245677307"/>
</node>
<node TEXT="非完全线程安全" POSITION="right" ID="ID_1770134733" CREATED="1607245742040" MODIFIED="1607245751443">
<edge COLOR="#00ff00"/>
<node TEXT="自增操作" ID="ID_1683454565" CREATED="1607245751452" MODIFIED="1607245756473"/>
</node>
<node TEXT="用处" POSITION="right" ID="ID_749062413" CREATED="1607245736783" MODIFIED="1607245739846">
<edge COLOR="#0000ff"/>
<node TEXT="让线程直接读写主存" ID="ID_1198215908" CREATED="1607245769149" MODIFIED="1607245822472">
<node TEXT="Cache Coherence" ID="ID_627735446" CREATED="1607245846823" MODIFIED="1607245864367"/>
<node TEXT="解决缓存一致性问题" ID="ID_983199724" CREATED="1607245833476" MODIFIED="1607245844163"/>
</node>
<node TEXT="Word Tearing" ID="ID_670357817" CREATED="1607245888915" MODIFIED="1607245899312">
<node TEXT="防止字撕裂" ID="ID_1182692631" CREATED="1607245822882" MODIFIED="1607245828569"/>
<node TEXT="撕裂成 4 字节处理" ID="ID_1515204402" CREATED="1607245881027" MODIFIED="1607245888481"/>
<node TEXT="得到原子性" ID="ID_730761075" CREATED="1607245945772" MODIFIED="1607245950488"/>
</node>
</node>
<node TEXT="Race Condition" POSITION="left" ID="ID_154260114" CREATED="1607292248512" MODIFIED="1607292253958">
<edge COLOR="#00ffff"/>
<node TEXT="竞态条件就是用老值运算新值" ID="ID_599475406" CREATED="1607292254905" MODIFIED="1607292277122"/>
<node TEXT="就算本身做对了，整个结果也是错的" ID="ID_39113026" CREATED="1607292277557" MODIFIED="1607292293348"/>
<node TEXT="因为违反了顺序和因果" ID="ID_79002100" CREATED="1607292295853" MODIFIED="1607292302485"/>
</node>
<node TEXT="原子性和可见性" POSITION="left" ID="ID_1436617833" CREATED="1607245966606" MODIFIED="1607296625754">
<edge COLOR="#00007c"/>
<node TEXT="Atomicity" ID="ID_72131929" CREATED="1607245981415" MODIFIED="1607245994231">
<node TEXT="操作不可分割" ID="ID_242221878" CREATED="1607246009867" MODIFIED="1607246013753"/>
<node TEXT="不能被线程调度器中断" ID="ID_1697845783" CREATED="1607294696400" MODIFIED="1607296693676"/>
<node TEXT="只有原子性不能保证可见性" ID="ID_149873145" CREATED="1607246033702" MODIFIED="1607246044948"/>
<node TEXT="先天的原子操作" ID="ID_1890019059" CREATED="1607296510260" MODIFIED="1607296709124">
<node TEXT="32 位或以内的基本类型" ID="ID_736985958" CREATED="1607296527431" MODIFIED="1607296551241"/>
<node TEXT="的返回或赋值操作" ID="ID_1685230637" CREATED="1607296551954" MODIFIED="1607296561072"/>
<node TEXT="就算是原子返回也可能会读取中间值" ID="ID_524514348" CREATED="1607300262472" MODIFIED="1607300273614"/>
</node>
</node>
<node TEXT="Volatility" ID="ID_615535421" CREATED="1607245996705" MODIFIED="1607246005495">
<node TEXT="主存保持最新值" ID="ID_1131358840" CREATED="1607246015555" MODIFIED="1607246020946"/>
</node>
<node TEXT="原子性和可见性是不同的" ID="ID_736808262" CREATED="1607296628316" MODIFIED="1607296633865"/>
<node TEXT="或者是两者只有其一也非线程安全" ID="ID_1286176809" CREATED="1607296634852" MODIFIED="1607296654133"/>
</node>
<node TEXT="synchronized" POSITION="left" ID="ID_371416888" CREATED="1607295151076" MODIFIED="1607300249068">
<edge COLOR="#007c00"/>
<node TEXT="同步通过排它锁实现原子性，同时保证可见性" ID="ID_1050960761" CREATED="1607246095582" MODIFIED="1607246113339"/>
<node TEXT="并发包的 atomic 同理" ID="ID_1875646145" CREATED="1607246115442" MODIFIED="1607246129335"/>
<node TEXT="可以通过原子性编写 lock-free 的代码无需同步" ID="ID_1982573797" CREATED="1607295218851" MODIFIED="1607295247621"/>
<node TEXT="Brian’s Rule of Synchronization" ID="ID_1290059917" CREATED="1607300369477" MODIFIED="1607300374830">
<node TEXT="写可能被其它线程读的变量" ID="ID_969827303" CREATED="1607300397681" MODIFIED="1607300474092"/>
<node TEXT="读可能被其它线程写的变量" ID="ID_660714580" CREATED="1607300411907" MODIFIED="1607300461643"/>
<node TEXT="需使用同步，且读写用同一把锁" ID="ID_990970403" CREATED="1607300492022" MODIFIED="1607300519591"/>
</node>
</node>
</node>
</map>
