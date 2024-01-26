`include "PE_unit.v"
`include "Systolic_Mul.v"
`include "ControlReg.v"
`include "OrpandReg.v"

module matmul#(
  parameter DATA_WIDTH = 32, //Bit - Width of single element can be 8/16/32
  parameter BUS_WIDTH = 64, // APB Bus data bit width can be 16/32/64
  parameter ADDR_WIDTH  = 32, //APB address space bit width can be 16/24/32
  parameter SP_NTARGETS = 1, //The number of addressable targets in 
  parameter MAX_DIM = 4,
  parameter MATRIX_SIZE = 16 //MaxDim**2
)(clk_i, rst_ni, psel_i, penable_i,
				pwrite_i, pstrb_i, pwdata_i, paddr_i,
				pready_o, pslverr_o, prdata_o, busy_o);
				
	input clk_i, rst_ni, psel_i, penable_i, pwrite_i;	
	input [MAX_DIM-1:0] pstrb_i;
	input [BUS_WIDTH-1:0] pwdata_i;
	input [ADDR_WIDTH-1:0] paddr_i;
	output pready_o, pslverr_o;
	output [BUS_WIDTH-1:0] prdata_o;
	output busy_o;
	
	
	wire [DATA_WIDTH-1:0] write_data_Mat_A;
    wire [DATA_WIDTH-1:0] write_data_Mat_B;
    wire [DATA_WIDTH-1:0] read_data_Mat_A;
    wire [DATA_WIDTH-1:0] read_data_Mat_B;
    wire [ADDR_WIDTH-1:0] addr_Mat_A;
    wire [ADDR_WIDTH-1:0] addr_Mat_B;
    wire write_en_Mat_A;
    wire write_en_Mat_B;

  // Instantiate OperandRegisters for Matrix A
  OperandRegisters #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MATRIX_SIZE(MATRIX_SIZE)
  ) operand_A (
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
  ) operand_B (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .write_data_Mat(write_data_Mat_B),
    .read_data_Mat(read_data_Mat_B),
    .addr_Mat(addr_Mat_B),
    .write_en_Mat(write_en_Mat_B)
  );

endmodule