`include "defines.sv"

module PR_2_ID_EX(clk, rsts, PR1_instruction, PR1_RF_out1, PR1_RF_out2, PR1_ALU_ops, PR1_sel_ALU_src_reg2s, 
	PR1_sel_ALU_src_consts, PR1_sel_PC_src_offsets, PR1_sel_PC_src_consts, PR1_sel_PC_src_plus1s, 
	PR1_sel_PC_src_stacks, PR1_MEM_writes, PR1_MEM_reads, PR1_sel_RF_write_src_ALUs, PR1_sel_RF_write_src_MEMs,
	PR1_sel_RF_read_reg2_srcs, PR1_RF_write_ens, PR1_sel_Cin_alus, PR1_push_stacks, PR1_pop_stacks,
	PR1_sel_ALU_src_shift_count

	// outputs:
	PR2_instruction, PR2_RF_out1, PR2_RF_out2,
	PR2_sel_ALU_src_reg2s, PR2_sel_ALU_src_consts, PR2_sel_PC_src_offsets, PR2_sel_PC_src_consts, 
	PR2_sel_PC_src_plus1s, PR2_sel_PC_src_stacks, PR2_MEM_writes, PR2_MEM_reads, PR2_sel_RF_write_src_ALUs, 
	PR2_sel_RF_write_src_MEMs, PR2_sel_RF_read_reg2_srcs,  PR2_RF_write_ens, PR2_sel_Cin_alus,
	PR2_push_stacks, PR2_pop_stacks, PR2_sel_ALU_src_shift_count;


	input clk, rst;
	input PR1_sel_ALU_src_reg2s, PR1_sel_ALU_src_consts, PR1_sel_PC_src_offsets, PR1_sel_PC_src_consts, 
		PR1_sel_PC_src_plus1s, PR1_sel_PC_src_stacks, PR1_MEM_writes, PR1_MEM_reads, PR1_sel_RF_write_src_ALUs, 
		PR1_sel_RF_write_src_MEMs, PR1_sel_RF_read_reg2_srcs,  PR1_RF_write_ens, PR1_sel_Cin_alus,
		PR1_push_stacks, PR1_pop_stacks, PR1_sel_ALU_src_shift_count;



	input [`INSTRUCTION_LEN - 1:0] PR1_instruction;
	input [`WORD_LEN - 1:0] PR1_RF_out1, PR1_RF_out2;

	output logic [`INSTRUCTION_LEN - 1:0] PR2_instruction;
	output logic [`WORD_LEN - 1:0] PR2_RF_out1, PR2_RF_out2;
	output logic PR2_sel_ALU_src_reg2s, PR2_sel_ALU_src_consts, PR2_sel_PC_src_offsets, PR2_sel_PC_src_consts, 
		PR2_sel_PC_src_plus1s, PR2_sel_PC_src_stacks, PR2_MEM_writes, PR2_MEM_reads, PR2_sel_RF_write_src_ALUs, 
		PR2_sel_RF_write_src_MEMs, PR2_sel_RF_read_reg2_srcs,  PR2_RF_write_ens, PR2_sel_Cin_alus,
		PR2_push_stacks, PR2_pop_stacks, PR2_sel_ALU_src_shift_count;


	always@(posedge clk, posedge rst) begin
		if(rst) begin
			{
				PR2_instruction, PR2_RF_out1, PR2_RF_out2, PR2_sel_ALU_src_reg2s,
				PR2_sel_ALU_src_consts, PR2_sel_PC_src_offsets, PR2_sel_PC_src_consts, 
				PR2_sel_PC_src_plus1s, PR2_sel_PC_src_stacks, PR2_MEM_writes, PR2_MEM_reads, PR2_sel_RF_write_src_ALUs, 
				PR2_sel_RF_write_src_MEMs, PR2_sel_RF_read_reg2_srcs,  PR2_RF_write_ens, PR2_sel_Cin_alus,
				PR2_push_stacks, PR2_pop_stacks, PR2_sel_ALU_src_shift_count
			} <= 0;
		end
		else begin
			PR2_instruction <= PR1_instruction ;
			PR2_RF_out1 <= PR1_RF_out1;
			PR2_RF_out2 <= PR1_RF_out2;
			PR2_sel_ALU_src_reg2s <= PR1_sel_ALU_src_reg2s;
			PR2_sel_ALU_src_consts <= PR1_sel_ALU_src_consts;
			PR2_sel_PC_src_offsets <= PR1_sel_PC_src_offsets;
			PR2_sel_PC_src_consts <= PR1_sel_PC_src_consts;
			PR2_sel_PC_src_plus1s <= PR1_sel_PC_src_plus1s;
			PR2_sel_PC_src_stacks <= PR1_sel_PC_src_stacks;
			PR2_MEM_writes <= PR1_MEM_writes;
			PR2_MEM_reads <= PR1_MEM_reads;
			PR2_sel_RF_write_src_ALUs <= PR1_sel_RF_write_src_ALUs;
			PR2_sel_RF_write_src_MEMs <= PR1_sel_RF_write_src_MEMs;
			PR2_sel_RF_read_reg2_srcs <= PR1_sel_RF_read_reg2_srcs;
			PR2_RF_write_ens <= PR1_RF_write_ens;
			PR2_sel_Cin_alus <= PR1_sel_Cin_alus;
			PR2_push_stacks <= PR1_push_stacks;
			PR2_pop_stacks <= PR1_pop_stacks;
			PR2_sel_ALU_src_shift_count <= PR1_sel_ALU_src_shift_count;
		end
	end
endmodule // PR_1_IF_ID