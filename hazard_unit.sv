`include "defines.sv"

module hazard_unit(
	PR2_MEM_read, PR2_rd, PR1_rs,
	PR1_rt, PR1_opcode,

	// Outputs
	PR1_IF_ID_write_en, PC_write_en, control_signals_en
);

	input PR2_MEM_read;
	input [2:0] PR2_rd, PR1_rs, PR1_rt;
	input [4:0] PR1_opcode;

	output logic PR1_IF_ID_write_en, PC_write_en, control_signals_en;

	always@(*) 

	begin

		{PR1_IF_ID_write_en, PC_write_en, control_signals_en} = 3'b111;

		if(
			(PR1_opcode[4:3] == `REGISTER_TYPE_OPCODE
				|| PR1_opcode[4:3] == `IMMEDIATE_TYPE_OPCODE
				|| PR1_opcode[4:2] == `SHIFT_TYPE_OPCODE
				|| (PR1_opcode[4:2] == `MEMORY_TYPE_OPCODE && PR1_opcode[1:0] == `STM_FN))
			&& (PR2_MEM_read == 1'b1 && (PR2_rd == PR1_rt || PR2_rd == PR1_rs))
		)
			{PR1_IF_ID_write_en, PC_write_en, control_signals_en} = 0;
		
  	end


endmodule