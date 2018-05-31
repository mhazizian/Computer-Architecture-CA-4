module register #(parameter integer WORD_LENGTH) (clk, rst, ld, in, out);

	input clk, rst, ld;
	input[WORD_LENGTH - 1:0] in;
	output logic[WORD_LENGTH - 1:0] out;
 
	always@(posedge clk, posedge rst) 
	begin
		if (ld) out <= in;
		if (rst) out <= 1;
	end
	
endmodule