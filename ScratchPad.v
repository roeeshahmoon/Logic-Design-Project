module SCRACHPAD#(parameter DATA_WIDTH = 32,
					parameter ADDR_WIDTH = 4,
					parameter MATRIX_SIZE = 16) // MaxDim**2
			(clk_i, rst_ni, done,
			res_o_0, res_o_1, res_o_2, res_o_3,
			res_o_4, res_o_5, res_o_6, res_o_7,
			res_o_8, res_o_9, res_o_10, res_o_11,
			res_o_12, res_o_13, res_o_14, res_o_15);
			  
	input wire [DATA_WIDTH-1:0] res_o_0, res_o_1, res_o_2, res_o_3, res_o_4, res_o_5, res_o_6, res_o_7, res_o_8, res_o_9, res_o_10, res_o_11, res_o_12, res_o_13, res_o_14, res_o_15;
	input wire clk_i, rst_ni, done;
	integer i;
	
    reg [DATA_WIDTH-1:0] ScratchPad [0:MATRIX_SIZE-1];

  // ScratchPad Write Logic
  always @(posedge clk_i or posedge !rst_ni) begin
    if (!rst_ni) begin
      for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
        ScratchPad[i] <= 0;
      end
    end else if (done) begin
			ScratchPad[0] <= res_o_0;
			ScratchPad[1] <= res_o_1;
			ScratchPad[2] <= res_o_2;
			ScratchPad[3] <= res_o_3;
			ScratchPad[4] <= res_o_4;
			ScratchPad[5] <= res_o_5;
			ScratchPad[6] <= res_o_6;
            ScratchPad[7] <= res_o_7;
			ScratchPad[8] <= res_o_8;
            ScratchPad[9] <= res_o_9;
			ScratchPad[10] <= res_o_10;
			ScratchPad[11] <= res_o_11;
			ScratchPad[12] <= res_o_12;
			ScratchPad[13] <= res_o_13;
			ScratchPad[14] <= res_o_14;
			ScratchPad[15] <= res_o_15;			
		end
  end
  
endmodule
