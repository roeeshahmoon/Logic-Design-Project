`resetall
`timescale 1ns/10ps
/*
	Author: Roee Shahmoon, ID: 206564759
	Author: Noam Klainer, ID: 316015411
	
	These module is procecor unit model.
*/
module pe#(parameter DATA_WIDTH = 32,parameter BUS_WIDTH = 64)(
	up_i, left_i, clk_i, rst_ni,start_bit, down_o, right_o, c_i, res_o, overflow_o,start_bit_o,mode_bit,done,counter);
	
	localparam MAX_DIM  = BUS_WIDTH/DATA_WIDTH;
	
	input signed  [DATA_WIDTH-1:0] up_i, left_i;
	input signed  [BUS_WIDTH-1:0] c_i;
	output reg signed [DATA_WIDTH-1:0] down_o=0, right_o = 0;
	input wire clk_i, rst_ni,start_bit,mode_bit;
	output reg start_bit_o=0;
	output reg overflow_o;
	output reg signed [BUS_WIDTH -1:0] res_o;
	output reg  done;
	output reg   [$clog2(3*MAX_DIM-2) -1:0] counter;
	
	
	
	
	
	
	
	reg   [$clog2(3*MAX_DIM-2) -1:0] zeros = 0 ;
	reg  signed [BUS_WIDTH-1:0] res_temp=0;
	reg  signed [BUS_WIDTH-1:0] res_prev=0;
	reg signed [BUS_WIDTH-1:0] A_mul_B =0;
	reg  signed [DATA_WIDTH-1:0] A_prev=0;
	reg  signed [DATA_WIDTH-1:0] B_prev=0;

	always @(posedge clk_i) begin
	if(!rst_ni || !start_bit) begin
		down_o <= 0;
		right_o <= 0;
		overflow_o <= 0;
		start_bit_o <= 0;
		counter <=0;
		done <= 0;
		res_temp <= 0;
		A_prev <= 0;
        B_prev	<= 0;
		A_mul_B <= 0;
	end
	else if (start_bit ) begin
			A_prev <= left_i;
			B_prev	<= up_i;
			if (counter == 0) begin
				res_temp <= mode_bit  ?  c_i + A_mul_B[BUS_WIDTH-1:0]:A_mul_B[BUS_WIDTH-1:0];
			end
			else begin 
				res_temp <=  res_temp[BUS_WIDTH-1:0]  + A_mul_B[BUS_WIDTH-1:0] ;
			end
			res_prev <=  res_temp;
			A_mul_B[BUS_WIDTH-1:0] <= up_i*left_i;
		if((res_prev[BUS_WIDTH-1] & A_mul_B[BUS_WIDTH-1] & (!res_temp[BUS_WIDTH-1])) || ((!res_prev[BUS_WIDTH-1]) & (!A_mul_B[BUS_WIDTH-1]) & res_temp[BUS_WIDTH-1])) begin 
			overflow_o <= 1;
		end
		else  begin 
			overflow_o <= overflow_o ;
		end
			
		
		right_o <= left_i;
		down_o <= up_i;
		start_bit_o <= start_bit;
		if(counter[$clog2(3*MAX_DIM-2) -1:0] == MAX_DIM[$clog2(3*MAX_DIM-2) -1:0]-1) begin 
			done<=1;
			
		end
		else begin 
			done <= 0;
			
			
		end
		counter <= counter + 1;
		res_o <= res_temp[BUS_WIDTH -1:0];
			
	end


	end

	
	

	
endmodule
				