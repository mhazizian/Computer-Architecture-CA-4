`include "defines.sv"

module ALU(alu_in1, alu_in2, cin, opcode, alu_out, cout, Z);

	input [7:0] alu_in1, alu_in2, alu_in2;
	input [3:0] opcode;
	input cin;
	output logic [7:0] alu_out;
	output logic Z, cout;
	
	logic [7:0] shift_out;
	
	assign Z = (alu_out == 8'b0 ? 1 : 0);
	
	always @(*) begin
			 
		integer i;
	
		shift_out = alu_in1;
	
		case(opcode)
			`ADD_FN:		{cout, alu_out} = alu_in1 + alu_in2;
			`ADDC_FN:		{cout, alu_out} = alu_in1 + alu_in2 + cin;
			`SUB_FN:		{cout, alu_out} = alu_in1 - alu_in2;
			`SUBC_FN: 		{cout, alu_out} = alu_in1 - alu_in2 - cin;	
			
			`AND_FN:begin
				alu_out	 = 	alu_in1 & alu_in2;
				cout	 = 	1'b0;end
				
			`OR_FN:begin
				alu_out	= 	alu_in1 | alu_in2;
				cout	= 	1'b0;end
				
			`XOR_FN:begin
				alu_out	= 	alu_in1 ^ alu_in2;
				cout	= 	1'b0;end
				
			`MASK_FN:begin
				alu_out	= 	~(alu_in1 & alu_in2);
				cout 	= 	1'b0;end	
				
			`SHL_FN:begin
				for (i = 0; i < alu_in2; i = i + 1) 
				begin	
					cout = shift_out[7];
					shift_out = {shift_out[6:0], 1'b0};
				end
				alu_out = shift_out;
			end
			
			`SHR_FN:begin
				for (i = 0; i < alu_in2; i = i + 1) 
				begin
					cout = shift_out[0];
					shift_out = {1'b0, shift_out[7:1]};
				end
				alu_out = shift_out;
			end
			
			`ROL_FN:begin
				for (i = 0; i < alu_in2; i = i + 1) 
				begin	
					shift_out = {shift_out[6:0], shift_out[7]}; 
				end
				cout = 1'b0;
				alu_out = shift_out;
			end
			
			`ROR_FN:begin
				for (i = 0; i < alu_in2; i = i + 1) 
				begin	
					shift_out = {shift_out[0], shift_out[7:1]}; 
				end
				cout = 1'b0;
				alu_out = shift_out;
			end		
			
		endcase
	
	end
	
endmodule