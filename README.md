# Matrix Multiplication Accelerator README

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

## Usage

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
    
### Matmul High Level Design Block Diagram

![Block_Diagram](/Logic-Design-Project/doc/Images/Block_Diagram.png)

### Control and Status

The accelerator operates based on control signals provided through the `pwrite_i`, `penable_i`, and `pwdata_i` inputs. Status of the accelerator operation is indicated through the `busy_o` and `done_o` outputs.

## Authors

- Roee Shahmoon
- Noam Klainer 
