#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <dirent.h>
#include <string.h>
#include <unistd.h>
#include <time.h> // clock
#include <stddef.h> // NULL
#include <math.h> // pow
#include <ctype.h> // isdigit isalpha

#define ATTRSIZE 5
#define BUFSIZE 128
#define BLOCKSIZE 4096 // 单位分块长度（提速）
#define USAGE "Usage: %s -p pkg -T r|w|s -a addr [-o offset] -t <i|u|f><1|2|4|8>[-val] [-n n] [-B blkSize] [-b bytes] [-v verbose]\n"

#define VM_READ 8 // r -
#define VM_WRITE 4 // w -
#define VM_EXEC 2 // x -
#define VM_MAYSHARE 1 // s p

// 防止负数溢出
typedef unsigned int Addr; // 用 unsigned long ?
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
void error (char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    fprintf(stderr, "error: ");
    vfprintf(stderr, fmt, args);
    fprintf(stderr, "\n");
    va_end(args);
    exit(1);
}

#define printVal(t, v) ({ \
    switch (t) { \
        case I1: printf("%d\n", (v).i1); break; \
        case U1: printf("%u\n", (v).u1); break; \
        case I2: printf("%d\n", (v).i2); break; \
        case U2: printf("%u\n", (v).u2); break; \
        case I4: printf("%d\n", (v).i4); break; \
        case U4: printf("%u\n", (v).u4); break; \
        case I8: printf("%lld\n", (v).i8); break; \
        case U8: printf("%llu\n", (v).u8); break; \
        case F4: printf("%g\n", (v).f4); break; \
        case F8: printf("%g\n", (v).f8); break; \
        default: error("printVal 不支持的类型 t=[%d]\n", (t)); \
    } \
})

#define inputVal(t, v, s) ({ \
    int res; \
    switch (t) { \
        case I1: case I2: case I4: case I8: \
            res = sscanf((s), "%lld", &(v).i8); break; \
        case U1: case U2: case U4: case U8: \
            res = sscanf((s), "%llu", &(v).u8); break; \
        case F4: res = sscanf((s), "%f", &(v).f4); break; \
        case F8: res = sscanf((s), "%lf", &(v).f8); break; \
        default: error("inputVal 不支持的类型 t=[%d] s=[%s]\n", (t), (s)); \
    } \
    if (res != 1) error("inputVal t=[%d] s=[%s]\n", (t), (s)); \
})

typedef struct Res {
    Addr addr;
    //Type typ;
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

#define traverse(p, f) ({ \
    int count = 0; \
    while (p) { \
        f; \
        (p) = (p)->next; \
        count++; \
    } \
    count; \
})

#define linkCount(p) traverse(p, 0)

// 不要把带参宏当成函数 且只在编译时有效 宏更像子程序
#define printMap(p) printf("%#x %#x %d %dk\n", (p)->start, (p)->end, (p)->attr, (p)->size / 1000)

#define printByte(b) printf("i4=%d u4=%u i8=%lld u8=%llu f4=%g f8=%g\n", (b).i4, (b).u4, (b).i8, (b).u8, (b).f4, (b).f8)

#define printRes(p, v) do { \
    if (v) { \
        printf("%#010x ", (p)->addr); \
        printByte((p)->val); \
    } else { \
        printf("%#010x\n", (p)->addr); \
    } \
    /*printVal((p)->typ, (p)->val);*/ \
} while(0)

#define showMaps(h) do { \
    typeof(h) p = (h); \
    printf("total %d\n", traverse(p, printMap(p))); \
} while (0)

#define showRes(h, v) ({ \
    typeof(h) p = (h); \
    traverse(p, printRes(p, (v))); \
})

/**
 * 打印字节数组
 * @param b {Byte *} 字节数组
 * @param n {int} b的长度
 * @param d {char *} 分隔符 一般通过 strToByte 获取
 * 最后一个分隔符不输出
 */
