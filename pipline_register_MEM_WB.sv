`include "defines.sv"

module PR4_MEM_WB(clk, rst, PR3_MEM_out, PR3_alu_out, PR3_sel_RF_write_src_MEM, PR3_sel_RF_write_src_ALU,
		PR3_RF_write_en,
		//outputs
		PR4_MEM_out, PR4_alu_out, PR4_sel_RF_write_src_MEM, PR4_sel_RF_write_src_ALU, PR4_RF_write_en,
		PR3_RF_out2, PR4_RF_out2,
		PR3_instruction, PR4_instruction
	);

	input clk, rst;
	input PR3_sel_RF_write_src_MEM, PR3_sel_RF_write_src_ALU, PR3_RF_write_en;
	input [`INSTRUCTION_LEN - 1:0] PR3_instruction;
	input [`WORD_LEN - 1:0] PR3_MEM_out, PR3_alu_out, PR3_RF_out2;

	output logic PR4_sel_RF_write_src_MEM, PR4_sel_RF_write_src_ALU, PR4_RF_write_en;

	output logic [`INSTRUCTION_LEN - 1:0] PR4_instruction;
	output logic [`WORD_LEN - 1:0] PR4_MEM_out, PR4_alu_out, PR4_RF_out2;

	always@(posedge clk, posedge rst) begin
		if(rst) begin
			// {
			// 	PR4_MEM_out, PR4_alu_out, PR4_sel_RF_write_src_MEM, PR4_sel_RF_write_src_ALU,
			// 	PR4_RF_write_en, PR4_instruction
			// } <= 0;
		end
		else begin
			PR4_MEM_out <= PR3_MEM_out;
			PR4_alu_out <= PR3_alu_out;
			PR4_sel_RF_write_src_MEM <= PR3_sel_RF_write_src_MEM;
			PR4_sel_RF_write_src_ALU <= PR3_sel_RF_write_src_ALU;
			PR4_RF_write_en <= PR3_RF_write_en;
			PR4_RF_out2 <= PR3_RF_out2;
			PR4_instruction <= PR3_instruction;
		end
	end
endmodule // PR_1_IF_ID