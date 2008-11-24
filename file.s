file.f_op:	.fill 4
file.f_dentry: .fill 4
dentry.d_inode: .fill 4
dentry.d_count: .long 0
dentry.d_mounted: .fill 4
file_operations.read: .fill 4
file_operations.readdir: .fill 4
inode.i_ino: .long 32
inode.i_sb: .fill 4
inode.i_fop: .fill 4
inode.i_size: .fill 4
super_block.s_op: .fill 4
super_operations.read_inode: .long 0x8
fs_struct.lock: .long 4
fs_struct.rootmnt : .fill 4
fs_struct.root : .fill 4
vfsmount.mnt_count: .fill 4
vfsmount.mnt_sb: .long 0x14
task_struct.fs: .fill 4

struct_file: .fill 0x150
dentry_root: .fill 4
vfsmount_root: .fill 4
sb_root: .fill 4
inode_root: .fill 4

// struct inode *file_get_inode(struct file *file);
EXPORT_LABEL(file_get_inode)
	.fill 0x40


// void file_init();
EXPORT_LABEL(file_init)
	PUSH_ALL
	subl $0x20, %esp

	GET_VAL32(posix_lock_file, %esi)
	GET_ADDR(file_get_inode, %edi)
	movl %edi, %ebp
	movl $0x40, %ecx
	cld; rep movsb

	movl %ebp, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000ff; .long 0x000000e9;
	.byte 'n';
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	call xde_find
	testl %eax, %eax
	jz file_init_out
	movb $0xc3, (%esi)

#ifdef _DEBUG_
	GET_ADDR(file_get_inode, %eax)
	movl %eax, 4(%esp)
    DPRINT("<3>file_get_inode at %lx\n") 
#endif

	GET_ADDR(file_get_inode, %esi)
	movzbl 2(%esi), %ebx
	SET_VAL32(file.f_dentry, %ebx)
	movzbl 5(%esi), %ebx
	SET_VAL32(dentry.d_inode, %ebx)

	GET_VAL32(set_fs_root, %eax)
	movl %eax, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000ff; .long 0x0000008b;
	.byte 's'; .byte 0x02; .long 0x000000ff;
	.byte 0x00; .long 0x000000ff; .long 0x0000008b;
	.byte 's'; .byte 0x02; .long 0x000000ff;
	.byte 0x00; .long 0x0000ffff; .long 0x0000fff0;
	.byte 's'; .byte 0x03; .long 0x000000ff;
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	GET_ADDR(fs_struct.root, %eax)
	movl %eax, 0xc(%esp)
	GET_ADDR(fs_struct.rootmnt, %eax)
	movl %eax, 0x10(%esp)
	GET_ADDR(vfsmount.mnt_count, %eax)
	movl %eax, 0x14(%esp)
	call xde_find
	testl %eax, %eax
	jz file_init_out

#ifdef _DEBUG_
	GET_VAL32(fs_struct.root, %eax)
	movl %eax, 0x4(%esp)
	GET_VAL32(fs_struct.rootmnt, %eax)
	movl %eax, 0x8(%esp)
	GET_VAL32(vfsmount.mnt_count, %eax)
	movl %eax, 0xc(%esp)
	DPRINT("<3>fs_struct.root %lx; fs_struct.rootmnt %lx; vfsmount.mnt_count %lx\n") 
#endif


	GET_VAL32(do_path_lookup, %eax)
	movl %eax, (%esp)
	movl $0x40, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x0000c0FF; .long 0x0000808b;
	.byte 's'; .byte 0x02; .long 0xffffffff;
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	GET_ADDR(task_struct.fs, %eax)
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz file_init_out

#ifdef _DEBUG_
	GET_VAL32(task_struct.fs, %eax)
	movl %eax, 0x4(%esp)
	DPRINT("<3>task_struct.fs %lx\n") 
