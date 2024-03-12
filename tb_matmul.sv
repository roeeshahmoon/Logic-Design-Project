`include "headers.vh"

module matmul_tb ;

import matmul_pkg::*;


// Internal signal declarations
logic clk = 1'b0, rst;
// Interface instantiation
matmul_intf intf(
	.clk(clk), .rst(rst)
);
// Init clock process
initial forever 
	#(CLK_NS/2) clk = ~clk;
// Init reset process
initial begin: TOP_RST
	rst = 1'b1; // Assert reset
	// Reset for RST_CYC cycles
	repeat(RST_CYC) @(posedge clk);
	rst = 1'b0; // Deassert reset
end
// DUT //	
matmul #(
		.DATA_WIDTH(DATA_WIDTH),
		.BUS_WIDTH(BUS_WIDTH),
		.ADDR_WIDTH(ADDR_WIDTH),
		.SP_NTARGETS(SP_NTARGETS)
	  ) dut (
		.clk_i(intf.clk),
		.rst_ni(!intf.rst),
		.pwdata_i(intf.pwdata),
		.paddr_i(intf.paddr),
		.psel_i(intf.psel),
		.penable_i(intf.penable),
		.pwrite_i(intf.pwrite),	
		.pstrb_i(intf.pstrb),
		.pready_o(intf.pready),
		.pslverr_o(intf.pslverr),
		.prdata_o(intf.prdata),
		.busy_o(intf.busy),
		.done_o(intf.done)		
	  );
	
// TODO : Override this path parameter !!!
matmul_tester #(
	.RESOURCE_BASE("C:/LAB1")
) u_tester (
   .intf(intf)
);


endmodule