#define bytePrint(b, n, d) ({ \
    Byte *p = (Byte *)b; \
    for (int i = 0; i < (n); i++) \
        printf("%02x%s", p[i], i + 1 == n ? "" : d); \
    printf("\n"); \
})

/**
 * 字节数组转字符串
 * @param ba 字节数组
 * @param baSize 字节数组的长度
 * @param sa 字符数组
 * @param saSize 字符数组的长度 sizeof而非strlen
 * @param dlm 分隔符
 * @return 返回传过来的字符数组
 * 一个字符数组能存 saSize / off + 1 个字节 或 saSize / (dlen + 1)
 * 为什么不用宏 就算用 ({}) 包起来同名变量也会互相干扰
 */
char *byteToStr (Byte *ba, int baSize, char *sa, int saSize, char *dlm) {
    int dlen = strlen(dlm);
    int off = dlen + 2;
    int next = 0; // 下一个字节(相当于i * off)
    for (int i = 0; i < baSize && next < saSize; i++, next += off)
        sprintf(sa + next, "%02x%s", ba[i], dlm);
    sa[next - dlen] = 0; // 上一个分隔符的第一个字符置零
    return sa;
}

/**
 * 字符到数字的映射(支持16进制)
 * @param c {char|int} 要映射的字符
 * @return {int} 返回字符所代表的数字
 * 注意 如果有 ? 指挥替换为 0 而不会报错
 */
#define charMap(c) ({ \
    int r = (c); \
    if (r >= '0' && r <= '9') r -= '0'; \
    else if (r >= 'a' && r <= 'f') r = r - 'a' + 10; \
    else if (r >= 'A' && r <= 'F') r = r - 'A' + 10; \
    else if (r == '?') r = 0; \
    else error("不支持的字符 ASCII=%d\n", r); \
    r; \
})

#define maskMap(c) ((c) == '?' ? 0 : 0xf)

#define isByte(c) ( \
    ((c) >= '0' && (c) <= '9') || \
    ((c) >= 'a' && (c) <= 'f') || \
    ((c) >= 'A' && (c) <= 'F') || \
    ((c) == '?') \
)

/**
 * 字符串转字节数组
 * @param b 字节数组
 * @param n 拷贝n个字节 -1表示由字符串决定其长度
 * @param s 字节码字符串(自动识别分隔符)
 * @param mask 蒙版数组 如果不为空 则再生成蒙版 其长度与字节数组一致
 * @param dlm 获取字节码字符串的分隔符
 * @return {int} 返回拷贝了多少个字节
 * 自动检测分隔符长度，要求 1.分隔符起码长度相同 2.分隔符不能为数字字符或字母字符
 */
int strToByte (Byte *b, int n, char *s, Byte *mask, char *dlm) {
    int off = 2; // 2个字节 + 自动检测分隔符长度
    for (; s[off] && !isByte(s[off]); off++)
        if (dlm) *dlm++ = s[off];
    int cnt = n;
    int slen = strlen(s);
    Byte h, l; // 最起码保留2个字符
    for (int i = 0; i < slen && s[i] && s[i + 1] && cnt; i += off, cnt--) {
        h = charMap(s[i]) << 4;
        l = charMap(s[i + 1]);
        b[i / off] = h + l;
        if (mask) {
            h = maskMap(s[i]) << 4;
            l = maskMap(s[i + 1]);
            mask[i / off] = h + l;
        }
    }
    return n - cnt;
}

/**
 * 数组反转(字符串、字节数组皆可)
 * @param b {void *} 一般是Byte * 也可以是 int *
 * @param n {int} b的长度
 * @return {Byte *} 返回字节数组指针
 */
#define byteRev(b, n) ({ \
    Byte *p = (Byte *)(b); \
    Byte t; \
    for (int i = 0, j = (n) - 1; i < j; i++, j--) { \
        t = (p)[i]; \
        (p)[i] = (p)[j]; \
        (p)[j] = t; \
    } \
    (p); \
})

