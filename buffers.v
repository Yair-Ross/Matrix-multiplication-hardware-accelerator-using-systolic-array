//
// Verilog Module Multiplexer_Accelarator_lib.buffers
//
// Created:
//          by - rossy.UNKNOWN (SHOHAM)
//          at - 19:04:51 01/25/2024
//
// using Mentor Graphics HDL Designer(TM) 2019.2 (Build 5)
//

`resetall
`timescale 1ns/10ps

module buffers(clk_i, rst_ni, start_i, operand_A_i, operand_B_i, n_i, k_i, m_i, 
 left_o, up_o);

	// PARAMERES
	parameter DATA_WIDTH = 16; // width of the data BUS in bits
	parameter BUS_WIDTH = 64; // width of the BUS in bits
	parameter ADDR_WIDTH = 8; // width of addres BUS in bits
	localparam MAX_DIM = BUS_WIDTH/DATA_WIDTH; // max dimension of the matrix
	parameter SP_NTARGETS = 4; // number of optionally matrix targets in ScratchPad 
	
	//inputs
	input wire clk_i; // clock
	input wire rst_ni; // reset
	input wire start_i; // start bit
	input wire [BUS_WIDTH*MAX_DIM-1:0] operand_A_i; // operand A 
	input wire [BUS_WIDTH*MAX_DIM-1:0] operand_B_i; // operand B

	input wire [1:0] n_i;
	input wire [1:0] k_i;
	input wire [1:0] m_i;

	//outputs
	output wire [MAX_DIM*DATA_WIDTH-1:0] left_o; // left input to the systolic array (input 0)
	output wire [MAX_DIM*DATA_WIDTH-1:0] up_o;   // up input to the systolic array (input 0)
	
	integer i;
	generate


	case(MAX_DIM)
	// for multiply 2 matrixes in maxDIM 4 
	4: begin

	reg [DATA_WIDTH-1:0] left0_buff [3:0]; // row of 7 buffers in width of DATA_WIDTH each (number 0)
	reg [DATA_WIDTH-1:0] left1_buff [4:0]; // row of 7 buffers in width of DATA_WIDTH each (number 1)
	reg [DATA_WIDTH-1:0] left2_buff [5:0]; // row of 7 buffers in width of DATA_WIDTH each (number 2)
	reg [DATA_WIDTH-1:0] left3_buff [6:0]; // row of 7 buffers in width of DATA_WIDTH each (number 3)
	reg [DATA_WIDTH-1:0] up0_buff [3:0];   // column of 7 buffers in width of DATA_WIDTH each (number 0)
	reg [DATA_WIDTH-1:0] up1_buff [4:0];   // column of 7 buffers in width of DATA_WIDTH each (number 1)
	reg [DATA_WIDTH-1:0] up2_buff [5:0];   // column of 7 buffers in width of DATA_WIDTH each (number 2)
	reg [DATA_WIDTH-1:0] up3_buff [6:0];   // column of 7 buffers in width of DATA_WIDTH each (number 3)
	
	always @(posedge clk_i or negedge rst_ni) begin: MAT_ARR
	if (!rst_ni) begin
		for (i=0; i<4; i=i+1) left0_buff[i] <= 0; //reset the (number 0) row of 7 buffers in width of DATA_WIDTH each 
		for (i=0; i<5; i=i+1) left1_buff[i] <= 0; //reset the (number 1) row of 7 buffers in width of DATA_WIDTH each 
		for (i=0; i<6; i=i+1) left2_buff[i] <= 0; //reset the (number 2) row of 7 buffers in width of DATA_WIDTH each 
		for (i=0; i<7; i=i+1) left3_buff[i] <= 0; //reset the (number 3) row of 7 buffers in width of DATA_WIDTH each 
		for (i=0; i<4; i=i+1) up0_buff[i] <= 0;   //reset the (number 0) column of 7 buffers in width of DATA_WIDTH each 
		for (i=0; i<5; i=i+1) up1_buff[i] <= 0;   //reset the (number 1) column of 7 buffers in width of DATA_WIDTH each 
		for (i=0; i<6; i=i+1) up2_buff[i] <= 0;   //reset the (number 2) column of 7 buffers in width of DATA_WIDTH each 
		for (i=0; i<7; i=i+1) up3_buff[i] <= 0;   //reset the (number 3) column of 7 buffers in width of DATA_WIDTH each 
	end
	else
	begin
		if(start_i)
		begin
			//left buffer (1st row)
				left0_buff[0] <= operand_A_i[DATA_WIDTH-1:0]; //set the 0st value of Matrix A (a0) in the 1st row of the buffer in 1st place 	
			if(k_i==3 || k_i==2 || k_i==1)
				left0_buff[1] <= operand_A_i[2*DATA_WIDTH-1:DATA_WIDTH];  //set the 1st value of Matrix A (a1) in the 1st row of the buffer in 2st place 
			else
				left0_buff[1] <= 0;
			if(k_i==3 || k_i==2)
				left0_buff[2] <= operand_A_i[3*DATA_WIDTH-1:2*DATA_WIDTH]; //set the 2st value of Matrix A (a2) in the 1st row of the buffer in 3st place 
			else
				left0_buff[2] <= 0;	
			if(k_i==3)	
				left0_buff[3] <= operand_A_i[4*DATA_WIDTH-1:3*DATA_WIDTH]; //set the 3st value of Matrix A (a3) in the 1st row of the buffer in 4st place 
			else
				left0_buff[3] <= 0;

				//left buffer (2st row)
				left1_buff[0] <= 0; //set 0 in the 2st row of the left buffer in 1st place
			if(n_i==3 || n_i==2 || n_i==1)
				left1_buff[1] <= operand_A_i[5*DATA_WIDTH-1:4*DATA_WIDTH]; //set the 4st value of Matrix A (a4) in the 2st row of the left buffer in 2st place
			else
				left1_buff[1] <= 0;
			if((n_i==3 || n_i==2 || n_i==1) && (k_i==3 || k_i==2 || k_i==1))	
				left1_buff[2] <= operand_A_i[6*DATA_WIDTH-1:5*DATA_WIDTH]; //set the 5st value of Matrix A (a5) in the 2st row of the left buffer in 3st place
			else	
				left1_buff[1] <= 0;		
			if((n_i==3 || n_i==2 || n_i==1) && (k_i==3 || k_i==2))	
				left1_buff[3] <= operand_A_i[7*DATA_WIDTH-1:6*DATA_WIDTH]; //set the 6st value of Matrix A (a6) in the 2st row of the left buffer in 4st place
			else
				left1_buff[3] <= 0;
			if((n_i==3 || n_i==2 || n_i==1) && k_i==3)		
				left1_buff[4] <= operand_A_i[8*DATA_WIDTH-1:7*DATA_WIDTH]; //set the 7st value of Matrix A (a7) in the 2st row of the left buffer in 5st place
			else
				left1_buff[4] <= 0;	

				//left buffer (3st row)
				left2_buff[0] <= 0; //set 0 in the 3st row of the left buffer in 1st place
				left2_buff[1] <= 0; //set 0 in the 3st row of the left buffer in 2st place
			if(n_i==3 || n_i==2)
				left2_buff[2] <= operand_A_i[9*DATA_WIDTH-1:8*DATA_WIDTH]; //set the 8st value of Matrix A (a8) in the 3st row of the left buffer in 3st place
			else
				left2_buff[2] <= 0;
			if((n_i==3 || n_i==2) && (k_i==3 || k_i==2 || k_i==1))	
				left2_buff[3] <= operand_A_i[10*DATA_WIDTH-1:9*DATA_WIDTH]; //set the 9st value of Matrix A (a9) in the 3st row of the left buffer in 4st place
			else	
				left2_buff[3] <= 0;
			if((n_i==3 || n_i==2) && (k_i==3 || k_i==2))
				left2_buff[4] <= operand_A_i[11*DATA_WIDTH-1:10*DATA_WIDTH]; //set the 10st value of Matrix A (a10) in the 3st row of the left buffer in 5st place
			else
				left2_buff[4] <= 0;
			if((n_i==3 || n_i==2) && k_i==3)
				left2_buff[5] <= operand_A_i[12*DATA_WIDTH-1:11*DATA_WIDTH]; //set the 11st value of Matrix A (a11) in the 3st row of the left buffer in 6st place
			else
				left2_buff[5] <= 0;	

				//left buffer (4st row)
				left3_buff[0] <= 0; //set 0 in the 4st row of the left buffer in 1st place
				left3_buff[1] <= 0; //set 0 in the 4st row of the left buffer in 2st place
				left3_buff[2] <= 0; //set 0 in the 4st row of the left buffer in 3st place
			if(n_i==3)
				left3_buff[3] <= operand_A_i[13*DATA_WIDTH-1:12*DATA_WIDTH]; //set the 12st value of Matrix A (a12) in the 4st row of the left buffer in 4st place
			else
				left3_buff[3] <= 0;
			if(n_i==3 && (k_i==3 || k_i==2 || k_i==1))	
				left3_buff[4] <= operand_A_i[14*DATA_WIDTH-1:13*DATA_WIDTH]; //set the 13st value of Matrix A (a13) in the 4st row of the left buffer in 5st place
			else
				left3_buff[4] <= 0;
			if(n_i==3 && (k_i==3 || k_i==2)) 
				left3_buff[5] <= operand_A_i[15*DATA_WIDTH-1:14*DATA_WIDTH]; //set the 14st value of Matrix A (a14) in the 4st row of the left buffer in 6st place
			else
				left3_buff[5] <= 0;
			if(n_i==3 && k_i==3) 	
				left3_buff[6] <= operand_A_i[16*DATA_WIDTH-1:15*DATA_WIDTH]; //set the 15st value of Matrix A (a15) in the 4st row of the left buffer in 7st place
			else
				left3_buff[6] <= 0;

				//up buffer (1st column)
				up0_buff[0] <= operand_B_i[DATA_WIDTH-1:0]; //set the 0st value of Matrix B (b0) in the 1st column of the buffer in 1st place 
			if(k_i==3 || k_i==2 || k_i==1)	
				up0_buff[1] <= operand_B_i[2*DATA_WIDTH-1:DATA_WIDTH]; //set the 1st value of Matrix B (b1) in the 1st column of the buffer in 2st place 
			else
				up0_buff[1] <= 0;
			if(k_i==3 || k_i==2)		
				up0_buff[2] <= operand_B_i[3*DATA_WIDTH-1:2*DATA_WIDTH]; //set the 2st value of Matrix B (b2) in the 1st column of the buffer in 3st place 
			else
				up0_buff[2] <= 0;
			if(k_i==3)		
				up0_buff[3] <= operand_B_i[4*DATA_WIDTH-1:3*DATA_WIDTH]; //set the 3st value of Matrix B (b3) in the 1st column of the buffer in 4st place 
			else
				up0_buff[3] <= 0;

				//up buffer (2st column)
				up1_buff[0] <= 0; //set 0 in the 2st column of the up buffer in 1st place
			if(m_i==3 || m_i==2 || m_i==1)
				up1_buff[1] <= operand_B_i[5*DATA_WIDTH-1:4*DATA_WIDTH]; //set the 4st value of Matrix B (b4) in the 2st column of the buffer in 2st place 
			else
				up1_buff[1] <= 0;
			if((m_i==3 || m_i==2 || m_i==1) && (k_i==3 || k_i==2 || k_i==1))	
				up1_buff[2] <= operand_B_i[6*DATA_WIDTH-1:5*DATA_WIDTH]; //set the 5st value of Matrix B (b5) in the 2st column of the buffer in 3st place
			else
				up1_buff[2] <= 0;	
			if((m_i==3 || m_i==2 || m_i==1) && (k_i==3 || k_i==2))
				up1_buff[3] <= operand_B_i[7*DATA_WIDTH-1:6*DATA_WIDTH]; //set the 6st value of Matrix B (b6) in the 2st column of the buffer in 4st place
			else
				up1_buff[3] <= 0;
			if((m_i==3 || m_i==2 || m_i==1) && k_i==3)
				up1_buff[4] <= operand_B_i[8*DATA_WIDTH-1:7*DATA_WIDTH]; //set the 7st value of Matrix B (b7) in the 2st column of the buffer in 5st place
			else
				up1_buff[4] <= 0;

				//up buffer (3st column)
				up2_buff[0] <= 0; //set 0 in the 3st column of the up buffer in 1st place
				up2_buff[1] <= 0; //set 0 in the 3st column of the up buffer in 2st place
			if(m_i==3 || m_i==2)	
				up2_buff[2] <= operand_B_i[9*DATA_WIDTH-1:8*DATA_WIDTH]; //set the 8st value of Matrix B (b8) in the 3st column of the buffer in 3st place
			else
				up2_buff[2] <= 0;
			if((m_i==3 || m_i==2) && (k_i==3 || k_i==2 || k_i==1))
				up2_buff[3] <= operand_B_i[10*DATA_WIDTH-1:9*DATA_WIDTH]; //set the 9st value of Matrix B (b9) in the 3st column of the buffer in 4st place
			else
				up2_buff[3] <= 0;
			if((m_i==3 || m_i==2) && (k_i==3 || k_i==2))
				up2_buff[4] <= operand_B_i[11*DATA_WIDTH-1:10*DATA_WIDTH]; //set the 10st value of Matrix B (b10) in the 3st column of the buffer in 5st place
			else
				up2_buff[4] <= 0;
			if((m_i==3 || m_i==2) && k_i==3)
				up2_buff[5] <= operand_B_i[12*DATA_WIDTH-1:11*DATA_WIDTH]; //set the 11st value of Matrix B (b11) in the 3st column of the buffer in 6st place
			else
				up2_buff[5] <= 0;

				//up buffer (4st column)
				up3_buff[0] <= 0; //set 0 in the 4st column of the up buffer in 1st place
				up3_buff[1] <= 0; //set 0 in the 4st column of the up buffer in 2st place
				up3_buff[2] <= 0; //set 0 in the 4st column of the up buffer in 3st place
			if(m_i==3)	
				up3_buff[3] <= operand_B_i[13*DATA_WIDTH-1:12*DATA_WIDTH]; //set the 12st value of Matrix B (b12) in the 4st column of the buffer in 4st place
			else
				up2_buff[3] <= 0;
			if(m_i==3 && (k_i==3 || k_i==2 || k_i==1))
				up3_buff[4] <= operand_B_i[14*DATA_WIDTH-1:13*DATA_WIDTH]; //set the 13st value of Matrix B (b13) in the 4st column of the buffer in 5st place
			else
				up3_buff[4] <= 0;
			if(m_i==3 && (k_i==3 || k_i==2))
				up3_buff[5] <= operand_B_i[15*DATA_WIDTH-1:14*DATA_WIDTH]; //set the 14st value of Matrix B (b14) in the 4st column of the buffer in 6st place
			else
				up3_buff[5] <= 0;
			if(m_i==3 && k_i==3)
				up3_buff[6] <= operand_B_i[16*DATA_WIDTH-1:15*DATA_WIDTH]; //set the 15st value of Matrix B (b15) in the 4st column of the buffer in 7st place	
			else
				up3_buff[6] <= 0;
		end
		else
		begin
			// 1st left row
			left0_buff[0] <= left0_buff[1]; // transfer element from the 2st place to the 1st place
			left0_buff[1] <= left0_buff[2]; // transfer element from the 3st place to the 2st place
			left0_buff[2] <= left0_buff[3]; // transfer element from the 4st place to the 3st place
			left0_buff[3] <= 0;

            // 2st left row
			left1_buff[0] <= left1_buff[1]; // transfer element from the 2st place to the 1st place
			left1_buff[1] <= left1_buff[2]; // transfer element from the 3st place to the 2st place
			left1_buff[2] <= left1_buff[3]; // transfer element from the 4st place to the 3st place
			left1_buff[3] <= left1_buff[4]; // transfer element from the 5st place to the 4st place
			left1_buff[4] <= 0;

            // 3st left row
			left2_buff[0] <= left2_buff[1]; // transfer element from the 2st place to the 1st place
			left2_buff[1] <= left2_buff[2]; // transfer element from the 3st place to the 2st place
			left2_buff[2] <= left2_buff[3]; // transfer element from the 4st place to the 3st place
			left2_buff[3] <= left2_buff[4]; // transfer element from the 5st place to the 4st place
			left2_buff[4] <= left2_buff[5]; // transfer element from the 6st place to the 5st place
			left2_buff[5] <= 0;

            // 4st left row
			left3_buff[0] <= left3_buff[1]; // transfer element from the 2st place to the 1st place
			left3_buff[1] <= left3_buff[2]; // transfer element from the 3st place to the 2st place
			left3_buff[2] <= left3_buff[3]; // transfer element from the 4st place to the 3st place
			left3_buff[3] <= left3_buff[4]; // transfer element from the 5st place to the 4st place
			left3_buff[4] <= left3_buff[5]; // transfer element from the 6st place to the 5st place
			left3_buff[5] <= left3_buff[6]; // transfer element from the 7st place to the 6st place
			left3_buff[6] <= 0; // set 0 in the 7st element

            // 1st up column
			up0_buff[0] <= up0_buff[1]; // transfer element from the 2st place to the 1st place
			up0_buff[1] <= up0_buff[2]; // transfer element from the 3st place to the 2st place
			up0_buff[2] <= up0_buff[3]; // transfer element from the 4st place to the 3st place
			up0_buff[3] <= 0;

            // 2st up column
			up1_buff[0] <= up1_buff[1]; // transfer element from the 2st place to the 1st place
			up1_buff[1] <= up1_buff[2]; // transfer element from the 3st place to the 2st place
			up1_buff[2] <= up1_buff[3]; // transfer element from the 4st place to the 3st place
			up1_buff[3] <= up1_buff[4]; // transfer element from the 5st place to the 4st place
			up1_buff[4] <= 0;

            // 3st up column
			up2_buff[0] <= up2_buff[1]; // transfer element from the 2st place to the 1st place
			up2_buff[1] <= up2_buff[2]; // transfer element from the 3st place to the 2st place
			up2_buff[2] <= up2_buff[3]; // transfer element from the 4st place to the 3st place
			up2_buff[3] <= up2_buff[4]; // transfer element from the 5st place to the 4st place
			up2_buff[4] <= up2_buff[5]; // transfer element from the 6st place to the 5st place
			up2_buff[5] <= 0;

            // 3st up column
			up3_buff[0] <= up3_buff[1]; // transfer element from the 2st place to the 1st place
			up3_buff[1] <= up3_buff[2]; // transfer element from the 3st place to the 2st place
			up3_buff[2] <= up3_buff[3]; // transfer element from the 4st place to the 3st place
			up3_buff[3] <= up3_buff[4]; // transfer element from the 5st place to the 4st place
			up3_buff[4] <= up3_buff[5]; // transfer element from the 6st place to the 5st place
			up3_buff[5] <= up3_buff[6]; // transfer element from the 7st place to the 6st place
			up3_buff[6] <= 0;// set 0 in the 7st element
		end
	end
	end
	assign left_o[DATA_WIDTH-1:0] = left0_buff[0]; // connect 1st place in the 1st left row to the output -> systolic array
	assign left_o[2*DATA_WIDTH-1:DATA_WIDTH] = left1_buff[0]; // connect 1st place in the 2st left row to the output -> systolic array
	assign left_o[3*DATA_WIDTH-1:2*DATA_WIDTH] = left2_buff[0]; // connect 1st place in the 3st left row to the output -> systolic array
	assign left_o[4*DATA_WIDTH-1:3*DATA_WIDTH] = left3_buff[0]; // connect 1st place in the 4st left row to the output -> systolic array
	assign up_o[DATA_WIDTH-1:0] = up0_buff[0]; // connect 1st place in the 1st up column to the output -> systolic array
	assign up_o[2*DATA_WIDTH-1:DATA_WIDTH] = up1_buff[0]; // connect 1st place in the 2st up column to the output -> systolic array
	assign up_o[3*DATA_WIDTH-1:2*DATA_WIDTH] = up2_buff[0]; // connect 1st place in the 3st up column to the output -> systolic array
	assign up_o[4*DATA_WIDTH-1:3*DATA_WIDTH] = up3_buff[0]; // connect 1st place in the 4st up column to the output -> systolic array
	end

















	// for multiply 2 matrixes in maxDIM 2 
	2: begin

	reg [DATA_WIDTH-1:0] left0_buff [1:0]; // row of 7 buffers in width of DATA_WIDTH each (number 0)
	reg [DATA_WIDTH-1:0] left1_buff [2:0]; // row of 7 buffers in width of DATA_WIDTH each (number 1)
	reg [DATA_WIDTH-1:0] up0_buff [1:0];   // column of 7 buffers in width of DATA_WIDTH each (number 0)
	reg [DATA_WIDTH-1:0] up1_buff [2:0];   // column of 7 buffers in width of DATA_WIDTH each (number 1)

	always @(posedge clk_i or negedge rst_ni) begin: MAT_ARR
	if (!rst_ni) begin
		for (i=0; i<2; i=i+1) left0_buff[i] <= 0; //reset the (number 0) row of 7 buffers in width of DATA_WIDTH each 
		for (i=0; i<3; i=i+1) left1_buff[i] <= 0; //reset the (number 1) row of 7 buffers in width of DATA_WIDTH each 
		for (i=0; i<2; i=i+1) up0_buff[i] <= 0;   //reset the (number 0) column of 7 buffers in width of DATA_WIDTH each 
		for (i=0; i<3; i=i+1) up1_buff[i] <= 0;   //reset the (number 1) column of 7 buffers in width of DATA_WIDTH each 
	end
	else
	begin
		if(start_i)
		begin
				//left buffer (1st row)
				left0_buff[0] <= operand_A_i[DATA_WIDTH-1:0]; //set the 0st value of Matrix A (a0) in the 1st row of the buffer in 1st place 
			if(k_i==1)
				left0_buff[1] <= operand_A_i[2*DATA_WIDTH-1:DATA_WIDTH];  //set the 1st value of Matrix A (a1) in the 1st row of the buffer in 2st place 
			else
				left0_buff[1] <= 0;

				//left buffer (2st row)
				left1_buff[0] <= 0; //set 0 in the 2st row of the buffer in 1st place
			if(n_i==1)
				left1_buff[1] <= operand_A_i[3*DATA_WIDTH-1:2*DATA_WIDTH]; //set the 2st value of Matrix A (a2) in the 2st row of the buffer in 2st place 
			else
				left1_buff[1] <= 0;
			if(n_i==1 && k_i==1)
				left1_buff[2] <= operand_A_i[4*DATA_WIDTH-1:3*DATA_WIDTH]; //set the 3st value of Matrix A (a3) in the 2st row of the buffer in 3st place 
			else
				left1_buff[2] <= 0;

				//up buffer (1st column)	
				up0_buff[0] <= operand_B_i[DATA_WIDTH-1:0]; //set the 0st value of Matrix B (b0) in the 1st column of the buffer in 1st place 
			if(k_i==1)
				up0_buff[1] <= operand_B_i[2*DATA_WIDTH-1:DATA_WIDTH]; //set the 1st value of Matrix B (b1) in the 1st column of the buffer in 2st place 
			else
				up0_buff[1] <= 0;

                //up buffer (2st column)
				up1_buff[0] <= 0; //set 0 in the 2st column of the up buffer in 1st place
			if(m_i==1)
				up1_buff[1] <= operand_B_i[3*DATA_WIDTH-1:2*DATA_WIDTH]; //set the 2st value of Matrix B (b2) in the 2st column of the buffer in 2st place 
			else
				up1_buff[1] <= 0;
			if(m_i==1 && k_i==1)
				up1_buff[2] <= operand_B_i[4*DATA_WIDTH-1:3*DATA_WIDTH]; //set the 3st value of Matrix B (b3) in the 2st column of the buffer in 3st place 
			else
				up1_buff[2] <= 0;
				
		end
		else
		begin
			// 1st left row
			left0_buff[0] <= left0_buff[1]; // transfer element from the 2st place to the 1st place
			left0_buff[1] <= 0; // transfer element from the 3st place to the 2st place

            // 2st left row
			left1_buff[0] <= left1_buff[1]; // transfer element from the 2st place to the 1st place
			left1_buff[1] <= left1_buff[2]; // transfer element from the 3st place to the 2st place
			left1_buff[2] <= 0; // transfer element from the 4st place to the 3st place

            // 1st up column
			up0_buff[0] <= up0_buff[1]; // transfer element from the 2st place to the 1st place
			up0_buff[1] <= 0; // transfer element from the 3st place to the 2st place

            // 2st up column
			up1_buff[0] <= up1_buff[1]; // transfer element from the 2st place to the 1st place
			up1_buff[1] <= up1_buff[2]; // transfer element from the 3st place to the 2st place
			up1_buff[2] <= 0; // transfer element from the 4st place to the 3st place
		end
	end
	end
	assign left_o[DATA_WIDTH-1:0] = left0_buff[0]; // connect 1st place in the 1st left row to the output -> systolic array
	assign left_o[2*DATA_WIDTH-1:DATA_WIDTH] = left1_buff[0]; // connect 1st place in the 2st left row to the output -> systolic array
	assign up_o[DATA_WIDTH-1:0] = up0_buff[0]; // connect 1st place in the 1st up column to the output -> systolic array
	assign up_o[2*DATA_WIDTH-1:DATA_WIDTH] = up1_buff[0]; // connect 1st place in the 2st up column to the output -> systolic array
	end









