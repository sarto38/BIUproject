`timescale 1ns / 1ps

module  AND #(parameter integer D = 3) (ina,inb,rin,AndEnable,AndDone,out,clk);
	
	localparam randSize=D*(D-1)/2;
	input AndEnable;
	input  [0:D-1] ina, inb;
	input  [0:randSize-1] rin;
	wire [8:0] mid; 
	wire [2:0] out_wire;
	reg [8:0] mid_reg;
	reg  [1:0] counter = 2'b00;
   input clk;
	output reg [0:D-1] out;
	output reg AndDone = 0;
	integer ii=0;
	
	
	
	
	(* DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'hCCCC0000956A6A6A)
    )And1(
	  .O6(mid[1]),
	  .O5(mid[0]),		
        .I0(rin[0]),
        .I1(ina[0]),
        .I2(inb[1]),
        .I3(ina[1]),
        .I4(inb[0]),
		  .I5(1'b1)
    );
	
	
	
	
	(*  DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'hCCCC0000956A6A6A)
    )And2(
		.O6(mid[3]),
		.O5(mid[2]),		
        .I0(rin[1]),
        .I1(inb[2]),
        .I2(ina[0]),
        .I3(inb[0]),
        .I4(ina[2]),
		  .I5(1'b1)
    );

	 (* DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'hCCCC0000956A6A6A)
    )And3(
		.O6(mid[5]),
		.O5(mid[4]),		
        .I0(rin[2]),
        .I1(ina[1]),
        .I2(inb[2]),
        .I3(ina[2]),
        .I4(inb[1]),
		  .I5(1'b1)
    );
	assign mid[6] = rin[0];
	assign mid[7] = rin[1];
	assign mid[8] = rin[2];
	
	
		always @(posedge clk)
	begin
	for(ii=0; ii<9; ii=ii+1)
		mid_reg[ii] <= mid[ii];
	if(AndEnable == 1)
	begin
		for(ii=0; ii<3; ii=ii+1)
			out[ii] <= out_wire[ii];
		if(counter == 2)
			begin
			counter = 0;
			AndDone <= 1;
			end
		else
			begin
			counter= counter+1;
			AndDone <= 0;
			end		
	end
	else
	begin
			for(ii=0; ii<3; ii=ii+1)
				out[ii] <= 0;
	end
	end
	(* DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h9696969696969696)
    )And5(
        .O5(out_wire[0]), 
		  .I0(mid_reg[0]),
        .I1(mid_reg[1]),
        .I2(mid_reg[2]),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	 	 	(*  DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h9696969696969696)
    )And6(
        .O5(out_wire[2]), 
		  .I0(mid_reg[3]),
        .I1(mid_reg[7]),
        .I2(mid_reg[8]),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	 
	 	(*  DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h9696969696969696)
    )And7(
        .O5(out_wire[1]), 
		  .I0(mid_reg[6]),
        .I1(mid_reg[4]),
        .I2(mid_reg[5]),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
		
		
		
endmodule
