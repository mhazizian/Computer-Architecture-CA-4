`include "defines.v"

module PR_1_IF_ID(clk, rst, PC_in, Instruction_in, PC, Instruction)
	input clk, rst;
	input [`INSTRUCTION_LEN - 1:0] Instruction_in;
	input [`ADDRESS_LEN - 1:0] PC_in;

	output logic [`INSTRUCTION_LEN - 1:0] Instruction;
	input [`ADDRESS_LEN - 1:0] PC;

	@always(posedge clk, posedge rst) begin
		if(rst)
			{PC, Instruction} <= 0;
		else begin
			PC <= PC_in;
			Instruction <= Instruction_in;
		end
	end
endmodule // PR_1_IF_ID