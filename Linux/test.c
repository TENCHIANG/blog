#include <stdio.h>
#include <string.h> // memcpy

#define BUFSIZE 128

typedef unsigned char Byte;

#define 

#define bytePrint(b, n) ({ \
    Byte *p = (Byte *)(b); \
    for (int i = 0; i < (n); i++) \
        printf("%02x ", p[i]); \
    printf("\n"); \
})

// 123
// 0x7b Big-Endian: 低字节在高地址(对内存是反的)
// 0xb7 Little-Endian: 低字节在低地址(对于人是反的)
int main (void) {
    
    Byte buf[BUFSIZE] = { 0 };
    
    int i = 161;
    memcpy(buf, &i, sizeof(int));
    
    bytePrint(buf, BUFSIZE);
    
    
    
    return 0;
}
