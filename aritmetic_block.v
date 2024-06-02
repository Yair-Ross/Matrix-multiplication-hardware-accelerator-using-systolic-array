//
// Verilog Module Multiplexer_Accelarator_lib.aritmetic_block
//
// Created:
//          by - rossy.UNKNOWN (SHOHAM)
//          at - 12:52:41 01/19/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module aritmetic_block (clk_i, rst_ni, start_i, left_operand_i,
 up_operand_i, right_operand_o, down_operand_o, res_o, carry_o);

   // PARAMERES
	parameter DATA_WIDTH = 16; // width of the data BUS in bits
	parameter BUS_WIDTH = 64; // width of the BUS in bits
	parameter ADDR_WIDTH = 8; // width of addres BUS in bits
	localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; // max dimension of the matrix
	parameter SP_NTARGETS = 4; // number of optionally matrix targets in ScratchPad 
    
	// inputs
	input wire clk_i; // clock
	input wire rst_ni; //reset 
	input wire start_i; // start bit
	input wire signed [DATA_WIDTH-1:0] left_operand_i; // left input to PE
	input wire signed [DATA_WIDTH-1:0] up_operand_i; // up input to PE

    // outputs
	output reg signed [DATA_WIDTH-1:0] right_operand_o; // right output to PE
	output reg signed [DATA_WIDTH-1:0] down_operand_o; // down output to PE
	output wire signed [BUS_WIDTH-1:0] res_o; // sum of 4 nums can cause a carry of 2 digits
	output wire carry_o; // the output carry of the PE 
	wire signed [BUS_WIDTH-1:0] temp_mul; //temporary variable that saves the multiply result
	wire signed [BUS_WIDTH-1:0] temp_add;
	reg signed [BUS_WIDTH-1:0] temp_res;
	reg current_carry;


	always @(posedge clk_i or negedge rst_ni) begin: PE_BLOCK
		if(!rst_ni)
		begin
			temp_res <= 0;  // reset the result of PE element
			right_operand_o <= 0; // reset the right output of the PE 
			down_operand_o <= 0; // reset the down output of the PE
			current_carry <= 0;
		end 
		else 
		begin
			if(start_i)
			begin
				temp_res <= 0; // reset the result of PE element
				right_operand_o <= 0; // reset the right output of the PE
				down_operand_o <= 0; // reset the down output of the PE
				current_carry <= 0;
			end
			else
			begin
				temp_res <= temp_add;
				right_operand_o <= left_operand_i; // transfer the input to this PE to the next PE
				down_operand_o <= up_operand_i; // transfer the input to this PE to the next PE
				current_carry <= ((~temp_mul[BUS_WIDTH-1] & ~temp_res[BUS_WIDTH-1] & temp_add[BUS_WIDTH-1]) | (temp_mul[BUS_WIDTH-1] & temp_res[BUS_WIDTH-1] & ~temp_add[BUS_WIDTH-1]) | current_carry);
			end
		end
	end
	assign temp_mul = left_operand_i * up_operand_i; // multiply the inputs
	assign res_o = temp_res[BUS_WIDTH-1:0];
	assign carry_o = current_carry;
	assign temp_add = temp_res + temp_mul;
endmodule