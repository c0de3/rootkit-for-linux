#include "xde_table.s"

struct_dism:
	.fill sizeof_dism




// extern "C" int xde_find(void *addr, int len, const char *fmt, ...);
// @addr: the func to find
// @len: the max len to find
// @fmt: the format to match
// the format is:
// [offset(1B)] [mask(4B)] [to match(4B)]
// [action, can be:
//	'n' - no action
//	's' - save to label, label is placed in the arg list
//	'j' - follow the jxx ins, jmp to the location specified by the addr of the ins 
// (1B)]
// {[save offset(1B)] [save mask(4B)] | // when action is 's'
//	[(0B)] | // when action is 'n'
//	[val offset(1B)] [val mask(4B)] // when action is 'j'
//	(variable)}
// 
// return: the last matched ins addr. if not match, returns 0
EXPORT_LABEL(xde_find)
#define STACK_SIZE 0x10
#define ARG (STACK_SIZE + 24 + 4)
#define ADDR_END (STACK_SIZE - 4)
#define ARG_PTR	(STACK_SIZE - 8)
	PUSH_ALL
	subl $STACK_SIZE, %esp

	movl (ARG + 0x8)(%esp), %edi		// fmt
	movl ARG(%esp), %esi	// addr
	movl (ARG + 0x4)(%esp), %eax
	addl %esi, %eax
	movl %eax, ADDR_END(%esp)	// addr_end
	leal (ARG + 0xc)(%esp), %eax
	movl %eax, ARG_PTR(%esp)	// arg_ptr

1:	movl %esi, %eax

#ifdef _TEST_
	.extern temp_dism
	movl $temp_dism, %edx
#else
	GET_ADDR(struct_dism, %edx)
#endif
	call xde_dism
	testl %eax, %eax
	jz xde_find_out
	movl %eax, %ebp

	movzbl (%edi), %eax	// offset
	cmpl dism_len(%edx), %eax
	jae 6f
	movl 0(%esi, %eax, 1), %eax // val
	andl 1(%edi), %eax // mask
	cmpl 5(%edi), %eax // match
	jnz 6f
	
7:	movb 9(%edi), %al	// action
	cmpb $'n', %al
	jnz 9f
	// action 'n'
	leal 10(%edi), %edi
	jmp 7f

9:	cmpb $'s', %al
	jnz 10f
	// action 's'
	movzbl 10(%edi), %eax	// save offset
	movl 0(%esi, %eax, 1), %eax // save val
	andl 11(%edi), %eax		// save mask
	movl ARG_PTR(%esp), %ebx
	movl (%ebx), %ebx
	movl %eax, (%ebx)
	addl $4, ARG_PTR(%esp)
	leal 15(%edi), %edi
	jmp 7f

10:	cmpb $'j', %al
	jnz 8f
	// action 'j'
	movzbl 10(%edi), %eax	// offset
	movl 0(%esi, %eax, 1), %eax // val
	andl 11(%edi), %eax		// mask
	addl %ebp, %esi
	addl %eax, %esi
	xorl %ebp, %ebp
	leal 15(%edi), %edi
	jmp 7f

8:	xorl %eax, %eax
	jmp xde_find_out

6:	addl %ebp, %esi
	cmpl ADDR_END(%esp), %esi	// addr_end
	jl 1b
	xorl %eax, %eax
	jmp xde_find_out
	
7:	cmpb $'e', (%edi)
	jnz 6b
	movl %esi, %eax
	
xde_find_out:
	addl $STACK_SIZE, %esp
	POP_ALL
	ret
#undef STACK_SIZE
#undef ARG
#undef ARG_PTR
#undef ADDR_END

// int fastcall xde_dism(void *code, struct dism *di); 
// @code: the code to dism
// @di: the dism struct
// return: dism->len
EXPORT_LABEL(xde_dism)
#define ret_code 0
#define mod 4
#define rm 5
#define opcode 6
	pushl %ebx
	pushl %ecx
	pushl %edx
	pushl %esi
	pushl %edi
	movl %eax, %esi
	movl %edx, %edi
	subl $0x20, %esp

	movl %esi, opcode(%esp)

	movl $0x28, %ecx
	movl %edi, %eax
