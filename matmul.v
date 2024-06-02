//
// Verilog Module Multiplexer_Accelarator_lib.matmul
//
// Created:
//          by - rossy.UNKNOWN (SHOHAM)
//          at - 21:10:02 01/30/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps

module matmul(clk_i, rst_ni, psel_i, penable_i, pwrite_i, pstrb_i, pwdata_i, paddr_i, pready_o, pslverr_o, prdata_o, busy_o);

    parameter DATA_WIDTH = 16;
	parameter BUS_WIDTH = 64;
	parameter ADDR_WIDTH = 16;
	localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH;
	parameter SP_NTARGETS = 4;

    input                         clk_i; // Clock signal for the design
    input                         rst_ni; // Reset signal, active low
    input                         psel_i; // APB select
    input						penable_i; // APB enable
    input                         pwrite_i; // APB write enable
    input		   [MAX_DIM-1:0]	pstrb_i; // APB write strobe (’byte’ select)
    input        [BUS_WIDTH-1:0] pwdata_i; // APB write data
    input        [ADDR_WIDTH-1:0] paddr_i; // APB address 
    output wire                    pready_o; // APB slave ready
    output wire					pslverr_o; // APB slave error
    output wire   [BUS_WIDTH-1:0] prdata_o; // APB read data
    output wire					busy_o; // Busy signal, indicating the design cannot be written to

    wire [BUS_WIDTH-1:0] rdata;
    wire [ADDR_WIDTH-1:0] addr;
    wire [BUS_WIDTH-1:0] wdata;
    wire write;
    wire read;
	wire cont_busy;
	wire mem_busy;
	wire [MAX_DIM-1:0] strb;

	wire [BUS_WIDTH-1:0] sp_mat;
	wire [MAX_DIM**2-1:0] flags_adder;
	wire [MAX_DIM**2-1:0] flags_systolic;
	wire write_flag;
	wire modd;
	wire [BUS_WIDTH*MAX_DIM-1:0] operand_A;
	wire [BUS_WIDTH*MAX_DIM-1:0] operand_B;
	wire [SP_NTARGETS/4:0] sp_read_target;
	wire sp_read;
	wire start_FMEM;
	wire [1:0] write_target;
	wire [MAX_DIM-1:0] sp_mat_index;
	wire [1:0] n;
	wire [1:0] k;
	wire [1:0] m;

	wire finish;
	wire start;
	wire read_c;
	wire write_s;
	wire [1:0] read_target_c;
	wire [SP_NTARGETS/4:0] read_target_c_sp;
	wire [SP_NTARGETS/4:0] write_target_sp;

	wire [MAX_DIM*DATA_WIDTH-1:0] left;
	wire [MAX_DIM*DATA_WIDTH-1:0] up;

	wire [(BUS_WIDTH*(MAX_DIM**2))-1:0] mul;
  

    wire [(BUS_WIDTH*(MAX_DIM**2))-1:0] operand_c;
    wire [(BUS_WIDTH*(MAX_DIM**2))-1:0] res;

  

	apb_slave #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
     .SP_NTARGETS(SP_NTARGETS))
    apb(.clk_i(clk_i), .rst_ni(rst_ni), .psel_i(psel_i), .penable_i(penable_i), .pwrite_i(pwrite_i), .pstrb_i(pstrb_i),
    .pwdata_i(pwdata_i), .paddr_i(paddr_i), .rdata_i(rdata), .cont_busy_i(cont_busy), .mem_busy_i(mem_busy), .pready_o(pready_o), .pslverr_o(pslverr_o),
    .prdata_o(prdata_o), .busy_o(busy_o), .addr_o(addr), .wdata_o(wdata), .write_o(write), .read_o(read), .strb_o(strb));

	memory #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		mem(.clk_i(clk_i), .rst_ni(rst_ni), .sp_mat_i(sp_mat), .addr_i(addr), .read_i(read), .write_i(write), .wdata_i(wdata),
		.flags_adder_i(flags_adder), .flags_systolic_i(flags_systolic), .write_flag_i(write_flag), .strb_i(strb), .rdata_o(rdata),
		.mod_o(modd), .sp_read_o(sp_read), .sp_read_target_o(sp_read_target), .operand_A_o(operand_A), .operand_B_o(operand_B),
		.start_FMEM_o(start_FMEM), .write_target_o(write_target), .read_target_c_o(read_target_c), .sp_mat_index_o(sp_mat_index),
		.n_o(n), .k_o(k), .m_o(m), .mem_busy_o(mem_busy));

	control #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		cont(.clk_i(clk_i), .rst_ni(rst_ni), .start_FMEM_i(start_FMEM), .mod_i(modd), .finish_i(finish), .write_target_i(write_target),
		.read_target_c_i(read_target_c), .start_o(start), .read_c_o(read_c), .read_target_c_o(read_target_c_sp),
		.write_o(write_s), .write_target_o(write_target_sp), .write_flag_o(write_flag), .cont_busy_o(cont_busy));

	buffers #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		buff(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start), .operand_A_i(operand_A), .operand_B_i(operand_B),
		.n_i(n), .k_i(k), .m_i(m), .left_o(left), .up_o(up));

	systolic_array #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		sys_arr(.clk_i(clk_i), .rst_ni(rst_ni), .start_i(start), .left_i(left), .up_i(up), .mul_o(mul),
		.flags_systolic_o(flags_systolic), .finish_o(finish));

	adder #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		ad(.mul_i(mul), .mod_i(modd), .operand_c_i(operand_c), .flags_adder_o(flags_adder), .res_o(res));

	scratchpad #(.DATA_WIDTH(DATA_WIDTH), .BUS_WIDTH(BUS_WIDTH), .ADDR_WIDTH(ADDR_WIDTH),
		 .SP_NTARGETS(SP_NTARGETS))
		sp(.clk_i(clk_i), .rst_ni(rst_ni), .write_sp_i(write_s), .res_i(res), .read_target_c_sp_i(read_target_c_sp),
		.write_target_sp_i(write_target_sp), .read_c_i(read_c), .sp_read_i(sp_read), .sp_mat_index_i(sp_mat_index),
		.sp_read_target_i(sp_read_target), .operand_c_o(operand_c), .sp_mat_o(sp_mat));



// ### Please start your Verilog code here ### 

endmodule
