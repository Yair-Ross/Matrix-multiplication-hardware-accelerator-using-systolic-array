//
// Verilog Module matmulProj_lib.matmul_checker
//
// Created:
//          by - dan9.UNKNOWN (118-18)
//          at - 19:47:06 17/02/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module matmul_checker #(parameter DATA_WIDTH = 16, parameter BUS_WIDTH = 64,
	parameter ADDR_WIDTH = 16, localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH,
	parameter SP_NTARGETS = 4)
(
  // port declaration
	matmul_intf.functional_checker checker_bus
);



property reset_active;
        @(posedge checker_bus.clk) 
        ~checker_bus.rst |=> ((~checker_bus.pready) &&(~checker_bus.prdata) && (~checker_bus.pslverr)&& (~checker_bus.busy));
				endproperty

assert property(reset_active)
  else $error("Reset error");
  cover property(reset_active);
 
 
  
  
property read_operation_correctness;
    @(posedge checker_bus.clk) disable iff (!checker_bus.rst)
    (checker_bus.psel && checker_bus.penable && (~checker_bus.pwrite)) |-> ##[0:1] (checker_bus.pready || checker_bus.pslverr);
endproperty

assert property(read_operation_correctness)
  else $error("read error");
  cover property(read_operation_correctness);




property write_operation_correctness;
    @(posedge checker_bus.clk) disable iff (!checker_bus.rst)
    (checker_bus.psel && checker_bus.penable && checker_bus.pwrite) |-> ##[0:1](checker_bus.pready || checker_bus.pslverr);
endproperty
  
assert property(write_operation_correctness)
  else $error("write error");
cover property(write_operation_correctness);  
  
  
 

property pready_transition;
  @(posedge checker_bus.clk) disable iff (!checker_bus.rst)
  (checker_bus.pready |-> ##1 (!$stable(checker_bus.pready)));
endproperty

assert property (pready_transition)
  else $error("pready_transition error");
cover property(pready_transition);




property busy_bit;
  @(posedge checker_bus.clk) disable iff (!checker_bus.rst)
  (checker_bus.pready == 1 && checker_bus.pwdata[0] == 1 && checker_bus.paddr == 0) |-> ##1 (checker_bus.busy == 1);
endproperty

assert property (busy_bit)
  else $error("busy error");
cover property(busy_bit);




property valid_output; 
    @(posedge checker_bus.clk) disable iff (!checker_bus.rst)
        (checker_bus.pready && (~checker_bus.pwrite)) |=> checker_bus.prdata inside {[0:(2**BUS_WIDTH-1)]};
endproperty

assert property(valid_output)
  else $error("output not valid");
cover property(valid_output);



property valid_error; 
    @(posedge checker_bus.clk) disable iff (!checker_bus.rst)
        (checker_bus.pslverr) |=> (~checker_bus.pready);
endproperty

assert property(valid_error)
  else $error("still trying to write/read when error");
cover property(valid_error);



endmodule
