module APB#(parameter DATA_WIDTH = 32,  
		   parameter BUS_WIDTH = 16, 
		   parameter SP_NTARGETS = 2, 
		   parameter ADDR_WIDTH = 16,
		   parameter MAX_DIM = BUS_WIDTH/DATA_WIDTH)
		   (clk_i, rst_ni, psel_i,penable_i,transfer_i,pready_i,  //check nesscery
		   pwrite_i,pstrb_i,pwdata_i,paddr_i,
		   pready_o,pslverr_o,prdata_o,busy_o, 
		   pslverr_i, data_RF_i, data_RF_o);
		   
	//inputs & outputs from master
	input wire clk_i, rst_ni;
	input wire psel_i; //APB select
	input wire penable_i; //APB enable
	input wire pwrite_i;	//APB write enable
	input wire transfer_i;  // check if must
	
	input wire [MAX_DIM-1:0] pstrb_i; //APB write strobe (’byte’ select)
	input wire [BUS_WIDTH-1:0] pwdata_i; //APB write data
	input wire [ADDR_WIDTH-1:0] paddr_i; //APB address
	
	
	output reg  pready_o;  //APB slave ready
	output reg pslverr_o; //APB slave error
	output reg [BUS_WIDTH-1:0] prdata_o; //APB read data
	output reg busy_o;  //busy can't be writen for design 
	
	// inputs & outputs from MatmulCalc
	input wire pslverr_i ; //input from RF adress isn't ok
	input wire [BUS_WIDTH-1:0] data_RF_i; //data from RF
	output reg [BUS_WIDTH-1:0] data_RF_o; //data to RF
	//output reg [BUS_WIDTH-1:0] addr_RF_o; //addr to RF
	input wire pready_i;  // check if must
		   
    reg[1:0] curr_state;
    reg [BUS_WIDTH-1:0] data_valid;

	parameter idle = 2'b00;
	parameter setup = 2'b01;
	parameter access = 2'b10;
					   
				   
	always @(posedge clk_i)
    begin
      if(!rst_ni)
        begin
			curr_state <= idle;        
			prdata_o <= 0;
			pready_o <=0;
			pslverr_o <= 0;
			busy_o <= 0;
			data_RF_o <= 0;
			//addr_RF_o <= 0;
		  
        end
      else
        begin
			case (curr_state)
			idle: begin 
				prdata_o <= 0;
				pready_o <= 0;
				data_valid <= 0;
				
			if (psel_i && !penable_i)
					curr_state <= setup;       
		    end
			setup: begin
			if (psel_i && penable_i)	
					curr_state <= setup; 
			end
			
			access: begin
				if (pwrite_i) begin //write logic
					if (pstrb_i[0])
						data_valid[7:0] <= pwdata_i[7:0];
						
					if (pstrb_i[1])
						data_valid[15:8] <= pwdata_i[15:8];
						
					if (pstrb_i[2])
						data_valid[23:16] <= pwdata_i[23:16];
						
					if (pstrb_i[3])
						data_valid[31:24] <= pwdata_i[31:24];
						
			    data_RF_o  <= data_valid;
			    data_RF_o <= paddr_i;
			    pslverr_o <= pslverr_i;
				end	
				
				else begin //read logic 
				prdata_o <= data_RF_i;
				pslverr_o <= pslverr_i;
				pready_o <= pready_i; 
				end
				if (pready_i) // next state if pready_i == 1 go to setup else wait in access 
					curr_state <= setup; 
				else
					curr_state <= access; 
			end
			
			default: begin
				curr_state <= idle;
			end
			
			endcase
		end
	end

endmodule