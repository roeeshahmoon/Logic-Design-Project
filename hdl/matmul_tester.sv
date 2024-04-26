//
// Test Bench Module lab2_lib.eqn_impl_tester.eqn_impl_tester
//
// Created:
//          by - mikepi.grad (eesgi4)
//          at - 18:40:18 01/23/24

`include "headers.vh"

module matmul_tester #(
    parameter string RESOURCE_BASE = ""
) (
    matmul_intf intf
);

// Local declarations
//wire [31:0] out_width, out_height;
//logic img_done, stim_done, golden_done;
logic stim_done;
wire rst_i = intf.rst;





matmul_stim #(
    .INSTRUCTIONS_FILE($sformatf("%s/Bus_File.txt",RESOURCE_BASE)),
	.OUTPUTE_MAT_RES_FILE($sformatf("%s/MAT_RES_DUT.txt",RESOURCE_BASE)),//making the output file in the same place like the source
	.OUTPUTE_FLAGS_RES_FILE($sformatf("%s/FLAGS_RES_DUT.txt",RESOURCE_BASE))//making the output file in the same place like the source
) u_stim (
    .intf(intf),
    // TB Status
    //.out_width_o(out_width),
   // .out_height_o(out_height),
    //.img_done_o(img_done),
    .stim_done_o(stim_done)
);





//Golden-Model module
//mat_mul_golden #(
////    .MAX_IM_DIM(240),
//    .OUTFILE($sformatf("%s/out/BGUTROLL",RESOURCE_BASE)),
//	.GOLDENFILE($sformatf("%s/out/golden.raw",RESOURCE_BASE)),
////    .VERBOSE(1'b1)
//) u_golden (
//    .intf    (intf),
//    // TB Status
//    .out_width_i(out_width),
//    .out_height_i(out_height),
//    .img_done_i(img_done),
//    .stim_done_i(stim_done),
//    .golden_done_o(golden_done)
//);


initial begin: TB_INIT
    wait(rst_i); wait(!rst_i);
    wait(stim_done);
    $display("[%0t] Stim Done.", $time);
    //wait(golden_done);
    //$display("[%0t] Check Done.", $time);
    $finish;
end

endmodule // eqn_impl_tester


