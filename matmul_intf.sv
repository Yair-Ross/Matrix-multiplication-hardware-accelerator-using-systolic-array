//
// Verilog interface matmulProj_lib.Interface
//
// Created:
//          by - dan9.UNKNOWN (118-18)
//          at - 12:32:19 17/02/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
interface matmul_intf #(parameter DATA_WIDTH = 16, parameter BUS_WIDTH = 64,
	parameter ADDR_WIDTH = 16, localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH,
	parameter SP_NTARGETS = 4)(input logic clk, input logic rst);
	
	
logic psel; // apb select
logic	penable; // apb enable
logic pwrite; // apb write enable
logic	[MAX_DIM-1:0]	pstrb; // apb write strobe (’byte’ select)
logic [BUS_WIDTH-1:0] pwdata; // apb write data
logic [ADDR_WIDTH-1:0] paddr; // apb address 
logic pready; // apb slave ready
logic	pslverr; // apb slave error
logic [BUS_WIDTH-1:0] prdata; // apb read data
logic	busy; // Busy signal, indicating the design cannot be written to

	
// modports declaration

modport stimulus(input clk, rst, output psel, penable, pwrite, pstrb, pwdata, paddr);

modport matmul(input clk, rst, psel, penable, pwrite, pstrb, pwdata, paddr, output pready, pslverr, prdata, busy);

modport functional_checker(input clk, rst, psel, penable, pwrite, pstrb, pwdata, paddr, pready, pslverr, prdata, busy);     	

modport functional_coverage(input clk, rst, psel, penable, pwrite, pstrb, pwdata, paddr, pready, pslverr, prdata, busy);

modport golden_bus(input clk, rst, pready, penable, psel, pwrite, prdata);

endinterface