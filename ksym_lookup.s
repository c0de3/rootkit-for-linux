EXPORT_LABEL(ksyms)	.fill 4

#define _KSYM_DEBUG_
.equ __printk, 0xc0127be0
#define KSYM_DPRINT(fmt)   \
    movl $__printk, %eax;    \
    GET_STR(fmt, %edx); \
    movl %edx, (%esp);  \
    call *%eax;


// fastcall unsigned long ksym_lookup(char *name, int len) 
// @name: name of the function to find 
// @len: len of the name 
// return: addr of the function 
EXPORT_LABEL(ksym_lookup) 
    PUSH_ALL
    subl $0x14, %esp 

	movl %eax, (%esp)
	movl %edx, 4(%esp)

#ifndef _TEST_
    // saved = get_fs(); set_fs(KERNEL_DS);
    movl %esp, %eax 
    andl $0xffffe000, %eax 
    movl 0x18(%eax), %ebx 
    movl %ebx, 0x10(%esp)
    movl $0xffffffff, 0x18(%eax)
#endif

#ifndef _TEST_
	GET_VAL32(ksyms, %esi)
#else
	movl %ecx, %esi
#endif

ksym_lookup_getline:
	movl %esi, %edi
1:	cmpb $0, (%esi)
	jnz 4f
	xorl %eax, %eax
	jmp ksym_lookup_out
4:	cmpb $'\n', (%esi)
	jz 2f
	incl %esi
	jmp 1b
2:	
	movl %edi, %edx
	movl $2, %eax
1:	cmpb $' ', (%edi)
	jnz 2f
	decl %eax
	jz 3f
2:	incl %edi
	cmpl %esi, %edi
	jl 1b
	xorl %eax, %eax
	jmp ksym_lookup_out
3:	
	leal 1(%edi), %edi
	leal 1(%esi), %ebp
	movl (%esp), %esi
	movl 4(%esp), %ecx
	cld; rep cmpsb
	je 1f
	jmp ksym_lookup_next
1:	
	cmpb $'_', (%edi)
	je ksym_lookup_next
	cmpb $'0', (%edi)
	jl 3f
	cmpb $'9', (%edi)
	jle ksym_lookup_next
	cmpb $'a', (%edi)
	jl 3f
	cmpb $'z', (%edi)
	jle ksym_lookup_next
3:	
	xorl %eax, %eax
	movl $9, %esi
2:	movb (%edx), %bl
	cmpb $' ', %bl
	jz 3f
	cmpb $'a', %bl
	jb 4f
	cmpb $'f', %bl
	jna 6f
	xorl %eax, %eax
	jmp ksym_lookup_out
6:	subb $('a' - 10), %bl
	jmp 5f
4:	cmpb $'0', %bl
	jnb 7f
	xorl %eax, %eax
	jmp ksym_lookup_out
7:	cmpb $'9', %bl
	jna 8f
	xorl %eax, %eax
	jmp ksym_lookup_out
8:	subb $'0', %bl
5:	shl $4, %eax
	movb %al, %cl
	andb $0xF0, %cl
	orb %cl, %bl
	movb %bl, %al
	incl %edx
	decl %esi
	jnz 9f
	xorl %eax, %eax
	jmp ksym_lookup_out
9:	jmp 2b

ksym_lookup_next:
	movl %ebp, %esi
	jmp ksym_lookup_getline

3:	
ksym_lookup_out: 

#ifndef _TEST_
	movl %esp, %ebx 
    andl $0xffffe000, %ebx 
    movl 0x10(%esp), %ecx 
    movl %ecx, 0x18(%ebx)
#endif
	
    addl $0x14, %esp 
    POP_ALL
    ret 

	idt_ptr:
	.word 0xFF * 8
	.long 0x0 


// void ksyms_init();
EXPORT_LABEL(ksyms_init)
	PUSH_ALL
	subl $0x24, %esp

	// set KERNEL_DS 
    movl %esp, %eax 
    andl $0xffffe000, %eax 
    movl 0x18(%eax), %ebx 
    movl %ebx, 0x1c(%esp) 
    movl $0xffffffff, 0x18(%eax) 

