`include "PE_unit.v"
`include "Systolic_Mul.v"

`define MAX_DIM value
`define BUS_WIDTH value
`define ADDR_WIDTH value

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

