`resetall
`timescale 1ns/10ps
module PE_unit#(parameter DATA_WIDTH = 32)(
	up_i, left_i, clk_i, rst_ni, down_o, right_o, res_o, carry_o);
	
	input [DATA_WIDTH-1:0] up_i, left_i;
	output reg [DATA_WIDTH-1:0] down_o, right_o;
	input clk_i, rst_ni;
	output wire carry_o;
	output reg [DATA_WIDTH*2 -1:0] res_o;
	wire [DATA_WIDTH*2 -1:0] Mul_w;

	
	always @(posedge !rst_ni or posedge clk_i) begin
		if(!rst_ni) begin
			res_o <= 0;
			down_o <= 0;
			right_o <= 0;
		end
		else begin
			res_o <= res_o + Mul_w;
			right_o <= left_i;
			down_o <= up_i;
		end
	end
	
	assign Mul_w = up_i*left_i;
	assign carry_o = Mul_w[DATA_WIDTH*2 -1] & res_o[DATA_WIDTH*2 -1];
	
	
endmodule

