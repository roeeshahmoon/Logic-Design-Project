`resetall
`timescale 1ns/10ps
module pe#(parameter DATA_WIDTH = 32,parameter BUS_WIDTH = 64)(
	up_i, left_i, clk_i, rst_ni,start_bit, down_o, right_o, c_i, res_o, carry_o,start_bit_o,mode_bit,done,counter);
	
	localparam MAX_DIM  = BUS_WIDTH/DATA_WIDTH;
	
	input signed  [DATA_WIDTH-1:0] up_i, left_i;
	input signed  [BUS_WIDTH-1:0] c_i;
	output reg signed [DATA_WIDTH-1:0] down_o=0, right_o = 0;
	input wire clk_i, rst_ni,start_bit,mode_bit;
	output reg start_bit_o=0;
	output reg carry_o;
	output wire signed [BUS_WIDTH -1:0] res_o;
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
			res_temp = 0;
			down_o = 0;
			right_o = 0;
			carry_o = 0;
			counter = 0;
			start_bit_o = 0;
			done = 0;
			A_prev = 0;
            B_prev	= 0;
			A_mul_B = 0;
		end
		else if (start_bit ) begin
			A_prev = left_i;
			B_prev	= up_i;
			res_temp = mode_bit && (counter == zeros) ?  c_i:res_temp ;
			res_prev = res_temp;
			A_mul_B[BUS_WIDTH-1:0] = up_i*left_i;
			res_temp =  res_prev[BUS_WIDTH-1:0]  + A_mul_B[BUS_WIDTH-1:0] ;
			if((res_prev[BUS_WIDTH-1] & A_mul_B[BUS_WIDTH-1] & (!res_temp[BUS_WIDTH-1])) || ((!res_prev[BUS_WIDTH-1]) & (!A_mul_B[BUS_WIDTH-1]) & res_temp[BUS_WIDTH-1])) begin 
				carry_o = 1;
			end
			else  begin 
				carry_o = carry_o ^ 0;
			end
				
			
			right_o = left_i;
			down_o = up_i;
			start_bit_o = start_bit;
			if(counter[$clog2(3*MAX_DIM-2) -1:0] == MAX_DIM[$clog2(3*MAX_DIM-2) -1:0]-1) begin 
				done=1;
				
			end
			else begin 
				done = 0;
				
				
			end
			counter = counter + 1;
				
		end


	end
	assign res_o = res_temp[BUS_WIDTH -1:0];
	
	

	
endmodule
				