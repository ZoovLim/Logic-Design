`timescale 1ns / 1ps

module mux4(
    input [3:0] X,
    input [1:0] C,
    output reg Y
    );

	 always @(X or C)
		case(C)
			2'b00: Y = X[0];
			2'b01: Y = X[1];
			2'b10: Y = X[2];
			2'b11: Y = X[3];
		endcase
	 
endmodule