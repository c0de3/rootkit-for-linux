
// fastcall void *memmem(void *dst, int dstlen, void *src, int srclen) 
// find matched bytes 
// @dst: place to find 
// @dstlen: max bytes to find 
// @src: bytes to match 
// @srclen: length of the match bytes 
// return: if found, return the addr, else return 0 
EXPORT_LABEL(memmem) 
    pushl %ebx 
    pushl %esi 
    pushl %edi 
    movl 0x10(%esp), %edi 
    movl %ecx, %esi 
4:  movb (%eax), %bl 
    movb (%ecx), %bh 
    cmpb %bl, %bh 
    jnz 1f 
    incl %ecx 
    decl %edi 
    jnz 2f 
    subl 0x10(%esp), %eax 
    incl %eax 
    jmp 3f 
1:  movl 0x10(%esp), %edi 
    movl %esi, %ecx 
2:  decl %edx 
    jz 5f 
    incl %eax 
    jmp 4b 
5:  xorl %eax, %eax 
3:  popl %edi 
    popl %esi 
    popl %ebx 
    ret 
