#include <stdio.h>
#include <string.h>
#include <stdlib.h> //exit
#include <stdarg.h>
#include <ctype.h> // isdigit isalpha

#define BLOCKSIZE 128

typedef unsigned char Byte;

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
 * 注意 如果有 ? 指挥替换为 0 而不会报错
 */
#define charMap(c) ({ \
    int r = (c); \
    if (r >= '0' && r <= '9') r -= '0'; \
    else if (r >= 'a' && r <= 'f') r = r - 'a' + 10; \
    else if (r >= 'A' && r <= 'F') r = r - 'A' + 10; \
    else if (r == '?') r = 0; \
    else error("不支持的字符 ASCII=%d %c\n", r, r); \
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

int fastMemmem (Byte *a, int alen, Byte *b, int blen) {
    int tag[256] = { 0 };
    
    int i, j, k, match;
    for (i = 0; i < blen; i++) tag[b[i]] = 1;
    
    for (i = 0; i < alen; i++) {
        for (j = i + blen - 1, k = blen - 1, match = 1; k >= 0; j--, k--) {
            if (!tag[a[j]]) {
                match = 0;
                i = j;
                break;
            }
            if (match && a[j] != b[k]) match = 0;
        }
        if (match) return i;
    }
    
    return -1;
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

/**
 * b蒙版化a
 * an >= bn
 * 返回已蒙版化了多少个字节
 */
#define maskify(a, an, b, bn) ({ \
    int i; \
    for (i = 0; i < (an); i++) \
        (a)[i] &= (b)[i % (bn)]; \
    i; \
})
/*#define maskify(a, an, b, bn) ({ \
    int i, j, k; \
    for (i = 0; i < (an); i += (bn)) \
        for (k = i, j = 0; j < (bn); j++, k++) \
            (a)[k] &= (b)[j]; \
    k; \
})*/

/*,
tsu -c 'gcc -Wall -O3 /sdcard/Pictures/test.c -o /data/local/tmp/test/test'
tsu -c '/data/local/tmp/test/test'
*/
int main (void) {
    Byte buf[BLOCKSIZE] = { 0 };
    Byte buf2[BLOCKSIZE] = { 0 };
    
    char *btStr = "0000000F0000000000000000000000000000023000000000000000000000023FFFFFFFF000000000";
    char *btStr2 = "a6  00  00  00  fb  53  90  0c  0c  a1  00  00  00  00  00  00  00  00  00  12  00  00  00  00  05  29  ??  e3";
    
    Byte mask[BLOCKSIZE];
    memset(mask, 0xff, sizeof(mask));
    
    char dlm[BLOCKSIZE] = { 0 };
    int len = strToByte(buf, -1, btStr, NULL, dlm);
    int len2 = strToByte(buf2, -1, btStr2, mask, NULL);
    printf("buf="); bytePrint(buf, len, "");
    printf("mask="); bytePrint(mask, len, "");
    printf("buf2="); bytePrint(buf2, len, "");
    printf("len=%d dlm=[%s]\n", len, dlm);
    
    printf("%d\n", byteCmp(buf, buf2, len, mask));
    
    Byte a[BLOCKSIZE];
    memset(a, 0xff, BLOCKSIZE);
    printf("before="); bytePrint(a, len, "");
    printf("maskify=%d\n", maskify(a, len, mask + len/2, len/2));
    printf("after ="); bytePrint(a, len, "");
    
    //memset(buf2, 0, sizeof(buf2));
    len2 = strToByte(buf2, -1, "FF", NULL, dlm);
    printf("\nbuf ="); bytePrint(buf, len, "");
    printf("buf2="); bytePrint(buf2, len2, "");
    printf("%d\n", memmem8b(buf, len, buf2, len2, mask, len));
    //printf("%d\n", fastMemmem(buf, len, buf2, len2));
    
    /*char str[BLOCKSIZE] = { 0 };
    byteToStr(buf, len, str, sizeof(str), "--");
    printf("%s\nlen=%d\n", str, len);*/
    
    return 0;
}
