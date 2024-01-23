`include "PE_unit.v"
module tb_PE_unit();
    // Inputs
    reg [31:0] up_i, left_i;
    reg clk_i, rst_ni;

    // Outputs
    wire [31:0] down_o, right_o;
    wire [63:0] res_o;

    // Instance PE module
    PE_unit PE_test (
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
        up_i = 8'd2; 
        left_i = 8'd7; 
        rst_ni = 0;            

        // Start stimulate
        #10 rst_ni = 1;         
    end
endmodule
