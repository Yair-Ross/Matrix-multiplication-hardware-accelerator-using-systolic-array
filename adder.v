//
// Verilog Module Multiplexer_Accelarator_lib.Adder
//
// Created:
//          by - rossy.UNKNOWN (SHOHAM)
//          at - 14:03:22 01/27/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps

module adder(mul_i, mod_i , operand_c_i, flags_adder_o, res_o);

// PARAMERES
parameter DATA_WIDTH = 16; // width of the data BUS in bits
parameter BUS_WIDTH = 64; // width of the BUS in bits
parameter ADDR_WIDTH = 16; // width of addres BUS in bits
localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; // max dimension of the matrix
parameter SP_NTARGETS = 4; // number of optionally matrix targets in ScratchPad 


input wire [(BUS_WIDTH*(MAX_DIM**2))-1:0] mul_i; // result of the systolic array

input wire mod_i; // mod bit - determine if the output of this module includes the add of matrix C 

input wire [(BUS_WIDTH*(MAX_DIM**2))-1:0] operand_c_i; //matrix C that comes from ScratchPad

output reg [(BUS_WIDTH*(MAX_DIM**2))-1:0] res_o; // the result of the adder module

output wire [(MAX_DIM**2)-1:0] flags_adder_o; // output vector of carries 


// lenth of BUS_WIDTH + 1 to catch the carry result
wire [BUS_WIDTH-1:0] mid_res_mod [MAX_DIM**2-1:0]; //keep the add result of PE element with element from matrix C

wire [(BUS_WIDTH*(MAX_DIM**2))-1:0] mid_res_mod_comb; // combine the add results to one long element

//wire [(MAX_DIM**2)-1:0] flags_adder; // concatenate the carries fom all the add results
wire signed [BUS_WIDTH-1:0] sign_res [MAX_DIM**2-1:0];
wire signed [BUS_WIDTH-1:0] sign_c [MAX_DIM**2-1:0];



    genvar l;
	   generate
	   for (l = 0; l < MAX_DIM**2; l = l + 1)
        assign sign_res[l] = mul_i[(l+1)*BUS_WIDTH-1 -:BUS_WIDTH];
	   endgenerate
	   
	   genvar k;
	   generate
	   for (k = 0; k < MAX_DIM**2; k = k + 1)
        assign sign_c[k] = operand_c_i[(k+1)*BUS_WIDTH-1 -:BUS_WIDTH];
	   endgenerate

    always @*  
    begin:RES_MUX
        if(mod_i)
            res_o = mid_res_mod_comb; // connect the add result to the output     
        else
            res_o = mul_i; // connect the multiply of systolic array straight to the output
    end


	genvar j;
	generate
	for (j = 0; j < MAX_DIM**2; j = j + 1)
        assign mid_res_mod[j] = sign_res[j] + sign_c[j];
	endgenerate
	
    generate
    case(MAX_DIM)
	4: begin    
        //combine the add results of all the PE's in case of maxDIM = 4*4 
        assign mid_res_mod_comb = {mid_res_mod[15][BUS_WIDTH-1:0] , mid_res_mod[14][BUS_WIDTH-1:0] ,
        mid_res_mod[13][BUS_WIDTH-1:0] , mid_res_mod[12][BUS_WIDTH-1:0] , mid_res_mod[11][BUS_WIDTH-1:0] ,
        mid_res_mod[10][BUS_WIDTH-1:0] , mid_res_mod[9][BUS_WIDTH-1:0] , mid_res_mod[8][BUS_WIDTH-1:0] ,
        mid_res_mod[7][BUS_WIDTH-1:0] , mid_res_mod[6][BUS_WIDTH-1:0] , mid_res_mod[5][BUS_WIDTH-1:0] ,
        mid_res_mod[4][BUS_WIDTH-1:0] , mid_res_mod[3][BUS_WIDTH-1:0] , mid_res_mod[2][BUS_WIDTH-1:0] ,
        mid_res_mod[1][BUS_WIDTH-1:0] , mid_res_mod[0][BUS_WIDTH-1:0]} ;
    end
    2: begin
        //combine the add results of all the PE's in case of maxDIM = 2*2 
        assign mid_res_mod_comb = {mid_res_mod[3][BUS_WIDTH-1:0] , mid_res_mod[2][BUS_WIDTH-1:0] ,
        mid_res_mod[1][BUS_WIDTH-1:0] , mid_res_mod[0][BUS_WIDTH-1:0]} ;
    end
    default: begin
        assign mid_res_mod_comp = {mid_res_mod[0][BUS_WIDTH-1:0]} ;
    end
    endcase
    endgenerate

  
    
    genvar i;
	 generate
	 for (i = 0; i < MAX_DIM**2; i = i + 1)
      assign flags_adder_o[i] = (~sign_res[i][BUS_WIDTH-1] & ~sign_c[i][BUS_WIDTH-1] & mid_res_mod[i][BUS_WIDTH-1]) | (sign_res[i][BUS_WIDTH-1] & sign_c[i][BUS_WIDTH-1] & ~mid_res_mod[i][BUS_WIDTH-1]);
	 endgenerate

             

endmodule
