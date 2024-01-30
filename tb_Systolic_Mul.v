`include "SYSTOLIC_MUL.v"
module TB_SYSTOLIC_MUL#(parameter DATA_WIDTH = 32);

reg rst_ni, clk_i;

reg [DATA_WIDTH-1:0] left_i_0, left_i_4, left_i_8, left_i_12, up_i_0, up_i_1, up_i_2, up_i_3;
wire done;

Systolic_Mul #(32) Sys_test(left_i_0, left_i_4, left_i_8, left_i_12,
		      up_i_0, up_i_1, up_i_2, up_i_3,
		      clk_i, rst_ni, done);


initial begin //Row 1 and Col 1
	#3  left_i_0 <= 32'd1;   //a11
	    up_i_0 <= 32'd1; 	 //b11
	#10 left_i_0 <= 32'd2;   //a12
	    up_i_0 <= 32'd1;	 //b21
	#10 left_i_0 <= 32'd3;   //a13
	    up_i_0 <= 32'd1;     //b31
	#10 left_i_0 <= 32'd4;	 //a14
	    up_i_0 <= 32'd1;     //b41
	#10 left_i_0 <= 32'd0;   //0
	    up_i_0 <= 32'd0;     //0
	#10 left_i_0 <= 32'd0;   //0
	    up_i_0 <= 32'd0;     //0
	#10 left_i_0 <= 32'd0;	 //0
	    up_i_0 <= 32'd0;     //0
end                          
                             
initial begin //Row 2 and Col 2               
	#3  left_i_4 <= 32'd0;   //0
	    up_i_1 <= 32'd0;     //0
	#10 left_i_4 <= 32'd5;   //a21
	    up_i_1 <= 32'd2;    //b12
	#10 left_i_4 <= 32'd6;   //a22
	    up_i_1 <= 32'd2;     //b22
	#10 left_i_4 <= 32'd7;   //a23
	    up_i_1 <= 32'd2;     //b32
	#10 left_i_4 <= 32'd8;   //a24
	    up_i_1 <= 32'd2;     //b42
	#10 left_i_4 <= 32'd0;   //0
	    up_i_1 <= 32'd0;     //0
	#10 left_i_4 <= 32'd0;	 //0
	    up_i_1 <= 32'd0;     //0
end

initial begin //Row 3 and Col 3 
	#3  left_i_8 <= 32'd0;	 //0
	    up_i_2 <= 32'd0;     //0
	#10 left_i_8 <= 32'd0;   //0
	    up_i_2 <= 32'd0;     //0
	#10 left_i_8 <= 32'd9;  //a31
	    up_i_2 <= 32'd3;    //b13
	#10 left_i_8 <= 32'd10;  //a32
	    up_i_2 <= 32'd3;    //b23
	#10 left_i_8 <= 32'd11;   //a33
	    up_i_2 <= 32'd3;     //b33
	#10 left_i_8 <= 32'd12;   //a34
	    up_i_2 <= 32'd3;     //b43
	#10 left_i_8 <= 32'd0;	 //0
	    up_i_2 <= 32'd0;     //0
end

initial begin //Row 4 and Col 4
	#3  left_i_12 <= 32'd0;	 //0
	    up_i_3 <= 32'd0;     //0
	#10 left_i_12 <= 32'd0;  //0
	    up_i_3 <= 32'd0;     //0
	#10 left_i_12 <= 32'd0;  //0
	    up_i_3 <= 32'd0;     //0
	#10 left_i_12 <= 32'd13; //a41
	    up_i_3 <= 32'd4;    //b14
	#10 left_i_12 <= 32'd14; //a42
	    up_i_3 <= 32'd4;    //b24
	#10 left_i_12 <= 32'd15; //a43
	    up_i_3 <= 32'd4;     //b34
	#10 left_i_12 <= 32'd16; //a44
	    up_i_3 <= 32'd4;     //b44
	#10 left_i_12 <= 32'd0;	 //0
	    up_i_3 <= 32'd0;     //0
end

initial begin
rst_ni <= 0;
clk_i <= 0;
#3
rst_ni <= 1;
end

initial begin
	clk_i = 0;
	forever #5 clk_i = ~clk_i;
end


endmodule
