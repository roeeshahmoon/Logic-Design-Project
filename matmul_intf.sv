`include "headers.vh"

interface matmul_intf(input logic clk, input logic rst);
	import matmul_pkg::*;

	logic psel, penable, pwrite;	
	logic [MAX_DIM-1:0] pstrb;
	logic [BUS_WIDTH-1:0] pwdata;
	logic [ADDR_WIDTH-1:0] paddr;
	logic pready, pslverr,busy,done;
	logic [BUS_WIDTH-1:0] prdata;




	modport DEVICE  (input  clk, rst, psel, penable, pwrite, pstrb,
						pwdata, paddr, output pready, pslverr, prdata, busy,done);
	modport STIMULUS (output  clk, rst, psel, penable, pwrite, pstrb,
						pwdata, paddr, input pready, pslverr, prdata, busy,done);
	//modport CHECKCOV(input  clk, rst, ena, im_pixel, w_pixel, param, iw_pixel);

endinterface
