// 13 bit for TR, 8 bit for IR, 5 bit for DI, 8 bit for acc, 8 bit for ALU_out

module register #(parameter integer WORD_LENGTH) (clk, rst, ld, in, out);

	input clk, rst, ld;
	input[WORD_LENGTH - 1:0] in;
	output logic[WORD_LENGTH - 1:0] out;
 
	always@(posedge clk, posedge rst) 
	begin
		if (ld) out <= in;
		if (rst) out <= 0;
	end
	
endmodule