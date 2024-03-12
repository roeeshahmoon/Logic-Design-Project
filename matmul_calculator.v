`resetall
`timescale 1ns/10ps
`include "pe.v"

module matmul_calculator#(parameter BUS_WIDTH = 16,parameter DATA_WIDTH = 8,parameter ADDR_WIDTH = 16,parameter SP_NTARGETS = 2)(
	 clk_i, rst_ni, A, B, C, M, flags,start_bit,mode_bit,done,counter);//M = A*B
	

	localparam MAX_DIM  = BUS_WIDTH/DATA_WIDTH;// MAX_DIM**2
	

	input wire [BUS_WIDTH-1:0] A, B;
	input wire [BUS_WIDTH*MAX_DIM*MAX_DIM-1:0]  C;
	output wire [BUS_WIDTH*MAX_DIM*MAX_DIM-1:0]  M;
	input wire clk_i, rst_ni,start_bit,mode_bit;
	output wire [MAX_DIM*MAX_DIM-1:0] flags;
	output wire done;
	output wire   [$clog2(3*MAX_DIM-2) -1:0] counter;
	wire [DATA_WIDTH-1:0] A_internal [MAX_DIM*MAX_DIM - 1:0] ;
	wire [DATA_WIDTH-1:0] B_internal [MAX_DIM*MAX_DIM - 1:0] ;
	wire [0:0] done_internal[MAX_DIM*MAX_DIM - 1:0], start_bit_internal[MAX_DIM*MAX_DIM - 1:0] ;
	wire [$clog2(3*MAX_DIM-2) -1:0] counter_i [MAX_DIM*MAX_DIM - 1:0] ;
	
	
	
	
	


	




		
	genvar row;
	generate for(row=0; row<MAX_DIM;row = row + 1) begin: GEN_DIM_X

		genvar col;
		for(col=0; col<MAX_DIM;col = col + 1) begin: GEN_DIM_Y
			

				wire signed [DATA_WIDTH-1:0] A_in	;
				wire signed [DATA_WIDTH-1:0] B_in	;
				wire start_bit_i ;
				


				if (row == 0 && col == 0) begin 
					assign A_in = A[DATA_WIDTH-1:0];
					assign B_in = B[DATA_WIDTH-1:0];
					assign start_bit_i = start_bit;
		
					
				end	
				else if (row == 0) begin 
				
					assign A_in = A_internal[col - 1];
					assign B_in = B[(col + 1 )*DATA_WIDTH-1:( col )*DATA_WIDTH];
					assign start_bit_i = start_bit_internal[col-1];
				
			
				end	
					
				else if (col == 0 ) begin 
					assign A_in = A[(row + 1 )*DATA_WIDTH-1:(row)*DATA_WIDTH];
					assign B_in = B_internal[(row-1)*MAX_DIM];
					assign start_bit_i = start_bit_internal[(row-1)*MAX_DIM];
				

				end	
				else  begin 
				
					assign A_in = A_internal[row*MAX_DIM + col - 1];
				    assign B_in = B_internal[(row-1)*MAX_DIM + col];
					assign start_bit_i = start_bit_internal[(row-1)*MAX_DIM + col];
					

				end	
				
				assign done = done_internal[MAX_DIM**2-1];
				assign counter = counter_i[0];
				
				pe #(.DATA_WIDTH(DATA_WIDTH),.BUS_WIDTH(BUS_WIDTH)) pe_generate_0_j (
						.up_i(B_in),
						.left_i(A_in),
						.c_i(C[(row*MAX_DIM+col+1)*BUS_WIDTH-1:(row*MAX_DIM+col)*BUS_WIDTH]),
						.clk_i(clk_i),
						.rst_ni(rst_ni),
						.down_o(B_internal[row*MAX_DIM + col]),
						.right_o(A_internal[row*MAX_DIM + col]),
						.res_o(M[(row*MAX_DIM + col+1)*BUS_WIDTH-1:(row*MAX_DIM + col)*BUS_WIDTH]),
						.carry_o(flags[(row*MAX_DIM + col + 1 )-1:(row*MAX_DIM + col )]),
						.start_bit(start_bit_i),
						.mode_bit(mode_bit),
						.start_bit_o(start_bit_internal[(row)*MAX_DIM+col]),
						.done(done_internal[row*MAX_DIM + col])	,
						.counter(counter_i[row*MAX_DIM+col])
			    	);
			
		end
		
	end endgenerate

						
	
	
endmodule

