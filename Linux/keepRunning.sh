#!/system/bin/sh

prefix=/sdcard/

logInit() { echo -n > $prefix.log; }

log () {
	echo "$@"
	echo $(date) "$@" >> $prefix.log;
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
	local interval=${3:-3}
	
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

# 指定进程正在运行
pidIsRun () {
	local pid=$1
	[ -n "$pid" ] && ps | awk '{print $2}' | grep $pid > /dev/null
}

# 杀死进程
killPid () {
	local pid=$1
	kill -9 "$pid" 2>/dev/null # -15还不一定杀得了
}


# pid awk$2
# ppid awk$3
# pid 就是该脚本所在进程 ppid是mu_bak也就是su也就是系统设置里的root管理
# 杀死 ppid pid会挂载到 1 下，杀死pid ppid也会杀死
# 一般 ppid=$((pid-1))
# 如果不根据 $$ 可能会杀多个 可能会错杀
getPid () {
	# 前面加 echo 是为了把换行符替换为空格（支持多PID）
	local pid=$(cat $prefix.pid 2>/dev/null) # 从文件读取并测试
	[ -n "$pid" ] && pidIsRun $(($pid - 1)) && pidIsRun $pid && echo -n $pid
}

# 运行脚本 记录其pid 
runProgram () {
	[ $# -lt 2 ] && usage # 参数检查 必须要有 包名和活动名

	local pid=$(getPid)
	if [ -n "$pid" ]; then
		log "脚本已在运行 PID=$pid" || log "脚本出错 pid=$pid \$\$=$$"
	else
		echo $$ > $prefix.pid && log "脚本已启动 PID=$$" && keepRunning $@
	fi
}

stopProgram () {
	local pid=$(getPid)
	if [ -n "$pid" ]; then
		killPid $pid && echo "已关闭 PID=$pid" || echo "关闭失败 PID=$pid"
	else
		log 没有已运行的脚本
	fi
}

statusProgram () {
	local pid=$(getPid)
	[ -n "$pid" ] && log "脚本正在运行 PID=$pid" || log 脚本没在运行
}

# 打印使用说明并且退出脚本
usage () {
	log
	log "Usage: $0 option packageName activityName interval[s|m|h|d]"
	log "option start|stop|restart|status"
	log "packageName 包名"
	log "activityName app的主activity名"
	log "interval 检查间隔 默认3秒 不加后缀为秒 加后缀 s秒 m分 h时 d天"
	log
	exit 1
}

# 作为服务的入口
switch () {
	local opt=$1
	shift
	case $opt in
		start)
			runProgram $@
			;;
		stop)
			stopProgram
			;;
		restart)
			stopProgram && log "脚本已重启"
			runProgram $@
			;;
		status)
			statusProgram
			;;
		*)
			usage
			;;
	esac
}

logInit
switch $@
