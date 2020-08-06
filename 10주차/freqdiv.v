`timescale 1ns / 1ps

module freqdiv(
    input rst,
    input clkIN,
    output reg clkOUT
    );
	 
	 reg [31:0] count;
	 
	 always @(posedge clkIN) begin
			if(count == 32'd25000000) begin
				count <= 32'd0;
				clkOUT <= ~clkOUT;
			end
			else begin
				count <= count + 1;
			end
	end
endmodule