`timescale 1ns / 1ps

module mux16(
    input [15:0] X,
    input [3:0] C,
    output Y
    );

	 wire [3:0] w;
	 wire outw; 
	 
    mux4 m1(X[3:0], C[1:0], w[0]); 
	 mux4 m2(X[7:4], C[1:0], w[1]);
	 mux4 m3(X[11:8], C[1:0], w[2]);
	 mux4 m4(X[15:12], C[1:0], w[3]);
	 mux4 m5(w, C[3:2], outw);
	 
	 assign Y = outw;
endmodule