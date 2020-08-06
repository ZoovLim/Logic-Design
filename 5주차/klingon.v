`timescale 1ns / 1ps

module klingon(
    input [3:0] I,
    output reg [6:0] O
    );

always @(*) begin
	case(I)
		4'd0: O = 7'b1111110;
		4'd1: O = 7'b1000000;
		4'd2: O = 7'b1000001;
		4'd3: O = 7'b1001001;
		4'd4: O = 7'b0100011;
		4'd5: O = 7'b0011101;
		4'd6: O = 7'b0100101;
		4'd7: O = 7'b0010011;
		4'd8: O = 7'b0110110;
		4'd9: O = 7'b0110111;
		default: O = 7'b0000000;
	endcase
end
	
endmodule