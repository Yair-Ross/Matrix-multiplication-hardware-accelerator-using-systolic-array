# Matrix-Multiplication-Hardware-Accelarator-Using-Systolic-Array
## PROJECT OVERVIEW

The Matrix Multiplication Hardware Accelerator is designed multiply matrices faster and more efficiently than the CPU. It is designed to communicate with a CPU using AMBA4 protocol. The project was developed using Verilog and System Verilog and demonstrated the design and verification parts of ASIC design.

## FEATURES
- multiply and add effitiently matrices
- support matrices of dimentions from 1x1 to 4x4 (can also be non ssquare matrices)
- configurable parameter size: BUS_WITH, ADRESS_WIDTH, DATA_WIDTH, SP_NTARGETS(ammount of matrices stored in sp memory)
- can be connected and controlled from a AMBA bus


## MODULE COMPONENTS
- adder.v : component that adds two matrices
- apb_slave.v : apb slave for communicating with other devices
- arithmetic_block : a single element of the systolic array capable of multiplication and accumulation
- buffers.v : the component that responsible to feed the data to the systolic array
- control.v : the control component responsible for the fsm and sending control signals for the other components
- matmul.v : the top module
- memory.v : is where the registers and oparators are kept
- scratchpad.v : is where the result matrices are saved
- systolic_array.v : the component responsible for the marix multiplication


## VERIFICATION COMPONENTS
- matmul_checker.sv : verifies the signal behavior and relationship in the design
- matmul_coverage.sv : checks the covarage of all module signals
- matmul_golden.sv : compare and save the golden model results and the DUT results
- mamul_int.sv : the interface of the system
- matmul_stimulus.sv : feeds the inputs into the DUT
- matmul_tb.sv : the top level test bench for the verification process
- golden_model_big.py : the reference golden model
- generate_random_big.py : generates random inputs for the stimulus and golden model


## CONFIGURATION
- BUS_WIDTH: Width of the data bus connecting to the accelerator
- DATA_WIDTH: Width of each data element in the matrices
- ADDR_WIDTH: Width of the address bus for memory access
- SP_NTARGETS: Number of targets in the scratchpad memory


## MATMUL BLOCK DIAGRAM
![image](https://github.com/theLazyProgrammer-Assafsof/Matrix-multiplication-hardware-accelerator-using-systolic-array/assets/25639834/3b0bdc4a-feb7-471d-a820-5ca72cc0b514)

## MATMUL PORTS
- ![image](https://github.com/theLazyProgrammer-Assafsof/Matrix-multiplication-hardware-accelerator-using-systolic-array/assets/25639834/567c81bb-bfda-4bd9-b3af-ce93dc36dea1)
## VERIFICATION BLOCK DIAGRAM
![image](https://github.com/theLazyProgrammer-Assafsof/Matrix-multiplication-hardware-accelerator-using-systolic-array/assets/25639834/9731dc39-7d8e-4231-b80a-b6651b03be16)

## WORK ENVIRONMENT
the project was design using HDL designer 2021 under strict design policies. it was testet using Questasim.
