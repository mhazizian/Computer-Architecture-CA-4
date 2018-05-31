`include "defines.sv"

module PR3_EX_MEM(
	clk, rst, PR2_alu_out, PR3_alu_out,
	PR3_MEM_write, PR3_MEM_read,
	PR2_instruction, PR3_instruction
	);

	input clk, rst;

	input [`WORD_LEN - 1:0] PR2_alu_out;
	input [`INSTRUCTION_LEN - 1:0] PR2_instruction;

	output logic [`WORD_LEN - 1:0] PR3_alu_out;
	output logic [`INSTRUCTION_LEN - 1:0] PR3_instruction;

	always@(posedge clk, posedge rst) begin
		if(rst) begin
			//
		end
		else begin
			//
		end
	end
endmodule