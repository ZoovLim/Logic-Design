`timescale 1ns/1ps

//Machine code layout

/*
Jump:	00 [offset 6b]
Load:	01 [rt] [rs] [off] -> rt = rs[off]
Loading to any register should update tb_data of TB wiring (Handled by TA).

Store: 	10 [rs] [rd] [off] -> rd[off] = rs

Arith:	11 [op] [rd] [rs]
	11 00 NOP
	11 01 ADD	rd += rs
	11 10 SUB	rd -= rs
	11 11 NOP
*/


module cpu	//Do not change top module name or ports.
(
	input	clk,
	input	areset,

	output	[7:0] imem_addr,	//Request instruction memory
	input	[7:0] imem_data,	//Returns 

	output	[7:0] tb_data		//Testbench wiring.
);

	//Data memory and testbench wiring. you may rename them if you like.
	wire dmem_write;
	wire [7:0] dmem_addr, dmem_write_data, dmem_read_data;
	
	//Data memory module in tb.v.
	memory dmem(	.clk(clk), .areset(areset),
			.write(dmem_write), .addr(dmem_addr),
			.write_data(dmem_write_data), .read_data(dmem_read_data));

	assign tb_data = dmem_read_data;
	//Testbench wiring end.

	//Write your code here.
	reg [7:0] pc_current;
	wire [7:0] pc_next;
	
	wire [5:0] sign_extension_input;
	wire [7:0] sign_extension_output;
	
	wire [1:0] alu_op;
	wire alu_src, jump, reg_dst, mem_to_reg, reg_write;
	
	wire [1:0] reg_write_addr, reg_read_addr1, reg_read_addr2;
	wire [7:0] reg_write_data, reg_read_data1, reg_read_data2;
	
	wire [7:0] alu_input1, alu_input2, alu_output;		
	
	// PC
	always @ (posedge clk or posedge areset) begin
		if(areset == 1) pc_current <= 8'b00000000;
		else pc_current <= pc_next;
	end
	
	assign imem_addr = pc_current;
	
	// Control Logic Unit
	control control_unit(.mode(imem_data[7:6]), .opcode(imem_data[5:4]), .areset(areset), .alu_op(alu_op), .alu_src(alu_src),
											  .jump(jump), .reg_dst(reg_dst), .mem_to_reg(mem_to_reg), .mem_write(dmem_write), .reg_write(reg_write));
	
	// Register File
	assign reg_write_addr = (reg_dst == 0) ? imem_data[5:4] : imem_data[3:2];
	assign reg_read_addr1 = imem_data[3:2];
	assign reg_read_addr2 = (dmem_write == 0)? imem_data[1:0] : imem_data[5:4];
	
	register_file my_rf(.clk(clk), .areset(areset), .reg_write_enable(reg_write),
											.reg_write_addr(reg_write_addr), .reg_write_data(reg_write_data),
											.reg_read_addr1(reg_read_addr1), .reg_read_data1(reg_read_data1),
											.reg_read_addr2(reg_read_addr2), .reg_read_data2(reg_read_data2));
		
	assign dmem_write_data = reg_read_data2;										
	
	// Sign Extension
	assign sign_extension_input = imem_data[5:0];
	
	sign_extension my_sign_extension(.sign_extension_in(sign_extension_input), .jump(jump), .sign_extension_out(sign_extension_output));
	
	// ALU
	assign alu_input1 = reg_read_data1;
	assign alu_input2 = (alu_src == 0)? sign_extension_output : reg_read_data2;
	
	alu my_alu(.op(alu_op), .alu_in1(alu_input1), .alu_in2(alu_input2), .alu_out(alu_output));
	
	assign dmem_addr = alu_output;
	
	// Next PC Input
	assign pc_next = (jump == 0)? (pc_current + 8'b00000001) : (pc_current + sign_extension_output);
	
	// Register Write Data
	assign reg_write_data = (mem_to_reg == 0)? alu_output : dmem_read_data;

endmodule

module register_file
(
	input clk,
	input areset,
	
	input reg_write_enable,
	input [1:0] reg_write_addr,
	input [7:0] reg_write_data,
	
	input [1:0] reg_read_addr1,
	output [7:0] reg_read_data1,
	
	input [1:0] reg_read_addr2,
	output [7:0] reg_read_data2
);

	reg [7:0] r [3:0];
	
	always @ (posedge clk or posedge areset) begin
		if(areset) begin
			r[0] <= 8'b00000000;
			r[1] <= 8'b00000000;
			r[2] <= 8'b00000000;
			r[3] <= 8'b00000000;
		end
		else begin
			if(reg_write_enable) begin
				r[reg_write_addr] <= reg_write_data;
			end
		end
	end
	
	assign reg_read_data1 = r[reg_read_addr1];
	assign reg_read_data2 = r[reg_read_addr2];
	
endmodule

module control
(
	input [1:0] mode,
	input [1:0] opcode,
	input areset,
	
	output reg [1:0] alu_op,
	output reg alu_src, jump, reg_dst, mem_to_reg, mem_write, reg_write
);

	always @ (*) begin
		if(areset == 1) begin
			reg_dst = 0;
			mem_to_reg = 0;
			alu_src = 0;
			alu_op = 2'b00;
			jump = 0;
			mem_write = 0;
			reg_write = 0;
		end
		else begin
			case(mode)
				2'b00: begin	// jump
					reg_dst = 0;
					mem_to_reg = 0;
					alu_src = 0;
					alu_op = 2'b01;
					jump = 1;
					mem_write = 0;
					reg_write = 0;
					end
				2'b01: begin	// load
					reg_dst = 0;
					mem_to_reg = 1;
					alu_src = 0;
					alu_op = 2'b01;
					jump = 0;
					mem_write = 0;
					reg_write = 1;
					end
				2'b10: begin	// store
					reg_dst = 0;
					mem_to_reg = 0;
					alu_src = 0;
					alu_op = 2'b01;
					jump = 0;
					mem_write = 1;
					reg_write = 0;
					end
				2'b11: begin	// arith
					case(opcode)
						2'b00: begin	// nop
							reg_dst = 0;
							mem_to_reg = 0;
							alu_src = 0;
							alu_op = 2'b00;
							jump = 0;
							mem_write = 0;
							reg_write = 0;
							end
						2'b01: begin	// add
							reg_dst = 1;
							mem_to_reg = 0;
							alu_src = 1;
							alu_op = 2'b01;
							jump = 0;
							mem_write = 0;
							reg_write = 1;
							end
						2'b10: begin	// sub
							reg_dst = 1;
							mem_to_reg = 0;
							alu_src = 1;
							alu_op = 2'b10;
							jump = 0;
							mem_write = 0;
							reg_write = 1;
							end
						2'b11: begin	// addi
							reg_dst = 1;
							mem_to_reg = 0;
							alu_src = 0;
							alu_op = 2'b11;
							jump = 0;
							mem_write = 0;
							reg_write = 1;
							end
					endcase
				end			
			endcase
		end
	end

endmodule

module sign_extension
(
	input [5:0] sign_extension_in,
	input jump,
	
	output reg [7:0] sign_extension_out
);

	always @ (sign_extension_in or jump) begin
		if(jump == 1) begin
			sign_extension_out [5:0] <= sign_extension_in;
			sign_extension_out [7:6] <= {2{sign_extension_in[5]}};
		end
		else begin
			sign_extension_out [1:0] <= sign_extension_in [1:0];
			sign_extension_out [7:2] <= {6{sign_extension_in [1]}};
		end
	end

endmodule

module alu
(
	input [1:0] op,
	input [7:0] alu_in1,
	input [7:0] alu_in2,
	
	output reg [7:0] alu_out
);

	always @ (*) begin
		case(op)
			2'b00: alu_out = alu_in1;
			2'b01: alu_out = alu_in1 + alu_in2;
			2'b10: alu_out = alu_in1 - alu_in2;
			2'b11: begin
				if(alu_in2[7] == 0) alu_out = alu_in1 + alu_in2;
				else alu_out = alu_in1 - (~(alu_in2) + 1);
			end
		endcase
	end
	
endmodule