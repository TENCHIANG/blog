#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <dirent.h>
#include <string.h>
#include <unistd.h>

#define BUFSIZE 128

/**
 * 运行Shell命令并获取结果
 * 返回命令的状态码 失败返回 -1
 */
int shell (char *cmd, char *buf, int len) {
    
    if (!cmd || !buf || len < 0) {
        fprintf(stderr, "cmd = %s buf = %s len = %d\n", cmd, buf, len);
        return -1;
    }

    memset(buf, 0, len);
    FILE *fp = popen(cmd, "r");
    if (!fgets(buf, len, fp))
        fprintf(stderr, "获取Shell命令 %s 结果失败\n", cmd);
    
    int res = pclose(fp);
    if (res == -1) perror("关闭管道失败");
    return res % 255; // 0 ~ 254
}

/**
 * 获取指定包名的PID
 * 失败返回 -1
 */
int getPid (char *pkg) {
    char cmd[BUFSIZE] = { 0 };
    
    sprintf(cmd, "pidof -s %s", pkg);
    
    char pid[BUFSIZE] = { 0 };
    int code = shell(cmd, pid, sizeof(pid));
    if (code != 0) {
        fprintf(stderr, "获取 %s PID失败 状态码 %d\n", pkg, code);
        return -1;
    }
    
    return atoi(pid);
}

/**
 * 绕过游戏监控
 */
int bypass () {
    int code = system("echo 0 > /proc/sys/fs/inotify/max_user_watches") % 255;
    if (code != 0)
        fprintf(stderr, "绕过游戏监控失败 状态码 %d\n", code);
    return code;
}

/**
 * 获取mem文件句柄 失败返回 -1
 */
int openProcMem (int pid) {
    char buf[BUFSIZE] = { 0 };
    sprintf(buf, "/proc/%d/mem", pid);
    return open(buf, O_RDWR, O_SYNC);
}

// tsu -c 'gcc -Wall -O3 /sdcard/Pictures/mem.c -o /data/local/tmp/test/mem'
// tsu -c '/data/local/tmp/test/mem -p com.tencent.lycqsh -a 82bb400e -o 3210'
int main (int argc, char **argv) {
    unsigned long addr = 0;
    int count = 4; // 字节数
    int offset = 0; // addr偏移
    char *pkg = 0;
    
    int opt = -1;
    while ((opt = getopt(argc, argv, "a:c:o:p:")) != -1)
        switch (opt) {
            case 'a':
                sscanf(optarg, "%lx", &addr); // 加不加0x前缀都可以
                break;
            case 'c':
                sscanf(optarg, "%d", &count);
                break;
            case 'o':
                sscanf(optarg, "%d", &offset);
                break;
            case 'p':
                pkg = optarg;
                break;
            case '?':
                fprintf(stderr, "Unknown option: %c\n", (char)optopt);
                break;
        }
    if (optind < 5) {
        fprintf(stderr, "Usage: %s -a addr [-c count] -p pkg [-o offset]\n", argv[0]);
        exit(1);
    }
        
    //printf("optind = %d opterr = %d optopt = %d optarg = %s opt = %d\n", optind, opterr, optopt, optarg, opt);
    
    addr += offset;
    //printf("pkg = %s addr = %lu offset = %d count = %d\n", pkg, addr, offset, count);
    
	int pid = getPid(pkg);
    if (pid == -1) {
        fprintf(stderr, "%s 没有运行\n", pkg);
        exit(1);
    }
    
    bypass();
    
	int fd = openProcMem(pid);
    if (pid == -1) {
        fprintf(stderr, "fd = %d pid = %d\n", fd, pid);
        exit(1);
    }
    
    int res;
    
    //long data = 100;
    //res = pwrite64(fd, &data, sizeof(data), addr);
    
	/*double value = 0;
	res = pread64(fd, &value, count, addr);
    if (res == -1) {
        fprintf(stderr, "读取内存 %#lx 失败 pid = %d\n", addr, pid);
        exit(1);
    }
	printf("%#lx %ld %#lx %g\n", addr, value, value, value);*/
    
    unsigned char buf[BUFSIZE] = { 0 };
    res = pread64(fd, buf, count, addr);
    if (res == -1) {
        fprintf(stderr, "读取内存 %#lx 失败 pid = %d\n", addr, pid);
        exit(1);
    }
    printf("%#lx %ld %#lx %g ", addr, *(long *)buf, *(long *)buf, *(double *)buf);
    for (int i = 0; i < count; i++)
        printf("%02x ", buf[i]);
    printf("\n");
    
    res = close(fd);
    if (res == -1) {
        fprintf(stderr, "关闭 /proc/%d/mem 失败\n", pid);
        exit(1);
    }

	exit(0);
}
