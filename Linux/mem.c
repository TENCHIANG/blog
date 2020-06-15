#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <dirent.h>
#include <string.h>
#include <unistd.h>
#include <time.h> // clock
#include <stddef.h> // NULL

#define ATTRSIZE 5
#define BUFSIZE 128
#define BLOCKSIZE 1024 // 单位分块长度（提速）
#define USAGE "Usage: %s -p pkg -T r|w|s -a addr [-o offset] -t <i|u|f><1|2|4|8>[-val]\n"

#define VM_READ 8 // r -
#define VM_WRITE 4 // w -
#define VM_EXEC 2 // x -
#define VM_MAYSHARE 1 // s p

// 防止负数溢出
typedef unsigned int Addr; // 不知道为啥 unsigned int 只能截取一半明明长度一样
typedef unsigned char Byte;

typedef enum {
    READ,
    WRITE,
    SEARCH,
} Mode;

typedef struct Map {
    int size;
    Byte attr;
    Addr start, end;
    struct Map *next;
} Map;

typedef enum {
    I1, U1, I2, U2, I4, U4, I8, U8, F4, F8
} Type;

typedef union Value {
    char i1;
    unsigned char u1;
    
    short i2;
    unsigned short u2;
    
    int i4;
    unsigned u4;
    
    long long i8;
    unsigned long long u8;
    
    float f4;
    double f8;
} Value;

/**
 * error: print an error message and die（限制挺多）
 * 一个程序同时打开的文件限制为 20（包括 1 2 3吗）
 * close和fclose的区别：close没有flush（从内存刷新数据到文件）
 * exit或从主函数退出：所有打开的文件将被关闭（包括 1 2 3吗）
 * int char 0和指针可以无缝转换
 * 子程序可以没有返回值 可以直接退出程序 函数相反 函数一般不用全局变量 不做错误处理
 */
void error(char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    fprintf(stderr, "error: ");
    vfprintf(stderr, fmt, args);
    fprintf(stderr, "\n");
    va_end(args);
    exit(1);
}

#define refer(t, v) ({ \
    (t) == I1 ? (v).i1 : \
    (t) == U1 ? (v).u1 : \
    (t) == I2 ? (v).i2 : \
    (t) == U2 ? (v).u2 : \
    (t) == I4 ? (v).i4 : \
    (t) == U4 ? (v).u4 : \
    (t) == I8 ? (v).i8 : \
    (t) == U8 ? (v).u8 : \
    (t) == F4 ? (v).f4 : \
    (v).f8; \
})

#define referp(t, v) ({ \
    (t) == I1 ? &(v).i1 : \
    (t) == U1 ? &(v).u1 : \
    (t) == I2 ? &(v).i2 : \
    (t) == U2 ? &(v).u2 : \
    (t) == I4 ? &(v).i4 : \
    (t) == U4 ? &(v).u4 : \
    (t) == I8 ? &(v).i8 : \
    (t) == U8 ? &(v).u8 : \
    (t) == F4 ? &(v).f4 : \
    &(v).f8; \
})

#define printVal(t, v) ( \
    (t) == I1 ? printf("%d\n", (v).i1) : \
    (t) == U1 ? printf("%u\n", (v).u1) : \
    (t) == I2 ? printf("%d\n", (v).i2) : \
    (t) == U2 ? printf("%u\n", (v).u2) : \
    (t) == I4 ? printf("%d\n", (v).i4) : \
    (t) == U4 ? printf("%u\n", (v).u4) : \
    (t) == I8 ? printf("%lld\n", (v).i8) : \
    (t) == U8 ? printf("%llu\n", (v).u8) : \
    (t) == F4 ? printf("%f\n", (v).f4) : \
    printf("%lf\n", (v).f8) \
)

typedef struct Res {
    Addr addr;
    Type typ;
    Value val;
    struct Res *next;
} Res;

// 连接下一个节点
#define link(head, cur, p) do { \
    if (head) { \
        (cur)->next = (p); \
        (cur) = (p); \
    } else \
        (head) = (cur) = (p); \
} while(0)
    
