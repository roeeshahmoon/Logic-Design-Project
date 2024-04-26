`resetall
`timescale 1ns/10ps
/*
	Author: Roee Shahmoon, ID: 206564759
	Author: Noam Klainer, ID: 316015411
	
	These module is adress decoder unit.
*/


module address_decoder(clk_i, rst_ni,paddr_i,
			Address_sel_Mat_A,Address_sel_Mat_B,Address_sel_control_reg,Address_sel_SP,Address_sel_flags_reg);
			

		
		
input clk_i, rst_ni;
input [2:0] paddr_i;
output reg  Address_sel_Mat_A,Address_sel_Mat_B,Address_sel_control_reg,Address_sel_SP,Address_sel_flags_reg;




  
  
  
always @(*) begin 
	if(!rst_ni) begin 
		
		
		Address_sel_Mat_A       =	0;
		Address_sel_Mat_B       =	0;
		Address_sel_control_reg       =	0;
		Address_sel_flags_reg	=0;
		Address_sel_SP	=	0;
		
		
	end else begin 
		if(paddr_i[0] && !paddr_i[1] && !paddr_i[2]) begin 
			
			Address_sel_Mat_A       =	1;
			Address_sel_Mat_B       =	0;
			Address_sel_control_reg =	0;
			Address_sel_flags_reg	= 0;
			Address_sel_SP	=	0;
			
		end
		else if(!paddr_i[0] && paddr_i[1] && !paddr_i[2]) begin						
			Address_sel_Mat_B      =	1;		
			Address_sel_Mat_A      =	0;
			Address_sel_control_reg       =	0;
			Address_sel_flags_reg	= 0;
			Address_sel_SP	=	0;
		end
		else if(!paddr_i[0] && !paddr_i[1] && !paddr_i[2] ) begin
			
			Address_sel_control_reg       =	1;
			Address_sel_Mat_A       =	0;
			Address_sel_Mat_B       =	0;
			Address_sel_flags_reg	= 0;
	        Address_sel_SP	=	0;
		end	
		else if(paddr_i[0] && paddr_i[1] && !paddr_i[2]) begin
			
			Address_sel_Mat_A       =	0;
			Address_sel_Mat_B       =	0;
			Address_sel_control_reg       =	0;
			Address_sel_flags_reg	=1;
			Address_sel_SP	=	0;
		end
		else if(paddr_i[2] ) begin
			Address_sel_Mat_A       =	0;
			Address_sel_Mat_B       =	0;
			Address_sel_control_reg       =	0;
			Address_sel_flags_reg	= 0;
			Address_sel_SP	=	1;
		end
		else begin 
					
		Address_sel_Mat_A      =	0;
		Address_sel_Mat_B       =	0;
		Address_sel_control_reg    =	0;
		Address_sel_flags_reg	= 0;
		Address_sel_SP	=	0;
		end
		
	end
end
			

 

  
  

endmodule