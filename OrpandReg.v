module OperandRegister #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 4,
  parameter MATRIX_SIZE = 16 // MaxDim**2
)(
  input wire clk_i,          
  input wire rst_ni,          
  input wire [DATA_WIDTH-1:0] write_data_Mat_i, // Write data input for Matrix
  input wire [ADDR_WIDTH-1:0] addr_Mat_i,  // Address input for Matrix
  input wire write_en_Mat_i,              //Enable write
  output reg [DATA_WIDTH-1:0] read_data_Mat_o // Read data output for Matrix
);
  reg [DATA_WIDTH-1:0] matrix_Mat [0:MATRIX_SIZE-1];
  integer i;
  // Matrix Read Logic
  always @(posedge clk_i or posedge !rst_ni) begin
    if (!rst_ni) begin
      read_data_Mat_o <= 0;
    end else begin
      read_data_Mat_o <= matrix_Mat[addr_Mat_i];
    end
  end

  // Matrix Write Logic
  always @(posedge clk_i or posedge !rst_ni) begin
    if (!rst_ni) begin
      for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
        matrix_Mat[i] <= 0;
      end
    end else if (write_en_Mat_i) begin
      matrix_Mat[addr_Mat_i] <= write_data_Mat_i;
    end
  end

endmodule