#define traverse(p, f) do { \
    while (p) { \
        f; \
        (p) = (p)->next; \
    } \
} while (0)

// 不要把带参宏当成函数 且只在编译时有效 宏更像子程序
#define printMap(p) printf("%#x %#x %d %dk\n", (p)->start, (p)->end, (p)->attr, (p)->size / 1000)
#define printRes(p) do { \
    printf("%#x ", (p)->addr); \
    printVal((p)->typ, (p)->val); \
} while(0)

#define showMaps(h) do { \
    typeof(h) p = (h); \
    traverse(p, printMap(p)); \
} while (0)

#define showRes(h) do { \
    typeof(h) p = (h); \
    traverse(p, printRes(p)); \
} while (0)

/**
 * 运行Shell命令并获取结果
 * 返回命令的状态码 失败返回 -1
 */
int shell (char *cmd, char *buf, int len) {
    
    if (!cmd || !buf || len < 0)
        error("cmd = %s buf = %s len = %d\n", cmd, buf, len);

    memset(buf, 'a', len);
    FILE *fp = popen(cmd, "r");
    if (!fgets(buf, len, fp))
        error("获取Shell命令 %s 结果失败\n", cmd);
    
    int res = pclose(fp);
    if (res == -1) perror("关闭管道失败");
    return res % 255; // 0 ~ 254
}

/**
 * 绕过游戏监控(先于游戏运行一次)
 * r  只读方式打开，将文件指针指向文件头。
 * r+ 读写方式打开，将文件指针指向文件头。
 * w  写入方式打开，将文件指针指向文件头并将文件大小截为零。如果文件不存在则尝试创建之。
 * w+ 读写方式打开，将文件指针指向文件头并将文件大小截为零。如果文件不存在则尝试创建之。
 * a  写入方式打开，将文件指针指向文件末尾。如果文件不存在则尝试创建之。
 * a+ 读写方式打开，将文件指针指向文件末尾。如果文件不存在则尝试创建之。
 */
void byPass () {
    char *path = "/proc/sys/fs/inotify/max_user_watches";
    FILE *fp = fopen(path, "w+");
    
    int res = fgetc(fp);
    if (res == '0') {
        printf("为0不写入\n");
        return;
    }
    
    printf("非0则写入\n");
    res = fputc('0', fp);
    
    fclose(fp);
    if (res == EOF) error("写入文件 %s 失败\n", path);
}

/**
 * 获取指定包名的PID
 * 失败返回 0
 */
int getPid (char *pkg) {
    char buf[BUFSIZE] = { 0 };
    
    char cmd[BUFSIZE] = { 0 };
    sprintf(cmd, "pidof -s %s", pkg);
    
    int code = shell(cmd, buf, sizeof buf);
    int pid = 0;
    sscanf(buf, "%d", &pid);
    if (code != 0 || pid <= 0)
        error("获取 %s PID失败 PID %d 状态码 %d\n", pkg, pid, code);
    
    return pid;
}

/**
 * 获取mem文件句柄 失败返回 -1
 */
int openMem (int pid, Mode mode) {
    char buf[BUFSIZE] = { 0 };
    sprintf(buf, "/proc/%d/mem", pid);
    
    int fd = -1;
    switch (mode) {
        case READ:
        case SEARCH:
            fd = open(buf, O_RDONLY);
            break;
        case WRITE:
            fd = open(buf, O_WRONLY, O_SYNC);
            break;
        default:
            error("openMem参数错误 %d\n", mode);
    }
    if (fd == -1) error("打开 %s 失败\n", buf);
    
    return fd;
}

/**
 * 属性：字符串转数字
 */
int attrToNum (char *attr) {
    int num = 0;
    num |= attr[0] == 'r' ? VM_READ : 0;
    num |= attr[1] == 'w' ? VM_WRITE : 0;
    num |= attr[2] == 'x' ? VM_EXEC : 0;
    num |= attr[3] == 's' ? VM_MAYSHARE : 0;
    return num;
}

