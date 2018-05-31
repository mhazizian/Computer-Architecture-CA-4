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

	end
	
endmodule