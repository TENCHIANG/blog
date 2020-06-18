#include <stdio.h>
#include <string.h>
#include <stdlib.h> //exit
#include <stdarg.h>
#include <ctype.h> // isdigit isalpha

#define BLOCKSIZE 128

typedef unsigned char Byte;

/**
 * 打印字节数组
 * @param b {void *} 一般是Byte * 也可以是 int *
 * @param n {int} b的长度
 */
#define bytePrint(b, n) ({ \
    Byte *p = (Byte *)b; \
    for (int i = 0; i < (n); i++) \
        printf("%02x ", p[i]); \
    printf("\n"); \
})

void error (char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    fprintf(stderr, "error: ");
    vfprintf(stderr, fmt, args);
    fprintf(stderr, "\n");
    va_end(args);
    exit(1);
}



/**
 * 字符到数字的映射(支持16进制)
 * @param c {char|int} 要映射的字符
 * @return {int} 返回字符所代表的数字
 */
#define charMap(c) ({ \
    int r = (c); \
    if (r >= '0' && r <= '9') r -= '0'; \
    else if (r >= 'a' && r <= 'z') r = r - 'a' + 10; \
    else if (r >= 'A' && r <= 'Z') r = r - 'A' + 10; \
    else error("不支持的字符 %c\n", r); \
    r; \
})

/**
 * 字符串转字节数组
 * @param b {void *} 一般是Byte * 也可以是 int *
 * @param n {int} 拷贝n个字节 -1表示由字符串决定其长度
 * @param s {char *} 以 1a aa 10 形式存储的字符串(不要求是字符串数组可以写)
 * @return {Byte *} 返回拷贝了多少个字节
 * 自动检测分隔符长度，要求 1.分隔符起码长度相同 2.分隔符不能为数字字符或字母字符
 */
#define strToByte(b, n, s) ({ \
    int off = 2; /* 2个字节 + 自动检测分隔符长度 */ \
    for (int i = off; (s)[i] && !isdigit((s)[i]) && !isalpha((s)[i]); i++, off++) \
        continue; \
    Byte *p = (Byte *)b; \
    int cnt = (n); \
    Byte h, l; \
    for (int i = 0; s[i] && cnt > 0; i += off, cnt--) { \
        h = charMap(s[i]) << 4; /* 高字节 */ \
        l = charMap(s[i + 1]); \
        p[i / off] = h + l; \
    } \
    (n) - cnt; \
})

/*#define strToByte(b, n, s, d) ({ \
    Byte *p = (Byte *)b; \
    char buf[3] = { 0 }; \
    int cnt = (n); \
    int off = 2 + strlen(d); \
    for (int i = 0; s[i] && cnt > 0; i += off, cnt--) { \
        memcpy(buf, s + i, sizeof(buf) - 1); \
        (p[i / off] = (Byte)strtol(buf, NULL, 16); \
    } \
    (n) - cnt; \
})*/

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

/*,
tsu -c 'gcc -Wall -O3 /sdcard/Pictures/test.c -o /data/local/tmp/test/test'
tsu -c '/data/local/tmp/test/test'
*/
int main (void) {
    char buf[BLOCKSIZE] = { 0 };
    //double *addr = (double *)0x67453000;
    
    char *btStr = "A6 00 00 00 FB 53 90 0C 0C A1 00 00 00 00 00 00 00 00 00 12 00 00 00 00 05 29 11 E3";
    
    int len = strToByte(buf, strlen(btStr) / 3 + 1, btStr);
    bytePrint(buf, len);
    printf("%d %d\n", len, strlen(btStr) / 3 + 1);
    
    char str[BLOCKSIZE] = { 0 };
    byteToStr(buf, len, str, sizeof(str), "--");
    printf("%s\nlen=%d\n", str, len);
    
    return 0;
}