/**
 * 属性：数字转字符串
 */
char *numToAttr (char *attr, int num) {
    attr[0] = num & VM_READ ? 'r' : '-';
    attr[1] = num & VM_WRITE ? 'w' : '-';
    attr[2] = num & VM_EXEC ? 'x' : '-';
    attr[3] = num & VM_MAYSHARE ? 's' : 'p';
    attr[4] = 0;
    return attr;
}

/**
 * 解析maps文件 只过滤大小为0的内存段
 */
Map *loadMaps (int pid) {
    char buf[BUFSIZE] = { 0 };
    sprintf(buf, "/proc/%d/maps", pid);
    
    FILE *fp = fopen(buf, "r");
    if (!fp) {
        perror(buf);
        error("打开 %s 失败\n", buf);
    }
    
    Map *mapHead = NULL, *mapCur = NULL;
    
    char attr[ATTRSIZE] = { 0 };
    while (fgets(buf, BUFSIZE, fp)) {
        if (strlen(buf) >= 42) continue; // 只取 anonmyous
        /*if (strstr(buf, "(deleted)") || strstr(buf, "/system")
        ||  strstr(buf, "/dev") || strstr(buf, ".dex")
        ||  strstr(buf,"[heap]") || strstr(buf,"[anon:.bss]")
        || strstr(buf,"[anon:libc_malloc]") || strstr(buf,"kgsl-3d0")
        ) continue;*/
        
        //printf("%s", buf);
        
        Map *p = calloc(1, sizeof(Map));
        sscanf(buf, "%x-%x %s", &p->start, &p->end, attr);
        p->size = p->end - p->start;
        p->attr = attrToNum(attr);
        if (!p->size || !(p->attr & VM_READ)) { // 过滤没有r权限的内存段
            free(p);
            continue;
        }
        
        link(mapHead, mapCur, p);
    }
    
    for (Map *i = mapHead, *j = i->next; j; j = j->next) // 合并同属性连续内存段
        if (i->end == j->start && i->attr == j->attr) {
            i->next = j->next;
            i->end = j->end;
            i->size = i->end - i->start;
            free(j);
        } else
            i = j;
    
    //showMaps(mapHead);
    
    fclose(fp);
    return mapHead;
}

/**
 * 字符串反转（改变原来的数组）
 * 字节码（小端）转字符串
 * 高位低位翻转即可，字节本身不用翻转
 */
char *reverse (char *s) {
    int c;
    char *i = s, *j = s + strlen(s) - 1;
    while (i < j) {
        c = *i;
        *i++ = *j;
        *j-- = c;
    }
    return s;
}

// addr [offset] val
#define memRead(fd, addr, offset, val) ({ \
    typeof(addr) a = (addr) + (offset); \
    if (pread64((fd), &(val), sizeof(val), a) == -1) \
        error("读取内存 %#x 失败\n", a); \
    (val); \
})

/**
 * 搜索mem文件 失败返回 NULL
 * @param {int} pid 要搜索的进程号
 * @param {int} fd 已打开的内存句柄
 * @param {Type} typ
 * @param {Value} val
 */
Res *memSearch (int pid, int fd, Type typ, Value val) {
    
    Map *mapHead = loadMaps(pid);
    if (!mapHead) error("读取 /proc/%d/maps 失败\n", pid);
    
    Res *resHead = NULL, *resCur = NULL;
    
    for (Map *p = mapHead; p; p = p->next) {
        int blockLen = p->size / BLOCKSIZE;
        for (int i = 0; i < blockLen; i++) {
            Addr addr = p->start + i * BLOCKSIZE;
            Value tmp;
            // 这里的错误不严重 可忽略(可能是因为值为0)
            //if (pread64(fd, referp(typ, tmp), sizeof(refer(typ, tmp)), addr) == -1) {
            if (pread64(fd, &tmp, sizeof(tmp), addr) == -1) {
                printMap(p);
                error("读取内存 %x 失败\n", addr);
                //continue;
            }
            if (refer(typ, tmp) == refer(typ, val)) {
                Res *res = calloc(1, sizeof(Res));
                res->addr = addr;
                res->typ = typ;
                res->val = val;
                
                link(resHead, resCur, res);
            }
        }
    }
        
    return resHead;
}

