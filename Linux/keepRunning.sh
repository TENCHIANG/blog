#!/system/bin/sh

logInit() { rm -f log; }

log () { echo $@ >> log; }

# 检测程序是否正在运行
isRunning () {
    pkgName="$1"
    if [ -n "$pkgName" ]; then
        res=$(ps | grep "$pkgName" | awk '{print $8}')
        if [ -n "$res" ]; then return 0; fi
    fi
    return 1
}

# 启动程序
runPkg () {
    pkgName="$1"
    if [ -n "$pkgName" ]; then
        err=$(am start "$pkgName"/MainActivity 2>&1)
        code=$?
        log $code $err
        return $code
    fi
    return 1
}

# 保持程序运行
# 程序关闭则打开 开启则不做处理
keepRunning () {
    pkgName="$1"
    if [ -n "$pkgName" ]; then
        if isRunning "$pkgName"; then
            return 0
        else
            runPkg "$pkgName"
            return $?
        fi
    fi
    return 1
}

# 第一个参数 程序名
pkgName=$1

# 第二个参数 每次执行休息的时间 默认 3秒
# 后缀s代表秒（默认）
# m代表分钟
# h小时
# d天
interval=$2
if [ -z "$interval" ]; then interval=3; fi

logInit
while :; do
    if keepRunning "$pkgName"; then
        log 启动 $pkgName 成功
    else
        log 启动 $pkgName 失败
    fi
    log $(date)
    sleep "$interval"
done
