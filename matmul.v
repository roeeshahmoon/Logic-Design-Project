`include "PE_unit.v"
`include "Systolic_Mul.v"
`include "ControlRegister.v"
`include "OrpandReg.v"

`define DATA_WIDTH  32 //Bit - Width of single element can be 8/16/32
`define BUS_WIDTH  64 // APB Bus data bit width can be 16/32/64
`define ADDR_WIDTH  32 //APB address space bit width can be 16/24/32
`define SP NTARGETS 1 //The number of addressable targets in 
`define MAX_DIM 4 //can be 2/3/4

module matmul(clk_i, rst_ni, psel_i, penable_i,
				pwrite_i, pstrb_i, pwdata_i, paddr_i,
				pready_o, pslverr_o, prdata_o, busy_o);
				
	input clk_i, rst_ni, psel_i, penable_i, pwrite_i;	
	input [MAX_DIM-1:0] pstrb_i;
	input [BUS_WIDTH-1:0] pwdata_i;
	input [ADDR_WIDTH-1;0] paddr_i;
	output pready_o, pslverr_o;
	output [BUS_WIDTH-1:0] prdata_o;
	output busy_o;
	
	

