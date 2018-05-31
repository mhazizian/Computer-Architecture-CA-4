// LENGHTs

`define INSTRUCTION_LEN 19
`define ADDRESS_LEN		12
`define WORD_LEN		8

// OPCODEs

`define REGISTER_TYPE_OPCODE 				2'b00
`define IMMEDIATE_TYPE_OPCODE 				2'b01
`define SHIFT_TYPE_OPCODE 					3'b110
`define	MEMORY_TYPE_OPCODE 					3'b100
`define CONDITIONAL_JUMP_TYPE_OPCODE 		3'b101
`define NON_CONDITIONAL_JUMP_TYPE_OPCODE 	4'b1110
`define OTHER_TYPE_OPCODE 					6'b111100

// Non-conditional functions

`define JMP_OPCODE 5'b11100
`define JSB_OPCODE 5'b11101

// Register type functions

`define ADD_FN 		4'b0000
`define ADDC_FN 	4'b0001
`define SUB_FN 		4'b0010
`define SUBC_FN 	4'b0011
`define AND_FN	 	4'b0100
`define OR_FN 		4'b0101
`define XOR_FN 		4'b0110
`define MASK_FN 	4'b0111
`define SHL_FN 		4'b1100
`define SHR_FN 		4'b1101
`define ROL_FN 		4'b1110
`define ROR_FN 		4'b1111

// Memory type functions

`define LDM_FN 2'b00
`define STM_FN 2'b01

// Conditional type functions

`define BZ_FN 	2'b00
`define BNZ_FN 	2'b01
`define BC_FN 	2'b10
`define BNC_FN 	2'b11
