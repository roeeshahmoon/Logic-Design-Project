`include "PE_UNIT.v"
`include "SYSTOLIC_MUL.v"
`include "CONTROL_REG.v"
`include "OPRAND_REG.v"

module MATMUL#(
  parameter DATA_WIDTH = 32, //Bit - Width of single element can be 8/16/32
  parameter BUS_WIDTH = 64, // APB Bus data bit width can be 16/32/64
  parameter ADDR_WIDTH  = 32, //APB address space bit width can be 16/24/32
  parameter SP_NTARGETS = 1, //The number of addressable targets in 
  parameter MAX_DIM = 4,
  parameter MATRIX_SIZE = 16) //MaxDim**2
			(clk_i, rst_ni, psel_i, penable_i,
			pwrite_i, pstrb_i, pwdata_i, paddr_i,
			pready_o, pslverr_o, prdata_o, busy_o,
			write_data_Mat_A, write_data_Mat_B,
			read_data_Mat_A,read_data_Mat_B,
			addr_Mat_A, addr_Mat_B, write_en_Mat_A, write_en_Mat_B);
				
	input clk_i, rst_ni, psel_i, penable_i, pwrite_i;	
	input [MAX_DIM-1:0] pstrb_i;
	input [BUS_WIDTH-1:0] pwdata_i;
	input [ADDR_WIDTH-1:0] paddr_i;
	output pready_o, pslverr_o;
	output [BUS_WIDTH-1:0] prdata_o;
	output busy_o;
	
	input wire [DATA_WIDTH-1:0] write_data_Mat_A;
    input wire [DATA_WIDTH-1:0] write_data_Mat_B;
    input wire [DATA_WIDTH-1:0] read_data_Mat_A;
    input wire [DATA_WIDTH-1:0] read_data_Mat_B;
    input wire [ADDR_WIDTH-1:0] addr_Mat_A;
    input wire [ADDR_WIDTH-1:0] addr_Mat_B;
    input wire write_en_Mat_A;
    input wire write_en_Mat_B;
	
	
	
    // Signals for Systolic_Mul module

  wire [DATA_WIDTH-1:0] left_i_0, left_i_4, left_i_8, left_i_12,
                      up_i_0, up_i_1, up_i_2, up_i_3;
  wire done;
  

  always @(posedge clk_i or !rst_ni) begin
		if(!rst_ni) begin
			count <= 0;
		end else if(count == 0);
		  addr_Mat_A <= 0; 
		  addr_Mat_B <= 0; 

		  left_i_0 <= read_data_Mat_A;
		  up_i_0 <= read_data_Mat_B;
		  
		  left_i_4 <= 0;
		  up_i_1 <= 0;
		  
		  left_i_8 <= 0;
		  up_i_2 <= 0; 

		  left_i_12 <= 0;
		  up_i_3 <= 0;
		  
		end else if(count == 1);
		  addr_Mat_A <= 1; 
		  addr_Mat_B <= 1; 

		  left_i_0 <= 0;
		  up_i_0 <= 0;
		  
		  left_i_4 <= read_data_Mat_A;
		  up_i_1 <= read_data_Mat_B;
		  
		  left_i_8 <= 0;
		  up_i_2 <= 0; 

		  left_i_12 <= 0;
		  up_i_3 <= 0;
	  
		end else if(count == 2);
		  addr_Mat_A <= 0; 
		  addr_Mat_B <= 0; 

		  left_i_0 <= read_data_Mat_A;
		  up_i_0 <= read_data_Mat_B;
		  
		  left_i_4 <= 0;
		  up_i_1 <= 0;
		  
		  left_i_8 <= 0;
		  up_i_2 <= 0; 

		  left_i_12 <= 0;
		  up_i_3 <= 0;
		  
		end else if(count == 3);
		  addr_Mat_A <= 0; 
		  addr_Mat_B <= 0; 

		  left_i_0 <= read_data_Mat_A;
		  up_i_0 <= read_data_Mat_B;
		  
		  left_i_4 <= 0;
		  up_i_1 <= 0;
		  
		  left_i_8 <= 0;
		  up_i_2 <= 0; 

		  left_i_12 <= 0;
		  up_i_3 <= 0;
		  
		  
		end else if(count == 4);
		  addr_Mat_A <= 0; 
		  addr_Mat_B <= 0; 

		  left_i_0 <= read_data_Mat_A;
		  up_i_0 <= read_data_Mat_B;
		  
		  left_i_4 <= 0;
		  up_i_1 <= 0;
		  
		  left_i_8 <= 0;
		  up_i_2 <= 0; 

		  left_i_12 <= 0;
		  up_i_3 <= 0;
		  
		end else if(count == 5);
		  addr_Mat_A <= 0; 
		  addr_Mat_B <= 0; 

		  left_i_0 <= read_data_Mat_A;
		  up_i_0 <= read_data_Mat_B;
		  
		  left_i_4 <= 0;
		  up_i_1 <= 0;
		  
		  left_i_8 <= 0;
		  up_i_2 <= 0; 

		  left_i_12 <= 0;
		  up_i_3 <= 0;
	  
		end else if(count == 6);
		  addr_Mat_A <= 0; 
		  addr_Mat_B <= 0; 

		  left_i_0 <= read_data_Mat_A;
		  up_i_0 <= read_data_Mat_B;
		  
		  left_i_4 <= 0;
		  up_i_1 <= 0;
		  
		  left_i_8 <= 0;
		  up_i_2 <= 0; 

		  left_i_12 <= 0;
		  up_i_3 <= 0;
		  
		end else if(count == 7);
		  addr_Mat_A <= 0; 
		  addr_Mat_B <= 0; 

		  left_i_0 <= read_data_Mat_A;
		  up_i_0 <= read_data_Mat_B;
		  
		  left_i_4 <= 0;
		  up_i_1 <= 0;
		  
		  left_i_8 <= 0;
		  up_i_2 <= 0; 

		  left_i_12 <= 0;
		  up_i_3 <= 0;
	
	

	  end
  end
  
  
  // Instantiate OperandRegisters for Matrix A
  OperandRegisters #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MATRIX_SIZE(MATRIX_SIZE)
  ) operand_A_inst (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .write_data_Mat(write_data_Mat_A),
    .read_data_Mat(read_data_Mat_A),
    .addr_Mat(addr_Mat_A),
    .write_en_Mat(write_en_Mat_A)
  );

  // Instantiate OperandRegisters for Matrix B
  OperandRegisters #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MATRIX_SIZE(MATRIX_SIZE)
  ) operand_B_inst (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .write_data_Mat(write_data_Mat_B),
    .read_data_Mat(read_data_Mat_B),
    .addr_Mat(addr_Mat_B),
    .write_en_Mat(write_en_Mat_B)
  );
  
    // Instantiate your Systolic_Mul module
  Systolic_Mul #(DATA_WIDTH) Systolic_Mul_inst (
    .left_i_0(left_i_0),
    .left_i_4(left_i_4),
    .left_i_8(left_i_8),
    .left_i_12(left_i_12),
    .up_i_0(up_i_0),
    .up_i_1(up_i_1),
    .up_i_2(up_i_2),
    .up_i_3(up_i_3),
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .done(done)
  );
  

  // Instantiate the ScratchPad module
  ScratchPad #(DATA_WIDTH, ADDR_WIDTH, MATRIX_SIZE)
    SP_inst (
      .clk_i(clk),
      .rst_ni(rst_ni),
      .done(done),
      .res_o_0(res_o_0),
      .res_o_1(res_o_1),
      .res_o_2(res_o_2),
      .res_o_3(res_o_3),
      .res_o_4(res_o_4),
      .res_o_5(res_o_5),
      .res_o_6(res_o_6),
      .res_o_7(res_o_7),
      .res_o_8(res_o_8),
      .res_o_9(res_o_9),
      .res_o_10(res_o_10),
      .res_o_11(res_o_11),
      .res_o_12(res_o_12),
      .res_o_13(res_o_13),
      .res_o_14(res_o_14),
      .res_o_15(res_o_15)
    );

endmodule