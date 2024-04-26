`resetall
`timescale 1ns/10ps
`include "matmul_calculator.v"
`include "control_reg.v"
`include "operand_registerA.v"
`include "operand_registerB.v"
`include "address_decoder.v"
`include "scratchpad.v"

`define IDLE 1'b0 
`define WAIT 1'b1 
/*
	Author: Roee Shahmoon, ID: 206564759
	Author: Noam Klainer, ID: 316015411
	
	These module is top  model.
*/

module matmul#(parameter BUS_WIDTH = 8,parameter DATA_WIDTH = 4,parameter ADDR_WIDTH = 12,parameter SP_NTARGETS = 2)(clk_i, rst_ni, psel_i, penable_i,
			pwrite_i, pstrb_i, pwdata_i, paddr_i,
			pready_o, pslverr_o, prdata_o, busy_o, done_o);
			

    localparam MAX_DIM  = BUS_WIDTH/DATA_WIDTH;			
			
	input clk_i, rst_ni, psel_i, penable_i, pwrite_i;	
	input [MAX_DIM-1:0] pstrb_i;
	input [BUS_WIDTH-1:0] pwdata_i;
	input [ADDR_WIDTH-1:0] paddr_i;
	output reg  pready_o, pslverr_o;
	output reg [BUS_WIDTH-1:0] prdata_o;
	output wire busy_o,done_o;
	

	


	
	
	
    // Signals for Systolic_Mul module

	wire [BUS_WIDTH-1:0] read_data_Mat_A,read_data_Mat_B,read_data_SP;
	reg [BUS_WIDTH-1:0] write_data_Mat_A,write_data_Mat_B;
	reg [15:0] write_data_control;
	wire [BUS_WIDTH-1:0] buffer_Mat_A,buffer_Mat_B;
	reg [BUS_WIDTH-1:0] prdata_mux;
	wire [MAX_DIM**2 - 1:0] flags_i;
	reg [MAX_DIM**2 - 1:0] flags_reg;
	wire [15:0] control_register;
	wire [BUS_WIDTH*MAX_DIM**2 - 1:0] MAT_RES,operand_C_i;
	reg [BUS_WIDTH*MAX_DIM**2 - 1:0] operand_C_o;
	wire [1:0] n;
	wire [1:0] k;
	wire [1:0] m;
	wire done;
	wire   [$clog2(3*MAX_DIM-2) -1:0] counter;
	reg [0:0] state;
	reg busy_signal,start_bit ;
	reg [5+$clog2(MAX_DIM)-1:5] sub_addressing_operand ;
	reg [5+2*$clog2(MAX_DIM)-1:5] sub_addressing_sp ;
	wire  Address_sel_Mat_A,Address_sel_Mat_B,Address_sel_control_reg,Address_sel_SP,Address_sel_flags_reg;
	reg  write_ena_Mat_A,write_ena_Mat_B,write_ena_control_reg;
	wire [1:0] write_target_sp,read_target_sp;
	
	assign write_target_sp = control_register[3:2];
	assign read_target_sp = control_register[5:4];
  
     // Instantiate OperandRegisters for Matrix A
	  operand_register_a #(
		.DATA_WIDTH(DATA_WIDTH),
		.BUS_WIDTH(BUS_WIDTH)
	  ) operand_A_inst (
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.start_bit(control_register [0]),
		.reload_op(control_register[14]),
		.pwdata_i(write_data_Mat_A),
		.read_data_Mat_o(read_data_Mat_A),
		.buff(buffer_Mat_A),
		.addr_Mat_i(sub_addressing_operand),
		.write_en_Mat_i(write_ena_Mat_A),
		.pstrb_i(pstrb_i),
		.counter(counter),
		.n(n),
		.k(k)
	  );

	  // Instantiate OperandRegisters for Matrix B
	  operand_register_b #(
		.DATA_WIDTH(DATA_WIDTH),
		.BUS_WIDTH(BUS_WIDTH)
	  ) operand_B_inst (
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.start_bit(control_register [0]),
		.reload_op(control_register[15]),
		.pwdata_i(write_data_Mat_B),
		.read_data_Mat_o(read_data_Mat_B),
		.buff(buffer_Mat_B),
		.addr_Mat_i(sub_addressing_operand),
		.write_en_Mat_i(write_ena_Mat_B),
		.pstrb_i(pstrb_i),
		.counter(counter),
		.k(k),
		.m(m)
	  );
	  

	
	
	control_reg control_register_module (        
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.done(done),
		.ena_write_control_reg(write_ena_control_reg||done),
		.start_bit(start_bit),
		.mode_bit(write_data_control[1]),
		.write_target(write_data_control[3:2]),
        .read_target(write_data_control[5:4]),
		.dataflow_type(write_data_control[7:6]),
		.dimension_n(write_data_control[9:8]),
		.dimension_k(write_data_control[11:10]),
		.dimension_m(write_data_control[13:12]),
		.reload_operand_a(write_data_control[14]),
		.reload_operand_b(write_data_control[15]),
		.control_register(control_register)
		);
	
	address_decoder  address_decoder_inst (
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.paddr_i(paddr_i[4:2]),
		.Address_sel_Mat_A(Address_sel_Mat_A),
		.Address_sel_Mat_B(Address_sel_Mat_B),
		.Address_sel_control_reg(Address_sel_control_reg),
		.Address_sel_SP(Address_sel_SP),
		.Address_sel_flags_reg(Address_sel_flags_reg)
	  );

	scratchpad#(.BUS_WIDTH(BUS_WIDTH),.DATA_WIDTH(DATA_WIDTH),.SP_NTARGETS(SP_NTARGETS)) scratchpad_inst
			(.clk_i(clk_i), 
			 .rst_ni(rst_ni),
			 .write_target(write_target_sp),
			 .address_i(paddr_i[3:2]),
			 .address_i_for_op_c(read_target_sp),
			 .ena_write(busy_signal),
			 .sub_address_i(sub_addressing_sp),
			 .Data_i(MAT_RES),
 			 .Data_o(read_data_SP),
			 .Mat_o(operand_C_i));
 

    matmul_calculator#(.DATA_WIDTH(DATA_WIDTH),.BUS_WIDTH(BUS_WIDTH)) matmul_calculator_by_systolic_array (
        .A(buffer_Mat_A),
		.B(buffer_Mat_B),
		.C(operand_C_o),
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.start_bit(control_register [0]),
		.mode_bit(control_register[1]),
		.flags(flags_i),
        .M(MAT_RES),
		.done(done),
		.counter(counter)
    );

