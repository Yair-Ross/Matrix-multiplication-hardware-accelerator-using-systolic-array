`timescale 1ns/1ps
`define IDLE_SLAVE    2'b00
`define ENEBLE_SLAVE  2'b01
`define WRITE_INSIDE  2'b10
`define READ_OUT      2'b11
module apb_slave(clk_i, rst_ni, psel_i, penable_i, pwrite_i, pstrb_i, pwdata_i, 
paddr_i, rdata_i, cont_busy_i, mem_busy_i, pready_o, pslverr_o, prdata_o, busy_o, addr_o, wdata_o, write_o, read_o, strb_o);

  parameter DATA_WIDTH = 16;
	parameter BUS_WIDTH = 64;
	parameter ADDR_WIDTH = 16;
	localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH;
	parameter SP_NTARGETS = 4;
  

  input                         clk_i; // Clock signal for the design
  input                         rst_ni; // Reset signal, active low
  input                         psel_i; // APB select
  input							penable_i; // APB enable
  input                         pwrite_i; // APB write enable
  input		   [MAX_DIM-1:0]	pstrb_i; // APB write strobe (�byte� select)
  input        [BUS_WIDTH-1:0] pwdata_i; // APB write data
  input        [ADDR_WIDTH-1:0] paddr_i; // APB address
  input        [BUS_WIDTH-1:0] rdata_i;
  input                     cont_busy_i;
  input                     mem_busy_i;  
  output reg                    pready_o; // APB slave ready
  output wire					pslverr_o; // APB slave error
  output wire   [BUS_WIDTH-1:0] prdata_o; // APB read data
  output wire					busy_o; // Busy signal, indicating the design cannot be written to
  output reg   [ADDR_WIDTH-1:0] addr_o;
  output reg   [BUS_WIDTH-1:0] wdata_o;
  output reg                   write_o;
  output reg                   read_o;
  output reg     [MAX_DIM-1:0] strb_o;

reg [1:0] current_state;

always @(posedge clk_i or negedge rst_ni) begin: worker
  if (rst_ni == 0) begin
    current_state <= `IDLE_SLAVE;
    pready_o <= 0;
    write_o <= 0;
    read_o <= 0;
    wdata_o <= 0;
    addr_o <= 0;
    strb_o <= 0;
    end

  else begin
    case (current_state)

      `IDLE_SLAVE : begin
        pready_o <= 0;
        if(psel_i)
          current_state <= `ENEBLE_SLAVE;
      end

      `ENEBLE_SLAVE : begin
        if (psel_i && penable_i && ~pslverr_o) begin
          if (pwrite_i) begin
            write_o <= 1;
            addr_o <= paddr_i;
            wdata_o <= pwdata_i;
            pready_o <= 1;
            current_state <= `WRITE_INSIDE;
            strb_o <= pstrb_i;
          end
          else begin
            read_o <= 1;
            addr_o <= paddr_i;
            pready_o <= 1;  //  busy slave
            current_state <= `READ_OUT;
          end
        end
        else begin
          if (pslverr_o)
            current_state <= `IDLE_SLAVE;
        end
      end

      `WRITE_INSIDE : begin
        write_o <= 0;
        pready_o <= 0;
        current_state <= `IDLE_SLAVE;
      end

      `READ_OUT : begin
        pready_o <= 0;
        read_o <= 0;
        current_state <= `IDLE_SLAVE;
      end


      default: begin
        current_state <= `IDLE_SLAVE;
      end
    endcase

  end
end 



assign busy_o = cont_busy_i | mem_busy_i;
assign prdata_o = rdata_i;

assign pslverr_o = ((psel_i && pwrite_i && busy_o) || ((~pstrb_i == 0) && psel_i && (~pwrite_i)) || (pstrb_i == 0 && psel_i && pwrite_i) || (psel_i && (~paddr_i[1:0] == 2'b00)) || (psel_i && pwrite_i && (paddr_i[4:0] == 5'b10000 || paddr_i[4:0] == 5'b10100 || paddr_i[4:0] == 5'b11000 || paddr_i[4:0] == 5'b11100)));

endmodule