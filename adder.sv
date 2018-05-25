module adder #(parameter integer WORD_LENGTH) (first, second, out);
	
	input[11:0] first, second;
	output logic [11:0] out;
		
	assign out = second + first;

endmodule