assign n = control_register[9:8];
assign k = control_register[11:10];
assign m = control_register[13:12]; 

   
   
 always	@(*) begin : mux_for_pdata_o
	if(!rst_ni) begin 
		prdata_mux <= 0;
	end
	else begin 
		if(Address_sel_Mat_A) begin 
			prdata_mux<=read_data_Mat_A;
		end 
		else if(Address_sel_Mat_B) begin 
			prdata_mux<=read_data_Mat_B;
		end
		else if(Address_sel_control_reg) begin 
			prdata_mux<=control_register;
		end
		else if(Address_sel_SP) begin 
			prdata_mux	<=	read_data_SP;
		end
		else if(Address_sel_flags_reg) begin 
			prdata_mux	<=	flags_reg;
		end
		else begin 
			prdata_mux <= 0;
		end
	end
end

			
always @(posedge clk_i) begin 
	if(!rst_ni) begin 
		operand_C_o <= 0;
	end
	else if(!busy_signal) begin 
		operand_C_o <= operand_C_i;
	end
	else begin 
		operand_C_o <= operand_C_o;
	end
end
   
   
 
 always @(posedge clk_i)
 begin
 
   if(!rst_ni)
     begin
		state <= `IDLE;  
		prdata_o <= 0;
		pready_o <=0;
		busy_signal	<=	0;
		pslverr_o	<= 1'b0;	
		write_ena_control_reg <= 0;	
		write_ena_Mat_B <= 0;
		write_ena_Mat_A <= 0;
		start_bit <= 0;
		flags_reg <= 0;
	  
     end
   else
     begin
		//state = state;
		case (state)
		`IDLE: begin 
			prdata_o <= 0;
			busy_signal <= done ? 0:busy_signal;
			start_bit <= done ?   0:start_bit;
			write_ena_control_reg <= 0;
			write_ena_Mat_A <= 0;
			write_ena_Mat_B <= 0;
			
			
			if(psel_i) begin
				pready_o <= 1'b1;
				state <= `WAIT;
				sub_addressing_sp <= paddr_i[5+2*$clog2(MAX_DIM)-1:5];

			end
			else begin
				pready_o	<= 1'b0;
				state <= `IDLE;
			end								
		end
			
		`WAIT: begin
			if(psel_i) begin 
				pready_o <= 1'b1;
				state <= `WAIT;
				sub_addressing_sp <= paddr_i[5+2*$clog2(MAX_DIM)-1:5];
			end
			else begin 
				state <= `IDLE;
				pready_o <= 1'b0;
			end
			if(psel_i&&penable_i) begin 
				prdata_o <= prdata_mux;
				if(pwrite_i) begin
					busy_signal <= done ? 0:busy_signal;
					
					if(busy_signal || pstrb_i == 0) begin 
						pslverr_o	<= 1'b1;
					end
					else if(!paddr_i[2] && !paddr_i[3] && !paddr_i[4]) begin 
						write_data_control[15:1] <= pwdata_i[15:1];
						start_bit <= pwdata_i[0];
						write_data_control[0] <= pwdata_i[0];
						busy_signal <= pwdata_i[0];
						write_ena_control_reg <= 1;
						write_ena_Mat_A <= 0;
						write_ena_Mat_B <= 0;
						
						
						//pslverr_o	= n >= MAX_DIM-1 || k >= MAX_DIM-1 || m >= MAX_DIM-1 ? 1:0;
					end
					else if(paddr_i[2] && !paddr_i[3] && !paddr_i[4]) begin 
						write_data_Mat_A <= pwdata_i;
						write_ena_Mat_A <= 1;
						write_ena_Mat_B <= 0;
						write_ena_control_reg <= 0;
						sub_addressing_operand <= paddr_i[5+$clog2(MAX_DIM)-1:5];
						//pslverr_o	= sub_addressing_operand > n ? 1:0;
					end
					else if(!paddr_i[2] && paddr_i[3] && !paddr_i[4]) begin 
						write_data_Mat_B <= pwdata_i;
						write_ena_Mat_B <= 1;
						write_ena_Mat_A <= 0;
						write_ena_control_reg <= 0;
						sub_addressing_operand <= paddr_i[5+$clog2(MAX_DIM)-1:5];
						//pslverr_o	= sub_addressing_operand > k ? 1:0;
					end
					else begin 
						write_ena_control_reg <= 0;
						write_ena_Mat_A <= 0;
						write_ena_Mat_B <= 0;
					end
				end
				else begin 
					busy_signal <= done ? 0:busy_signal;
					start_bit <= done ? 0:start_bit;
					
				end
			
			
					
			end
			else begin 
				busy_signal <= done ? 0:busy_signal;
				start_bit <= done ? 0:start_bit;	
			end

				
		end	
		   
		
		
	
		default: begin

			state = `IDLE;

		end
		
		endcase
		flags_reg  <= done? flags_i:flags_reg;
	end
	
end

assign  busy_o = busy_signal;
assign done_o = done;
 
endmodule