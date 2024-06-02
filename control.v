//
// Verilog Module Multiplexer_Accelarator_lib.Mul_Cont
//
// Created:
//          by - rossy.UNKNOWN (SHOHAM)
//          at - 17:53:18 01/20/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps


module control (clk_i, rst_ni, start_FMEM_i, mod_i, finish_i, write_target_i,
read_target_c_i, start_o, read_c_o, read_target_c_o, write_o, write_target_o, write_flag_o, cont_busy_o);

	parameter DATA_WIDTH = 32;
	parameter BUS_WIDTH = 64;
	parameter ADDR_WIDTH = 16;
	localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH;
	parameter SP_NTARGETS = 4;

	parameter [2:0] IDLE = 3'b000,
					MUL_START = 3'b001,
					MUL_FINISH = 3'b010,
					ADD_C = 3'b011,
					SP_WRITE = 3'b100;


	input wire clk_i;
	input wire rst_ni;
	
	input wire mod_i;
	input wire start_FMEM_i;
	input wire finish_i;

	input wire [1:0] write_target_i;
	input wire [1:0] read_target_c_i;

	output wire start_o;
	output wire read_c_o;
	output wire write_o;

	output wire [SP_NTARGETS/4:0] read_target_c_o;
	output wire [SP_NTARGETS/4:0] write_target_o;

	output wire write_flag_o;
	output wire cont_busy_o;


	reg [2:0] current_state;
	reg [2:0] next_state;

	reg [8:0] out_sigs;//0 start_o, 1 read_c_o, 2-3 read_target_c_o, 4-5 write_target_o, 6 write_o, 7 write_flag_o, 8 busy
	reg [8:0] next_out_sigs;
	
	
	integer i;
	always @(posedge clk_i or negedge rst_ni) begin: CONT
		if(!rst_ni)
		begin
			current_state <= 0;
			out_sigs <= 0;
		end
		else
		begin
			current_state <= next_state;
			out_sigs <= next_out_sigs;
		end
	end


	
	always @(*) begin: CONTROL_FSM
		next_out_sigs = 9'b000000000;
		next_state = IDLE;
		case(current_state)
			IDLE: 
			begin
				next_out_sigs = 9'b00000000; 	//write_o = 0;
				if(start_FMEM_i) 
					next_state = MUL_START;
			end

			MUL_START:
			begin
				next_out_sigs = 9'b100000001; 	 //start_o = 1;
				next_state = MUL_FINISH;
			end
			
			MUL_FINISH: 
			begin
				next_out_sigs = 9'b100000000; // disable all signals in FSM
				if(finish_i)
				begin
					if(mod_i) 
						next_state = ADD_C;
					else 
						next_state = SP_WRITE;
				end
				else
					next_state = MUL_FINISH;
			end
			
			ADD_C: 
			begin
				next_out_sigs[1:0] = 2'b10; //read_c_o = 1, start_o = 0
				next_out_sigs[3:2] = read_target_c_i; // read_target_c_o = read_target_c_i
				next_out_sigs[8:4] = 5'b10000; //write_flag_o = 0, write_o = 0, write_target_o = 0 
				next_state = SP_WRITE;
			end

			SP_WRITE: 
			begin
				next_out_sigs[3:0] = 4'b0000; // start_o = 0, read_c_o = 0, read_target_c_o = 0
				next_out_sigs[5:4] = write_target_i; // write_target_o = write_target_i
				next_out_sigs[8:6] = 3'b111; //write_flag_o = 1, write_o = 1
				next_state = IDLE;				
			end

			
			default : 
			begin
				next_state = IDLE;
				next_out_sigs = 9'b000000000;
			end

		endcase
	end


	assign start_o = out_sigs[0];
	assign read_c_o = out_sigs[1];

	case(SP_NTARGETS)
	4: assign read_target_c_o = out_sigs[3:2];
	default: assign read_target_c_o = out_sigs[2];
	endcase

	case(SP_NTARGETS)
	4: assign write_target_o = out_sigs[5:4];
	default: assign write_target_o = out_sigs[4];
	endcase

	assign write_o = out_sigs[6];
	assign write_flag_o = out_sigs[7];
	assign cont_busy_o = out_sigs[8];

endmodule
