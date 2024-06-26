# Matrix Multiplication Accelerator 

## Introduction

The Matrix Multiplication Accelerator is a hardware module designed to efficiently compute matrix multiplications using a systolic array architecture. This module is intended to be integrated into larger digital systems, such as FPGA-based accelerators or custom ASIC designs, to accelerate matrix multiplication operations.

## Features

- Systolic array architecture for efficient matrix multiplication.
- Configurable parameters including bus width, data width, address width, and number of scratchpad targets.
- Supports matrix dimensions up to a configurable maximum.
- Interfaces for matrix input/output, control registers, and scratchpad memory.
- Flexible addressing schemes for memory access.
- Integration with control logic to manage matrix multiplication operations.
- Status signals for indicating busy state and operation completion.

## High Level Design Block Diagram

![Block_Diagram](/doc/Images/Block_Diagram.png)

## Usage
It is designed to efficiently perform matrix multiplication using a systolic array architecture, which enables a highly parallel
and pipelined computational structure to achieve high throughput and reduced latency compared to traditional sequential methods.

### Technology Stack

- Design stage written in Verilog using HDL
- Verification Stage written in Python Scripts, System Verilog and ModelSim

### Instantiation

To use the Matrix Multiplication Accelerator in your Verilog design, instantiate the `matmul_pkg` module with appropriate parameters with the correct constrains

### Configuration

- `BUS_WIDTH`: Width of the data bus connecting to the accelerator.
- `DATA_WIDTH`: Width of each data element in the matrices.
- `ADDR_WIDTH`: Width of the address bus for memory access.
- `SP_NTARGETS`: Number of targets in the scratchpad memory.

### Ports

- **Inputs**:
  - `clk_i`: Clock input.
  - `rst_ni`: Reset Negative input (active low).
  - `psel_i`: Peripheral select input.
  - `penable_i`: Peripheral enable input.
  - `pwrite_i`: Write/Read enable input.
  - `pstrb_i`: Byte enable input.
  - `pwdata_i`: Write data input.
  - `paddr_i`: Address input.

- **Outputs**:
  - `pready_o`: Ready output.
  - `pslverr_o`: Slave error output.
  - `prdata_o`: Read data output.
  - `busy_o`: Busy output.
  - `done_o`: Done output.

### Flow Chart

![Flow_Chart](/doc/Images/Flow_Chart.png)

### Control and Status

The accelerator operates based on control signals provided through the `psel_i`, `penable_i`, `pwdata_i` and `paddr_i` inputs from APB.
Status of the accelerator operation is indicated through the `busy_o` and `done_o` outputs.

## Verification 

### Test Bench Block Diagram

![Test_Bench](/doc/Images/Test_Bench.png)

We read all the data for the testbench from file `Bus_File.txt`, we randomize all the data on the python script `golden.py` using `python random moudle`.

The stimulus read instructions from  `Bus_File.txt` and generate APB master to write this data into the design.
 We wrote those data into files:
 `Param_File.txt`,
 `Mat_A.txt`,
 `Mat_B.txt`,
 `Mat_Res.txt`,
 `Flags_Res.txt`,
 `SP.txt`.

### Test Example

 ![Test_Exa](/doc/Images/Test_Exa.png)

In the end we are comparing between the result files from DUT `MAT_RES_DUT.txt` and `FLAGS_RES_DUT.txt` to golden script. 
We print to the screen how much hits and miss we have.


## Authors

- Roee Shahmoon
- Noam Klainer 
