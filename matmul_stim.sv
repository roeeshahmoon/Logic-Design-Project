
`include "headers.vh"

// Stimulus Module
module matmul_stim #(
    parameter string INSTRUCTIONS_FILE = "",
	parameter string OUTPUTE_FILE = "",
    parameter bit     VERBOSE    = 1'b0
) (
    matmul_intf.STIMULUS    intf,



    //output logic        img_done_o,
    output logic        stim_done_o
);
    import matmul_pkg::data_bus_t;
    import matmul_pkg::adrr_bus_t;
	import matmul_pkg::MAX_DIM;
	import matmul_pkg::elements_data_bus_t;
	import matmul_pkg::number_tests;
    // File descriptors
    integer instructions_fd,output_fd ;
    // Dimensions
    integer r, c, counter_test;
    // Operation counter


    wire        clk    = intf.clk;
    wire        rst    = intf.rst;
	wire        done_i    = intf.done;
	data_bus_t 	prdata_i;
	logic [1:0] sub_address_sp;
    // Interface signals declared internally
    logic       psel_o, penable_o, pwrite_o;
    data_bus_t        pwdata_o;
    adrr_bus_t        paddr_o;
    elements_data_bus_t        pstrb_o;
    // Interface signals connect to internal decl'
    assign intf.psel         = psel_o;
    assign intf.penable = penable_o;
    assign intf.pwrite  = pwrite_o;
    assign intf.pwdata     = pwdata_o;
	assign intf.paddr     = paddr_o;
	assign intf.pstrb     = pstrb_o;
    // TB Signals
    //assign out_width_o     = pix_width;
    //assign out_height_o  = pix_height;

    task do_reset; begin
        psel_o        = 1'b0;
		penable_o        = 1'b0;
		pwrite_o        = 1'b0;
		
        pwdata_o        = 0;
        paddr_o        = 0;
        pstrb_o        = 0;
		counter_test = 0;
		r = 0;
		c = 0;
        //img_done_o    = 1'b0;
        stim_done_o = 1'b0;
        // Open Stimulus files
           open_files(1'b0); // Open all 2
        wait( rst ); // Wait for reset to be asserted
        wait(!rst ); // Wait for reset to be deasserted
        // Reset done.
    end endtask

    task open_files(input logic reopen); begin
        if( !reopen ) begin
            // First time 
            instructions_fd = $fopen(INSTRUCTIONS_FILE, "r");
			output_fd = $fopen(OUTPUTE_FILE, "w");
			$fwrite(output_fd, "\n");
            if(instructions_fd == 0) $fatal(1, $sformatf("Failed to open %s", INSTRUCTIONS_FILE));
        end // else img_done_o = 1'b1;



    end endtask

 task write_output_file(input integer iteration_test);
 begin
 $fwrite(output_fd, "Mat Res in Test %0d is: \n\n", iteration_test);
 @(posedge clk)
 paddr_o = 0;
 psel_o = 1;
 pwrite_o = 0;
 @(posedge clk)
 penable_o = 1;
 @(posedge clk)
 penable_o = 0;
 @(posedge clk)
 sub_address_sp = intf.prdata[3:2];
 paddr_o = 16 + 4*sub_address_sp + 0;
 repeat(MAX_DIM**2) begin
	paddr_o[8:5] = r*MAX_DIM + c;
	@(posedge clk)
	penable_o = 1;
	@(posedge clk)
	penable_o = 0;
	@(posedge clk)
	prdata_i = intf.prdata;
	$fwrite(output_fd, "%0d.0",prdata_i);
	if(c == MAX_DIM-1) begin 
		$fwrite(output_fd , "\n");
		r = r + 1;
		c = 0;
	end
	else begin 
		$fwrite(output_fd , ",");
		c = c + 1;
	end
end
r = 0;
c = 0;
if(iteration_test < number_tests) begin 
	$fwrite(output_fd, "----------------------------------------------------------------------------------------------------\n");
end
else begin 
	$fwrite(output_fd, "----------------------------------------------------------------------------------------------------");
end	
end endtask
	



initial begin: INIT_STIM
	if(INSTRUCTIONS_FILE == "") $fatal(1, "INSTRUCTIONS_FILE is not set");
	
	do_reset();
	
	while(1) begin
		@(posedge clk)
		pwrite_o = 1;
		psel_o = 1;
		penable_o = 0;
		if($fscanf(instructions_fd, "%d,%d,%d/n", pwdata_o, paddr_o,pstrb_o) != 3)begin
                $fatal(1, "Failed to read the metadata line of IMAGE_FILE");
				$fclose(instructions_fd);
				$fclose(output_fd);
				@(posedge clk) stim_done_o = 1'b1;
				break;
        end
		
		if ( paddr_o == 0 && pwdata_o[0]) begin
			@(posedge clk)
			penable_o = 1;
			@(posedge clk)
			penable_o = 0;
			//pwrite_o = 0;
			wait(done_i == 1);
			write_output_file(counter_test+1);
			counter_test = counter_test + 1;
		end
		
		@(posedge clk)
		penable_o = 1;
		
	end
end


endmodule

