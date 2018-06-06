`include "defines.sv"

module forwarding_unit (
	PR3_RF_write_en, PR3_MEM_read, PR3_rd,
	PR4_RF_write_en, PR4_rd,
	PR2_rs, PR2_rt,
	forwardA, forwardB
);
	input PR3_RF_write_en, PR4_RF_write_en, PR3_MEM_read;
	input [2:0] PR3_rd, PR4_rd, PR2_rs, PR2_rt;

	output logic [1:0] forwardA, forwardB;

	always@(*) begin
		forwardA = 0;
		forwardB = 0;

		if (PR3_RF_write_en && ~PR3_MEM_read) begin
			if (PR3_rd == PR2_rs && PR3_rd != 3'b000)
				forwardA = 2;
			if (PR3_rd == PR2_rt && PR3_rd != 3'b000)
				forwardB = 2;
		end 
		if (PR4_RF_write_en) begin
			if ((PR4_rd == PR2_rs) && (~PR3_RF_write_en || PR3_rd != PR2_rs) && (PR4_rd != 3'b000))
				forwardA = 1;
			if ((PR4_rd == PR2_rt) && (~PR3_RF_write_en || PR3_rd != PR2_rt) && (PR4_rd != 3'b000))
				forwardB = 1;
		end

	end

endmodule