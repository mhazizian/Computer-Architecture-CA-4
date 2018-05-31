`include "defines.sv"

module data_path(clk, rst);

	input clk, rst;

	logic cout, sel_ALU_src_reg2, sel_ALU_src_const,
	
		sel_PC_src_offset, sel_PC_src_const, sel_PC_src_plus1,
		
		MEM_read, MEM_write, sel_RF_write_src_ALU, 
		
		sel_RF_write_src_MEM, RF_write_en,
		
		sel_RF_read_reg2_src,
		
		C_in, C_out, C_in_alu, sel_Cin_alu,
		
		sel_PC_src_stack, push_stack, 
		
		pop_stack, sel_ALU_src_shift_count,
		
		PR4_RF_write_en, PR1_sel_RF_read_reg2_src,
		
		PR1_push_stack, PR1_pop_stack, PR3_MEM_read, 
		
		PR3_MEM_write, 	PR4_sel_RF_write_src_MEM, 
		
		PR4_sel_RF_write_src_ALU, Z_in_alu;
	
	logic [`INSTRUCTION_LEN - 1 : 0] PR0_instruction,
	
		PR1_instruction, PR2_instruction, PR3_instruction, 
		
		PR4_instruction;
	
	logic [`ADDRESS_LEN - 1 : 0] next_pc, current_pc, 
	
		pc_plus_offset, stack_out, PR0_PC_plus1, PR1_PC_plus1;
			
	logic [`WORD_LEN - 1 : 0] alu_out, alu_in1, alu_in2, 
	
		register_file_out2, data_memory_out,
		
		register_file_write_input, PR4_RF_Wdata, 
		
		PR1_RF_out1, PR1_RF_out2, PR2_RF_out1,
		
		PR2_RF_out2, PR2_alu_out, PR3_alu_out,
		
		PR3_RF_out2, PR3_MEM_out, PR4_MEM_out, 
		
		PR4_alu_out;	
		
	logic [2:0] register_file_reg2_input;
	
	logic [3:0] PR1_ALU_op, PR2_ALU_op;

	// ###############################
	// ########### STAGE 0 ###########
	// ###############################
	
	
	// PC block
	
