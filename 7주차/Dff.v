`timescale 1ns / 1ps

module Dff(
    input CLK,
    input D,
    output Q,
    output Q_L
    );
	 
	 wire D_L, tmp_0, tmp_1, R, S;
	 
	 RSLatch rs_0(.R(D_L), .S(CLK), .Q(tmp_0), .Q_L(R));
	 RSLatch rs_1(.R((R | CLK)), .S(D), .Q(S), .Q_L(D_L));
	 RSLatch rs_2(.R(R), .S(S), .Q(Q), .Q_L(Q_L));

endmodule