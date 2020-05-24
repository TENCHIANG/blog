#!/system/bin/sh

prefix=/sdcard

logInit() { echo -n > $prefix/.log; }

log () {
	echo "$@"
	echo $(date) "$@" >> $prefix/.log;
}

# 检测程序是否正在运行
isRunning () {
    local packageName=$1
    if [ -n "$packageName" ]; then
        res=$(ps | awk '{print $9}' | grep "$packageName")
        if [ -n "$res" ]; then return 0; fi
    fi
    return 1
}

# 启动程序
runPkg () {
    local packageName=$1
	local activityName=$2
    if [ -n "$packageName" -a -n "$activityName" ]; then
        if am start "$packageName/$activityName" > /dev/null 2>&1; then
			return 0
		fi
    fi
    return 1
}

# 保持程序运行
# 程序关闭则打开 开启则不做处理
keepRunning () {
    local packageName=$1
	local activityName=$2
	local interval="${3:-3}"
	
	while true; do
        if isRunning $@; then
            :
        elif runPkg $@; then
            log $packageName/$activityName 启动成功
        else
            log $packageName/$activityName 启动失败
        fi
		sleep $interval
	done
}

# 指定进程正在运行并返回该pid
pidIsRun () {
	local pid=$1
	[ -n "$pid" ] && ps | awk '{print $2}' | grep $pid > /dev/null
}

# pid awk$2
# ppid awk$3
# pid 就是该脚本所在进程 ppid是mu_bak也就是su也就是系统设置里的root管理
# 杀死 ppid pid会挂载到 1 下，杀死pid ppid也会杀死
# 一般 ppid=$((pid-1))
# 如果不根据 $$ 可能会杀多个 可能会错杀
getPid () {
	local pid=$(cat $prefix/.pid 2>/dev/null) # 从文件读取并测试
	[ -n "$pid" ] && pidIsRun $(($pid - 1)) && pidIsRun $pid && echo -n $pid
}

# 运行脚本 记录其pid 
runProgram () {
	[ $# -lt 2 ] && usage # 参数检查 必须要有 包名和活动名
    
    logInit # 清空脚本
	local pid=$(getPid)
	if [ -n "$pid" ]; then
		log "脚本已在运行 PID=$pid" || log "脚本出错 pid=$pid \$\$=$$"
	else
		echo $$ > $prefix/.pid && log "脚本已启动 PPID=$PPID PID=$$" && keepRunning $@
	fi
}

stopProgram () {
	local pid=$(getPid)
	if [ -n "$pid" ]; then
		kill -15 $pid && echo "已关闭 PID=$pid" || echo "关闭失败 PID=$pid"
	else
		echo 没有已运行的脚本
	fi
}

# 打印使用说明并且退出脚本
usage () {
	echo
	echo "Usage: $0 option packageName activityName interval[s|m|h|d]"
	echo "option start|stop|restart|status|kill|boot"
	echo "interval 检查间隔 默认3秒 不加后缀为秒 加后缀 s秒 m分 h时 d天"
	echo "packageName 包名"
	echo "activityName app的主activity名"
	echo
	exit 1
}

# 作为服务的入口
switch () {
	local opt=$1
	[ -n "$opt" ] && shift
	case $opt in
		"start")
			runProgram $@
			;;
		"stop")
			stopProgram
			;;
		"restart")
			stopProgram && log "脚本已重启"
			runProgram $@
			;;
		"status")
            local pid=$(getPid)
            [ -n "$pid" ] && echo "脚本正在运行 PID=$pid" || echo 脚本没在运行
			;;
        "kill") # 杀死全部关于这个脚本的进程 可能会误杀 但绝对不会漏杀
            local pids=$(echo `ps | grep poll_sched | grep sh | awk '{print $2}'`)
            [ -n "$pids" ] && echo $pids && kill -15 $pids
            ;;
        "boot") # 开机启动（一次）
            local lock=$prefix/.lock
            if [ -f "$lock" ]; then
                echo "已初始化过"
            elif mount -o remount,rw /; then
                local name="${0:0:-3}" # 脚本名无后缀
                local rcname="/init.rc" # 开机启动脚本
                echo -e "\nservice keepRunning /sdcard/ais_debug/$name" >> $rcname && 
                echo -e "\tuser root" >> $rcname && 
                echo -e "\tgroup root" >> $rcname && 
                echo -e "\tclass main" >> $rcname && 
                echo -e "\toneshot" >> $rcname && 
                echo "import $rcname" >> $rcname && 
                echo "初始化成功" && echo "$rcname 不要重复写入" > $lock
            else
                echo "初始化失败"
            fi
            ;;
		*)
			usage
			;;
	esac
}

switch $@