1:	movb $0, (%eax)
	incl %eax
	loop 1b
	// memset(di, 0, sizeof(*di));

	movb $4, dism_defdata(%edi)
	movb $4, dism_defaddr(%edi)

	movl $0, ret_code(%esp)
	// ret_code = 0;

	movw (%esi), %bx
	cmpw $0x0000, %bx
	jz xd_out
	cmpw $0xFFFF, %bx
	jz xd_out
	// if (*code == 0xFFFF || *code == 0x0)
		// ret_codeurn 0;
		
repeat_prefix:
	movzbl (%esi), %eax
	incl %esi
	GET_ADDR(xde_table, %ebx)
	movl 0(%ebx, %eax, 4), %ecx
	// c = *code++;
	// t = xde_table[c];

	testl $C_ANYPREFIX, %ecx
	jz 1f
	// if (t & C_ANYPREFIX) {

		testl %ecx, dism_flag(%edi)
		jz 2f
		// if (t & dism->flag) {
			movl $0, ret_code(%esp)
			jmp xd_out
		// ret_codeurn 0;
		2:// }

		orl %ecx, dism_flag(%edi)
		// dism->flag |= t;

		testl $C_67, %ecx
		jz 3f
		// if (t & C_67) 
		xorb $6, dism_defaddr(%edi)
			// di->defaddr ^= 6;
		jmp 6f
		
		3:
		testl $C_66, %ecx
		jz 4f
		// if (t & C_66)
		xorb $6, dism_defdata(%edi)
			// di->defdata ^= 6;
		jmp 6f
		
		4:
		testl $C_SEG, %ecx
		jz 7f
		// if (t & C_SEG) 
		movb %al, dism_seg(%edi)
			// di->seg = c;
		jmp 6f

		7:
		testl $C_REP, %ecx
		jz 6f
		// if (t & C_REP)
		movb %al, dism_rep(%edi)
			// di->req = c;
		6:
		jmp repeat_prefix

	1:
	// }

	orl %ecx, dism_flag(%edi)
	movb %al, dism_opcode(%edi)
	// di->flag |= t; di->opcode = c;

	cmpb $0x0F, %al
	jnz 5f
	// if (c == 0x0F) {
		
		movzbl (%esi), %eax
		incl %esi
		// c = *code++;

		movb %al, dism_opcode2(%edi)

		GET_ADDR(xde_table, %ebx)
		movl (256 * 4)(%ebx, %eax, 4), %ecx
		orl %ecx, dism_flag(%edi)
		// di->opcode2 = c; flag |= xde_table[256 + c];

		cmpl $C_ERROR, dism_flag(%edi)
		jnz 8f
		// if (flags == C_ERROR) {
			movl $0, ret_code(%esp)
			jmp xd_out
		// ret_codeurn 0;
		8:
		// }

		jmp 9f

	5:
	cmpb $0xF7, %al
	jnz 10f
	// } else if (c == 0xF7) {
		
		movb (%esi), %bl
		testb $0x38, %bl
		jnz 11f
		// if (!(*code & 0x38)) 
			orl $C_DATA66, dism_flag(%edi)
			// di->flag |= C_DATA66;
		11:
		jmp 9f

	10:
	cmpb $0xF6, %al
	jnz 9f
	// } else if (c == 0xF6) {

		movb (%esi), %bl
		testb $0x38, %bl
		jnz 12f
		// if (!(*code & 0x38)) 
			orl $C_DATA66, dism_flag(%edi)
			// di->flag |= C_DATA1;
	12:	
	// }

	9:
	testl $C_MODRM, dism_flag(%edi)
	jz 13f
	// if (flag & C_MODRM) {

		movb (%esi), %al
		incl %esi
		// c = *code++

		movb %al, dism_modrm(%edi)
		// di->modrm = c;

		movb %al, %ah
		andb $0x38, %ah
		cmpb $0x20, %ah
		jnz 14f
		cmpb $0xFF, dism_opcode(%edi)
		jnz 14f
		// if ((c & 0x38) == 0x20 && dism->opcode == 0xFF) 
			orl	$C_STOP, dism_flag(%edi)
			// di->flag |= C_STOP
		14:
		movb %al, mod(%esp)
		andb $0xC0, mod(%esp)
		movb %al, rm(%esp)
		andb $0x07, rm(%esp)
		// mod = c & 0xC0; rm = c & 0x07;

		cmpb $0xC0, mod(%esp)
		jz 15f
		// if (mod != 0xC0) {
			
			cmpb $0x4, dism_defaddr(%edi)
			jnz 18f
			// if (di->defaddr == 0x4) {
				
				cmpb $0x4, rm(%esp)
				jnz 24f
				// if (rm == 4) {

					orl $C_SIB, dism_flag(%edi)
					// di->flag |= C_SIB;
					movzbl (%esi), %eax
					incl %esi
					// c = *code++;
					movb %al, dism_sib(%edi)
					// di->sib = c;
					movb %al, rm(%esp)
					andb $0x7, rm(%esp)
					// rm = c & 0x7;

				24:
				// }

				cmpb $0x40, mod(%esp)
				jnz 17f
				// if (mod == 0x40) 
					orl $C_ADDR1, dism_flag(%edi)
					// di->flag |= C_ADDR1;
					jmp 21f
				17:
				cmpb $0x80, mod(%esp)
				jnz 19f
				// else if (mod == 0x80)
					orl $C_ADDR4, dism_flag(%edi)
					// di->flag |= C_ADDR4;
					jmp 21f
				19:
				cmpb $0x5, rm(%esp)
				jnz 21f
				// else if (rm == 5)
					orl $C_ADDR4, dism_flag(%edi)
					// di->flag |= C_ADDR4;
				
				21:
				jmp 20f
			18:	
			// } else { 
				
				cmpb $0x40, mod(%esp)
				jnz 22f
				// if (mod == 0x40) 
					orl $C_ADDR1, dism_flag(%edi)
					// di->flag |= C_ADDR1;
					jmp 23f
				22:
				cmpb $0x80, mod(%esp)
				jz 24f
				// else if (mod == 0x80)
					orl $C_ADDR2, dism_flag(%edi)
					// di->flag |= C_ADDR2;
					jmp 23f
				24:
				cmpb $0x6, rm(%esp)
				// else if (rm == 6)
					orl $C_ADDR2, dism_flag(%edi)
					// di->flag |= C_ADDR2;
				23:
			20:
			// }
		15:
		// }
	13:
	// }

	movl dism_flag(%edi), %eax
	movl %eax, %ebx
	movl %eax, %ecx
	andl $(C_ADDR1 | C_ADDR2 | C_ADDR4), %eax
	andl $(C_DATA1 | C_DATA2 | C_DATA4), %ebx
	shrl $8, %ebx
	
	testl $C_ADDR67, %ecx
	jz 1f
	addb dism_defaddr(%edi), %al
	1:

	testl $C_DATA66, %ecx
	jz 2f
	addb dism_defdata(%edi), %bl
	2:

	movl %eax, dism_addrsize(%edi)
	movl %ebx, dism_datasize(%edi)
	
	movl %edi, %edx
	movl %eax, %ecx
	leal dism_addr(%edx), %edi
	cld; rep movsb

	movl %ebx, %ecx
	leal dism_data(%edx), %edi
	cld; rep movsb

	subl opcode(%esp), %esi
	movl %esi, ret_code(%esp)

	movl %esi, dism_len(%edx)

xd_out:
	movl ret_code(%esp), %eax
	addl $0x20, %esp
	popl %edi
	popl %esi
	popl %edx
	popl %ecx
	popl %ebx
	ret

#undef opcode
#undef retcode
#undef mod
#undef rm

