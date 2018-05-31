`include "defines.sv"

module PR3_EX_MEM(

	clk, rst, PR2_alu_out, PR2_alu_out,
	PR3_MEM_write, PR3_MEM_read,
	PR2_instruction, PR3_instruction,

	PR2_ALU_op, PR2_MEM_write, PR2_MEM_read, PR2_sel_RF_write_src_ALU, PR2_sel_RF_write_src_MEM,
	PR2_RF_write_en, PR2_sel_Cin_alu,
	PR3_sel_RF_write_src_MEM,  PR3_RF_write_en, PR3_sel_Cin_alu, PR3_sel_RF_write_src_ALU,
	PR2_RF_out2, PR3_RF_out2, PR3_ALU_op
	);


	input clk, rst;
	input   PR2_MEM_write, PR2_MEM_read, PR2_sel_RF_write_src_ALU, 
		PR2_sel_RF_write_src_MEM,  PR2_RF_write_en, PR2_sel_Cin_alu;

	input [3:0] PR2_ALU_op;

	input [`WORD_LEN - 1:0] PR2_alu_out, PR2_RF_out2;
	input [`INSTRUCTION_LEN - 1:0] PR2_instruction;

	output logic [`WORD_LEN - 1:0] PR3_alu_out, PR3_RF_out2;
	output logic [`INSTRUCTION_LEN - 1:0] PR3_instruction;

	output logic [3:0] PR3_ALU_op;

	output logic   PR3_MEM_write, PR3_MEM_read, PR3_sel_RF_write_src_ALU, 
		PR3_sel_RF_write_src_MEM,  PR3_RF_write_en, PR3_sel_Cin_alu;


	always@(posedge clk, posedge rst) begin
		if(rst) begin
			{
				PR3_instruction, PR3_RF_out, PR3_RF_out,  PR3_MEM_write, PR3_MEM_read, PR3_sel_RF_write_src_ALU, 
				PR3_sel_RF_write_src_MEM,  PR3_RF_write_en, PR3_sel_Cin_alu, PR3_ALU_op
			} <= 0;
		end
		else begin
			PR3_instruction <= PR2_instruction;
			PR3_RF_out2 <= PR2_RF_out2;
			PR3_MEM_write <= PR2_MEM_write;
			PR3_MEM_read <= PR2_MEM_read;
			PR3_sel_RF_write_src_ALU <= PR2_sel_RF_write_src_ALU;
			PR3_sel_RF_write_src_MEM <= PR2_sel_RF_write_src_MEM;
			PR3_RF_write_en <= PR2_RF_write_en;
			PR3_sel_Cin_alu <= PR2_sel_Cin_alu;
			PR3_ALU_op <= PR2_ALU_op;
		end
	end
endmodule // PR3_EX_MEM