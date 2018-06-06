`include "defines.sv"

module jump_controller (
	opcode, is_equal,

	// Outputs
	push_stack, pop_stack, sel_PC_src_const, sel_PC_src_offset, 
	sel_PC_src_stack, sel_PC_src_plus1, flush_PR1
);

	input [5:0] opcode;
	input is_equal;

	output logic 
		push_stack, pop_stack, sel_PC_src_const, sel_PC_src_offset, 
		sel_PC_src_stack, sel_PC_src_plus1, flush_PR1;

	always@(*) begin
		
		{
			push_stack, pop_stack, sel_PC_src_const, 
			sel_PC_src_offset, sel_PC_src_stack, flush_PR1
		} = 0;

		sel_PC_src_plus1 = 1;

		if(opcode[5:3] == `CONDITIONAL_JUMP_TYPE_OPCODE)begin
			case (opcode[2:1])			
				`BZ_FN : if (is_equal) begin
					sel_PC_src_offset = 1;
					sel_PC_src_plus1 = 0;
					flush_PR1 = 1;
				end
				`BNZ_FN : if (~is_equal) begin
					sel_PC_src_offset = 1;
					sel_PC_src_plus1 = 0;
					flush_PR1 = 1;
				end
			endcase
		end

		if (opcode[5:2] ==`NON_CONDITIONAL_JUMP_TYPE_OPCODE) begin
			flush_PR1 = 1;
			sel_PC_src_const = 1;

			if (opcode[5:1] == `JSB_OPCODE) 
				push_stack = 1;
		end

		if (opcode[5:0] == `OTHER_TYPE_OPCODE) begin
			pop_stack = 1;
			sel_PC_src_stack = 1;
			flush_PR1 = 1;
		end
	end

endmodule
