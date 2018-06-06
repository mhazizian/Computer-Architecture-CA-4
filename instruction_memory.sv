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

		ins_memory[7] 	<= {2'b00, 3'b000, 3'b011, 3'b001, 3'b010, 5'b00110}; 		// R3 = R1 + R2
		ins_memory[8] 	<= {2'b01, 3'b000, 3'b011, 3'b011, 8'b00001111}; 			// R3 = R3 + 15
		ins_memory[9] 	<= {2'b00, 3'b000, 3'b111, 3'b001, 3'b011, 5'b00110}; 		// R7 = R1 + R3
		ins_memory[10] 	<= {3'b100, 2'b01, 3'b111, 3'b000, 8'b11101001}; 			// save-memory: R7 to R0(233)
		ins_memory[11] 	<= {3'b100, 2'b01, 3'b011, 3'b000, 8'b11101010}; 			// save-memory: R3 to R0(234)
		ins_memory[12] 	<= {3'b100, 2'b01, 3'b011, 3'b000, 8'b11101011}; 			// save-memory: R3 to R0(235)

		ins_memory[13] 	<= {3'b100, 2'b00, 3'b110, 3'b000, 8'b11101011}; 			// load-memory: R0(235) to R6
		ins_memory[15] 	<= {2'b01, 3'b000, 3'b101, 3'b110, 8'b00001111}; 			// R5 = R6 + 15

		// ins_memory[7] 	<= {2'b00, 3'b000, 3'b011, 3'b001, 3'b010, 5'b00110}; 		// R3 = R1 + R2
		// ins_memory[20] 	<= {3'b100, 2'b00, 3'b111, 3'b000, 8'b01100100}; 			// load-memory: R0(100) to R7
		// ins_memory[30] 	<= {3'b100, 2'b01, 3'b111, 3'b000, 8'b11101001}; 			// save-memory: R3 to R0(233)

		// ins_memory[40] 	<= {2'b01, 3'b000, 3'b001, 3'b001, 8'b00001111}; 			// R1 = R1 + 15

		// ins_memory[50] 	<= {3'b110, 2'b00, 3'b111, 3'b111, 3'b010, 5'b00000};		// R7 = R7 << 2
		// ins_memory[60] 	<= {3'b110, 2'b01, 3'b111, 3'b111, 3'b010, 5'b00000};		// R7 = R7 >> 2
		// ins_memory[70] 	<= {3'b110, 2'b11, 3'b111, 3'b111, 3'b100, 5'b00000};		// R7 = R7 Rotate right 4
	end
	
endmodule