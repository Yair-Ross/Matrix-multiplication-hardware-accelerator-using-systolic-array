//
// Verilog Module yair_proj_lib.matmul_stimulus
//
// Created:
//          by - rossy.UNKNOWN (TOMER)
//          at - 17:42:18 02/17/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps
module matmul_stimulus #(
    parameter string FILE_PATH = "path",
    parameter DATA_WIDTH = 16,
    parameter BUS_WIDTH = 32,
    parameter ADDR_WIDTH = 16,
    parameter MAX_DIM = (BUS_WIDTH / DATA_WIDTH),
    parameter SP_NTARGETS = 4
    )
    (
   matmul_intf.stimulus    s_intf
   );
    `define NULL 0

    integer matfile_fd, scan_file;

    wire   clk    = s_intf.clk;
    wire   rst    = s_intf.rst;

    logic  psel_o; 
    logic  penable_o;   
    logic  pwrite_o;
    logic [MAX_DIM-1:0] pstrb_o;   
    logic [ADDR_WIDTH-1:0] paddr_o;
    logic [BUS_WIDTH-1:0] pwdata_o;
    logic [DATA_WIDTH*MAX_DIM-1:0] MAT_A[MAX_DIM-1:0];
    logic [DATA_WIDTH*MAX_DIM-1:0] MAT_B[MAX_DIM-1:0]; 

    logic [BUS_WIDTH-1:0] reg_cont;
    logic [ADDR_WIDTH-1:0] adress_cont;

    integer calc_mod, dest, c, n , k, m;

    task do_reset; begin
        psel_o = 1'b0;
	    penable_o = 1'b0;
	    pwrite_o = 1'b0;
	    pstrb_o = 0;
	    pwdata_o = 0;
	    paddr_o = 0;
        // Open Stimulus files
        open_files(1'b0); // Open file
        wait( !rst ); // Wait for reset to be asserted
        wait( rst ); // Wait for reset to be deasserted
        // Reset done.
    end endtask

    task open_files(input logic reopen); begin
        if( !reopen ) begin
            // First time
            matfile_fd = $fopen(FILE_PATH, "r");
            if(matfile_fd == 0) $fatal(1, $sformatf("Failed to open %s", FILE_PATH));
        end 
    end endtask

    task read_data(input logic first); begin
        if($fscanf(matfile_fd, "%1d%1d%1d%1d%1d%1d\n", calc_mod, dest, c, n, k, m) != 6) begin
            if(first) 
                $fatal(1, "Failed to read n,k,m line of MAT");
        end

            
        for(int i=0;i<MAX_DIM;i=i+1) begin
            if($fscanf(matfile_fd, "%b\n", MAT_A[i]) != 1) 
                $fatal(1, $sformatf("Failed to read the %0dth row of matrix A", i));
            @(posedge clk); 
        end 
        
        for(int i=0;i<MAX_DIM;i=i+1) begin
            if($fscanf(matfile_fd, "%b\n", MAT_B[i]) != 1) 
                $fatal(1, $sformatf("Failed to read the %0dth col of matrix B", i));
            @(posedge clk); 
        end 
        //$fclose(matfile_fd);
        

    end
    endtask
    
    task write_to_apb_slave(input [ADDR_WIDTH-1:0] ad,input [BUS_WIDTH-1:0] data,input [MAX_DIM-1:0] strb);
        begin		
        psel_o = 1'b1;
        pwrite_o = 1'b1;
        pstrb_o = strb;
        pwdata_o = data;
        paddr_o = ad;
        repeat(1) @(posedge clk);
        penable_o = 1'b1;

        repeat(2) @(posedge clk);
        psel_o = 0;
        penable_o = 0;
        pwrite_o = 0;
        pstrb_o = 0;
        pwdata_o = 0;
        paddr_o = 0;
        repeat(1) @(posedge clk);            
        end	  
    endtask
        

    task read_from_apb_slave(input [ADDR_WIDTH-1:0] ad);
    begin
        psel_o = 1'b1;
        pwrite_o = 1'b0;
        pstrb_o = 0;
        paddr_o = ad;
        repeat(1) @(posedge clk);
        penable_o = 1'b1;

        repeat(2) @(posedge clk);
        psel_o = 0;
        penable_o = 0;
        pwrite_o = 0;
        pstrb_o = 0;
        paddr_o = 0;
        repeat(1) @(posedge clk);
    end
    endtask

    task write_reg();
    begin
        reg_cont[0] = 1'b1;
        reg_cont[1] = calc_mod;
        reg_cont[3:2] = dest;
        reg_cont[5:4] = c;
        reg_cont[7:6] = 0;
        reg_cont[9:8] = n;
        reg_cont[11:10] = k;
        reg_cont[13:12] = m;
        reg_cont[BUS_WIDTH-1:14] = 0;
        write_to_apb_slave(0, reg_cont, 1);
    end
    endtask


    initial begin: INIT_STIM
        if(FILE_PATH == "") $fatal(1, "MAT_FILE is not set");
        do_reset();
        for(int r=0;r<30;r=r+1) begin
        read_data(1'b1);
         @(posedge clk); 
       for(int i=0;i<MAX_DIM;i=i+1) begin
         adress_cont = 0;
         adress_cont[4:0]=4;
         adress_cont[MAX_DIM/4+5:5]=i;
         write_to_apb_slave( adress_cont, MAT_A[i], 4'b1111);
   
         end 
        for(int i=0;i<MAX_DIM;i=i+1) begin
         adress_cont = 0;
         adress_cont[4:0]=8;
         adress_cont[MAX_DIM/4+5:5]=i;
         write_to_apb_slave( adress_cont, MAT_B[i], 4'b1111);
 
         end
         write_reg();
         repeat(20) @(posedge clk);
         for (int i=0;i<MAX_DIM**2;i=i+1)
          begin
            adress_cont[4:0]=16+(dest*4);
            adress_cont[MAX_DIM+4:5]=i; 
         read_from_apb_slave(adress_cont);
       end
       
       repeat(3) @(posedge clk);
       
       read_data(1'b1);
         @(posedge clk); 
       for(int i=0;i<MAX_DIM;i=i+1) begin
         adress_cont = 0;
         adress_cont[4:0]=4;
         adress_cont[MAX_DIM/4+5:5]=i;
         write_to_apb_slave( adress_cont, MAT_A[i], 4'b1111);

         end 
        for(int i=0;i<MAX_DIM;i=i+1) begin
         adress_cont = 0;
         adress_cont[4:0]=8;
         adress_cont[MAX_DIM/4+5:5]=i;
         write_to_apb_slave( adress_cont, MAT_B[i], 4'b1111);
  
         end
         write_reg();
          write_to_apb_slave(16'h0008,777, 4'b1111);
         repeat(20) @(posedge clk);
         for (int i=0;i<MAX_DIM**2;i=i+1)
          begin
            adress_cont[4:0]=16+(dest*4);
            adress_cont[MAX_DIM+4:5]=i; 
         read_from_apb_slave(adress_cont);
       end
       repeat(4) @(posedge clk);
        end

        read_data(1'b1);
         @(posedge clk); 
       for(int i=0;i<MAX_DIM;i=i+1) begin
         adress_cont = 0;
         adress_cont[4:0]=4;
         adress_cont[MAX_DIM/4+5:5]=i;
         write_to_apb_slave( adress_cont, MAT_A[i], 4'b1111);
       
         end 
        for(int i=0;i<MAX_DIM;i=i+1) begin
         adress_cont = 0;
         adress_cont[4:0]=8;
         adress_cont[MAX_DIM/4+5:5]=i;
         write_to_apb_slave( adress_cont, MAT_B[i], 4'b1111);
    
         end
         write_reg();
         repeat(20) @(posedge clk);
         for (int i=0;i<MAX_DIM**2;i=i+1)
          begin
            adress_cont[4:0]=16+(dest*4);
            adress_cont[MAX_DIM+4:5]=i; 
         read_from_apb_slave(adress_cont);
       end

       repeat(4) @(posedge clk);
       
       adress_cont = 0;
        adress_cont[4:0]=8;
        write_to_apb_slave( adress_cont, 32'h22222222, 4'b1111);
        adress_cont = 0;
        adress_cont[4:0]=8;
        write_to_apb_slave( adress_cont, 32'hffffffff, 4'b0011);
        adress_cont = 0;
        adress_cont[4:0]=8;
        read_from_apb_slave(adress_cont);
       
       
       
       repeat(4) @(posedge clk);

        adress_cont[4:0]=12;
        adress_cont[MAX_DIM+4:5]=0; 
         read_from_apb_slave(adress_cont);
       
       repeat(4) @(posedge clk);
       
       //flag check very long
       /*
       read_data(1'b1);
         @(posedge clk); 
       for(int i=0;i<MAX_DIM;i=i+1) begin
         adress_cont = 0;
         adress_cont[4:0]=4;
         adress_cont[MAX_DIM/4+5:5]=i;
         write_to_apb_slave( adress_cont, MAT_A[i], 4'b1111);
         // @(posedge clk); 
         //@(posedge clk); 
         end 
        for(int i=0;i<MAX_DIM;i=i+1) begin
         adress_cont = 0;
         adress_cont[4:0]=8;
         adress_cont[MAX_DIM/4+5:5]=i;
         write_to_apb_slave( adress_cont, MAT_B[i], 4'b1111);
         // @(posedge clk); 
         //@(posedge clk); 
         end
         write_reg();
          //write_to_apb_slave('h04,'h06, 4'b1111);
         repeat(20) @(posedge clk);
         for (int i=0;i<MAX_DIM**2;i=i+1)
          begin
            adress_cont[4:0]=16+(dest*4);
            adress_cont[MAX_DIM+4:5]=i; 
         read_from_apb_slave(adress_cont);
       end
         
        read_data(1'b1);
        
       for(int r=0;r<32768;r=r+1) begin
           @(posedge clk); 
         for(int i=0;i<MAX_DIM;i=i+1) begin
           adress_cont = 0;
           adress_cont[4:0]=4;
           adress_cont[MAX_DIM/4+5:5]=i;
           write_to_apb_slave( adress_cont, MAT_A[i], 4'b1111);
           // @(posedge clk); 
           //@(posedge clk); 
           end 
          for(int i=0;i<MAX_DIM;i=i+1) begin
           adress_cont = 0;
           adress_cont[4:0]=8;
           adress_cont[MAX_DIM/4+5:5]=i;
           write_to_apb_slave( adress_cont, MAT_B[i], 4'b1111);
           // @(posedge clk); 
           //@(posedge clk); 
           end
           write_reg();
            //write_to_apb_slave('h04,'h06, 4'b1111);
           repeat(20) @(posedge clk);
           //$display("%d",r);
       end
       for (int i=0;i<MAX_DIM**2;i=i+1)
          begin
            adress_cont[4:0]=16+(dest*4);
            adress_cont[MAX_DIM+4:5]=i; 
         read_from_apb_slave(adress_cont);
       end
       adress_cont[4:0]=12;
        adress_cont[MAX_DIM+4:5]=0; 
         read_from_apb_slave(adress_cont);
         */
       $fclose(matfile_fd);
       
       
    end 


assign s_intf.psel = psel_o; 
assign s_intf.penable = penable_o;   
assign s_intf.pwrite = pwrite_o;
assign s_intf.pstrb = pstrb_o;   
assign s_intf.paddr = paddr_o;
assign s_intf.pwdata = pwdata_o;

endmodule
