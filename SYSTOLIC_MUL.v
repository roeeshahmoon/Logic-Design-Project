`include "PE_UNIT.v"
module SYSTOLIC_MUL#(parameter DATA_WIDTH = 32)
			(left_i_0, left_i_4, left_i_8, left_i_12,
		      up_i_0, up_i_1, up_i_2, up_i_3,
		      clk_i, rst_ni, done);
	
	input [DATA_WIDTH-1:0] left_i_0, left_i_4, left_i_8, left_i_12,
		      up_i_0, up_i_1, up_i_2, up_i_3;
	output reg done;
	input clk_i, rst_ni;
	reg [3:0] count;
	
	wire [DATA_WIDTH-1:0] down_o_0, down_o_1, down_o_2, down_o_3, down_o_4, down_o_5, down_o_6, down_o_7, down_o_8, down_o_9, down_o_10, down_o_11, down_o_12, down_o_13, down_o_14, down_o_15;
	wire [DATA_WIDTH-1:0] right_o_0, right_o_1, right_o_2, right_o_3, right_o_4, right_o_5, right_o_6, right_o_7, right_o_8, right_o_9, right_o_10, right_o_11, right_o_12, right_o_13, right_o_14, right_o_15;
	wire [DATA_WIDTH-1:0] res_o_0, res_o_1, res_o_2, res_o_3, res_o_4, res_o_5, res_o_6, res_o_7, res_o_8, res_o_9, res_o_10, res_o_11, res_o_12, res_o_13, res_o_14, res_o_15;
	wire carry_o_0, carry_o_1, carry_o_2, carry_o_3, carry_o_4, carry_o_5, carry_o_6, carry_o_7, carry_o_8, carry_o_9, carry_o_10, carry_o_11, carry_o_12, carry_o_13, carry_o_14, carry_o_15;

	//get input from outside up and left
	PE_UNIT PE0 (up_i_0, left_i_0, clk_i, rst_ni, down_o_0, right_o_0, res_o_0, carry_o_0);
	
	//get input from outside up and last level
	PE_UNIT PE1 (up_i_1, right_o_0, clk_i, rst_ni, down_o_1, right_o_1, res_o_1, carry_o_1);
	PE_UNIT PE2 (up_i_2, right_o_1, clk_i, rst_ni, down_o_2, right_o_2, res_o_2, carry_o_2);
	PE_UNIT PE3 (up_i_3, right_o_2, clk_i, rst_ni, down_o_3, right_o_3, res_o_3, carry_o_3);
	
	//get input from outside left and up level
	PE_UNIT PE4 (down_o_0, left_i_4, clk_i, rst_ni, down_o_4, right_o_4, res_o_4, carry_o_4);
	PE_UNIT PE8 (down_o_4, left_i_8, clk_i, rst_ni, down_o_8, right_o_8, res_o_8, carry_o_8);
	PE_UNIT PE12 (down_o_8, left_i_12, clk_i, rst_ni, down_o_12, right_o_12, res_o_12, carry_o_12);
	
	//get input from last level and up level
	//second row
	PE_UNIT PE5 (down_o_1, right_o_4, clk_i, rst_ni, down_o_5, right_o_5, res_o_5, carry_o_5);
	PE_UNIT PE6 (down_o_2, right_o_5, clk_i, rst_ni, down_o_6, right_o_6, res_o_6, carry_o_6);
	PE_UNIT PE7 (down_o_3, right_o_6, clk_i, rst_ni, down_o_7, right_o_7, res_o_7, carry_o_7);
	//third row
	PE_UNIT PE9 (down_o_5, right_o_8, clk_i, rst_ni, down_o_9, right_o_9, res_o_9, carry_o_9);
	PE_UNIT PE10 (down_o_6, right_o_9, clk_i, rst_ni, down_o_10, right_o_10, res_o_10, carry_o_10);
	PE_UNIT PE11 (down_o_7, right_o_10, clk_i, rst_ni, down_o_11, right_o_11, res_o_11, carry_o_11);
	//fourth row
	PE_UNIT PE13 (down_o_9, right_o_12, clk_i, rst_ni, down_o_13, right_o_13, res_o_13, carry_o_13);
	PE_UNIT PE14 (down_o_10, right_o_13, clk_i, rst_ni, down_o_14, right_o_14, res_o_14, carry_o_14);
	PE_UNIT PE15 (down_o_11, right_o_14, clk_i, rst_ni, down_o_15, right_o_15, res_o_15, carry_o_15);
	
	always @(posedge clk_i) begin
		if(!rst_ni) begin
			done <= 0;
			count <= 0;
		end
		else begin
			if(count == 10) begin
				done <= 1;
				count <= 0;
			end
			else begin
				done <= 0;
				count <= count + 1;
			end
		end	
	end 
	
		      
endmodule
		      
