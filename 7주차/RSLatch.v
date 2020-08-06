`timescale 1ns / 1ps

module RSLatch(
    input R,
    input S,
    output Q,
    output Q_L
    );
	 
	 assign #10 Q = ~(Q_L | R);
	 assign #10 Q_L = ~(Q | S);

endmodule