`include "defines.sv"

module register_file #(parameter integer WORD_LENGTH, ID_LENGTH) (
	clk, rst, write_reg, write_data,
	write_reg_en, read_reg1, read_reg2,
	read_data1, read_data2
	);

	input clk, rst, write_reg_en;
	input [ID_LENGTH - 1:0] read_reg1, read_reg2, write_reg;
	input [WORD_LENGTH - 1:0] write_data;
	output logic [WORD_LENGTH - 1:0] read_data1, read_data2;
	
	reg[WORD_LENGTH - 1:0] acc[0:WORD_LENGTH - 1];	
	logic[WORD_LENGTH - 1:0] ld_reg;	
	int j;
	genvar i;
	
// Generate 4 regsiters

	register_rf #(.WORD_LENGTH(WORD_LENGTH)) register0(.clk(clk), .rst(rst), .ld(ld_reg[0]), .in(0), .out(acc[0]));

	generate for (i = 1; i < WORD_LENGTH; i = i + 1)
		begin
			register_rf #(.WORD_LENGTH(WORD_LENGTH)) registers(.clk(clk), .rst(rst), .ld(ld_reg[i]), .in(write_data), .out(acc[i]));
		end
	endgenerate

// Read registers combinational
	
	assign read_data1 = acc[read_reg1];
	assign read_data2 = acc[read_reg2];

// Write regsiter on negedge of clock
	
	always @(negedge clk, write_reg_en, write_reg) begin
		for ( j = 0; j < WORD_LENGTH; j = j + 1)	ld_reg[j] = 1'b0;
		if (write_reg_en)	ld_reg[write_reg] = 1'b1;
	end
	
// Reset load signals
	
	always@(posedge rst)
	begin
		for ( j = 0; j < WORD_LENGTH; j = j + 1)	ld_reg[j] = 1'b0;
	end
	
endmodule