//	register #(.WORD_LENGTH(12)) PC(.clk(clk), .rst(rst), .ld(1'b1), .in(next_pc), .out(current_pc));
	
	register #(.WORD_LENGTH(12)) PC(.clk(clk), .rst(rst), .ld(1'b1), .in(PR0_PC_plus1), .out(current_pc));
	

	incrementer #(.WORD_LENGTH(12)) PC_inc(
	
		.in(current_pc), .out(PR0_PC_plus1)
		
	);
	
		
	// Instruction memory
	
	
	InstructionMemory IM(rst, current_pc, PR0_instruction);	

	
	// PIPE-LINE REGISTERS

	PR1_IF_ID PR1_IF_ID_unit(.clk(clk), .rst(rst), .PR0_PC_plus1(PR0_PC_plus1),

		.PR0_instruction(PR0_instruction),.PR1_PC_plus1(PR1_PC_plus1), .PR1_instruction(PR1_instruction));


	// ###############################
	// ########### STAGE 1 ###########
	// ###############################

	// Controller
	
	
	Controller CU(	
		.instruction(PR1_instruction[18:13]), .C_out(C_out) , 	
		.Z_out(Z_out), .ALU_op(PR1_ALU_op), 
		.sel_ALU_src_reg2(PR1_sel_ALU_src_reg2), 	
		.sel_ALU_src_const(PR1_sel_ALU_src_const),	
		.sel_PC_src_offset(PR1_sel_PC_src_offset), 	
		.sel_PC_src_const(PR1_sel_PC_src_const), 	
		.sel_PC_src_plus1(PR1_sel_PC_src_plus1), 	
		.sel_PC_src_stack(PR1_sel_PC_src_stack),	
		.MEM_write(PR1_MEM_write), .MEM_read(PR1_MEM_read),	
		.sel_RF_write_src_ALU(PR1_sel_RF_write_src_ALU), 	
		.sel_RF_write_src_MEM(PR1_sel_RF_write_src_MEM),	
		.sel_RF_read_reg2_src(PR1_sel_RF_read_reg2_src), 	
		.RF_write_en(PR1_RF_write_en),	
		.sel_Cin_alu(PR1_sel_Cin_alu),
		.push_stack(PR1_push_stack), .pop_stack(PR1_pop_stack),	
		.sel_ALU_src_shift_count(PR1_sel_ALU_src_shift_count)
	);

	
	// Register file
		
	register_file #(.WORD_LENGTH(8), .ID_LENGTH(3)) RF(	
		.clk(clk), .rst(rst), .write_reg(PR4_instruction[13:11]),
		.write_data(PR4_RF_Wdata),	
		.write_reg_en(PR4_RF_write_en), 	
		.read_reg1(PR1_instruction[10:8]), 	
		.read_reg2(register_file_reg2_input),	
		.read_data1(PR1_RF_out1), .read_data2(PR1_RF_out2)	
	);
	
		
	mux_2_to_1 #(.WORD_LENGTH(3)) MUX_RF_second_src(	
		.first(PR1_instruction[13:11]), .second(PR1_instruction[7:5]), 
		.sel_first(PR1_sel_RF_read_reg2_src), .sel_second(~PR1_sel_RF_read_reg2_src), 
		.out(register_file_reg2_input)
	);
	
	// Stack block
	
	
	Stack stack(.clk(clk), .address(PR1_PC_plus1), .push(PR1_push_stack), .pop(PR1_pop_stack), .stack_out(stack_out));	
	
	
	// PC block


	adder #(.WORD_LENGTH(12)) PC_adder(
		.first(PR1_PC_plus1), .second({4'b0, PR1_instruction[7:0]}), 
		.out(pc_plus_offset) // Handling sign extend 
		
	);


	// PIPE-LINE REGISTERS

	PR2_ID_EX PR2_ID_EX_unit(.clk(clk), .rst(rst), .PR1_instruction(PR1_instruction),
		.PR1_RF_out1(PR1_RF_out1), .PR1_RF_out2(PR1_RF_out2),
		.PR1_ALU_op(PR1_ALU_op), .PR1_sel_ALU_src_reg2(PR1_sel_ALU_src_reg2),
		.PR1_sel_ALU_src_const(PR1_sel_ALU_src_const), .PR1_MEM_write(PR1_MEM_write),
		.PR1_MEM_read(PR1_MEM_read), .PR1_sel_RF_write_src_ALU(PR1_sel_RF_write_src_ALU),
		.PR1_sel_RF_write_src_MEM(PR1_sel_RF_write_src_MEM),
		.PR1_RF_write_en(PR1_RF_write_en), .PR1_sel_Cin_alu(PR1_RF_write_en),
		.PR1_sel_ALU_src_shift_count(PR1_sel_ALU_src_shift_count),

		// Outputs:
		.PR2_instruction(PR2_instruction), .PR2_RF_out1(PR2_RF_out1), .PR2_RF_out2(PR2_RF_out2),
		.PR2_sel_ALU_src_reg2(PR2_sel_ALU_src_reg2), .PR2_sel_ALU_src_const(PR2_sel_ALU_src_const), 
		.PR2_MEM_write(PR2_MEM_write), .PR2_MEM_read(PR2_MEM_read), 
		.PR2_sel_RF_write_src_ALU(PR2_sel_RF_write_src_ALU),
		.PR2_sel_RF_write_src_MEM(PR2_sel_RF_write_src_MEM),
		.PR2_RF_write_en(PR2_RF_write_en), .PR2_sel_Cin_alu(PR2_sel_Cin_alu),
		.PR2_sel_ALU_src_shift_count(PR2_sel_ALU_src_shift_count)
	);

	
	// ###############################
	// ########### STAGE 2 ###########
	// ###############################
	
	
	// ALU block
	
	
	ALU ALU_unit(
		.alu_in1(PR2_RF_out1), .alu_in2(alu_in2), .cin(C_out), 	
		.opcode(PR2_ALU_op), .alu_out(PR2_alu_out), 
		.cout(C_in_alu), .Z(Z_in_alu)
	);
	
	
	mux_3_to_1 #(.WORD_LENGTH(8)) MUX_ALU_src(	
		.first(PR2_RF_out2), .second(PR2_instruction[7:0]), .third({5'b0, PR2_instruction[7:5]}),	
		.sel_first(PR2_sel_ALU_src_reg2), .sel_second(PR2_sel_ALU_src_const), .sel_third(PR2_sel_ALU_src_shift_count), 	
		.out(alu_in2)
	);

	// PIPE-LINE REGISTERS
	
	PR3_EX_MEM(
		.clk(clk), .rst(rst), .PR2_alu_out(PR2_alu_out), 
		.PR2_alu_out(PR2_alu_out), .PR2_instruction(PR2_instruction),
		.PR2_ALU_op(PR2_ALU_op), .PR2_MEM_write(PR2_MEM_write), .PR2_MEM_read(PR2_MEM_read),
		.PR2_sel_RF_write_src_ALU(PR2_sel_RF_write_src_ALU), .PR2_sel_RF_write_src_MEM(PR2_sel_RF_write_src_MEM),
		.PR2_RF_write_en(PR2_RF_write_en), .PR2_sel_Cin_alu(PR2_sel_Cin_alu),
		
		// Output
		.PR3_instruction(PR3_instruction), .PR3_MEM_write(PR3_MEM_write), .PR3_MEM_read(PR3_MEM_read),
		.PR3_sel_RF_write_src_MEM(PR3_sel_RF_write_src_MEM), .PR3_RF_write_en(PR3_RF_write_en),
		.PR3_sel_Cin_alu(PR3_sel_Cin_alu), .PR3_sel_RF_write_src_ALU(PR3_sel_RF_write_src_ALU)
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
		.PR3_RF_Wdata(PR3_RF_Wdata), .PR3_RF_write_en(PR3_RF_write_en),

		// Outputs
		.PR4_MEM_out(PR4_MEM_out), .PR4_alu_out(PR4_alu_out),
		.PR4_sel_RF_write_src_MEM(PR4_sel_RF_write_src_MEM),
		.PR4_sel_RF_write_src_ALU(PR4_sel_RF_write_src_ALU),
		.PR4_RF_Wdata(PR4_RF_Wdata), .PR4_RF_write_en(PR4_RF_write_en)
	);

	// #########################################
	// ########### THERE IS NO STAGE ###########
	// #########################################
		
		
/*		
	///////%%%%%%%%%%%%%%%%%%%///////
	
	mux_4_to_1 #(.WORD_LENGTH(12)) MUX_PC_src(
	
	.first(pc_plus1), .second(instruction[11:0]), .third(pc_plus_offset),
	
	.fourth(stack_out), .sel_first(sel_PC_src_plus1),
	
	.sel_second(sel_PC_src_const), .sel_third(sel_PC_src_offset),
	
	.sel_fourth(sel_PC_src_stack), .out(next_pc)
	
	);

	///////%%%%%%%%%%%%%%%%%%%///////
	*/
	
	
	
	// Flip flops
	
	
	register #(.WORD_LENGTH(1)) C(	
		.clk(clk), .rst(rst),	
		.ld(sel_Cin_alu), .in(C_in_alu), .out(C_out)	
	);
	
	
	register #(.WORD_LENGTH(1)) Z(	
		.clk(clk), .rst(rst), .ld(sel_Cin_alu),	
		.in(Z_in_alu), .out(Z_out)	
	);
	

endmodule
	
	