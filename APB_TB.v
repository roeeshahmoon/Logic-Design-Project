`timescale 1ns/1ps // Adjust the timescale as needed

module APB_TB;

  // Parameters
  localparam DATA_WIDTH = 32;
  localparam BUS_WIDTH = 16;
  localparam SP_NTARGETS = 2;
  localparam ADDR_WIDTH = 16;
  localparam MAX_DIM = BUS_WIDTH / DATA_WIDTH;

  // Signals
  reg clk;
  reg rst_n;
  reg psel;
  reg penable;
  reg pwrite;
  reg transfer;
  reg [MAX_DIM-1:0] pstrb;
  reg [BUS_WIDTH-1:0] pwdata;
  reg [ADDR_WIDTH-1:0] paddr;
  reg pready_i;
  reg pslverr_i;
  reg [BUS_WIDTH-1:0] data_RF_i;
  wire [BUS_WIDTH-1:0] prdata_o;
  wire busy_o;
  wire [BUS_WIDTH-1:0] data_RF_o;

  // Instantiate APB module
  APB #(
    .DATA_WIDTH(DATA_WIDTH),
    .BUS_WIDTH(BUS_WIDTH),
    .SP_NTARGETS(SP_NTARGETS),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MAX_DIM(MAX_DIM)
  ) dut (
    .clk_i(clk),
    .rst_ni(rst_n),
    .psel_i(psel),
    .penable_i(penable),
    .pwrite_i(pwrite),
    .transfer_i(transfer),
    .pstrb_i(pstrb),
    .pwdata_i(pwdata),
    .paddr_i(paddr),
    .pready_o(),
    .pslverr_o(),
    .prdata_o(prdata_o),
    .busy_o(busy_o),
    .pslverr_i(pslverr_i),
    .data_RF_i(data_RF_i),
    .data_RF_o(data_RF_o),
    .pready_i(pready_i)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test stimulus
  initial begin
    // Initialize inputs
    rst_n = 0;
    psel = 0;
    penable = 0;
    pwrite = 0;
    transfer = 0;
    pstrb = 0;
    pwdata = 0;
    paddr = 0;
    pready_i = 0;
    pslverr_i = 0;
    data_RF_i = 0;

    // Apply reset
    #10 rst_n = 1;

    // Test scenario
    #20 psel = 1;
    #5 transfer = 1;
    #5 penable = 1;
    #5 pwrite = 1;
    #5 pwdata = 32'hABCDEFF0; // Your write data
    #5 paddr = 16'h1234; // Your address

    // Add more test scenarios based on your requirements

    // Finish simulation
    #100 $finish;
  end

endmodule
