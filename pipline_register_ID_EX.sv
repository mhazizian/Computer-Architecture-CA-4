`include "defines.sv"

module PR2_ID_EX(clk, rst, flush, PR1_instruction, PR1_RF_out1, PR1_RF_out2, PR1_ALU_op, PR1_sel_ALU_src_reg2, 
		PR1_sel_ALU_src_const, PR1_MEM_write, PR1_MEM_read, PR1_sel_RF_write_src_ALU, PR1_sel_RF_write_src_MEM,
		PR1_RF_write_en, PR1_sel_Cin_alu,
		PR1_sel_ALU_src_shift_count,
		PR1_RF_r2,

		// outputs:
		PR2_instruction, PR2_RF_out1, PR2_RF_out2,
		PR2_sel_ALU_src_reg2, PR2_sel_ALU_src_const, PR2_MEM_write, PR2_MEM_read, PR2_sel_RF_write_src_ALU, 
		PR2_sel_RF_write_src_MEM,  PR2_RF_write_en, PR2_sel_Cin_alu,
		PR2_sel_ALU_src_shift_count, PR2_ALU_op,
		PR2_RF_r2
	);


	input clk, rst, flush;
	input PR1_sel_ALU_src_reg2, PR1_sel_ALU_src_const, PR1_MEM_write, PR1_MEM_read, PR1_sel_RF_write_src_ALU, 
		PR1_sel_RF_write_src_MEM,  PR1_RF_write_en, PR1_sel_Cin_alu,
		PR1_sel_ALU_src_shift_count;



	input [`INSTRUCTION_LEN - 1:0] PR1_instruction;
	input [`WORD_LEN - 1:0] PR1_RF_out1, PR1_RF_out2;

	input [3 : 0] PR1_ALU_op;
	input [2:0] PR1_RF_r2;

	output logic [`INSTRUCTION_LEN - 1:0] PR2_instruction;
	output logic [`WORD_LEN - 1:0] PR2_RF_out1, PR2_RF_out2;
	output logic PR2_sel_ALU_src_reg2, PR2_sel_ALU_src_const, PR2_MEM_write, PR2_MEM_read, PR2_sel_RF_write_src_ALU, 
		PR2_sel_RF_write_src_MEM,  PR2_RF_write_en, PR2_sel_Cin_alu,
		PR2_sel_ALU_src_shift_count;

	output logic [3 : 0] PR2_ALU_op;
	output logic [2:0] PR2_RF_r2;


	always@(posedge clk, posedge rst) begin
		if(rst, flush) begin
			{
				PR2_instruction, PR2_RF_out1, PR2_RF_out2, PR2_sel_ALU_src_reg2,
				PR2_sel_ALU_src_const, PR2_MEM_write, PR2_MEM_read, PR2_sel_RF_write_src_ALU, 
				PR2_sel_RF_write_src_MEM,  PR2_RF_write_en, PR2_sel_Cin_alu,
				PR2_sel_ALU_src_shift_count, PR2_ALU_op, PR2_RF_r2
			} <= 0;
		end
		else begin
			PR2_instruction <= PR1_instruction ;
			PR2_RF_out1 <= PR1_RF_out1;
			PR2_RF_out2 <= PR1_RF_out2;
			PR2_sel_ALU_src_reg2 <= PR1_sel_ALU_src_reg2;
			PR2_sel_ALU_src_const <= PR1_sel_ALU_src_const;
			PR2_MEM_write <= PR1_MEM_write;
			PR2_MEM_read <= PR1_MEM_read;
			PR2_sel_RF_write_src_ALU <= PR1_sel_RF_write_src_ALU;
			PR2_sel_RF_write_src_MEM <= PR1_sel_RF_write_src_MEM;
			PR2_RF_write_en <= PR1_RF_write_en;
			PR2_sel_Cin_alu <= PR1_sel_Cin_alu;
			PR2_sel_ALU_src_shift_count <= PR1_sel_ALU_src_shift_count;
			PR2_ALU_op <= PR1_ALU_op;
			PR2_RF_r2 <= PR1_RF_r2;
		end
	end
endmodule // PR_1_IF_ID