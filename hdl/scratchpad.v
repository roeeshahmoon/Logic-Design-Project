module scratchpad#(parameter BUS_WIDTH = 16,parameter DATA_WIDTH = 8,parameter SP_NTARGETS = 2) // MaxDim**2
			(clk_i, rst_ni,write_target,ena_write,address_i_for_op_c,sub_address_i,address_i,
			Data_i, Data_o,Mat_o);

	localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH;


	input wire [BUS_WIDTH*MAX_DIM**2-1:0] Data_i;
	input wire [1:0]  write_target;
	input wire [1:0]  address_i;
	input wire [1:0]  address_i_for_op_c;
	input wire [2*$clog2(MAX_DIM)-1:0] sub_address_i;
	input wire clk_i, rst_ni,ena_write;
	output wire [BUS_WIDTH*MAX_DIM**2-1:0] Mat_o;
	output reg[BUS_WIDTH-1:0] Data_o;
	

	reg [BUS_WIDTH - 1:0] scratchpad_reg [SP_NTARGETS-1:0][MAX_DIM**2-1:0];
	integer i;
	wire [BUS_WIDTH-1:0] zeros = 0;
	
	genvar num_mat;
	generate for(num_mat = 0 ; num_mat < SP_NTARGETS ; num_mat = num_mat + 1) begin : write_block
		genvar num_element;
		for(num_element = 0; num_element < MAX_DIM**2 ; num_element = 	num_element + 1) begin : write_element
			always @(posedge clk_i) begin
				if(!rst_ni) begin 
					//for(i=0;i<SP_NTARGETS;i=i+1) begin 
					scratchpad_reg[num_mat][num_element]  <= zeros;
					//end
				end 
				else  if(ena_write && num_mat[1:0] == write_target[1:0]) begin 		 
					scratchpad_reg[num_mat[SP_NTARGETS:0]][num_element]  <= Data_i[(num_element+1)*BUS_WIDTH - 1:num_element*BUS_WIDTH];
				end
			end
		end
		
	end
	endgenerate
		


	always @(*) begin 
		
		Data_o	= scratchpad_reg[address_i][sub_address_i];
	
	end

	
	//assign Mat_o = scratchpad_reg[address_i_for_op_c[$clog2(SP_NTARGETS)-1:0]];  
	genvar j;
	generate for(j=0;j<MAX_DIM**2;j=j+1) begin : read_mat_block
		assign Mat_o[BUS_WIDTH*(j+1)-1:BUS_WIDTH*j] = scratchpad_reg[address_i_for_op_c][j];
	end
	endgenerate
  
  

endmodule


