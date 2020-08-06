`timescale 1ns / 1ps

module JKff_test;

	// Inputs
	reg J;
	reg CLK;
	reg K;

	// Outputs
	wire Q;
	wire Q_L;

	// Instantiate the Unit Under Test (UUT)
	JKff uut (
		.J(J), 
		.CLK(CLK), 
		.K(K), 
		.Q(Q), 
		.Q_L(Q_L)
	);

	initial begin
		CLK = 0;
		
		J = 0;
		K = 0;
		force Q = 0;
		force Q_L = 1;
		#35;
		
		release Q;
		release Q_L;
		#65;
		
		J = 0;
		K = 1;
		#100;
		
		J = 1;
		K = 0;
		#100;
		
		J = 1;
		K = 1;
		#200;
		
		J = 0;
		K = 0;
	end
	
	always #50 CLK = ~CLK;
      
endmodule