module CONTROL_REG(
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

  reg [15:0] control_register ;

  always @(posedge clk_i or posedge !rst_ni) begin
    if (!rst_ni) begin
      control_register  <= 0;
    end else if (start_bit) begin
      // Check for write during operation and assert error signal
      if (control_register [0]) begin
        pslverr_o <= 1;
      end else begin
        control_register [0]  <= start_bit;
        control_register [1]  <= mode_bit;
        control_register [3:2] <= write_target;
        control_register [5:4] <= read_target;
        control_register [7:6] <= dataflow_type;
        control_register [9:8] <= dimension_n; //dimension Matrix A
        control_register [11:10] <= dimension_k; //dimension Matrix B
        control_register [13:12] <= dimension_m; //dimension Matrix C
        control_register [14] <= reload_operand_a; //Only required if using buffers/queues.
        control_register [15] <= reload_operand_b; //Only required if using buffers/queues.
        // Reset error signal
        pslverr_o <= 0;
      end
    end
  end

endmodule