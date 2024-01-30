`include "OPRAND_REG.v"
module TB_OPRAND_REG;

  // Parameters
  localparam DATA_WIDTH = 32;
  localparam ADDR_WIDTH = 4;
  localparam MATRIX_SIZE = 16;

  // Inputs
  reg clk_i;
  reg rst_ni;
  reg [DATA_WIDTH-1:0] write_data_Mat_i;
  reg [ADDR_WIDTH-1:0] addr_Mat_i;
  reg write_en_Mat_i;

  // Outputs
  wire [DATA_WIDTH-1:0] read_data_Mat_o;

  // Instantiate OperandRegister module
  OperandRegister #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MATRIX_SIZE(MATRIX_SIZE)
  ) uut (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .write_data_Mat_i(write_data_Mat_i),
    .read_data_Mat_o(read_data_Mat_o),
    .addr_Mat_i(addr_Mat_i),
    .write_en_Mat_i(write_en_Mat_i)
  );

  // Clock generation
  initial begin
    clk_i = 0;
    forever #5 clk_i = ~clk_i;
  end

  // Test scenario
  initial begin
    // Initialize inputs
    rst_ni = 0;
    write_data_Mat_i = 32'd0;
    addr_Mat_i = 4'd0;
    write_en_Mat_i = 1;

    // Stop reset
    #10 rst_ni = 1;

    // Write to Matrix
    #30 addr_Mat_i = 4'd0;
		write_data_Mat_i = 32'd8;
		write_en_Mat_i = 1;

    // Read from Matrix
    #30 addr_Mat_i = 4'd0;
     write_en_Mat_i = 0;

    // Write to Matrix
	#30 addr_Mat_i = 4'd2;
	    write_data_Mat_i = 32'd88;
	    write_en_Mat_i = 1;
	
	//Read from Matrix
	#30 addr_Mat_i = 4'd2;
	    write_en_Mat_i = 0;
	
  end

endmodule
