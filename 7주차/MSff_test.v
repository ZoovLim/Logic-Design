`timescale 1ns / 1ps

module MSff_test;

	// Inputs
	reg CLK;
	reg R;
	reg S;

	// Outputs
	wire Q;
	wire Q_L;
	wire P;
	wire P_L;

	// Instantiate the Unit Under Test (UUT)
	MSff uut (
		.CLK(CLK), 
		.R(R), 
		.S(S), 
		.Q(Q), 
		.Q_L(Q_L),
		.P(P),
		.P_L(P_L)
	);

	initial begin
		CLK = 0;
		
		R = 0;
		S = 0;
		#50;
		
		R = 0;
		S = 1;
		#200;
        
		R = 0;
		S = 0;
		#100;
		
		R = 1;
		S = 0;
		#100;
		
		R = 0;
		S = 0;
		#50;
		
		R = 0;
		S = 1;
		#30;
		
		R = 0;
		S = 0;       
		
	end
	
	always #100 CLK = ~CLK;
      
endmodule