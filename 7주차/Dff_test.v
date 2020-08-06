`timescale 1ns / 1ps

module Dff_test;

	// Inputs
	reg CLK;
	reg D;

	// Outputs
	wire Q;
	wire Q_L;

	// Instantiate the Unit Under Test (UUT)
	Dff uut (
		.CLK(CLK), 
		.D(D), 
		.Q(Q), 
		.Q_L(Q_L)
	);

	initial begin
		CLK = 0;
		D = 0;
		#50;
      
		D = 1;
		#200;
		
		D = 0;
		#300;
      
		D = 1;
		#200;
		
		D = 0;
	end
     
	always #100 CLK = ~CLK;
endmodule