module OperandRegisters #(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4,
  parameter MATRIX_SIZE = 16
)(
  input wire clk,          // Clock input
  input wire rst,          // Reset input
  input wire [DATA_WIDTH-1:0] data_A, // Data input for Matrix-A
  input wire [DATA_WIDTH-1:0] data_B, // Data input for Matrix-B

  output reg [DATA_WIDTH-1:0] read_data_A, // Read data for Matrix-A
  output reg [DATA_WIDTH-1:0] read_data_B, // Read data for Matrix-B

  input wire [ADDR_WIDTH-1:0] addr_A,  // Address input for Matrix-A
  input wire [ADDR_WIDTH-1:0] addr_B,  // Address input for Matrix-B
  input wire write_en_A,    // Write enable for Matrix-A
  input wire write_en_B     // Write enable for Matrix-B
);
  reg [DATA_WIDTH-1:0] matrix_A [0:MATRIX_SIZE-1]; // Matrix-A registers
  reg [DATA_WIDTH-1:0] matrix_B [0:MATRIX_SIZE-1]; // Matrix-B registers

  // Matrix-A Read Logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      read_data_A <= DATA_WIDTH'b0;
    end else if (addr_A < MATRIX_SIZE) begin
      read_data_A <= matrix_A[addr_A];
    end
  end

  // Matrix-B Read Logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      read_data_B <= DATA_WIDTH'b0;
    end else if (addr_B < MATRIX_SIZE) begin
      read_data_B <= matrix_B[addr_B];
    end
  end

  // Matrix-A Write Logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
        matrix_A[i] <= DATA_WIDTH'b0;
      end
    end else if (write_en_A && addr_A < MATRIX_SIZE) begin
      matrix_A[addr_A] <= data_A;
    end
  end

  // Matrix-B Write Logic
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
        matrix_B[i] <= DATA_WIDTH'b0;
      end
    end else if (write_en_B && addr_B < MATRIX_SIZE) begin
      matrix_B[addr_B] <= data_B;
    end
  end

endmodule
