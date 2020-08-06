`timescale 1ns / 1ps

module klingon_test;

	// Inputs
	reg [3:0] I;

	// Outputs
	wire [6:0] O;

	// Instantiate the Unit Under Test (UUT)
	klingon uut (
		.I(I), 
		.O(O)
	);

	initial begin
		I = 0;
		#20;
      
		I = 1;
		#20;
		
		I = 2;
		#20;
		
		I = 3;
		#20;
		
		I = 4;
		#20;
		
		I = 5;
		#20;
		
		I = 6;
		#20;
		
		I = 7;
		#20;
		
		I = 8;
		#20;
		
		I = 9;
		#20;
		
		I = 10;
		#20;
		
		I = 11;
		#20;
		
		I = 12;
		#20;
		
		I = 13;
		#20;
		
		I = 14;
		#20;
		
		I = 15;
		#20;
	end
      
endmodule