#endif

	GET_VAL32(iput, %eax)
	movl %eax, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000FF; .long 0x0000008b;
	.byte 's'; .byte 0x02; .long 0x000000ff;
	.byte 0x00; .long 0x000000FF; .long 0x0000008b;
	.byte 's'; .byte 0x02; .long 0x000000ff;
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	GET_ADDR(inode.i_sb, %eax)
	movl %eax, 0xc(%esp)
	GET_ADDR(super_block.s_op, %eax)
	movl %eax, 0x10(%esp)
	call xde_find
	testl %eax, %eax
	jz file_init_out

#ifdef _DEBUG_
	GET_VAL32(inode.i_sb, %eax)
	movl %eax, 4(%esp)
	GET_VAL32(super_block.s_op, %eax)
	movl %eax, 8(%esp)
    DPRINT("<3>inode.i_sb %lx; super_block.s_op %lx\n") 
#endif

	GET_VAL32(vfs_readdir, %eax)
	movl %eax, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000FF; .long 0x00000075;
	.byte 'j'; .byte 0x01; .long 0x000000ff;
	.byte 0x00; .long 0x000000FF; .long 0x0000008b;
	.byte 's'; .byte 0x02; .long 0x000000ff;
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	GET_ADDR(file_operations.readdir, %eax)
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz file_init_out

#ifdef _DEBUG_
	GET_VAL32(file_operations.readdir, %eax)
	movl %eax, 4(%esp)
    DPRINT("<3>file_operations.readdir %lx\n") 
#endif

	GET_VAL32(init_special_inode, %eax)
	movl %eax, (%esp)
	movl $0x100, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000FF; .long 0x000000b8;
	.byte 'n';
	.byte 0x00; .long 0x000000FF; .long 0x00000089;
	.byte 's'; .byte 0x02; .long 0x000000ff;
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	GET_ADDR(inode.i_fop, %eax)
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz file_init_out

#ifdef _DEBUG_
	GET_VAL32(inode.i_fop, %eax)
	movl %eax, 4(%esp)
    DPRINT("<3>inode.i_fop %lx\n") 
#endif

	// dentry_root = current->fs->root;
	// vfsmount_root = current->fs->rootmnt;
	movl %esp, %esi
	andl $0xffffe000, %esi
	movl (%esi), %esi
	GET_STRUCT_VAL32(%esi, task_struct.fs, %edi)
	GET_STRUCT_VAL32(%edi, fs_struct.root, %esi)
	SET_VAL32(dentry_root, %esi)
	GET_STRUCT_VAL32(%edi, fs_struct.rootmnt, %edx)
	SET_VAL32(vfsmount_root, %edx)

	// inode_root = dentry_root->d_inode;
	GET_STRUCT_VAL32(%esi, dentry.d_inode, %edi)
	SET_VAL32(inode_root, %edi)

	// sb_root = inode_root->i_sb;
	GET_STRUCT_VAL32(%edi, inode.i_sb, %edx)
	SET_VAL32(sb_root, %edx)

#ifdef _DEBUG_
	GET_VAL32(dentry_root, %eax)
	movl %eax, 0x8(%esp)
	GET_VAL32(inode_root, %eax)
	movl %eax, 0x4(%esp)
    DPRINT("<3>inode_root %lx; dentry_root %lx; \n") 
#endif

	GET_VAL32(follow_mount, %eax)
	movl %eax, (%esp)
	movl $0x50, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x0000c0ff; .long 0x0000408b;
	.byte 's'; .byte 0x02; .long 0x000000ff;
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	GET_ADDR(dentry.d_mounted, %eax)
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz file_init_out

#ifdef _DEBUG_
	GET_VAL32(dentry.d_mounted, %eax)
	movl %eax, 0x4(%esp)
    DPRINT("<3>dentry.d_mounted %lx\n") 
#endif

	GET_VAL32(shmem_truncate, %eax)
	movl %eax, (%esp)
	movl $0x50, 0x4(%esp)
	call 1f
	.byte 0x00; .long 0x000000ff; .long 0x0000008b;
	.byte 's'; .byte 0x02; .long 0x000000ff;
	.byte 'e'
