`timescale 1ns / 1ps

module shift_reg_8b(
		input CLRb,
		input [1:0] s,
		input CLK,
		input SDL,
		input SDR,
		input [7:0] D,
		output [7:0] Q
    );
	 
	 reg [7:0] O;
	 
	 always @(posedge CLK or negedge CLRb) begin
		if (!CLRb) begin
			O = 0;
		end
		else begin
			case(s)
				2'b11 : O = D;
				2'b10 : O = {O[6:0], SDL};
				2'b01 : O = {SDR, O[7:1]};
				default : O = O;
			endcase		
		end
	end

	assign Q = O;
endmodule