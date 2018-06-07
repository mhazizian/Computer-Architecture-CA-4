`include "defines.sv"

module data_path(clk, rst);

	input clk, rst;

	logic PR1_sel_PC_src_offset, PR2_sel_PC_src_offset,
		sel_PC_src_const,
		sel_PC_src_plus1,C_in, C_out,	
		C_in_alu, sel_Cin_alu,	
		sel_PC_src_stack,

		PR4_RF_write_en, PR1_sel_RF_read_reg2_src,	
		PR1_push_stack, PR1_pop_stack, PR3_MEM_read, 	
		PR3_MEM_write, 	PR4_sel_RF_write_src_MEM, 	
		PR4_sel_RF_write_src_ALU, Z_in_alu,

		PR1_sel_ALU_src_reg2, 
		PR1_sel_ALU_src_const, PR1_MEM_write, PR1_MEM_read,
		PR1_sel_RF_write_src_ALU, PR1_sel_RF_write_src_MEM,
		PR1_RF_write_en, PR1_sel_Cin_alu,
		PR1_sel_ALU_src_shift_count,

		PR2_sel_ALU_src_reg2, PR2_sel_ALU_src_const, PR2_MEM_write,
		PR2_MEM_read, PR2_sel_RF_write_src_ALU, 
		PR2_sel_RF_write_src_MEM,  PR2_RF_write_en, PR2_sel_Cin_alu,
		PR2_sel_ALU_src_shift_count, PR3_sel_Cin_alu,
		PR3_sel_RF_write_src_MEM, PR3_sel_RF_write_src_ALU,
		PR3_RF_write_en, 

		PR1_IF_ID_write_en, PC_write_en, control_signals_en,
		MEM_write, RF_write_en, flush_PR1_BP, flush_PR1_JC, flush_PR2;
	
	logic [`INSTRUCTION_LEN - 1 : 0] PR0_instruction,
		PR1_instruction, PR2_instruction, PR3_instruction, 	
		PR4_instruction;
	
	logic [`ADDRESS_LEN - 1 : 0] next_pc, current_pc,
		stack_out, PR0_PC_plus1, PR1_PC_plus1, 
		PR1_PC_plus_offset, PR2_PC_plus_offset;
			
	logic [`WORD_LEN - 1 : 0] alu_in2, 	
		PR4_RF_Wdata, 	
		PR1_RF_out1, PR1_RF_out2, PR2_RF_out1,	
		PR2_RF_out2, PR2_alu_out, PR3_alu_out,	
		PR3_RF_out2, PR3_MEM_out, PR4_MEM_out, 
		PR4_alu_out, PR4_RF_out2, PR2_RF_out2_forward, 
		PR2_alu_in1;	
		
	logic [2:0] PR1_RF_r2,
		PR2_RF_r2;

	logic [1:0] forwardA, forwardB;
	
	logic [3:0] PR1_ALU_op, PR2_ALU_op;

	logic PR1_is_equal;

	// ###############################
	// ########### STAGE 0 ###########
	// ###############################
	
	
	// PC block
	
	register #(.WORD_LENGTH(12)) PC(.clk(clk), .rst(rst), .ld(PC_write_en), .in(next_pc), .out(current_pc));
	
	// register #(.WORD_LENGTH(12)) PC(.clk(clk), .rst(rst), .ld(PC_write_en), .in(PR0_PC_plus1), .out(current_pc));
	
	incrementer #(.WORD_LENGTH(12)) PC_inc(
		.in(current_pc), .out(PR0_PC_plus1)	
	);
	
		
	// Instruction memory
	
	
	InstructionMemory IM(rst, current_pc, PR0_instruction);	

	
	// PIPE-LINE REGISTERS

	PR1_IF_ID PR1_IF_ID_unit(.clk(clk), .rst(rst), .flush(flush_PR1_JC | flush_PR1_BP), .PR0_PC_plus1(PR0_PC_plus1),
		.PR0_instruction(PR0_instruction),.PR1_PC_plus1(PR1_PC_plus1), .PR1_instruction(PR1_instruction),
		.write_en(PR1_IF_ID_write_en)
	);


	// ###############################
	// ########### STAGE 1 ###########
	// ###############################

	// Controller
	
	
	Controller CU(	
		.instruction(PR1_instruction[18:13]),
		.ALU_op(PR1_ALU_op), 
		.sel_ALU_src_reg2(PR1_sel_ALU_src_reg2), 	
		.sel_ALU_src_const(PR1_sel_ALU_src_const),	
		.MEM_write(MEM_write),
		.MEM_read(PR1_MEM_read),	
		.sel_RF_write_src_ALU(PR1_sel_RF_write_src_ALU), 	
		.sel_RF_write_src_MEM(PR1_sel_RF_write_src_MEM),	
		.sel_RF_read_reg2_src(PR1_sel_RF_read_reg2_src), 	
		.RF_write_en(RF_write_en),	
		.sel_Cin_alu(sel_Cin_alu),
		.sel_ALU_src_shift_count(PR1_sel_ALU_src_shift_count)
	);

	
	// Register file
		
	register_file #(.WORD_LENGTH(8), .ID_LENGTH(3)) RF(	
		.clk(clk), .rst(rst), .write_reg(PR4_instruction[13:11]),
		.write_data(PR4_RF_Wdata),	
		.write_reg_en(PR4_RF_write_en), 	
		.read_reg1(PR1_instruction[10:8]), 	
		.read_reg2(PR1_RF_r2),	
		.read_data1(PR1_RF_out1), .read_data2(PR1_RF_out2)	
	);
	
	assign PR1_is_equal = ((PR1_RF_out1 == PR1_RF_out2) ? 1 : 0); 
		
	mux_2_to_1 #(.WORD_LENGTH(3)) MUX_RF_second_src(	
		.first(PR1_instruction[13:11]), .second(PR1_instruction[7:5]), 
		.sel_first(PR1_sel_RF_read_reg2_src), .sel_second(~PR1_sel_RF_read_reg2_src), 
		.out(PR1_RF_r2)
	);
	
	// Stack block
	
	
	Stack stack(.clk(clk), .address(PR1_PC_plus1), .push(PR1_push_stack), .pop(PR1_pop_stack), .stack_out(stack_out));	
	
	// Jump controller

	jump_controller jump_controller(
		.opcode(PR1_instruction[18:13]), .is_equal(PR1_is_equal),
		.push_stack(PR1_push_stack), .pop_stack(PR1_pop_stack), 
		.sel_PC_src_const(sel_PC_src_const), .sel_PC_src_offset(PR1_sel_PC_src_offset),
		.sel_PC_src_stack(sel_PC_src_stack), .sel_PC_src_plus1(sel_PC_src_plus1), .flush_PR1(flush_PR1_JC)
	);

	// PC block


	adder #(.WORD_LENGTH(12)) PC_adder(
		.first(PR1_PC_plus1), 
		.second({PR1_instruction[7], PR1_instruction[7], PR1_instruction[7], PR1_instruction[7], PR1_instruction[7:0]}), 
		.out(PR1_PC_plus_offset)	
	);

	mux_2_to_1 #(.WORD_LENGTH(3)) MUX_hazard_unit(	
		.first({MEM_write, RF_write_en, sel_Cin_alu}), .second(0), 
		.sel_first(control_signals_en), .sel_second(~control_signals_en), 
		.out({PR1_MEM_write, PR1_RF_write_en, PR1_sel_Cin_alu})
	);

	// PIPE-LINE REGISTERS

	PR2_ID_EX PR2_ID_EX_unit(.clk(clk), .rst(rst), .flush(flush_PR2), .PR1_instruction(PR1_instruction),
		.PR1_RF_out1(PR1_RF_out1), .PR1_RF_out2(PR1_RF_out2),
		.PR1_ALU_op(PR1_ALU_op), .PR1_sel_ALU_src_reg2(PR1_sel_ALU_src_reg2),
		.PR1_sel_ALU_src_const(PR1_sel_ALU_src_const), .PR1_MEM_write(PR1_MEM_write),
		.PR1_MEM_read(PR1_MEM_read), .PR1_sel_RF_write_src_ALU(PR1_sel_RF_write_src_ALU),
		.PR1_sel_RF_write_src_MEM(PR1_sel_RF_write_src_MEM),
		.PR1_RF_write_en(PR1_RF_write_en), .PR1_sel_Cin_alu(PR1_sel_Cin_alu),
		.PR1_sel_ALU_src_shift_count(PR1_sel_ALU_src_shift_count),
		.PR1_RF_r2(PR1_RF_r2), .PR1_PC_plus_offset(PR1_PC_plus_offset), 

		// Outputs:
		.PR2_instruction(PR2_instruction), .PR2_RF_out1(PR2_RF_out1), .PR2_RF_out2(PR2_RF_out2),
		.PR2_sel_ALU_src_reg2(PR2_sel_ALU_src_reg2), .PR2_sel_ALU_src_const(PR2_sel_ALU_src_const), 
		.PR2_MEM_write(PR2_MEM_write), .PR2_MEM_read(PR2_MEM_read), 
		.PR2_sel_RF_write_src_ALU(PR2_sel_RF_write_src_ALU),
		.PR2_sel_RF_write_src_MEM(PR2_sel_RF_write_src_MEM),
		.PR2_RF_write_en(PR2_RF_write_en), .PR2_sel_Cin_alu(PR2_sel_Cin_alu),
		.PR2_sel_ALU_src_shift_count(PR2_sel_ALU_src_shift_count), .PR2_ALU_op(PR2_ALU_op), 
		.PR2_RF_r2(PR2_RF_r2), .PR2_PC_plus_offset(PR2_PC_plus_offset)
	);

	
	// ###############################
	// ########### STAGE 2 ###########
	// ###############################
	
	
	// ALU block
	
	
	ALU ALU_unit(
		.alu_in1(PR2_alu_in1), .alu_in2(alu_in2), .cin(C_out), 	
		.opcode(PR2_ALU_op), .alu_out(PR2_alu_out), 
		.cout(C_in_alu), .Z(Z_in_alu)
	);
	
	mux_3_to_1 #(.WORD_LENGTH(8)) MUX_forwardA(	
		.first(PR2_RF_out1), .second(PR4_RF_Wdata), .third(PR3_alu_out),	
		.sel_first(~forwardA[1] & ~forwardA[0]), .sel_second(~forwardA[1] & forwardA[0]), .sel_third(forwardA[1] & ~forwardA[0]), 	
		.out(PR2_alu_in1)
	);

	mux_3_to_1 #(.WORD_LENGTH(8)) MUX_forwardB(	
		.first(PR2_RF_out2), .second(PR4_RF_Wdata), .third(PR3_alu_out),	
		.sel_first(~forwardB[1] & ~forwardB[0]), .sel_second(~forwardB[1] & forwardB[0]), .sel_third(forwardB[1] & ~forwardB[0]), 	
		.out(PR2_RF_out2_forward)
	);

	mux_3_to_1 #(.WORD_LENGTH(8)) MUX_ALU_src(	
		.first(PR2_RF_out2_forward), .second(PR2_instruction[7:0]), .third({5'b0, PR2_instruction[7:5]}),	
		.sel_first(PR2_sel_ALU_src_reg2), .sel_second(PR2_sel_ALU_src_const), .sel_third(PR2_sel_ALU_src_shift_count), 	
		.out(alu_in2)
	);

	branch_prediction branch_prediction(
	.opcode(PR2_instruction[18:14]), .C_in(C_out), 
	.sel_PC_src_offset(PR2_sel_PC_src_offset), .flush_PR1(flush_PR1_BP),
	.flush_PR2(flush_PR2)
	);

	// Flip flops
	
	
	register #(.WORD_LENGTH(1)) C(	
		.clk(clk), .rst(rst),	
		.ld(PR2_sel_Cin_alu), .in(C_in_alu), .out(C_out)	
	);
	
	
	register #(.WORD_LENGTH(1)) Z(	
		.clk(clk), .rst(rst), 
		.ld(PR2_sel_Cin_alu), .in(Z_in_alu), .out(Z_out)	
	);
	

	// PIPE-LINE REGISTERS
	
	PR3_EX_MEM PR3_EX_MEM_unit(
		.clk(clk), .rst(rst), .PR2_alu_out(PR2_alu_out), 
		.PR2_instruction(PR2_instruction), .PR2_MEM_read(PR2_MEM_read),
		.PR2_ALU_op(PR2_ALU_op), .PR2_MEM_write(PR2_MEM_write),
		.PR2_sel_RF_write_src_ALU(PR2_sel_RF_write_src_ALU), .PR2_sel_RF_write_src_MEM(PR2_sel_RF_write_src_MEM),
		.PR2_RF_write_en(PR2_RF_write_en), .PR2_sel_Cin_alu(PR2_sel_Cin_alu),
		
		// Output
		.PR3_instruction(PR3_instruction), .PR3_MEM_write(PR3_MEM_write), .PR3_MEM_read(PR3_MEM_read),
		.PR3_sel_RF_write_src_MEM(PR3_sel_RF_write_src_MEM), .PR3_RF_write_en(PR3_RF_write_en),
		.PR3_sel_Cin_alu(PR3_sel_Cin_alu), .PR3_sel_RF_write_src_ALU(PR3_sel_RF_write_src_ALU),
		.PR2_RF_out2(PR2_RF_out2_forward), .PR3_RF_out2(PR3_RF_out2),
		.PR3_alu_out(PR3_alu_out)

	);

	// ###############################
	// ########### STAGE 3 ###########
	// ###############################
	
	
	// Data Memory block
	
	
	DataMemory data_MEM(.clk(clk), .rst(rst), .Address(PR3_alu_out), 	
		.WriteData(PR3_RF_out2), .MemRead(PR3_MEM_read), 
		.MemWrite(PR3_MEM_write), .ReadData(PR3_MEM_out)
	);	
	
	// ###############################
	// ########### STAGE 4 ###########
	// ###############################
	
	
	// Register file

	
	mux_2_to_1 #(.WORD_LENGTH(8)) MUX_data_MEM(
		.first(PR4_MEM_out), .second(PR4_alu_out), 	
		.sel_first(PR4_sel_RF_write_src_MEM), 	
		.sel_second(PR4_sel_RF_write_src_ALU),	
		.out(PR4_RF_Wdata)	
	);

	PR4_MEM_WB PR4_MEM_WB_unit(
		.clk(clk), .rst(rst), .PR3_MEM_out(PR3_MEM_out), .PR3_alu_out(PR3_alu_out),
		.PR3_sel_RF_write_src_MEM(PR3_sel_RF_write_src_MEM),
		.PR3_sel_RF_write_src_ALU(PR3_sel_RF_write_src_ALU),
		.PR3_RF_write_en(PR3_RF_write_en),
		.PR3_instruction(PR3_instruction),

		// Outputs
		.PR4_MEM_out(PR4_MEM_out), .PR4_alu_out(PR4_alu_out),
		.PR4_sel_RF_write_src_MEM(PR4_sel_RF_write_src_MEM),
		.PR4_sel_RF_write_src_ALU(PR4_sel_RF_write_src_ALU),
		.PR4_RF_write_en(PR4_RF_write_en),
		.PR3_RF_out2(PR3_RF_out2), .PR4_RF_out2(PR4_RF_out2),
		.PR4_instruction(PR4_instruction)
	);

	// #########################################
	// ########### THERE IS NO STAGE ###########
	// #########################################		

	forwarding_unit forwarding_unit(
        .PR3_RF_write_en(PR3_RF_write_en), .PR3_MEM_read(PR3_MEM_read), 
        .PR3_rd(PR3_instruction[13:11]), 
        .PR4_RF_write_en(PR4_RF_write_en),
        .PR4_rd(PR4_instruction[13:11]), .PR2_rs(PR2_instruction[10:8]), .PR2_rt(PR2_RF_r2),

        .forwardA(forwardA), .forwardB(forwardB)
	);

	hazard_unit hazard_unit(
		.PR2_MEM_read(PR2_MEM_read), .PR2_rd(PR2_instruction[13:11]), .PR1_rs(PR1_instruction[10:8]),
		.PR1_rt(PR1_RF_r2), .PR1_opcode(PR1_instruction[18:14]),
		.PR1_IF_ID_write_en(PR1_IF_ID_write_en), .PC_write_en(PC_write_en), 

		.control_signals_en(control_signals_en)
	);

	
	// PC input selector

	mux_5_to_1 #(.WORD_LENGTH(12)) MUX_PC_src(
		.first(PR0_PC_plus1), .second(PR1_instruction[11:0]), .third(PR1_PC_plus_offset),
		.fourth(stack_out), .fifth(PR2_PC_plus_offset),

		// .sel_first(1'b1),
		.sel_first(sel_PC_src_plus1 & ~PR2_sel_PC_src_offset),
		.sel_second(sel_PC_src_const), .sel_third(PR1_sel_PC_src_offset),
		.sel_fourth(sel_PC_src_stack), .sel_fifth(PR2_sel_PC_src_offset),

		.out(next_pc)
	);



endmodule
	
	