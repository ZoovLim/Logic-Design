`timescale 1ns / 1ps

module JKff(
    input J,
    input CLK,
    input K,
    output Q,
    output Q_L
    );
	 
	 wire J_tmp, K_tmp;
	 
	 assign #10 J_tmp = CLK & J & ~Q;
	 assign #10 K_tmp = CLK & K & Q;
	 
	 RSLatch rs_0(.R(K_tmp), .S(J_tmp), .Q(Q), .Q_L(Q_L));

endmodule