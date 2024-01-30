`include "PE_UNIT.v"
module TB_PE_UNIT#(parameter DATA_WIDTH = 32)();
    // Inputs
    reg [DATA_WIDTH-1:0] up_i, left_i;
    reg clk_i, rst_ni;

    // Outputs
    wire [DATA_WIDTH-1:0] down_o, right_o;
    wire [63:0] res_o;

    // Instance PE module
    PE_UNIT #(32) PE_TEST (
        .up_i(up_i),
        .left_i(left_i),
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .down_o(down_o),
        .right_o(right_o),
        .res_o(res_o)
    );

    // Clock generate
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

    // Initialize Simulate
    initial begin
        // Initialize inputs
        up_i = 32'd5; 
        left_i = 32'd3; 
        rst_ni = 0;            

        // Start stimulate
        #10 rst_ni = 1;         
    end
endmodule
