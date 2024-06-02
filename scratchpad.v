//
// Verilog Module Multiplexer_Accelarator_lib.scratchpad
//
// Created:
//          by - rossy.UNKNOWN (SHOHAM)
//          at - 13:42:24 01/19/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps


module scratchpad (clk_i, rst_ni, write_sp_i, res_i, read_target_c_sp_i, write_target_sp_i, read_c_i, sp_read_i,
sp_mat_index_i, sp_read_target_i, operand_c_o, sp_mat_o);

   // PARAMERES
	parameter DATA_WIDTH = 16; // width of the data BUS in bits
	parameter BUS_WIDTH = 64; // width of the BUS in bits
	parameter ADDR_WIDTH = 8; // width of addres BUS in bits
	localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; // max dimension of the matrix
	parameter SP_NTARGETS = 4; // number of optionally matrix targets in ScratchPad 

	input wire clk_i; // clock
	input wire rst_ni; // reset
	input wire write_sp_i; // signal from the control that indicates to write to the ScratchPad
	
	input wire [(BUS_WIDTH*(MAX_DIM**2))-1:0] res_i; // result from the Adder module that need to be strored in the ScratchPad

	input wire [SP_NTARGETS/4:0] read_target_c_sp_i; // matrix read target from ScratchPad to matrix C 
	input wire [SP_NTARGETS/4:0] write_target_sp_i; // matrix write target to ScratchPad from the Adder module
	input wire read_c_i; // signal from the control module that indicates to read matrix C from the ScratchPad

	input wire [SP_NTARGETS/4:0] sp_read_target_i; // matrix read target from ScratchPad to memory_decoder module 
	input wire sp_read_i; // signal from the memory_decoder module that indicates to read matrix from the ScratchPad to the memory_decoder
	input wire [MAX_DIM-1:0] sp_mat_index_i;

	output reg [(BUS_WIDTH*(MAX_DIM**2))-1:0] operand_c_o; // matrix c - suppose to get added with the systolic array output when mod bit is set

	output reg [BUS_WIDTH-1:0] sp_mat_o; // element of chosen matrix that goes to the memory_decoder module


	// BUS_WIDTH determenis the width of a single element in a matrix
	// SP_NTARGETS determines the number of rows (number of matrixes)
	reg [BUS_WIDTH-1:0] matrixes [SP_NTARGETS-1:0][MAX_DIM**2-1:0];


	integer i; // index i
	integer j; // index j
	


	generate
	case(SP_NTARGETS)
	4: begin

	always @(posedge clk_i or negedge rst_ni) begin: MAT_ARR
    if (!rst_ni) begin
        for (i = 0; i < SP_NTARGETS; i = i + 1) begin
            for (j = 0; j < MAX_DIM**2; j = j + 1) begin
                matrixes[i][j] <= 0; // clear all the matrixes that exists in ScratchPad
            end
        end
        operand_c_o <= 0; // clear the output of matrix C 
    end
    else begin
        // for this write conditions - transfer the result matrix (Adder result) to its dedicated target
		if(write_sp_i && write_target_sp_i == 2'b00) for (i=0; i<MAX_DIM**2; i=i+1) matrixes[0][i] <= res_i[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH];
		// for this write conditions - transfer the result matrix (Adder result) to its dedicated target
		if(write_sp_i && write_target_sp_i == 2'b01) for (i=0; i<MAX_DIM**2; i=i+1) matrixes[1][i] <= res_i[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH];
		// for this write conditions - transfer the result matrix (Adder result) to its dedicated target
		if(write_sp_i && write_target_sp_i == 2'b10) for (i=0; i<MAX_DIM**2; i=i+1) matrixes[2][i] <= res_i[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH];
		// for this write conditions - transfer the result matrix (Adder result) to its dedicated target
		if(write_sp_i && write_target_sp_i == 2'b11) for (i=0; i<MAX_DIM**2; i=i+1) matrixes[3][i] <= res_i[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH];
		
		if(read_c_i) begin
		case(read_target_c_sp_i)
			// for this read conditions - transfer the chosen matrix from the ScratchPad to the operand C matrix
			2'b00 : for (i=0; i<MAX_DIM**2; i=i+1) operand_c_o[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH] <= matrixes[0][i];
			// for this read conditions - transfer the chosen matrix from the ScratchPad to the operand C matrix
			2'b01 : for (i=0; i<MAX_DIM**2; i=i+1) operand_c_o[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH] <= matrixes[1][i];
			// for this read conditions - transfer the chosen matrix from the ScratchPad to the operand C matrix
			2'b10 : for (i=0; i<MAX_DIM**2; i=i+1) operand_c_o[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH] <= matrixes[2][i];
			// for this read conditions - transfer the chosen matrix from the ScratchPad to the operand C matrix
			2'b11 : for (i=0; i<MAX_DIM**2; i=i+1) operand_c_o[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH] <= matrixes[3][i];
			default : for (i=0; i<MAX_DIM**2; i=i+1) operand_c_o[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH] <= 0;
		endcase
		end

    end
	end
	end

	2: begin
		
	always @(posedge clk_i or negedge rst_ni) begin: MAT_ARR
    if (!rst_ni) begin
        for (i = 0; i < SP_NTARGETS; i = i + 1) begin
            for (j = 0; j < MAX_DIM**2; j = j + 1) begin
                matrixes[i][j] <= 0; // clear all the matrixes that exists in ScratchPad
            end
        end
        operand_c_o <= 0; // clear the output of matrix C 
		//sp_mat_o <= 0; // clear the output element that transfers to the memory_decoder module
    end
    else begin
        // for this write conditions - transfer the result matrix (Adder result) to its dedicated target
		if(write_sp_i && write_target_sp_i == 1'b0) for (i=0; i<MAX_DIM**2; i=i+1) matrixes[0][i] <= res_i[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH];
		// for this write conditions - transfer the result matrix (Adder result) to its dedicated target
		if(write_sp_i && write_target_sp_i == 1'b1) for (i=0; i<MAX_DIM**2; i=i+1) matrixes[1][i] <= res_i[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH];
		
		if(read_c_i) begin
		case(read_target_c_sp_i)
			// for this read conditions - transfer the chosen matrix from the ScratchPad to the operand C matrix
			1'b0 : for (i=0; i<MAX_DIM**2; i=i+1) operand_c_o[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH] <= matrixes[0][i];
			// for this read conditions - transfer the chosen matrix from the ScratchPad to the operand C matrix
			1'b1 : for (i=0; i<MAX_DIM**2; i=i+1) operand_c_o[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH] <= matrixes[1][i];
			
			default : for (i=0; i<MAX_DIM**2; i=i+1) operand_c_o[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH] <= 0;
		endcase
		end
		
    end
	end
	end

	default: begin
		
	always @(posedge clk_i or negedge rst_ni) begin: MAT_ARR
    if (!rst_ni) begin
        for (i = 0; i < SP_NTARGETS; i = i + 1) begin
            for (j = 0; j < MAX_DIM**2; j = j + 1) begin
                matrixes[i][j] <= 0; // clear all the matrixes that exists in ScratchPad
            end
        end
        operand_c_o <= 0; // clear the output of matrix C 
		//sp_mat_o <= 0; // clear the output element that transfers to the memory_decoder module
    end
    else begin
        if(write_sp_i && write_target_sp_i == 1'b0) for (i=0; i<MAX_DIM**2; i=i+1) matrixes[0][i] <= res_i[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH];
		if(read_c_i) begin
				case(read_target_c_sp_i)
					1'b0 : for (i=0; i<MAX_DIM**2; i=i+1) operand_c_o[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH] <= matrixes[0][i];
					default : for (i=0; i<MAX_DIM**2; i=i+1) operand_c_o[(BUS_WIDTH*(i+1))-1 -:BUS_WIDTH] <= 0;
				endcase
				end
				
    end
	end
	end

endcase
endgenerate

generate
case(SP_NTARGETS)

4: begin 
always @*  
begin:SP_READ4
	sp_mat_o = 0;
	if(sp_read_i) begin
		case(sp_read_target_i)
			2'b00 : sp_mat_o = matrixes[0][sp_mat_index_i];
			2'b01 : sp_mat_o = matrixes[1][sp_mat_index_i];
			2'b10 : sp_mat_o = matrixes[2][sp_mat_index_i];
			2'b11 : sp_mat_o = matrixes[3][sp_mat_index_i];
			default : sp_mat_o = 0;
		endcase
	end
end
end

2: begin 
always @*  
begin:SP_READ2
	sp_mat_o = 0;
	if(sp_read_i) begin
		case(sp_read_target_i)
			1'b0 : sp_mat_o = matrixes[0][sp_mat_index_i];
			1'b1 : sp_mat_o = matrixes[1][sp_mat_index_i];
			default : sp_mat_o = 0;
		endcase
	end
end
end

default: begin 
always @*  
begin:SP_READ1
	sp_mat_o = 0;
	if(sp_read_i) begin
		case(sp_read_target_i)
			1'b0 : sp_mat_o = matrixes[0][sp_mat_index_i];
			default : sp_mat_o = 0;
		endcase
	end
end

end
endcase
endgenerate

endmodule