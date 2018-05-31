`include "defines.sv"

module PR_1_IF_ID(clk, rst, PC_in, Instruction_in, PR1_PC_plus1, PR1_Instruction);
	input clk, rst;
	input [`INSTRUCTION_LEN - 1:0] Instruction_in;
	input [`ADDRESS_LEN - 1:0] PC_in;

	output logic [`INSTRUCTION_LEN - 1:0] PR1_Instruction;
	output logic [`ADDRESS_LEN - 1:0] PR1_PC_plus1;

	always@(posedge clk, posedge rst) begin
		if(rst) begin
			PR1_PC_plus1 <= 0;
			PR1_Instruction <= 0;
		end
		else begin
			PR1_PC_plus1 <= PC_in;
			PR1_Instruction <= Instruction_in;
		end
	end
endmodule // PR_1_IF_ID