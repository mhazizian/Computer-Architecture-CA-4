`include "defines.sv"

module Controller(
	instruction, ALU_op, sel_ALU_src_reg2, sel_ALU_src_const,
	MEM_write, MEM_read, sel_RF_write_src_ALU, sel_RF_write_src_MEM, 
	sel_RF_read_reg2_src, RF_write_en, sel_Cin_alu,
	sel_ALU_src_shift_count
	);
	
	input [5:0] instruction;
	
	output logic[3:0] ALU_op;
	output logic sel_ALU_src_reg2, sel_ALU_src_const,
	MEM_write, MEM_read, sel_RF_write_src_ALU,
	sel_RF_write_src_MEM, sel_RF_read_reg2_src, RF_write_en,
	sel_Cin_alu, sel_ALU_src_shift_count;
	
	always @(instruction) begin
	
		sel_ALU_src_reg2 = 0; sel_ALU_src_const = 0;		
		MEM_write = 0; MEM_read = 0;		
		sel_RF_write_src_ALU = 0; sel_RF_write_src_MEM = 0;
		sel_RF_read_reg2_src = 0; sel_ALU_src_shift_count = 0;
		RF_write_en = 0; sel_Cin_alu = 0; 

		case(instruction[5:4])
		
			`REGISTER_TYPE_OPCODE : begin
			
				ALU_op = {1'b0, instruction[3:1]};
				sel_ALU_src_reg2 = 1;
				sel_Cin_alu = 1;					
				sel_RF_write_src_ALU = 1;
				RF_write_en = 1;
			end
			
			`IMMEDIATE_TYPE_OPCODE : begin
			
				ALU_op = {1'b0, instruction[3:1]};
				sel_ALU_src_const = 1;
				sel_Cin_alu = 1;	
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
			end
			
			`MEMORY_TYPE_OPCODE : begin
			
				ALU_op = `ADD_FN;
				sel_ALU_src_const = 1;		
				
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
	end

endmodule // Controller