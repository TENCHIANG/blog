#include <stdio.h>
#include <string.h>

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

/**
 * 字符串转字节数组
 * @param b {void *} 一般是Byte * 也可以是 int *
 * @param n {int} 拷贝n个字节 -1表示由字符串决定其长度
 * @param s {char *} 以 1a aa 10 形式存储的字符串(不要求是字符串数组可以写)
 * @param d {char *} delim 分隔符
 * @return {Byte *} 返回拷贝了多少个字节
 */
char hexMap[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf };
#define strToByte(b, n, s, d) ({ \
    Byte *p = (Byte *)b; \
    int cnt = (n); \
    int off = 2 + strlen(d); \
    for (int i = 0; s[i] && cnt > 0; i += off, cnt--) { \
        Byte h = s[i] - '0'; \
        /*h = hexMap[h];*/ \
        Byte l = s[i + 1] - '0'; \
        /*l = hexMap[l];*/ \
        printf("h=%x l=%x off=%d n=%d %c-%c\n", h, l, off, n, s[i], s[i+1]); \
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

/*
tsu -c 'gcc -Wall -O3 /sdcard/Pictures/test.c -o /data/local/tmp/test/test'
tsu -c '/data/local/tmp/test/test'
*/
int main (void) {
    char buf[BLOCKSIZE] = { 0 };
    //double *addr = (double *)0x67453000;
    
    char *btStr = "A6 00 00 00 FB 53 90 0C 0C A1 00 00 00 00 00 00 00 00 00 12 00 00 00 00 05 29 11 E3";
    
    int len = strToByte(buf, strlen(btStr) / 3 + 1, btStr, " ");
    bytePrint(buf, len);
    printf("%d %d\n", len, strlen(btStr) / 3 + 1);
    
    return 0;
}
