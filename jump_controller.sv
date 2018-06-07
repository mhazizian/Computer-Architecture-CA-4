`include "defines.sv"

module jump_controller (
	opcode, z_out, PR2_jump_en, 

	// Outputs
	push_stack, pop_stack, sel_PC_src_const, sel_PC_src_offset, 
	sel_PC_src_stack, sel_PC_src_plus1, flush_PR1
);

	input [5:0] opcode;
	input z_out, PR2_jump_en;

	output logic 
		push_stack, pop_stack, sel_PC_src_const, sel_PC_src_offset, 
		sel_PC_src_stack, sel_PC_src_plus1, flush_PR1;

	always@(*) begin
		
		{
			push_stack, pop_stack, sel_PC_src_const, 
			sel_PC_src_offset, sel_PC_src_stack, flush_PR1
		} = 0;

		sel_PC_src_plus1 = 1;

		if(opcode[5:3] == `CONDITIONAL_JUMP_TYPE_OPCODE && (~PR2_jump_en))begin
			case (opcode[2:1])			
				`BZ_FN : if (z_out) begin
					sel_PC_src_offset = 1;
					sel_PC_src_plus1 = 0;
					flush_PR1 = 1;
				end
				`BNZ_FN : if (~z_out) begin
					sel_PC_src_offset = 1;
					sel_PC_src_plus1 = 0;
					flush_PR1 = 1;
				end
			endcase
		end

		if (opcode[5:2] ==`NON_CONDITIONAL_JUMP_TYPE_OPCODE && (~PR2_jump_en)) begin
			flush_PR1 = 1;
			sel_PC_src_const = 1;
			sel_PC_src_plus1 = 0;

			if (opcode[5:1] == `JSB_OPCODE) 
				push_stack = 1;
		end

		if (opcode[5:0] == `OTHER_TYPE_OPCODE && (~PR2_jump_en)) begin
			pop_stack = 1;
			sel_PC_src_stack = 1;
			flush_PR1 = 1;
			sel_PC_src_plus1 = 0;
		end
	end

endmodule
