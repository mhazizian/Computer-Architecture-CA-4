`include "defines.sv"

module branch_prediction(
	opcode, C_in, sel_PC_src_offset, flush_PR1,
	flush_PR2
	);

	input [4:0] opcode;

	input C_in;

	output logic flush_PR1, flush_PR2, sel_PC_src_offset;

	always@(*) begin

		{flush_PR2, flush_PR1, sel_PC_src_offset} = 0;

		if(opcode[4:2] == `CONDITIONAL_JUMP_TYPE_OPCODE)begin
			case (opcode[1:0])			
				`BC_FN : if (C_in) begin
					sel_PC_src_offset = 1;
					flush_PR1 = 1;
					flush_PR2 = 1;
				end
				
				`BNC_FN : if (~C_in) begin
					sel_PC_src_offset = 1;
					flush_PR1 = 1;
					flush_PR2 = 1;
				end
			endcase			
		end
	end

endmodule