/**
 * 字节数组比较 也可以比较字符串(memcmp strcmp)
 * @param a 字节数组
 * @param b 字节数组
 * @param n 要对比多少个字节
 * @param m 字节数组 蒙版 如果传NULL 则使用 memcmp 否则在蒙版的基础上对比
 * @return {int} 相等返回 0
 * 注意：memcmp只返回 -1 0 1
 */
int byteCmp (Byte *a, Byte *b, int n, Byte *m) {
    int p, q;
    for (int i = 0; i < n; i++) {
        p = m ? (a[i] & m[i]) : a[i];
        q = m ? (b[i] & m[i]) : b[i];
        if (p != q) return p - q;
    }
    return 0;
}

/**
 * 把str用delim分割成若干份，分别保存到save里，保存n个
 * 返回保存了几份 i < cnt 其实直接save[i]也行
 */
int split (char *str, char *delim, char **save, int n) {
    char *next;
    char *sub = strtok_r(str, delim, &next);
    
    int cnt;
    for (cnt = 0; cnt < n && sub; cnt++) {
        save[cnt] = sub;
        sub = strtok_r(NULL, delim, &next);
    }
    return cnt;
}

/**
 * 运行Shell命令并获取结果
 * 返回命令的状态码 失败返回 -1
 */
int shell (char *cmd, char *buf, int len) {
    
    if (!cmd || !buf || len < 0)
        error("cmd = %s buf = %s len = %d\n", cmd, buf, len);

    FILE *fp = popen(cmd, "r");
    if (!fgets(buf, len, fp)) return -1;
        //error("获取Shell命令 %s 结果失败\n", cmd);
    
    int res = pclose(fp);
    if (res == -1) perror("关闭管道失败");
    return res % 255; // 0 ~ 254
}

/**
 * 获取指定包名的PID
 * 失败返回 0
 */
/*int getPid (char *pkg) {
    char buf[BUFSIZE] = { 0 };
    
    char cmd[BUFSIZE] = { 0 };
    sprintf(cmd, "pidof -s %s", pkg);
    
    int code = shell(cmd, buf, sizeof buf);
    int pid = 0;
    sscanf(buf, "%d", &pid);
    if (code != 0 || pid <= 0) error("%s 没有运行 %d\n", pkg, code);
    
    return pid;
}*/

/**
 * 通过PID找其包名
 * 注意 /proc/pid/status 里的包名不一定是完整的
 */
char *getPkg (int pid, char *pkg) {
    char buf[BUFSIZE] = { 0 };
    
    sprintf(buf, "/proc/%d/status", pid);
    FILE *fp = fopen(buf, "r");
    if (!fp) error("打开%s失败", buf);
    
    if (!fgets(buf, BUFSIZE - 1, fp) || !strstr(buf, pkg) || sscanf(buf, "%*s %s\n", pkg) != 1)
        error("获取%d包名失败\n", pid);
    
    return pkg;
}

/**
 * 通过包名找其PID 没找到则报错
 * 因为 /proc/pid/status 里的包名不一定是完整的, 所以也不用完整的包名识别
 */
