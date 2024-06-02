//
// Verilog Module Multiplexer_Accelarator_lib.systolic_arr
//
// Created:
//          by - rossy.UNKNOWN (SHOHAM)
//          at - 13:07:19 01/20/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps


module systolic_array(clk_i, rst_ni ,start_i , left_i, up_i, mul_o, flags_systolic_o, finish_o);

    // PARAMERES
	parameter DATA_WIDTH = 16; // width of the data BUS in bits
	parameter BUS_WIDTH = 64; // width of the BUS in bits
	parameter ADDR_WIDTH = 8; // width of addres BUS in bits
	localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; // max dimension of the matrix
	parameter SP_NTARGETS = 4; // number of optionally matrix targets in ScratchPad
	localparam COMP_TIME = 5+(MAX_DIM/4)*7;

	input wire clk_i; // clock 
	input wire rst_ni; // reset
	input wire start_i; // start bit
	
	input wire [MAX_DIM*DATA_WIDTH-1:0] left_i; // input element of matrix A all rows
	
	input wire [MAX_DIM*DATA_WIDTH-1:0] up_i; // input element of matrix B (column 0)
	
	output wire [(BUS_WIDTH*(MAX_DIM**2))-1:0] mul_o; // concatenataion of all the arithmetic blocks results

	output wire [MAX_DIM**2-1:0] flags_systolic_o; // // concatenataion of all the arithmetic blocks carries
	
	output reg finish_o; // finish bit - connected to the control
	
	reg [3:0] counter; // counter of cycles of all the multiply operation 
	
	wire [BUS_WIDTH-1:0] res [MAX_DIM**2-1:0];
	wire [DATA_WIDTH-1:0] right [MAX_DIM**2-1:0];
	wire [DATA_WIDTH-1:0] down [MAX_DIM**2-1:0];


	generate
	case(MAX_DIM)
	// in case of the dimension of the matrixes is 4*4
	4: begin
		// associate the aritmetic block 0 to the systolic array
	    aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe0(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(left_i[DATA_WIDTH-1:0]),
		.up_operand_i(up_i[DATA_WIDTH-1:0]), .right_operand_o(right[0]), .down_operand_o(down[0]), .res_o(res[0]),
		.carry_o(flags_systolic_o[0]));
		// associate the aritmetic block 1 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe1(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[0]),
		.up_operand_i(up_i[2*DATA_WIDTH-1:DATA_WIDTH]), .right_operand_o(right[1]), .down_operand_o(down[1]), .res_o(res[1]),
		.carry_o(flags_systolic_o[1]));
		// associate the aritmetic block 2 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe2(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[1]),
		.up_operand_i(up_i[3*DATA_WIDTH-1:2*DATA_WIDTH]), .right_operand_o(right[2]), .down_operand_o(down[2]), .res_o(res[2]),
		.carry_o(flags_systolic_o[2]));
		// associate the aritmetic block 3 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe3(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[2]),
		.up_operand_i(up_i[4*DATA_WIDTH-1:3*DATA_WIDTH]), .right_operand_o( ), .down_operand_o(down[3]), .res_o(res[3]),
		.carry_o(flags_systolic_o[3]));
		// associate the aritmetic block 4 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe4(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(left_i[2*DATA_WIDTH-1:DATA_WIDTH]),
		.up_operand_i(down[0]), .right_operand_o(right[4]), .down_operand_o(down[4]), .res_o(res[4]),
		.carry_o(flags_systolic_o[4]));
		// associate the aritmetic block 5 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe5(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[4]),
		.up_operand_i(down[1]), .right_operand_o(right[5]), .down_operand_o(down[5]), .res_o(res[5]),
		.carry_o(flags_systolic_o[5]));
		// associate the aritmetic block 6 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe6(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[5]),
		.up_operand_i(down[2]), .right_operand_o(right[6]), .down_operand_o(down[6]), .res_o(res[6]),
		.carry_o(flags_systolic_o[6]));
		// associate the aritmetic block 7 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe7(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[6]),
		.up_operand_i(down[3]), .right_operand_o( ), .down_operand_o(down[7]), .res_o(res[7]),
		.carry_o(flags_systolic_o[7]));
		// associate the aritmetic block 8 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe8(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(left_i[3*DATA_WIDTH-1:2*DATA_WIDTH]),
		.up_operand_i(down[4]), .right_operand_o(right[8]), .down_operand_o(down[8]), .res_o(res[8]),
		.carry_o(flags_systolic_o[8]));
		// associate the aritmetic block 9 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe9(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[8]),
		.up_operand_i(down[5]), .right_operand_o(right[9]), .down_operand_o(down[9]), .res_o(res[9]),
		.carry_o(flags_systolic_o[9]));
		// associate the aritmetic block 10 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe10(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[9]),
		.up_operand_i(down[6]), .right_operand_o(right[10]), .down_operand_o(down[10]), .res_o(res[10]),
		.carry_o(flags_systolic_o[10]));
		// associate the aritmetic block 11 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe11(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[10]),
		.up_operand_i(down[7]), .right_operand_o( ), .down_operand_o(down[11]), .res_o(res[11]),
		.carry_o(flags_systolic_o[11]));
		// associate the aritmetic block 12 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe12(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(left_i[4*DATA_WIDTH-1:3*DATA_WIDTH]),
		.up_operand_i(down[8]), .right_operand_o(right[12]), .down_operand_o( ), .res_o(res[12]),
		.carry_o(flags_systolic_o[12]));
		// associate the aritmetic block 13 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe13(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[12]),
		.up_operand_i(down[9]), .right_operand_o(right[13]), .down_operand_o( ), .res_o(res[13]),
		.carry_o(flags_systolic_o[13]));
		// associate the aritmetic block 14 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe14(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[13]),
		.up_operand_i(down[10]), .right_operand_o(right[14]), .down_operand_o( ), .res_o(res[14]),
		.carry_o(flags_systolic_o[14]));
		// associate the aritmetic block 15 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe15(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[14]),
		.up_operand_i(down[11]), .right_operand_o( ), .down_operand_o( ), .res_o(res[15]),
		.carry_o(flags_systolic_o[15]));
	end
	// in case of the dimension of the matrixes is 2*2
	2:
	begin
		// associate the aritmetic block 0 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe0(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(left_i[DATA_WIDTH-1:0]),
		.up_operand_i(up_i[DATA_WIDTH-1:0]), .right_operand_o(right[0]), .down_operand_o(down[0]), .res_o(res[0]),
		.carry_o(flags_systolic_o[0]));
		// associate the aritmetic block 1 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe1(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[0]),
		.up_operand_i(up_i[2*DATA_WIDTH-1:DATA_WIDTH]), .right_operand_o( ), .down_operand_o(down[1]), .res_o(res[1]),
		.carry_o(flags_systolic_o[1]));
		// associate the aritmetic block 2 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe2(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(left_i[2*DATA_WIDTH-1:DATA_WIDTH]),
		.up_operand_i(down[0]), .right_operand_o(right[2]), .down_operand_o( ), .res_o(res[2]),
		.carry_o(flags_systolic_o[2]));
		// associate the aritmetic block 3 to the systolic array
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe3(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(right[2]),
		.up_operand_i(down[1]), .right_operand_o( ), .down_operand_o( ), .res_o(res[3]),
		.carry_o(flags_systolic_o[3]));
	end
	// in case of the dimension of the matrixes is 1*1
	default
	begin
		aritmetic_block #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		pe0(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start_i), .left_operand_i(left_i[DATA_WIDTH-1:0]),
		.up_operand_i(up_i[DATA_WIDTH-1:0]), .right_operand_o( ), .down_operand_o( ), .res_o(res[0]),
		.carry_o(flags_systolic_o[0]));
	end
	endcase
	endgenerate

	
	always @(posedge clk_i or negedge rst_ni) begin: SYS_ARR
		if(!rst_ni)
		begin
			counter <= 0; // clear the counter of the cycles of the multiply operation 
			finish_o <= 0; // clear the finish output indicator
		end
		else
		begin
			if(start_i)
			begin
				counter <= 0;
				finish_o <= 0;
			end
			else
			begin
				if(counter == COMP_TIME) // end of operation
				begin
					counter <= 0; // reset the counter
					finish_o <= 1; // finish bit is set
				end
				else
				begin
					counter <= counter + 1; // another cycle is ended
					finish_o <= 0; // not finish yet
				end
			end
		end
	end


genvar i;
generate
	for(i=0; i<MAX_DIM**2; i=i+1)
		assign mul_o[(i+1)*BUS_WIDTH-1 -:BUS_WIDTH] = res[i];
endgenerate

endmodule