// tsu -c 'gcc -Wall -O3 /sdcard/Pictures/mem.c -o /data/local/tmp/test/mem'
// tsu -c '/data/local/tmp/test/mem -p com.tencent.lycqsh -T r -a 0E1FD8B0 -o 0 -t i4'
// tsu -c '/data/local/tmp/test/mem -p com.tencent.lycqsh -T s -t i4-161'
// -p pkg
// -T r|w|s
// a addr
// o offset
// b 
int main (int argc, char **argv) {
    char *pkg = NULL;
    
    Addr addr = 0;
    int offset = 0;
    
    Mode mode = READ; // 默认为读内存
    
    Type typ = -1;
    Value val;
    
    int opt = -1;
    opterr = 0; // 自己处理错误
    while ((opt = getopt(argc, argv, "p:T:a:o:t:")) != -1)
        switch (opt) {
            case 'p':
                pkg = optarg;
                break;
            case 'T':
                switch (*optarg) {
                    case 'r':
                        mode = READ;
                        break;
                    case 'w':
                        mode = WRITE;
                        break;
                    case 's':
                        mode = SEARCH;
                        break;
                    default:
                        error("不支持的操作 %c\n", *optarg);
                }
                break;
            case 'a':
                sscanf(optarg, "%x", &addr); // 加不加0x前缀都可以
                break;
            case 'o':
                sscanf(optarg, "%d", &offset);
                break;
            case 't':
                switch (optarg[1]) {
                    case '1':
                        switch (optarg[0]) {
                            case 'i': typ = I1; break;
                            case 'u': typ = U1; break;
                        }
                        break;
                    case '2':
                        switch (optarg[0]) {
                            case 'i': typ = I2; break;
                            case 'u': typ = U2; break;
                        }
                        break;
                    case '4': 
                        switch (optarg[0]) {
                            case 'i': typ = I4; break;
                            case 'u': typ = U4; break;
                            case 'f': typ = F4; break;
                        }
                        break;
                    case '8': 
                        switch (optarg[0]) {
                            case 'i': typ = I8; break;
                            case 'u': typ = U8; break;
                            case 'f': typ = F8; break;
                        }
                        break;
                }
                switch (typ) {
                    case I1: case I2: case I4: case I8:
                        sscanf(optarg + 3, "%lld", &val.i8); break;
                    case U1: case U2: case U4: case U8:
                        sscanf(optarg + 3, "%llu", &val.u8); break;
                    case F4: case F8:
                        sscanf(optarg + 3, "%lf", &val.f8); break;
                    default: error("不支持的类型 %s\n", optarg);
                }
                printf("typ %d %d\n", typ, val.i4);
                break;
                
            case '?':
                error("Unknown option: %c\n", (char)optopt); // 可能有选项没读到
        }
    
    // 有typ必有val
    if (!pkg || typ == -1) error(USAGE, argv[0]);
    
	int pid = getPid(pkg);
    
    byPass();
    
    int fd = openMem(pid, mode);
    switch (mode) {
        case READ: { // addr [offset] val
            if (!addr) error(USAGE, argv[0]);
            memRead(fd, addr, offset, val);
            printf("%#x ", addr + offset);
            printVal(typ, val);
            break;
        }
        case SEARCH: {
            int start = clock();
            Res *res = memSearch(pid, fd, typ, val);
            showRes(res);
            double ms = (1.0 * clock() - start) / 1000;
            printf("memSearch %gms\n", ms);
            break;
        }
        case WRITE:
            //int fd = openMem(pid, mode);
            //long data = 100;
            //pwrite64(fd, &data, sizeof(data), addr);
            break;
        default:
            error("不支持的模式 %d\n", mode);
    }
    
    close(fd);
	exit(0);
}
