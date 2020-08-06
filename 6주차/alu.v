`timescale 1ns / 1ps

module alu
(
	input [1:0] mode, opcode,
	input ain, bin,
	output reg result, cout
);

always @(*) begin
	case({mode, opcode})
		4'b0000 : {cout, result} = {1'bx, ain};
		4'b0001 : {cout, result} = {1'bx, ~ain};
		4'b0010 : {cout, result} = {1'bx, ((ain * ~bin) + (~ain * bin))};
		4'b0011 : {cout, result} = {1'bx, ~((ain * ~bin) + (~ain * bin))};
		4'b0100 : {cout, result} = {1'b0, ain};
		4'b0101 : {cout, result} = ~{1'b0, ain};
		4'b0110 : {cout, result} = ain + bin;
		4'b0111 : {cout, result} = {(~ain) * bin, (ain * bin) + (~ain * ~bin)};
		4'b1000 : {cout, result} = ain + 1'b1;
		4'b1001 : {cout, result} = (~{1'b0, ain}) + 2'b1;
		4'b1010 : {cout, result} = ain + bin + 1'b1;
		4'b1011 : {cout, result} = bin + ((~{1'b0, ain}) + 2'b1);
		default : {cout, result} = {1'bx, 1'bx};
	endcase
	
end

endmodule