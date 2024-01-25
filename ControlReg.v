module ControlRegister(
  input clk_i,      
  input rst_ni,      
  input start_bit,
  input mode_bit,
  input [1:0] write_target,
  input [1:0] read_target,
  input [1:0] dataflow_type,
  input [1:0] dimension_n,
  input [1:0] dimension_k,
  input [1:0] dimension_m,
  input reload_operand_a,
  input reload_operand_b,
  output reg pslverr_o  // Error signal
);

  reg [15:0] control_reg;

  always @(posedge clk_i or posedge !rst_ni) begin
    if (!rst_ni) begin
      control_reg <= 0;
    end else if (start_bit) begin
      // Check for write during operation and assert error signal
      if (control_reg[0]) begin
        pslverr_o <= 1;
      end else begin
        control_reg[0]  <= start_bit;
        control_reg[1]  <= mode_bit;
        control_reg[3:2] <= write_target;
        control_reg[5:4] <= read_target;
        control_reg[7:6] <= dataflow_type;
        control_reg[9:8] <= dimension_n; //dimension Matrix A
        control_reg[11:10] <= dimension_k; //dimension Matrix B
        control_reg[13:12] <= dimension_m; //dimension Matrix C
        control_reg[14] <= reload_operand_a; //Only required if using buffers/queues.
        control_reg[15] <= reload_operand_b; //Only required if using buffers/queues.
        // Reset error signal
        pslverr_o <= 0;
      end
    end
  end

endmodule