//
// Verilog Module yair_proj_lib.matmul_golden
//
// Created:
//          by - rossy.UNKNOWN (TOMER)
//          at - 12:44:58 02/18/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module matmul_golden #(
    parameter string GOLDEN_PATH = "filepath.txt",
    parameter string DUT_PATH = "filepath.txt",
    parameter DATA_WIDTH = 16,
    parameter BUS_WIDTH = 32,
    parameter ADDR_WIDTH = 16,
    parameter MAX_DIM = (BUS_WIDTH / DATA_WIDTH),
    parameter SP_NTARGETS = 4,
    //localparam res_size = (MAX_DIM**2)*2*30+18+16+17
    localparam res_size = (MAX_DIM**2)*2*30+18
    )
    (
   matmul_intf.golden_bus    gold_intf
   );

    `define NULL 0

    integer data_file_0;
    integer scan_file_0;
    integer data_file_1;
    integer hit = 0;
    integer miss = 0;
    integer error = 0;

    string val;

    reg [BUS_WIDTH-1:0] results [res_size];
    reg [BUS_WIDTH-1:0] current;
    reg [BUS_WIDTH-1:0] size;
    reg [BUS_WIDTH-1:0] count;


    initial
    begin : init_proc
        data_file_0 = $fopen(GOLDEN_PATH, "r");
        if (data_file_0 == `NULL) begin
            $display("golden file is null");
            $finish;
        end

        for (count=0; count <res_size; count=count+1) begin 
            scan_file_0 = $fscanf(data_file_0, "%b\n", results[count]);
        end
        count = 0;
        data_file_1 = $fopen(DUT_PATH, "w");
        if (data_file_0 == `NULL) begin
            $display("DUT result file is null");
            $finish;
        end
        hit = 0;
        miss = 0;
        error = 0;
    end

    always @(negedge gold_intf.clk)
    begin: res_proc
        if(gold_intf.pready && gold_intf.penable && gold_intf.psel && ~gold_intf.pwrite) begin
            current = results[count];
            if(gold_intf.prdata == current) begin
                hit ++;
              end
            else
                begin
                miss ++;
                $display("count:%d, miss: golden %h, matmul %h, at: %t", count, current, gold_intf.prdata, $time);
              end
            $fwrite(data_file_1, "%b\n", gold_intf.prdata);
            if(count < (res_size - 1))
                count ++;
            else begin
                $display("finished with %d hits and %d misses and%d errors", hit, miss, error);
                count = 0;
            end
        end
    end




// ### Please start your Verilog code here ### 

endmodule
