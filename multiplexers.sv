// 13 bit for mem_ins_src , 8 bit for ALU_sec_src, 2 bit for rf_dest_reg_src

module mux_2_to_1 #(parameter integer WORD_LENGTH) (first, second, sel_first, sel_second, out);
  
	input[WORD_LENGTH - 1:0] first, second;
	input sel_first, sel_second;
	output logic [WORD_LENGTH - 1:0] out;
	
	assign out = sel_first ? first : (sel_second ? second : out); 
	
endmodule

// 8 bit for rf_write_src

module mux_3_to_1 #(parameter integer WORD_LENGTH) (first, second, third, sel_first, sel_second, sel_third, out);

	input[WORD_LENGTH - 1:0] first, second, third;
	input sel_first, sel_second, sel_third;
	output logic [WORD_LENGTH - 1:0] out;
		
	assign out = sel_first ? first : (sel_second ? second : (sel_third ? third : out)); 
	
endmodule

module mux_4_to_1 #(parameter integer WORD_LENGTH) (first, second, third, fourth, sel_first, sel_second, sel_third, sel_fourth, out);

	input[WORD_LENGTH - 1:0] first, second, third, fourth;
	input sel_first, sel_second, sel_third, sel_fourth;
	output logic [WORD_LENGTH - 1:0] out;
		
	assign out = sel_first ? first : (sel_second ? second : (sel_third ? third : (sel_fourth ? fourth : out))); 
	
endmodule