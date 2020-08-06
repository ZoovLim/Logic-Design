`timescale 1ns/1ps			

module seq_detector
(
	//Control signals
	input clk,	//Positive edge triggered.
	input areset,	//Reset all in 1

	//Data signals
	input seq,
	output detected
);
	//Declare your variables here.
	parameter [3:0] S0 = 2'b00,
						 S1 = 2'b01,
						 S2 = 2'b10,
						 S3 = 2'b11;
	reg [1:0] state = S0;	
	
	always @(posedge clk)
	begin
		//Write your code here.
		if(areset == 1) state = S0;
		else begin
			case(state)
				S0: begin
					if(seq == 0) state = S1;
					else state = S2;
				end
				S1: begin
					if(seq == 0) state = S1;
					else state = S3;
				end
				S2: begin
					if(seq == 0) state = S1;
					else state = S2;
				end
				S3: begin
					if(seq == 0) state = S1;
					else state = S2;
				end
				default: state = S0;
			endcase	
		end		
	end

	//You may write some wiring code here.
	assign detected = (state == S3 && seq == 0)? 1 : 0;
endmodule