1:	popl %eax
	movl %eax, 0x8(%esp)
	GET_ADDR(inode.i_size, %eax)
	movl %eax, 0xc(%esp)
	call xde_find
	testl %eax, %eax
	jz file_init_out

#ifdef _DEBUG_
	GET_VAL32(inode.i_size, %ebx)
	movl %ebx, 0x4(%esp)
    DPRINT("<3>inode.i_size %lx\n") 
#endif

file_init_out:
	addl $0x20, %esp
	POP_ALL
	ret


// struct inode *iget(struct super_block *sb, unsigned long ino);
EXPORT_LABEL(iget)
	PUSH_ALL
	movl %eax, %esi

	GET_VAL32(iget_locked, %ebp)
	call *%ebp
	testl %eax, %eax
	jz 1f
	movl %eax, %edi
	
	GET_STRUCT_VAL32(%esi, super_block.s_op, %ebp)
	GET_STRUCT_VAL32(%ebp, super_operations.read_inode, %esi)
	movl %edi, %eax
	call *%esi

	GET_VAL32(unlock_new_inode, %esi)
	movl %edi, %eax
	call *%esi

	movl %edi, %eax
1:
	POP_ALL
	ret

/*
int readdir_filler(void * __buf, const char * name, int namlen, loff_t offset,
		   u64 ino, unsigned int d_type);
*/
EXPORT_LABEL(readdir_filler)
#define STACK_SIZE 0x2c
	PUSH_ALL
	subl $STACK_SIZE, %esp
	movl %eax, %ebp
	movl %edx, %esi
	movl %ecx, %edi

	//DPRINT("<3>readdir_filler called\n")

	movl %esi, 0x4(%esp)	// name
	movl %edi, 0x8(%esp)	// len
	movl (STACK_SIZE + 0x24)(%esp), %eax
	movl %eax, 0xc(%esp)	// ino_l
	movl (STACK_SIZE + 0x28)(%esp), %eax
	movl %eax, 0x10(%esp)	// ino_h
	movl (STACK_SIZE + 0x2c)(%esp), %eax
	movl %eax, 0x14(%esp)	// type
	movl $-1, 0x18(%esp)	// mount
	movl $-1, 0x1c(%esp)		// size_l
	movl $-1, 0x20(%esp)		// size_h

	// inode = iget(sb, ino);
	movl 0xc(%esp), %edx
	movl %ebp, %eax
	call iget
	testl %eax, %eax
	jz 1f
	movl %eax, %esi

	GET_STRUCT_VAL64(%esi, inode.i_size, %eax, %ebx)
	movl %eax, 0x1c(%esp)
	movl %ebx, 0x20(%esp)
	
	// dentry = d_find_alias(inode);
	movl %esi, %eax
	GET_VAL32(d_find_alias, %ebx)
	call *%ebx
	testl %eax, %eax
	jz 1f
	movl %eax, %edi

	// mounted = d_mountpoint(dentry);
	GET_STRUCT_VAL32(%edi, dentry.d_mounted, %eax)
	movl %eax, 0x18(%esp)	// mount

	// iput(inode);
	movl %esi, %eax
	GET_VAL32(iput, %ebx)
	call *%ebx	
	
1:	DPRINT("<3>name:%s len:%lx ino:%llx type:%lx mount:%lx size:%llx\n")

readdir_filler_out:
	xorl %eax, %eax
	addl $STACK_SIZE, %esp
	POP_ALL
	ret
#undef STACK_SIZE