default: begin
	reg [DATA_WIDTH-1:0] left0_buff [0:0]; // row of 7 buffers in width of DATA_WIDTH each (number 0)
	reg [DATA_WIDTH-1:0] up0_buff [0:0];   // column of 7 buffers in width of DATA_WIDTH each (number 0)

	always @(posedge clk_i or negedge rst_ni) begin: MAT_ARR
	if (!rst_ni) begin
		for (i=0; i<1; i=i+1) left0_buff[i] <= 0; //reset the (number 0) row of 7 buffers in width of DATA_WIDTH each 
		for (i=0; i<1; i=i+1) up0_buff[i] <= 0;   //reset the (number 0) column of 7 buffers in width of DATA_WIDTH each 
	end
	else
	begin
		if(start_i)
		begin
				left0_buff[0] <= operand_A_i[DATA_WIDTH-1:0];

				up0_buff[0] <= operand_B_i[DATA_WIDTH-1:0];
				
		end
		else
		begin
			// 1st left row
			left0_buff[0] <= 0; // transfer element from the 2st place to the 1st place

            // 1st up column
			up0_buff[0] <= 0; // transfer element from the 2st place to the 1st place
		end
	end
	end
	assign left_o[DATA_WIDTH-1:0] = left0_buff[0]; // connect 1st place in the 1st left row to the output -> systolic array
	assign up_o[DATA_WIDTH-1:0] = up0_buff[0]; // connect 1st place in the 1st up column to the output -> systolic array
	end



	endcase
	endgenerate
	

endmodule
