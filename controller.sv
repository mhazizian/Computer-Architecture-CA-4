`include "defines.sv"

module Controller(

	instruction, C_out , Z_out, ALU_op, sel_ALU_src_reg2, sel_ALU_src_const,
	
	// sel_PC_src_offset, sel_PC_src_const, sel_PC_src_plus1, sel_PC_src_stack,
	
	MEM_write, MEM_read, sel_RF_write_src_ALU, sel_RF_write_src_MEM, 
	
	sel_RF_read_reg2_src, RF_write_en, sel_Cin_alu,

	// push_stack, pop_stack, 

	sel_ALU_src_shift_count
	
	);

	
	input [5:0] instruction;
	
	input C_out, Z_out;
	
	output logic[3:0] ALU_op;
	
	output logic sel_ALU_src_reg2, sel_ALU_src_const,
	
	// sel_PC_src_offset, sel_PC_src_const, sel_PC_src_plus1, sel_PC_src_stack, 

	MEM_write, MEM_read, sel_RF_write_src_ALU,

	sel_RF_write_src_MEM, sel_RF_read_reg2_src, RF_write_en,
	
	sel_Cin_alu, 

	// push_stack, pop_stack, 

	sel_ALU_src_shift_count;
	
	always @(instruction) begin
	
		sel_ALU_src_reg2 = 0; sel_ALU_src_const = 0;		
		// sel_PC_src_const = 0; sel_PC_src_offset = 0;
		// sel_PC_src_plus1 = 0; 
		MEM_write = 0; MEM_read = 0;		
		sel_RF_write_src_ALU = 0; sel_RF_write_src_MEM = 0;
		sel_RF_read_reg2_src = 0; sel_ALU_src_shift_count = 0;
		RF_write_en = 0; sel_Cin_alu = 0; 
		// push_stack = 0; pop_stack = 0; 
		// sel_PC_src_stack = 0;


		case(instruction[5:4])
		
			`REGISTER_TYPE_OPCODE : begin
			
				ALU_op = {1'b0, instruction[3:1]};
				sel_ALU_src_reg2 = 1;
				sel_Cin_alu = 1;				
				// sel_PC_src_plus1 = 1;			
				sel_RF_write_src_ALU = 1;
				RF_write_en = 1;
			end
			
			`IMMEDIATE_TYPE_OPCODE : begin
			
				ALU_op = {1'b0, instruction[3:1]};
				sel_ALU_src_const = 1;
				sel_Cin_alu = 1;
				// sel_PC_src_plus1 = 1;			
				sel_RF_write_src_ALU = 1;
				RF_write_en = 1;			
			end
			
		endcase

		case (instruction[5:3])
		
			`SHIFT_TYPE_OPCODE :  begin
			
				ALU_op = {2'b11, instruction[2:1]};
				sel_ALU_src_shift_count = 1;
				sel_RF_write_src_ALU = 1;
				sel_Cin_alu = 1;
				RF_write_en = 1;			
				// sel_PC_src_plus1 = 1;
			end
			
			`MEMORY_TYPE_OPCODE : begin
			
				ALU_op = `ADD_FN;
				sel_ALU_src_const = 1;		
				// sel_PC_src_plus1 = 1;
				
				case(instruction[2:1])
				
					`STM_FN : begin
						MEM_write = 1;
						sel_RF_read_reg2_src = 1;
					end
					
					`LDM_FN : begin
					MEM_read = 1;
					sel_RF_write_src_MEM = 1;
					RF_write_en = 1;	
					end
					
				endcase
			end
		endcase
			
		// 	`CONDITIONAL_JUMP_TYPE_OPCODE : begin

		// 		sel_PC_src_plus1 = 1;
				
		// 		case (instruction[2:1])
				
		// 			`BZ_FN : if (Z_out) begin
		// 				sel_PC_src_offset = 1;
		// 				sel_PC_src_plus1 = 0;
		// 			end
					
		// 			`BC_FN : if (C_out) begin
		// 				sel_PC_src_offset = 1;
		// 				sel_PC_src_plus1 = 0;
		// 			end
					
		// 			`BNZ_FN : if (~Z_out) begin
		// 				sel_PC_src_offset = 1;
		// 				sel_PC_src_plus1 = 0;
		// 			end
					
		// 			`BNC_FN : if (~C_out) begin
		// 				sel_PC_src_offset = 1;
		// 				sel_PC_src_plus1 = 0;
					
		// 			end
		// 		endcase			
		// 	end
		// endcase
		
		// if (instruction[5:2] ==`NON_CONDITIONAL_JUMP_TYPE_OPCODE) begin
		// 	sel_PC_src_const = 1;
		// 	sel_RF_write_src_ALU = 1;
			
		// 	if (instruction[5:1] == `JSB_OPCODE) 
		// 		// push_stack = 1;
			
		// end

		// if (instruction[5:0] == `OTHER_TYPE_OPCODE) begin
		// 	// pop_stack = 1;
		// 	sel_PC_src_stack = 1;
		
		// end
			
	end

endmodule // Controller