// void __readdir(struct dentry *dentry);
EXPORT_LABEL(__readdir)
	PUSH_ALL
	movl %eax, %ebp

	// memset(file, 0, sizeof(*file));
	// file->f_dentry = dentry;
	xorb %al, %al
	GET_VAL32(struct_file, %edi)
	movl %edi, %esi	// file
	movl $0x150, %ecx
	cld; rep stosb
	SET_STRUCT_VAL32(%esi, file.f_dentry, %ebp)

	// inode = dentry->d_inode;
	GET_STRUCT_VAL32(%ebp, dentry.d_inode, %edi)	// inode

	// sb = inode->i_sb;
	GET_STRUCT_VAL32(%edi, inode.i_sb, %ebp)	// sb

	// inode->f_op->readdir(file, sb, readdir_filler);
	GET_ADDR(readdir_filler, %ecx)
	movl %ebp, %edx
	movl %esi, %eax
	GET_STRUCT_VAL32(%edi, inode.i_fop, %ebx)
	GET_STRUCT_VAL32(%ebx, file_operations.readdir, %ebp)
	call *%ebp

	POP_ALL
	ret

/*
struct inode_arg {
	u8 len;
	u32 ino[0];
};
*/

// fastcall struct dentry *inode_arg_to_dentry(struct inode_arg *ia);
EXPORT_LABEL(inode_arg_to_dentry)
#define STACK_SIZE 0x21
	PUSH_ALL
	subl $STACK_SIZE, %esp

	movb (%eax), %bl
	movb %bl, (STACK_SIZE - 1)(%esp)	// len
	
	incl %eax
	movl %eax, (STACK_SIZE - 5)(%esp)	// ino ptr

	movl (%eax), %esi	// ino
	GET_VAL32(sb_root, %edi) // sb
	GET_VAL32(vfsmount_root, %ebp) // vfsmnt

1:
	// inode = iget(sb, ino);
	movl %edi, %eax
	movl %esi, %edx
	call iget
	testl %eax, %eax
	jz 2f
	movl %eax, %ebx	// inode

#ifdef _DEBUG_
	movl %esi, 4(%esp)
	DPRINT("<3>iget %d\n")
#endif	

	// dentry = d_find_alias(inode);
	movl %ebx, %eax
	GET_VAL32(d_find_alias, %edx)
	call *%edx
	testl %eax, %eax
	jz 4f
	movl %eax, %edx

#ifdef _DEBUG_
	movl %esi, 4(%esp)
	DPRINT("<3>d_find_alias %d\n")
#endif	

	/*
	if (!d_mountpoint(dentry))
		break;
	*/
	GET_STRUCT_VAL32(%edx, dentry.d_mounted, %eax)
	testl %eax, %eax
	jz 3f

#ifdef _DEBUG_
	movl %esi, 4(%esp)
	DPRINT("<3>d_mountpoint %d\n")
#endif	

	// __follow_mount(&{ vfsmnt, dentry});
	movl %ebp, (%esp)
	movl %edx, 4(%esp)
	movl %esp, %eax
	GET_VAL32(__follow_mount, %ecx)
	call *%ecx
	testl %eax, %eax
	jz 3f

#ifdef _DEBUG_
	movl %esi, 4(%esp)
	DPRINT("<3>__follow_mount %d\n")
#endif		

	// sb = vfsmnt->mnt_sb;
	movl (%esp), %ebp
	movl 4(%esp), %edx
	GET_STRUCT_VAL32(%ebp, vfsmount.mnt_sb, %edi)
	
	// get next ino
	movl %edx, %eax
	decb (STACK_SIZE - 1)(%esp)
	jz 2f
	movl (STACK_SIZE - 5)(%esp), %ecx
	addl $4, %ecx
	movl (%ecx), %esi
	movl %ecx, (STACK_SIZE - 5)(%esp)

3:	// dput(dentry);
	movl %edx, %eax
	GET_VAL32(dput, %ecx)
	call *%ecx

4:	// iput(inode)
	movl %ebx, %eax
	GET_VAL32(iput, %ecx)
	call *%ecx

	//cmpb $0, (STACK_SIZE - 1)(%esp)
	//jnz 1b
	xorl %eax, %eax

2:	addl $STACK_SIZE, %esp
	POP_ALL
	ret
#undef STACK_SIZE

