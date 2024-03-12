



module operand_register_b#(parameter BUS_WIDTH = 16,parameter DATA_WIDTH = 8)(
	clk_i, rst_ni,start_bit, pwdata_i,counter, addr_Mat_i,write_en_Mat_i, pstrb_i, read_data_Mat_o,buff,reload_op,k,m);
		
localparam MAX_DIM  = BUS_WIDTH/DATA_WIDTH;		
localparam NEW_MAX_DIM = 2*MAX_DIM - 1;
localparam NEW_WIDTH = DATA_WIDTH * NEW_MAX_DIM;
		
		
		
input wire clk_i;          
input wire rst_ni;
input wire start_bit; 
input wire reload_op;                   
input wire [BUS_WIDTH-1:0] pwdata_i; // Write data input for Matrix
input wire [$clog2(3*MAX_DIM-2) -1:0] counter; // counter for the buffer
input wire [$clog2(MAX_DIM)-1:0] addr_Mat_i;  // Address input for row i Matrix(sub adressing
input wire [2-1:0] k,m;  // dim for operan B
input wire write_en_Mat_i;              //Enable write
input wire [MAX_DIM-1:0] pstrb_i; //element select
output reg [BUS_WIDTH-1:0] read_data_Mat_o; // Read data output for Matrix
output reg [BUS_WIDTH-1:0] buff; // Read data output for mul operand



wire [DATA_WIDTH-1:0] zeros = 0;
reg [DATA_WIDTH-1:0] matrix_Mat [0:MAX_DIM-1][0:MAX_DIM-1];
reg [DATA_WIDTH-1:0] write_data_Mat [0:MAX_DIM-1];


genvar r;
generate for(r=0;r<MAX_DIM;r=r+1) begin  : generate_buffer_mult
	always @(*) begin 
		if(!rst_ni) begin
			buff[(r+1)*DATA_WIDTH-1:r*DATA_WIDTH] <= zeros;
		end
		else if(start_bit) begin 
			if(counter - r[$clog2(3*MAX_DIM-2) -1:0] < MAX_DIM) begin
				if(counter[1:0] - r[1:0] <= k && r[1:0] <= m) begin 
					buff[(r+1)*DATA_WIDTH-1:r*DATA_WIDTH] <= matrix_Mat[counter-r][r];
				end 
				else begin
					buff[(r+1)*DATA_WIDTH-1:r*DATA_WIDTH] <= zeros;
				end
			end
			else begin 
				buff[(r+1)*DATA_WIDTH-1:r*DATA_WIDTH] <= zeros;
			end
		end
		//else  begin
			//buff[DATA_WIDTH-1:0] <= zeros;
			
		//end
	end
end
endgenerate


genvar c;
generate
    for (c = 0; c < MAX_DIM; c = c + 1) begin: generate_vaild_word
        always @(*) begin
		if(pstrb_i[c]) begin 
				if(c>m) begin 
					write_data_Mat[c] <= 0;
				end
				else begin
					write_data_Mat[c] <= pwdata_i[(c+1)*DATA_WIDTH-1:c*DATA_WIDTH];
				end
			end 
			else begin 
				write_data_Mat[c] <= matrix_Mat[addr_Mat_i][c];
			end
			
        end
    end
endgenerate

  
  // Matrix Write Logic
genvar u;
generate for(u = 0; u < MAX_DIM; u = u + 1) begin: generate_write_mat_row
	genvar j;
	for (j = 0; j < MAX_DIM; j = j + 1) begin: generate_write_mat_col
		always @(negedge clk_i ) begin
			if (!rst_ni) begin
				matrix_Mat[u][j] <= 0;
			end
		 
				
			else if(write_en_Mat_i && u[$clog2(MAX_DIM)-1:0] == addr_Mat_i) begin
					if(u > k) begin 
						matrix_Mat[u][j] <= 0;
					end
					else begin 				
						matrix_Mat[u][j]	<=	write_data_Mat[j];
					end
			
			end
  
		end
	end
	
  end
  endgenerate



	  // Matrix read Logic
genvar w;
generate for(w=0;w<MAX_DIM;w=w+1) begin :generate_read_mat
  always @(*) begin
  	if (!rst_ni) begin
		read_data_Mat_o[(w+1)*DATA_WIDTH - 1:w*DATA_WIDTH] <= 0;
	end 
	else begin			
		read_data_Mat_o[(w+1)*DATA_WIDTH - 1:w*DATA_WIDTH] <= matrix_Mat[addr_Mat_i][w];
  
	end
	
  end
 end
 endgenerate








endmodule