1:	GET_ADDR(idt_ptr, %ebx)
	sidt (%ebx)
	movl 2(%ebx), %ebp

#ifdef _KSYM_DEBUG_
	movl %ebp, 4(%esp)
	KSYM_DPRINT("<3>idt at%lx\n")
#endif

	movw (0x80 * 8 + 6)(%ebp), %ax
	shl $16, %eax
	movw (0x80 * 8)(%ebp), %ax
	movl %eax, %ebp

#ifdef _KSYM_DEBUG_
	movl %eax, 4(%esp)
	KSYM_DPRINT("<3>int 0x80 sr at %lx\n")
#endif

	movl %ebp, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000ff; .long 0x000000ff
	.byte 's'; .byte 0x03; .long 0xffffffff
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	leal 0x10(%esp), %eax
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz ksyms_init_out
	movl 0x10(%esp), %ebp
	
#ifdef _KSYM_DEBUG_
	movl %ebp, 4(%esp)
	KSYM_DPRINT("<3>sys_call_table at %lx\n")
#endif
	
	movl (5 * 4)(%ebp),	%ebx	// __NR_open = 5
	SET_VAL32(sys_open, %ebx)
	movl (3 * 4)(%ebp), %ebp	// __NR_read = 3

#ifdef _KSYM_DEBUG_
	GET_VAL32(sys_open, %eax)
	movl %eax, 8(%esp)
	movl %ebp, 4(%esp)
	KSYM_DPRINT("<3>sys_read at %lx, sys_open at %lx\n")
#endif

	movl %ebp, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000ff; .long 0x000000e8; 
	.byte 'n';
	.byte 0x00; .long 0x000000ff; .long 0x000000e8;
	.byte 's'; .byte 0x01; .long 0xffffffff
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	leal 0x10(%esp), %eax
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz ksyms_init_out
	movl 0x10(%esp), %ebp
	leal 5(%eax), %eax
	addl %eax, %ebp

#ifdef _KSYM_DEBUG_
	movl %ebp, 4(%esp)
	KSYM_DPRINT("<3>vfs_read at %lx\n")
#endif

	movl %ebp, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000ff; .long 0x000000c3; 
	.byte 'n';
	.byte 0x00; .long 0x000000ff; .long 0x0000008b;
	.byte 's'; .byte 0x02; .long 0x000000ff
	.byte 0x00; .long 0x000000ff; .long 0x0000008b;
	.byte 's'; .byte 0x02; .long 0x000000ff
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	GET_ADDR(file.f_op, %eax)
	movl %eax, 0xc(%esp)
	GET_ADDR(file_operations.read, %eax)
	movl %eax, 0x10(%esp)
	call xde_find
	testl %eax, %eax
	jz ksyms_init_out
	
#ifdef _KSYM_DEBUG_
	GET_VAL32(file.f_op, %eax)
	movl %eax, 4(%esp)
	GET_VAL32(file_operations.read, %eax)
	movl %eax, 8(%esp)
	KSYM_DPRINT("<3>file.f_op %lx, file_operations.read %lx\n")
#endif

	GET_VAL32(sys_open, %eax)
	movl %eax, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000ff; .long 0x000000e8; 
	.byte 's'; .byte 0x01; .long 0xffffffff;
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	leal 0x10(%esp), %eax
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz ksyms_init_out
	movl 0x10(%esp), %ebp
	leal 5(%eax), %eax
	addl %eax, %ebp

#ifdef _KSYM_DEBUG_
	movl %ebp, 4(%esp)
	KSYM_DPRINT("<3>do_sys_open at %lx\n")
#endif
	
	movl %ebp, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x0000ffff; .long 0x00007f78; 
	.byte 'n';
	.byte 0x00; .long 0x000000ff; .long 0x000000e8; 
	.byte 's'; .byte 0x01; .long 0xffffffff;
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	leal 0x10(%esp), %eax
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz ksyms_init_out
	movl 0x10(%esp), %ebp
	leal 5(%eax), %eax
	addl %eax, %ebp
	SET_VAL32(do_filp_open, %ebp)

