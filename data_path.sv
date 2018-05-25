module data_path(clk, rst);

	input clk, rst;

	logic cout, sel_ALU_src_reg2, sel_ALU_src_const,
	
		sel_PC_src_offset, sel_PC_src_const, sel_PC_src_plus1,
		
		MEM_read, MEM_write, sel_RF_write_src_ALU, 
		
		sel_RF_write_src_MEM, RF_write_en,
		
		sel_RF_read_reg2_src,
		
		C_in, C_out, C_in_alu, sel_Cin_alu,
		
		sel_PC_src_stack, push_stack, 
		
		pop_stack, sel_ALU_src_shift_count;
	
	logic [18:0] instruction;
	
	logic [11:0] next_pc, current_pc, 
	
		pc_plus1, pc_plus_offset, stack_out;
			
	logic [7:0] alu_out, alu_in1, alu_in2, register_file_out2, data_memory_out,
	
		register_file_write_input;	
		
	logic [2:0] register_file_reg2_input;
	
	logic [3:0] ALU_op;
	
	// Controller
	
	Controller CU(
	
	.instruction(instruction[18:13]), .C_out(C_out) , 
	
	.Z_out(Z_out), .ALU_op(ALU_op), 
	
	.sel_ALU_src_reg2(sel_ALU_src_reg2), 
	
	.sel_ALU_src_const(sel_ALU_src_const),
	
	.sel_PC_src_offset(sel_PC_src_offset), 
	
	.sel_PC_src_const(sel_PC_src_const), 
	
	.sel_PC_src_plus1(sel_PC_src_plus1), 
	
	.sel_PC_src_stack(sel_PC_src_stack),
	
	.MEM_write(MEM_write), .MEM_read(MEM_read),
	
	.sel_RF_write_src_ALU(sel_RF_write_src_ALU), 
	
	.sel_RF_write_src_MEM(sel_RF_write_src_MEM),
	
	.sel_RF_read_reg2_src(sel_RF_read_reg2_src), 
	
	.RF_write_en(RF_write_en),
	
	.sel_Cin_alu(sel_Cin_alu),

	.push_stack(push_stack), .pop_stack(pop_stack),
	
	.sel_ALU_src_shift_count(sel_ALU_src_shift_count)
	
	);
	
	
	// Flip flops
	
	register #(.WORD_LENGTH(1)) C(
	
	.clk(clk), .rst(rst),
	
	.ld(sel_Cin_alu), .in(C_in_alu), .out(C_out)
	
	);
	
	register #(.WORD_LENGTH(1)) Z(
	
	.clk(clk), .rst(rst), .ld(sel_Cin_alu),
	
	.in(Z_in_alu), .out(Z_out)
	
	);
	
	// Stack block
	
	Stack stack(clk, pc_plus1, push_stack, pop_stack, stack_out);	
	
	
	
	// PC block
	
	incrementer #(.WORD_LENGTH(12)) inc_pc(
	
	.in(current_pc), .out(pc_plus1)
	
	);
//	incrementer_12 inc_pc(current_pc, pc_plus1);

	add_sub_12 pc_adder(pc_plus1, instruction[7:0], pc_plus_offset);

	
	mux_4_to_1 #(.WORD_LENGTH(12)) mux_pc_source(
	
	.first(pc_plus1), .second(instruction[11:0]), .third(pc_plus_offset),
	
	.fourth(stack_out), .sel_first(sel_PC_src_plus1),
	
	.sel_second(sel_PC_src_const), .sel_third(sel_PC_src_offset),
	
	.sel_fourth(sel_PC_src_stack), .out(next_pc)
	
	);
	
	
	register #(.WORD_LENGTH(12)) pc(.clk(clk), .rst(rst), .ld(1'b1), .in(next_pc), .out(current_pc));	
	
	
	
	// Instruction memory
	
	InstructionMemory im(rst, current_pc, instruction);	
	
	
	// Register file
	
	mux_2_to_1 #(.WORD_LENGTH(3)) mux_rf_second_source(
	
	.first(instruction[13:11]), .second(instruction[7:5]), 
	
	.sel_first(sel_RF_read_reg2_src), .sel_second(~sel_RF_read_reg2_src), 
	
	.out(register_file_reg2_input)
	
	);
	
	
	register_file rf(
	
	.clk(clk), .rst(rst), .write_reg(instruction[13:11]), 
	
	.write_data(register_file_write_input),
	
	.write_reg_en(RF_write_en), 
	
	.read_reg1(instruction[10:8]), 
	
	.read_reg2(register_file_reg2_input),
	
	.read_data1(alu_in1), .read_data2(register_file_out2)
	
	);

	// ALU block
	
	mux_3_to_1 #(.WORD_LENGTH(8)) mux_alu_source(
	
	.first(register_file_out2), .second(instruction[7:0]), .third({5'b0, instruction[7:5]}), 
	
	.sel_first(sel_ALU_src_reg2), .sel_second(sel_ALU_src_const), .sel_third(sel_ALU_src_shift_count), 
	
	.out(alu_in2)
	
	);

	Alu alu(alu_in1, alu_in2, C_out, ALU_op, alu_out, C_in_alu, Z_in_alu);
		
	// Data Memory block
	
	DataMemory data_memory(clk, rst, alu_out, register_file_out2, MEM_read, MEM_write, data_memory_out);

	
	mux_2_to_1 #(.WORD_LENGTH(8)) mux_data_memory(
	
	.first(data_memory_out), .second(alu_out), 
	
	.sel_first(sel_RF_write_src_MEM), 
	
	.sel_second(sel_RF_write_src_ALU),
	
	.out(register_file_write_input)
	
	);	

endmodule
	
	