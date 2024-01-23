module PE_unit(up_i, left_i, clk_i, rst_ni, down_o, right_o, res_o);
	input [31:0] up_i, left_i;
	output reg [31:0] down_o, right_o;
	input clk_i, rst_ni;
	output reg [63:0] res_o;
	wire [63:0] mult_w;
	always @(posedge !rst_ni or posedge clk_i) begin
		if(!rst_ni) begin
			res_o <= 0;
			down_o <= 0;
			right_o <= 0;
		end
		else begin
			res_o <= res_o + mult_w;
			right_o <= left_i;
			down_o <= up_i;
		end
	end
	assign mult_w = up_i*left_i;
endmodule
