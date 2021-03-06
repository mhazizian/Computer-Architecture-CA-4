module InstructionMemory(rst, address, instruction);

	input [11:0] address;
	input rst;
	output logic[18:0] instruction;

	reg[18:0] ins_memory[0:4095];

	always @(address) begin
		instruction <= ins_memory[address];
	end
	
	always @(posedge rst) begin
		ins_memory <= '{default:19'b0};

		// ##################################
		// ########### PROGRAM 1 ############
		// ##################################
		
		// ins_memory[2] 	<= {3'b100, 2'b00, 3'b001, 3'b000, 8'b01100100}; 			// load-memory: R0(100) to R1
		// ins_memory[3] 	<= {3'b100, 2'b00, 3'b010, 3'b000, 8'b01100110}; 			// load-memory: R0(102) to R2
		// ins_memory[4] 	<= {2'b00, 3'b000, 3'b011, 3'b001, 3'b010, 5'b00110}; 		// R3 = R1 + R2
		// ins_memory[5] 	<= {3'b100, 2'b01, 3'b011, 3'b000, 8'b01101000}; 			// save-memory: R3 to R0(104)

		// ins_memory[6] 	<= {3'b100, 2'b00, 3'b001, 3'b000, 8'b01100101}; 			// load-memory: R0(101) to R1
		// ins_memory[7] 	<= {3'b100, 2'b00, 3'b010, 3'b000, 8'b01100111}; 			// load-memory: R0(103) to R2
		// ins_memory[8] 	<= {2'b00, 3'b001, 3'b011, 3'b001, 3'b010, 5'b00110}; 		// R3 = R1 + R2 + ci
		// ins_memory[9] 	<= {3'b100, 2'b01, 3'b011, 3'b000, 8'b01101001}; 			// save-memory: R3 to R0(105)


		// ##################################
		// ########### PROGRAM 2 ############
		// ##################################

		ins_memory[1] 	<= {2'b00, 3'b000, 3'b111, 3'b000, 3'b000, 5'b00000}; 		// R7 = R0 + R0
		ins_memory[2] 	<= {2'b00, 3'b000, 3'b001, 3'b000, 3'b000, 5'b00000}; 		// R1 = R0 + R0

		// LOOP 
		ins_memory[3] 	<= {2'b01, 3'b010, 3'b011, 3'b001, 8'b00010100}; 			// R3 = R1 - 20
		ins_memory[4] 	<= {3'b101, 2'b00, 6'b111000, 8'b00000110}; 				// BrachZ is True pc = pc + 1 + 6 (To END)
				
		ins_memory[5] 	<= {3'b100, 2'b00, 3'b010, 3'b001, 8'b01100100}; 			// load-memory: R1(100) to R2
		ins_memory[6] 	<= {2'b00, 3'b010, 3'b011, 3'b111, 3'b010, 5'b10100}; 		// R3 = R7 - R2
		ins_memory[7] 	<= {3'b101, 2'b11, 6'b111000, 8'b00000001}; 				// BrachNC is True pc = pc + 1 + 1 (To L1)
		ins_memory[8] 	<= {2'b00, 3'b000, 3'b111, 3'b010, 3'b000, 5'b00000}; 		// R7 = R2 + R0

		// L1
		ins_memory[9] 	<= {2'b01, 3'b000, 3'b001, 3'b001, 8'b00000001}; 			// R1 = R1 + 1
		ins_memory[10] 	<= {5'b11100, 2'b11, 12'b000000000011}; 					// jump to LOOP

		// END

		// #########################################
		// ########### COSTOM TEST CASE ############
		// #########################################

		// ins_memory[7] 	<= {2'b00, 3'b000, 3'b011, 3'b001, 3'b010, 5'b00110}; 		// R3 = R1 + R2
		// ins_memory[8] 	<= {2'b01, 3'b000, 3'b011, 3'b011, 8'b00001111}; 			// R3 = R3 + 15
		// ins_memory[9] 	<= {2'b00, 3'b000, 3'b111, 3'b001, 3'b011, 5'b00110}; 		// R7 = R1 + R3
		// ins_memory[10] 	<= {3'b100, 2'b01, 3'b111, 3'b000, 8'b11101001}; 			// save-memory: R7 to R0(233)
		// ins_memory[11] 	<= {3'b100, 2'b01, 3'b011, 3'b000, 8'b11101010}; 			// save-memory: R3 to R0(234)
		// ins_memory[12] 	<= {3'b100, 2'b01, 3'b011, 3'b000, 8'b11101011}; 			// save-memory: R3 to R0(235)

		// ins_memory[13] 	<= {3'b100, 2'b00, 3'b110, 3'b000, 8'b11101011}; 			// load-memory: R0(235) to R6

		// ins_memory[14] <= {5'b11101, 2'b11, 12'b000000010100};						// JSB to adr = 20

		// ins_memory[15] 	<= {2'b00, 3'b000, 3'b111, 3'b001, 3'b011, 5'b00110}; 		// R7 = R1 + R3
		// ins_memory[16] 	<= {2'b01, 3'b000, 3'b101, 3'b110, 8'b01111111}; 			// R5 = R6 + 127
		// ins_memory[17] 	<= {3'b100, 2'b01, 3'b111, 3'b000, 8'b11010010}; 			// save-memory: R7 to R0(210)
		// ins_memory[19] 	<= {3'b101, 2'b11, 6'b111000, 8'b00000101}; 				// BrachNC is True pc = pc + 1 + 5 (To L1)

		// ins_memory[20] <= {6'b111100, 13'b0000000100000};							// return

		// ins_memory[25] 	<= {2'b01, 3'b000, 3'b101, 3'b101, 8'b01111111}; 			// R5 = R5 + 127	
		// ins_memory[26] 	<= {3'b110, 2'b00, 3'b101, 3'b101, 3'b010, 5'b00000};		// R5 = R5 << 2

		// ins_memory[27] 	<= {3'b100, 2'b00, 3'b001, 3'b000, 8'b11101011}; 			// load-memory: R0(233) to R1
		// ins_memory[28] 	<= {2'b01, 3'b000, 3'b010, 3'b001, 8'b00000001}; 			// R2 = R1 + 1

		// ins_memory[29] <= {5'b11100, 2'b11, 12'b000000110100};						// JMP to adr = 52

	end
	
endmodule