#ifdef _KSYM_DEBUG_
	GET_VAL32(do_filp_open, %eax)
	movl %eax, 4(%esp)
	KSYM_DPRINT("<3>do_filp_open at %lx\n")
#endif

	// file = do_filp_open(AT_FDCWD, "/proc/kallsyms", O_RDONLY, 0);
	GET_VAL32(do_filp_open, %ebp)
	movl $-100, %eax
	GET_STR("/proc/kallsyms", %edx)
	xorl %ecx, %ecx
	movl $0, (%esp)
	call *%ebp
	testl %eax, %eax
	jz ksyms_init_out
	movl %eax, %esi

	GET_STRUCT_VAL32(%esi, file.f_op, %ebx)
	GET_STRUCT_VAL32(%ebx, file_operations.read, %edi)

#ifdef _KSYM_DEBUG_
	movl %edi, 4(%esp)
	KSYM_DPRINT("<3>file opened, file->f_op->read at %lx\n")
#endif


	movl %edi, (%esp)
	movl $0x200, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x0000ffff; .long 0x0000840f; 
	.byte 'j'; .byte 0x2; .long 0xffffffff;
	.byte 0x00; .long 0x000000ff; .long 0x000000a1; 
	.byte 's'; .byte 0x01; .long 0xffffffff;
	.byte 0x00; .long 0x000000ff; .long 0x000000e8; 
	.byte 's'; .byte 0x01; .long 0xffffffff;
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	leal 0x14(%esp), %eax
	movl %eax, 0xc(%esp)
	leal 0x18(%esp), %eax
	movl %eax, 0x10(%esp)
	call xde_find
	testl %eax, %eax
	jz ksyms_init_out

	movl 0x14(%esp), %ebx
	movl (8 + 7 * 12 + 4)(%ebx), %ebx
	movl 0x18(%esp), %ebp
	leal 5(%eax), %eax
	addl %eax, %ebp

#ifdef _KSYM_DEBUG_
	movl %ebx, 8(%esp)
	movl %ebp, 4(%esp)
	KSYM_DPRINT("<3>kmem_cache_alloc at %lx, param 1 is %lx\n")
#endif
	
	// buf = kmem_cache_alloc(malloc_sizes[1MB].cs_cachep, GFP_KERNEL | __GFP_ZERO);
	movl %ebx, %eax
	movl $0xd0, %edx
	call *%ebp
	testl %eax, %eax
	jz ksyms_init_out
	movl %eax, %ebp

	SET_VAL32(ksyms, %ebp)

#ifdef _KSYM_DEBUG_
	movl %ebp, 4(%esp)
	KSYM_DPRINT("<3>kmem_cache_alloc 1MB for kallsyms at %lx ok!\n")
#endif


#define posl 0x4
#define posh 0x8

	movl $0, posl(%esp)
	movl $0, posh(%esp)

	GET_VAL32(ksyms, %ebx)

	// file->f_op->read(file, buf, 1024 * 1024 * 1, &pos);
1:	leal posl(%esp), %eax
	movl %eax, (%esp)
	movl %ebx, %edx
	movl $(1024 * 1024), %ecx
	movl %esi, %eax
	movl %edi, %ebp
	call *%ebp
	testl %eax, %eax
	jz 3f
	addl %eax, %ebx
	jmp 1b
3:

#undef posh
#undef posl

#ifdef _KSYM_DEBUG_
	GET_VAL32(ksyms, %eax)
	movl %eax, 4(%esp)
	KSYM_DPRINT("<3>read kallsym ok! content: %.10s ...\n")
#endif
	
	movl $1, %eax

ksyms_init_out:
	
	// restore DS
    movl %esp, %ebx 
    andl $0xffffe000, %ebx 
    movl 0x1c(%esp), %ecx 
    movl %ecx, 0x18(%ebx) 

	addl $0x24, %esp
	POP_ALL
	ret
