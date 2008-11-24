#include <stdio.h>

#define fastcall __attribute__ ((regparm(3)))
extern fastcall unsigned long ksym_lookup(char *name, int len, char *);
extern fastcall void *memmem(char *dst, int dstlen, void *src, int srclen);
extern fastcall int xde_dism(void *code, void *di);
unsigned long *ksyms __attribute__ ((align(4))), retcode;
int xde_find(void *addr, int len, void *fmt, ...);
void test_func();
void test_call();


#define BYTE unsigned char
#define DWORD unsigned long


struct dism
{
  BYTE  defaddr;         // 00
  BYTE  defdata;         // 01
  DWORD len;             // 02 03 04 05
  DWORD flag;            // 06 07 08 09
  DWORD addrsize;        // 0A 0B 0C 0D
  DWORD datasize;        // 0E 0F 10 11
  BYTE  rep;             // 12
  BYTE  seg;             // 13
  BYTE  opcode;          // 14
  BYTE  opcode2;         // 15
  BYTE  modrm;           // 16
  BYTE  sib;             // 17

  BYTE	addr[8];			// 18
  BYTE	data[8];			// 20
} __attribute__ ((packed));

struct dism temp_dism;
int fuck[2] = {0};

int main()
{
	xde_find(test_func, 0x200, test_call, &fuck[0], &fuck[1]);
	printf("%lx %lx\n", fuck[0], fuck[1]);
}