int getPid (char *pkg) {
    FILE *fp;
    int pid = 0;
    char buf[BUFSIZE] = { 0 };
    
    DIR *dp = opendir("/proc");
    if (!dp) error("打开/proc失败");
    
    char *save[3] = { 0 };
    int len = split(pkg, ".", save, sizeof(save));
    if (len > 0) pkg = save[len - 1]; // 最后一个
    
    struct dirent *p = NULL;
    while ((p = readdir(dp))) {
        if (!strcmp(p->d_name, ".") || !strcmp(p->d_name, ".."))
            continue;
        sprintf(buf, "/proc/%s/status", p->d_name);
        if (!(fp = fopen(buf, "r"))) continue;
        if (fgets(buf, BUFSIZE - 1, fp) && strstr(buf, pkg)) {
            pid = atoi(p->d_name);
            break;
        }
        fclose(fp);
    }
    fclose(fp);
    closedir(dp);
    
    if (!pid) error("获取 %s PID失败\n", pkg);
    
    return pid;
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
    if (res == '0') return;
    
    res = fputc('0', fp);
    
    fclose(fp);
    if (res == EOF) error("写入文件 %s 失败\n", path);
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
            fd = open64(buf, O_RDONLY);
            break;
        case WRITE:
            fd = open64(buf, O_WRONLY, O_SYNC);
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
 * 解析maps文件 过滤 1.大小为0的内存段 2.只取anonmyous段
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
        
    if (!mapHead) error("读取 %s 失败\n", buf);
    
    //showMaps(mapHead);
    
    fclose(fp);
    return mapHead;
}

/**
 * 读取len个字节
 * 返回读取的字节数
 */
int memRead (int fd, void *data, int len, Addr addr, int offset) {
    Byte *bytes = (Byte *)data;
    addr += offset;
    int cnt = pread64(fd, bytes, len, addr);
    //if (cnt == -1 || cnt != len) error("读取内存 %#x 失败 cnt=%d\n", addr, cnt);
    return cnt;
}

/**
 * 写入len个字节
 * 返回写入的字节数
 */
int memWrite (int fd, void *data, int len, Addr addr, int offset) {
    Byte *bytes = (Byte *)data;
    addr += offset;
    int cnt = pwrite64(fd, bytes, len, addr);
    if (cnt == -1 || cnt != len) error("写入内存 %#x 失败 cnt=%d\n", addr, cnt);
    return cnt;
}
     
/**
 * 搜索mem文件 失败返回 NULL
 */
Res *memSearch (Map *map, int fd, Byte *bytes, int len, int n, int blkSize, Byte *mask) {
    Res *resHead = NULL, *resCur = NULL;
    Byte blk[BLOCKSIZE]; // 直接申请块的最大容量
    Byte tmp[BLOCKSIZE];
    
    //int miniBlock = len < 8 ? len : 8;
    int miniBlock = len;
    int lenPerBlk = blkSize / miniBlock;
    
    for (Map *p = map; p && n; p = p->next) {
        int blkPerChunk = p->size / blkSize; // 每个内存段分多少个块
        for (int i = 0; i < blkPerChunk && n; i++) {
            Addr addr = p->start + i * blkSize;
            memRead(fd, blk, blkSize, addr, 0); // 一次读一整块
            for (int j = 0; j < lenPerBlk && n; j++) {
                int off = j * miniBlock;
                Byte *blkoff = blk + off;
                if (!byteCmp(blkoff, bytes, len, mask)) {
                    addr += off;
                    memRead(fd, tmp, len, addr, 0); // 再次确认
                    if (byteCmp(tmp, bytes, len, mask)) { // 暂不清楚为啥会误识别(也许是对齐的问题?)
                        printf("start=%x end=%x addr=%x blkPerChunk=%d lenPerBlk=%d off=%d\n" , p->start, p->end, addr, blkPerChunk, lenPerBlk, off);
                        continue;
                    }
                    Res *res = calloc(1, sizeof(Res));
                    res->addr = addr;
                    memcpy(&res->val, tmp, sizeof(res->val));
                    //res->typ = typ;
                    //res->val = val;
                    link(resHead, resCur, res);
                    if (n > -1) n--;
                }
            }
        }
    }
    
    return resHead;
}

/**
 * 8字节数组比较(类似strstr memmem)
 * 返回 t在s中的第一个下标(返回的还是1字节下标)
 */
