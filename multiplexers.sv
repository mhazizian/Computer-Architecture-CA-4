module mux_2_to_1 #(parameter integer WORD_LENGTH) (first, second, sel_first, sel_second, out);
  
	input[WORD_LENGTH - 1:0] first, second;
	input sel_first, sel_second;
	output logic [WORD_LENGTH - 1:0] out;
	
	assign out = sel_first ? first : (sel_second ? second : out); 
	
endmodule



module mux_3_to_1 #(parameter integer WORD_LENGTH) (first, second, third, sel_first, sel_second, sel_third, out);

	input[WORD_LENGTH - 1:0] first, second, third;
	input sel_first, sel_second, sel_third;
	output logic [WORD_LENGTH - 1:0] out;
		
	assign out = sel_first ? first : (sel_second ? second : (sel_third ? third : out)); 
	
endmodule


module mux_5_to_1 #(parameter integer WORD_LENGTH) (first, second, third, fourth, fifth,
	sel_first, sel_second, sel_third, sel_fourth, sel_fifth, out);

	input[WORD_LENGTH - 1:0] first, second, third, fourth, fifth;
	input sel_first, sel_second, sel_third, sel_fourth, sel_fifth;
	output logic [WORD_LENGTH - 1:0] out;
		
	assign out = sel_first ? first : (sel_second ? second : (sel_third ? third : (sel_fourth ? fourth : (sel_fifth ? fifth : out)))); 
	
endmodule