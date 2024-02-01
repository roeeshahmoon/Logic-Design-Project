`resetall
`timescale 1ns/10ps
module PE_UNIT#(parameter DATA_WIDTH = 32)(
	up_i, left_i, clk_i, rst_ni, down_o, right_o, res_o, carry_o);
	
	input [DATA_WIDTH-1:0] up_i, left_i;
	output reg [DATA_WIDTH-1:0] down_o, right_o;
	input wire clk_i, rst_ni;
	output reg carry_o;
	output reg [DATA_WIDTH*2 -1:0] res_o;
	
	always @(posedge clk_i) begin
		if(!rst_ni) begin
			res_o <= 0;
			down_o <= 0;
			right_o <= 0;
			carry_o <= 0;
		end
		else begin
			{carry_o, res_o} <= res_o + up_i*left_i;
			right_o <= left_i;
			down_o <= up_i;
		end
	end
	
	
endmodule