int memmem8b (void *a, int sn, void *b, int tn, void *mask, int mn) {
    unsigned long long *s = (unsigned long long *)a, *t = (unsigned long long *)b, *ma = (unsigned long long *)mask;
    if (tn < 8) { // 对齐
        ma[0] ^= 0xffffffffffffffff << 8 * tn;
        tn = 8; // 除8时直接变1
    }
    sn /= 8; tn /= 8;
    int i, j, k;
    for (i = 0; i < sn; i++) {
        for (j = i, k = 0; k < tn && (s[j] & ma[k % mn]) == (t[k] & ma[k % mn]); j++, k++)
            continue;
        //printf("ma[0]=[%016llx] i=%d j=%d k=%d s[j]=[%016llx] t[k]=[%016llx]\n", ma[0], i, j, k, s[j] & ma[j % mn], t[k] & ma[k % mn]);
        if (k > 0 && k >= tn)
            return i * 8;
    }
    return -1;
}

Res *memSeaByt (Map *map, int fd, Byte *bytes, int bytSize, int n, int blkSize, Byte *mask) {
    Byte blk[BLOCKSIZE]; // 直接申请块的最大容量
    Res *resHead = NULL, *resCur = NULL;
    bytSize = bytSize < 8 ? 8 : bytSize; // 按8字节对齐
    for (Map *p = map; p && n; p = p->next) {
        int blkPerChunk = p->size / blkSize; // 每个内存段分多少个块
        for (int i = 0; i < blkPerChunk && n; i++) {
            Addr addr = p->start + i * blkSize;
            memRead(fd, blk, blkSize, addr, 0); // 一次读一整块
            int off = memmem8b(blk, blkSize, bytes, bytSize, mask, bytSize);
            if (off > -1) {
                addr += off;
                Res *res = calloc(1, sizeof(Res));
                res->addr = addr;
                memcpy(&res->val, blk + off, sizeof(res->val));
                link(resHead, resCur, res);
                if (n > -1) n--;
            }
        }
    }
    return resHead;
}

int typeToByte (Byte *bp, Type typ, Value val) {
    int len = 0;
    switch (typ) {
        case I1: case I2: case I4:
        case U1: case U2: case U4: case F4: 
            len = 4;
            break;
        case I8: case U8: case F8:
            len = 8;
            break;
        default:
            error("不支持的类型 typ=%d\n", typ);
    }
    if (len <= 0 || !bp) error("typeToByte typ=%d len=%d bp=%p\n", typ, len, bp);
    memcpy(bp, &val, len);
    return len;
}

