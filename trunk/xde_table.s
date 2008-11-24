
EXPORT_LABEL(xde_table)
.long  C_MODRM  	// 00 
.long  C_MODRM  	// 01 
.long  C_MODRM  	// 02 
.long  C_MODRM  	// 03 
.long  C_DATA1  	// 04 
.long  C_DATA66  	// 05 
.long  C_BAD  	// 06 
.long  C_BAD  	// 07 
.long  C_MODRM  	// 08 
.long  C_MODRM  	// 09 
.long  C_MODRM  	// 0A 
.long  C_MODRM  	// 0B 
.long  C_DATA1  	// 0C 
.long  C_DATA66  	// 0D 
.long  C_BAD  	// 0E 
.long  C_OPCODE2  	// 0F 
.long  C_MODRM+C_BAD  	// 10 
.long  C_MODRM  	// 11 
.long  C_MODRM+C_BAD  	// 12 
.long  C_MODRM  	// 13 
.long  C_DATA1+C_BAD  	// 14 
.long  C_DATA66+C_BAD  	// 15 
.long  C_BAD  	// 16 
.long  C_BAD  	// 17 
.long  C_MODRM+C_BAD  	// 18 
.long  C_MODRM  	// 19 
.long  C_MODRM  	// 1A 
.long  C_MODRM  	// 1B 
.long  C_DATA1+C_BAD  	// 1C 
.long  C_DATA66+C_BAD  	// 1D 
.long  C_BAD  	// 1E 
.long  C_BAD  	// 1F 
.long  C_MODRM  	// 20 
.long  C_MODRM  	// 21 
.long  C_MODRM  	// 22 
.long  C_MODRM  	// 23 
.long  C_DATA1  	// 24 
.long  C_DATA66  	// 25 
.long  C_SEG+C_BAD  	// 26 
.long  C_BAD  	// 27 
.long  C_MODRM  	// 28 
.long  C_MODRM  	// 29 
.long  C_MODRM  	// 2A 
.long  C_MODRM  	// 2B 
.long  C_DATA1  	// 2C 
.long  C_DATA66  	// 2D 
.long  C_SEG+C_BAD  	// 2E 
.long  C_BAD  	// 2F 
.long  C_MODRM  	// 30 
.long  C_MODRM  	// 31 
.long  C_MODRM  	// 32 
.long  C_MODRM  	// 33 
.long  C_DATA1  	// 34 
.long  C_DATA66  	// 35 
.long  C_SEG+C_BAD  	// 36 
.long  C_BAD  	// 37 
.long  C_MODRM  	// 38 
.long  C_MODRM  	// 39 
.long  C_MODRM  	// 3A 
.long  C_MODRM  	// 3B 
.long  C_DATA1  	// 3C 
.long  C_DATA66  	// 3D 
.long  C_SEG+C_BAD  	// 3E 
.long  C_BAD  	// 3F 
.long  0  	// 40 
.long  0  	// 41 
.long  0  	// 42 
.long  0  	// 43 
.long  C_BAD  	// 44 
.long  0  	// 45 
.long  0  	// 46 
.long  0  	// 47 
.long  0  	// 48 
.long  0  	// 49 
.long  0  	// 4A 
.long  0  	// 4B 
.long  C_BAD  	// 4C 
.long  0  	// 4D 
.long  0  	// 4E 
.long  0  	// 4F 
.long  0  	// 50 
.long  0  	// 51 
.long  0  	// 52 
.long  0  	// 53 
.long  0  	// 54 
.long  0  	// 55 
.long  0  	// 56 
.long  0  	// 57 
.long  0  	// 58 
.long  0  	// 59 
.long  0  	// 5A 
.long  0  	// 5B 
.long  C_BAD  	// 5C 
.long  0  	// 5D 
.long  0  	// 5E 
.long  0  	// 5F 
.long  C_BAD  	// 60 
.long  C_BAD  	// 61 
.long  C_MODRM+C_BAD  	// 62 
.long  C_MODRM+C_BAD  	// 63 
.long  C_SEG  	// 64 
.long  C_SEG+C_BAD  	// 65 
.long  C_66  	// 66 
.long  C_67  	// 67 
.long  C_DATA66  	// 68 
.long  C_MODRM+C_DATA66  	// 69 
.long  C_DATA1  	// 6A 
.long  C_MODRM+C_DATA1  	// 6B 
.long  C_BAD  	// 6C 
.long  C_BAD  	// 6D 
.long  C_BAD  	// 6E 
.long  C_BAD  	// 6F 
.long  C_DATA1+C_REL+C_BAD  	// 70 
.long  C_DATA1+C_REL+C_BAD  	// 71 
.long  C_DATA1+C_REL  	// 72 
.long  C_DATA1+C_REL  	// 73 
.long  C_DATA1+C_REL  	// 74 
.long  C_DATA1+C_REL  	// 75 
.long  C_DATA1+C_REL  	// 76 
.long  C_DATA1+C_REL  	// 77 
.long  C_DATA1+C_REL  	// 78 
.long  C_DATA1+C_REL  	// 79 
.long  C_DATA1+C_REL+C_BAD  	// 7A 
.long  C_DATA1+C_REL+C_BAD  	// 7B 
.long  C_DATA1+C_REL  	// 7C 
.long  C_DATA1+C_REL  	// 7D 
.long  C_DATA1+C_REL  	// 7E 
.long  C_DATA1+C_REL  	// 7F 
.long  C_MODRM+C_DATA1  	// 80 
.long  C_MODRM+C_DATA66  	// 81 
.long  C_MODRM+C_DATA1+C_BAD  	// 82 
.long  C_MODRM+C_DATA1  	// 83 
.long  C_MODRM  	// 84 
.long  C_MODRM  	// 85 
.long  C_MODRM  	// 86 
.long  C_MODRM  	// 87 
.long  C_MODRM  	// 88 
.long  C_MODRM  	// 89 
.long  C_MODRM  	// 8A 
.long  C_MODRM  	// 8B 
.long  C_MODRM+C_BAD  	// 8C 
.long  C_MODRM  	// 8D 
.long  C_MODRM+C_BAD  	// 8E 
.long  C_MODRM  	// 8F 
.long  0  	// 90 
.long  0  	// 91 
.long  0  	// 92 
.long  C_BAD  	// 93 
.long  C_BAD  	// 94 
.long  C_BAD  	// 95 
.long  C_BAD  	// 96 
.long  C_BAD  	// 97 
.long  C_BAD  	// 98 
.long  0  	// 99 
.long  C_DATA66+C_DATA2+C_BAD  	// 9A 
.long  0  	// 9B 
.long  C_BAD  	// 9C 
.long  C_BAD  	// 9D 
.long  C_BAD  	// 9E 
.long  C_BAD  	// 9F 
.long  C_ADDR67  	// A0 
.long  C_ADDR67  	// A1 
.long  C_ADDR67  	// A2 
.long  C_ADDR67  	// A3 
.long  0  	// A4 
.long  0  	// A5 
.long  0  	// A6 
.long  0  	// A7 
.long  C_DATA1  	// A8 
.long  C_DATA66  	// A9 
.long  0  	// AA 
.long  0  	// AB 
.long  0  	// AC 
.long  C_BAD  	// AD 
.long  0  	// AE 
.long  C_BAD  	// AF 
.long  C_DATA1  	// B0 
.long  C_DATA1  	// B1 
.long  C_DATA1  	// B2 
.long  C_DATA1  	// B3 
.long  C_DATA1  	// B4 
.long  C_DATA1  	// B5 
.long  C_DATA1+C_BAD  	// B6 
.long  C_DATA1+C_BAD  	// B7 
.long  C_DATA66  	// B8 
.long  C_DATA66  	// B9 
.long  C_DATA66  	// BA 
.long  C_DATA66  	// BB 
.long  C_DATA66+C_BAD  	// BC 
.long  C_DATA66  	// BD 
.long  C_DATA66  	// BE 
.long  C_DATA66  	// BF 
.long  C_MODRM+C_DATA1  	// C0 
.long  C_MODRM+C_DATA1  	// C1 
.long  C_DATA2+C_STOP  	// C2 
.long  C_STOP  	// C3 
.long  C_MODRM+C_BAD  	// C4 
.long  C_MODRM+C_BAD  	// C5 
.long  C_MODRM+C_DATA1  	// C6 
.long  C_MODRM+C_DATA66  	// C7 
.long  C_DATA2+C_DATA1  	// C8 
.long  0  	// C9 
.long  C_DATA2+C_STOP+C_BAD  	// CA 
.long  C_STOP+C_BAD  	// CB 
.long  C_BAD  	// CC 
.long  C_DATA1  	// CD 
.long  C_BAD  	// CE 
.long  C_STOP+C_BAD  	// CF 
.long  C_MODRM  	// D0 
.long  C_MODRM  	// D1 
.long  C_MODRM  	// D2 
.long  C_MODRM  	// D3 
.long  C_DATA1+C_BAD  	// D4 
.long  C_DATA1+C_BAD  	// D5 
.long  C_BAD  	// D6 
.long  C_BAD  	// D7 
.long  C_MODRM  	// D8 
.long  C_MODRM  	// D9 
.long  C_MODRM  	// DA 
.long  C_MODRM  	// DB 
.long  C_MODRM  	// DC 
.long  C_MODRM  	// DD 
.long  C_MODRM  	// DE 
.long  C_MODRM  	// DF 
.long  C_DATA1+C_REL+C_BAD  	// E0 
.long  C_DATA1+C_REL+C_BAD  	// E1 
.long  C_DATA1+C_REL  	// E2 
.long  C_DATA1+C_REL  	// E3 
.long  C_DATA1+C_BAD  	// E4 
.long  C_DATA1+C_BAD  	// E5 
.long  C_DATA1+C_BAD  	// E6 
.long  C_DATA1+C_BAD  	// E7 
.long  C_DATA66+C_REL  	// E8 
.long  C_DATA66+C_REL+C_STOP  	// E9 
.long  C_DATA66+C_DATA2+C_BAD  	// EA 
.long  C_DATA1+C_REL+C_STOP  	// EB 
.long  C_BAD  	// EC 
.long  C_BAD  	// ED 
.long  C_BAD  	// EE 
.long  C_BAD  	// EF 
.long  C_LOCK+C_BAD  	// F0 
.long  C_BAD  	// F1 
.long  C_REP  	// F2 
.long  C_REP  	// F3 
.long  C_BAD  	// F4 
.long  C_BAD  	// F5 
.long  C_MODRM  	// F6 
.long  C_MODRM  	// F7 
.long  0  	// F8 
.long  0  	// F9 
.long  C_BAD  	// FA 
.long  C_BAD  	// FB 
.long  0  	// FC 
.long  0  	// FD 
.long  C_MODRM  	// FE 
.long  C_MODRM  	// FF 
.long  C_MODRM  	// 00 
.long  C_MODRM  	// 01 
.long  C_MODRM  	// 02 
.long  C_MODRM  	// 03 
.long  C_ERROR  	// 04 
.long  C_ERROR  	// 05 
.long  0  	// 06 
.long  C_ERROR  	// 07 
.long  0  	// 08 
.long  0  	// 09 
.long  0  	// 0A 
.long  0  	// 0B 
.long  C_ERROR  	// 0C 
.long  C_ERROR  	// 0D 
.long  C_ERROR  	// 0E 
.long  C_ERROR  	// 0F 
.long  C_ERROR  	// 10 
.long  C_ERROR  	// 11 
.long  C_ERROR  	// 12 
.long  C_ERROR  	// 13 
.long  C_ERROR  	// 14 
.long  C_ERROR  	// 15 
.long  C_ERROR  	// 16 
.long  C_ERROR  	// 17 
.long  C_MODRM  	// 18 
.long  C_ERROR  	// 19 
.long  C_ERROR  	// 1A 
.long  C_ERROR  	// 1B 
.long  C_ERROR  	// 1C 
.long  C_ERROR  	// 1D 
.long  C_ERROR  	// 1E 
.long  C_ERROR  	// 1F 
.long  C_ERROR  	// 20 
.long  C_ERROR  	// 21 
.long  C_ERROR  	// 22 
.long  C_ERROR  	// 23 
.long  C_ERROR  	// 24 
.long  C_ERROR  	// 25 
.long  C_ERROR  	// 26 
.long  C_ERROR  	// 27 
.long  C_ERROR  	// 28 
.long  C_ERROR  	// 29 
.long  C_ERROR  	// 2A 
.long  C_ERROR  	// 2B 
.long  C_ERROR  	// 2C 
.long  C_ERROR  	// 2D 
.long  C_ERROR  	// 2E 
.long  C_ERROR  	// 2F 
.long  C_ERROR  	// 30 
.long  C_ERROR  	// 31 
.long  C_ERROR  	// 32 
.long  C_ERROR  	// 33 
.long  C_ERROR  	// 34 
.long  C_ERROR  	// 35 
.long  C_ERROR  	// 36 
.long  C_ERROR  	// 37 
.long  C_ERROR  	// 38 
.long  C_ERROR  	// 39 
.long  C_ERROR  	// 3A 
.long  C_ERROR  	// 3B 
.long  C_ERROR  	// 3C 
.long  C_ERROR  	// 3D 
.long  C_ERROR  	// 3E 
.long  C_ERROR  	// 3F 
.long  C_MODRM  	// 40 
.long  C_MODRM  	// 41 
.long  C_MODRM  	// 42 
.long  C_MODRM  	// 43 
.long  C_MODRM  	// 44 
.long  C_MODRM  	// 45 
.long  C_MODRM  	// 46 
.long  C_MODRM  	// 47 
.long  C_MODRM  	// 48 
.long  C_MODRM  	// 49 
.long  C_MODRM  	// 4A 
.long  C_MODRM  	// 4B 
.long  C_MODRM  	// 4C 
.long  C_MODRM  	// 4D 
.long  C_MODRM  	// 4E 
.long  C_MODRM  	// 4F 
.long  C_ERROR  	// 50 
.long  C_ERROR  	// 51 
.long  C_ERROR  	// 52 
.long  C_ERROR  	// 53 
.long  C_ERROR  	// 54 
.long  C_ERROR  	// 55 
.long  C_ERROR  	// 56 
.long  C_ERROR  	// 57 
.long  C_ERROR  	// 58 
.long  C_ERROR  	// 59 
.long  C_ERROR  	// 5A 
.long  C_ERROR  	// 5B 
.long  C_ERROR  	// 5C 
.long  C_ERROR  	// 5D 
.long  C_ERROR  	// 5E 
.long  C_ERROR  	// 5F 
.long  C_ERROR  	// 60 
.long  C_ERROR  	// 61 
.long  C_ERROR  	// 62 
.long  C_ERROR  	// 63 
.long  C_ERROR  	// 64 
.long  C_ERROR  	// 65 
.long  C_ERROR  	// 66 
.long  C_ERROR  	// 67 
.long  C_ERROR  	// 68 
.long  C_ERROR  	// 69 
.long  C_ERROR  	// 6A 
.long  C_ERROR  	// 6B 
.long  C_ERROR  	// 6C 
.long  C_ERROR  	// 6D 
.long  C_ERROR  	// 6E 
.long  C_ERROR  	// 6F 
.long  C_ERROR  	// 70 
.long  C_ERROR  	// 71 
.long  C_ERROR  	// 72 
.long  C_ERROR  	// 73 
.long  C_ERROR  	// 74 
.long  C_ERROR  	// 75 
.long  C_ERROR  	// 76 
.long  C_ERROR  	// 77 
.long  C_ERROR  	// 78 
.long  C_ERROR  	// 79 
.long  C_ERROR  	// 7A 
.long  C_ERROR  	// 7B 
.long  C_ERROR  	// 7C 
.long  C_ERROR  	// 7D 
.long  C_ERROR  	// 7E 
.long  C_ERROR  	// 7F 
.long  C_DATA66+C_REL  	// 80 
.long  C_DATA66+C_REL  	// 81 
.long  C_DATA66+C_REL  	// 82 
.long  C_DATA66+C_REL  	// 83 
.long  C_DATA66+C_REL  	// 84 
.long  C_DATA66+C_REL  	// 85 
.long  C_DATA66+C_REL  	// 86 
.long  C_DATA66+C_REL  	// 87 
.long  C_DATA66+C_REL  	// 88 
.long  C_DATA66+C_REL  	// 89 
.long  C_DATA66+C_REL  	// 8A 
.long  C_DATA66+C_REL  	// 8B 
.long  C_DATA66+C_REL  	// 8C 
.long  C_DATA66+C_REL  	// 8D 
.long  C_DATA66+C_REL  	// 8E 
.long  C_DATA66+C_REL  	// 8F 
.long  C_MODRM  	// 90 
.long  C_MODRM  	// 91 
.long  C_MODRM  	// 92 
.long  C_MODRM  	// 93 
.long  C_MODRM  	// 94 
.long  C_MODRM  	// 95 
.long  C_MODRM  	// 96 
.long  C_MODRM  	// 97 
.long  C_MODRM  	// 98 
.long  C_MODRM  	// 99 
.long  C_MODRM  	// 9A 
.long  C_MODRM  	// 9B 
.long  C_MODRM  	// 9C 
.long  C_MODRM  	// 9D 
.long  C_MODRM  	// 9E 
.long  C_MODRM  	// 9F 
.long  0  	// A0 
.long  0  	// A1 
.long  0  	// A2 
.long  C_MODRM  	// A3 
.long  C_MODRM+C_DATA1  	// A4 
.long  C_MODRM  	// A5 
.long  C_ERROR  	// A6 
.long  C_ERROR  	// A7 
.long  0  	// A8 
.long  0  	// A9 
.long  0  	// AA 
.long  C_MODRM  	// AB 
.long  C_MODRM+C_DATA1  	// AC 
.long  C_MODRM  	// AD 
.long  C_ERROR  	// AE 
.long  C_MODRM  	// AF 
.long  C_MODRM  	// B0 
.long  C_MODRM  	// B1 
.long  C_MODRM  	// B2 
.long  C_MODRM  	// B3 
.long  C_MODRM  	// B4 
.long  C_MODRM  	// B5 
.long  C_MODRM  	// B6 
.long  C_MODRM  	// B7 
.long  C_ERROR  	// B8 
.long  C_ERROR  	// B9 
.long  C_MODRM+C_DATA1  	// BA 
.long  C_MODRM  	// BB 
.long  C_MODRM  	// BC 
.long  C_MODRM  	// BD 
.long  C_MODRM  	// BE 
.long  C_MODRM  	// BF 
.long  C_MODRM  	// C0 
.long  C_MODRM  	// C1 
.long  C_ERROR  	// C2 
.long  C_ERROR  	// C3 
.long  C_ERROR  	// C4 
.long  C_ERROR  	// C5 
.long  C_ERROR  	// C6 
.long  C_ERROR  	// C7 
.long  0  	// C8 
.long  0  	// C9 
.long  0  	// CA 
.long  0  	// CB 
.long  0  	// CC 
.long  C_DATA1  	// CD 
.long  0  	// CE 
.long  0  	// CF 
.long  C_ERROR  	// D0 
.long  C_ERROR  	// D1 
.long  C_ERROR  	// D2 
.long  C_ERROR  	// D3 
.long  C_ERROR  	// D4 
.long  C_ERROR  	// D5 
.long  C_ERROR  	// D6 
.long  C_ERROR  	// D7 
.long  C_ERROR  	// D8 
.long  C_ERROR  	// D9 
.long  C_ERROR  	// DA 
.long  C_ERROR  	// DB 
.long  C_ERROR  	// DC 
.long  C_ERROR  	// DD 
.long  C_ERROR  	// DE 
.long  C_ERROR  	// DF 
.long  C_ERROR  	// E0 
.long  C_ERROR  	// E1 
.long  C_ERROR  	// E2 
.long  C_ERROR  	// E3 
.long  C_ERROR  	// E4 
.long  C_ERROR  	// E5 
.long  C_ERROR  	// E6 
.long  C_ERROR  	// E7 
.long  C_ERROR  	// E8 
.long  C_ERROR  	// E9 
.long  C_ERROR  	// EA 
.long  C_ERROR  	// EB 
.long  C_ERROR  	// EC 
.long  C_ERROR  	// ED 
.long  C_ERROR  	// EE 
.long  C_ERROR  	// EF 
.long  C_ERROR  	// F0 
.long  C_ERROR  	// F1 
.long  C_ERROR  	// F2 
.long  C_ERROR  	// F3 
.long  C_ERROR  	// F4 
.long  C_ERROR  	// F5 
.long  C_ERROR  	// F6 
.long  C_ERROR  	// F7 
.long  C_ERROR  	// F8 
.long  C_ERROR  	// F9 
.long  C_ERROR  	// FA 
.long  C_ERROR  	// FB 
.long  C_ERROR  	// FC 
.long  C_ERROR  	// FD 
.long  C_ERROR  	// FE 
.long  C_ERROR  	// FF 