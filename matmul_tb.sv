//
// Verilog Module matmulProj_lib.matmul_tb
//
// Created:
//          by - dan9.UNKNOWN (118-18)
//          at - 20:49:42 17/02/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module matmul_tb #(parameter DATA_WIDTH = 8, parameter BUS_WIDTH = 32,
	parameter ADDR_WIDTH = 16, localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH,
	parameter SP_NTARGETS = 4, localparam MAIN_PATH = "C:\\Users\\rossy\\Downloads\\212404982_207287889\\212404982_207287889\\");
	
	logic clk = 1'b0, rst;
	
matmul_intf #(
    .DATA_WIDTH(DATA_WIDTH),
    .BUS_WIDTH(BUS_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .SP_NTARGETS(SP_NTARGETS)
    )tb(.clk(clk),
      .rst(rst));
      
initial forever 
	#10 clk = ~clk;
// Init reset process
initial begin: TOP_RST
	rst = 1'b0; // Assert reset
	// Reset for RST_CYC cycles
	repeat(2) @(posedge clk);
	rst = 1'b1; // Deassert reset
end      

matmul_stimulus #(
    .FILE_PATH($sformatf("%smat_inputs.txt",MAIN_PATH)),
    .DATA_WIDTH(DATA_WIDTH),
    .BUS_WIDTH(BUS_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MAX_DIM(MAX_DIM),
    .SP_NTARGETS(SP_NTARGETS)
    ) generator(
    .s_intf(tb)
    );	

matmul #(
    .DATA_WIDTH(DATA_WIDTH),
    .BUS_WIDTH(BUS_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .SP_NTARGETS(SP_NTARGETS)
    )dut(
      .clk_i(clk),
      .rst_ni(rst),
      .psel_i(tb.psel),
      .penable_i(tb.penable),
      .pwrite_i(tb.pwrite),
      .pstrb_i(tb.pstrb),
      .pwdata_i(tb.pwdata),
      .paddr_i(tb.paddr),
      .pready_o(tb.pready),
      .pslverr_o(tb.pslverr),
      .prdata_o(tb.prdata),
      .busy_o(tb.busy)
      );
           
matmul_checker #(
    .DATA_WIDTH(DATA_WIDTH),
    .BUS_WIDTH(BUS_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .SP_NTARGETS(SP_NTARGETS)
    )check(
      .checker_bus(tb)
      );
      
matmul_coverage #(
    .DATA_WIDTH(DATA_WIDTH),
    .BUS_WIDTH(BUS_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .SP_NTARGETS(SP_NTARGETS)
    )cov(
      .coverage_bus(tb)
      );            

matmul_golden #(
    .GOLDEN_PATH($sformatf("%sgolden_outputs.txt",MAIN_PATH)),
    .DUT_PATH($sformatf("%smat_outputs.txt",MAIN_PATH)),
    .DATA_WIDTH(DATA_WIDTH),
    .BUS_WIDTH(BUS_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .MAX_DIM(MAX_DIM),
    .SP_NTARGETS(SP_NTARGETS)
    )gold(
      .gold_intf(tb)
      );

endmodule