/*
tsu -c 'gcc -Wall -O3 /sdcard/Pictures/mem.c -o /data/local/tmp/test/mem && cp /data/local/tmp/test/mem /sdcard/Pictures/mem'
tsu -c 'gcc -Wall -O3 /sdcard/Pictures/mem.c -o /sdcard/Pictures/mem'

tsu -c '/data/local/tmp/test/mem -pcom.tencent.lycqsh -Tr -a 0x67453000 -o0 -ti4 -v1'
tsu -c '/data/local/tmp/test/mem -pcom.tencent.lycqsh -Ts -ti4-161 -n10 -v1'

tsu -c '/data/local/tmp/test/mem -pcom.tencent.lycqsh -Ts -b0200010006000000 -n10 -v1' 65538D

tsu -c '/data/local/tmp/test/mem -pcom.tencent.lycqsh -Tw -a0E0BB780 -o0 -ti4-162'
*/
int main (int argc, char **argv) {
    char *pkg = NULL;
    
    Addr addr = 0;
    int offset = 0;
    
    Mode mode = READ; // 默认为读内存
    
    Type typ = -1;
    Value val;
    
    int n = -1; // 代表获取所有搜索结果
    int blkSize = BLOCKSIZE; // 分块大小
    
    Byte mask[BUFSIZE];
    memset(mask, 0xff, sizeof(mask)); // 0x00才起作用
    Byte bytes[BUFSIZE] = { 0 };
    int btlen = 0;
    
    int verbose = 0; // 打印详细信息
    
    int opt = -1;
    opterr = 0; // 自己处理错误
    while ((opt = getopt(argc, argv, "p:T:a:o:t:n:B:b:v:")) != -1)
        switch (opt) {
            case 'p':
                pkg = optarg;
                break;
            case 'T':
                switch (*optarg) {
                    case 'r': mode = READ; break;
                    case 'w': mode = WRITE; break;
                    case 's': mode = SEARCH; break;
                    default: error("不支持的操作 %c\n", *optarg);
                }
                break;
            case 'a':
                sscanf(optarg, "%x", &addr); // 加不加0x前缀都可以
                break;
            case 'o':
                sscanf(optarg, "%d", &offset);
                break;
            case 't': {
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
                // READ模式无需输入值
                // 也意味着 要先读取 -T 选项
                if (mode != READ) {
                    int len = strlen(optarg);
                    if (len <= 3) {
                        fprintf(stderr, "没有输入任何值 len=%d\n", len);
                        error(USAGE, argv[0]);
                    }
                    inputVal(typ, val, optarg + 3);
                    //printVal(typ, val);
                }
                break;
            }    
            case 'n':
                sscanf(optarg, "%d", &n);
                break;
            case 'B':
                sscanf(optarg, "%d", &blkSize);
                if (blkSize > BLOCKSIZE || blkSize <= 0 || blkSize % 2 != 0)
                    error("块大小应为2的倍数且不能超过%d %d %% 2 == %d\n", BLOCKSIZE, blkSize, blkSize % 2);
                break;
            case 'b':
                if (!(btlen = strToByte(bytes, -1, optarg, mask, NULL))) error(USAGE, argv[0]);
                break;
            case 'v':
                verbose = 1;
                break;
            case '?':
                error("Unknown option: %c\n", (char)optopt); // 可能有选项没读到
        }
    
    /**
     * 这里做 typ 的判断(有typ必有val)
     * 如果是搜特征码 bytes 则无需 typ val
     */
    if (!pkg || (!btlen && typ == -1)) error(USAGE, argv[0]);
    
    byPass();
	int pid = getPid(pkg);
    if (verbose) printf("pid=%d\n", pid);
    int fd = openMem(pid, mode);
    
    int start = clock();
    switch (mode) {
        case READ: { // addr [offset] val
            if (!addr) error(USAGE, argv[0]);
            memRead(fd, &val, sizeof(val), addr, offset);
            printf("%#x ", addr + offset);
            printVal(typ, val);
            bytePrint(&val, sizeof(val), "");
            break;
        }
        case SEARCH: {
            // 搜索有两种：1.搜索类型 2.搜索特征码
            if (btlen <= 0) {
                btlen = typeToByte(bytes, typ, val);
                if (verbose) {
                    printf("搜索类型模式\n");
                    printf("bytes="); bytePrint(bytes, btlen, "");
                }
            }
            
            Map *map = loadMaps(pid);
            Res *res = memSeaByt(map, fd, bytes, btlen, n, blkSize, mask);
            
            int tot = 0;
            tot = showRes(res, verbose);
            if (verbose) {
                printf("tot=%d\n", tot);
                printf("type=%d btlen=%d\n", typ, btlen);
                printf("bytes="); bytePrint(bytes, btlen, "");
                printf(" mask="); bytePrint(mask, btlen, "");
            }
            break;
        }
        case WRITE: {
            if (!addr) error(USAGE, argv[0]);
            btlen = typeToByte(bytes, typ, val);
            bytePrint(bytes, btlen, "");
            memWrite(fd, bytes, btlen, addr, offset);
            break;
        }
        default:
            error("不支持的模式 %d\n", mode);
    }
    if (verbose) {
        double ms = (1.0 * clock() - start) / 1000;
        printf("耗时=%gms\n", ms);
    }
    
    close(fd);
	exit(0);
}
