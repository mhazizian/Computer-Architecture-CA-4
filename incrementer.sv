module incrementer #(parameter integer WORD_LENGTH) (in, out);

	input[WORD_LENGTH - 1:0] in;
	output logic[WORD_LENGTH - 1:0] out;

	assign out = in + 1;	
	
endmodule
