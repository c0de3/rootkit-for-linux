#define C_ERROR   0xFFFFFFFF
#define C_ADDR1   0x00000001 //�������е�ַ��С��λ�ֶ�(�ֽ�)
#define C_ADDR2   0x00000002
#define C_ADDR4   0x00000004 //(˫��)
#define C_LOCK    0x00000008 //����ǰ׺
#define C_67      0x00000010 //��ַ��С����ǰ׺(16/32λ)
#define C_66      0x00000020 //��������С����ǰ׺(16/32λ)
#define C_REP     0x00000040 //�ظ�ǰ׺
#define C_SEG     0x00000080 //�μĴ���ǰ׺
#define C_ANYPREFIX  (C_66+C_67+C_LOCK+C_REP+C_SEG)
#define C_DATA1   0x00000100 //�����������ݴ�С��λ�ֶ�
#define C_DATA2   0x00000200
#define C_DATA4   0x00000400
#define C_SIB     0x00000800 //SIB�ֽ�
#define C_ADDR67  0x00001000 //��ַ�ֽ���Ϊdisasm_defaddr
#define C_DATA66  0x00002000 //�����ֽ���Ϊdisasm_defdata
#define C_MODRM   0x00004000 //MODRM�ֽ�
#define C_BAD     0x00008000
#define C_OPCODE2 0x00010000 //������ڶ����ֽ�
#define C_REL     0x00020000 // ������תָ��jxx����call
#define C_STOP    0x00040000 // ���ǻ���ָ�ret_code����jmp

/*
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
};
*/

#define dism_defaddr 0x0
#define dism_defdata 0x1
#define dism_len 0x2
#define dism_flag 0x6
#define dism_addrsize 0xa
#define dism_datasize 0xe
#define dism_rep 0x12
#define dism_seg 0x13
#define dism_opcode 0x14
#define dism_opcode2 0x15
#define dism_modrm 0x16
#define dism_sib 0x17
#define dism_addr 0x18
#define dism_data 0x20
#define sizeof_dism 0x28
