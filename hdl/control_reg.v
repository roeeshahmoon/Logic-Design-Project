`resetall
`timescale 1ns/10ps
/*
	Author: Roee Shahmoon, ID: 206564759
	Author: Noam Klainer, ID: 316015411
	
	These module is resgister model.
*/



module control_reg(clk_i,rst_ni,done,ena_write_control_reg,start_bit,mode_bit,write_target,read_target,dataflow_type,dimension_n,dimension_k
					,dimension_m,reload_operand_a,reload_operand_b,control_register);
  input clk_i;      
  input rst_ni;
  input done;
  input ena_write_control_reg;  
  input start_bit;
  input mode_bit;
  input [1:0] write_target;
  input [1:0] read_target;
  input [1:0] dataflow_type;
  input [1:0] dimension_n;
  input [1:0] dimension_k;
  input [1:0] dimension_m;
  input reload_operand_a;
  input reload_operand_b;
  output wire [15:0] control_register;  // Error signal

	
  reg [15:0] data_reg;

  always @(posedge clk_i ) begin
    if (!rst_ni) begin
		data_reg  <= 0;
    end 
	else if (ena_write_control_reg) begin
	  // Check for write during operation and assert error signal
	  
		data_reg [0]  <= done ? 0:start_bit;
		data_reg [1]  <= mode_bit;
		data_reg [3:2] <= write_target;
		data_reg [5:4] <= read_target;
		data_reg [7:6] <= dataflow_type;
		data_reg [9:8] <= dimension_n; //dimension Matrix A
		data_reg [11:10] <= dimension_k; //dimension Matrix B
		data_reg [13:12] <= dimension_m; //dimension Matrix C
		data_reg [14] <= reload_operand_a; //Only required if using buffers/queues.
		data_reg [15] <= reload_operand_b; //Only required if using buffers/queues.
		// Reset error signal
		
      
    end

  end
  
  assign control_register = data_reg;

endmodule