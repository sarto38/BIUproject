`timescale 1ns / 1ps

module  AND_flat #(parameter integer D = 2) (ina,inb,rin,AndEnable,AndDone,out,clk);
	
	localparam randSize=D*(D-1)/2;
	input AndEnable;
	input  [0:D-1] ina, inb;
	input  [0:randSize-1] rin;
	wire [3:0] mid; 
	wire [1:0] out_wire;
	reg [3:0] mid_reg;
	reg  [1:0] counter = 2'b00;
    input clk;
	output reg [0:D-1] out;
	output reg AndDone = 0;
	integer ii=0;
	
	(* DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h7777777788888888)
    )And1(
	.O5(mid[0]),		
        .I0(ina[0]),
        .I1(inb[0]),
        .I2(1'b1),
        .I3(1'b1),
        .I4(1'b1),
		.I5(1'b1)
    );
	(*  DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h7887878787787878)
    )And2(
	.O5(mid[1]),		
        .I0(inb[0]),
        .I1(ina[1]),
        .I2(rin[0]),
        .I3(inb[1]),
        .I4(ina[0]),
		.I5(1'b1)
    );
	(*  DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h7777777788888888)
    )And3(
	.O5(mid[2]),		
        .I0(ina[1]),
        .I1(inb[1]),
        .I2(1'b1),
        .I3(1'b1),
        .I4(1'b1),
		.I5(1'b1)
    );
	assign mid[3] = rin[0];
	
		always @(posedge clk)
	begin
	for(ii=0; ii<4; ii=ii+1)
		mid_reg[ii] <= mid[ii];
	if(AndEnable == 1)
	begin
		for(ii=0; ii<2; ii=ii+1)
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
			for(ii=0; ii<2; ii=ii+1)
				out[ii] <= 0;
	end
	end
	(* DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h9999999966666666)
    )And5(
        .O5(out_wire[0]), 
	.I0(mid_reg[0]),
        .I1(mid_reg[1]),
        .I2(1'b1),
        .I3(1'b1),
        .I4(1'b1),
		.I5(1'b1)
    );
	 	(*  DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h9999999966666666)
    )And6(
        .O5(out_wire[1]), 
	.I0(mid_reg[2]),
        .I1(mid_reg[3]),
        .I2(1'b1),
        .I3(1'b1),
        .I4(1'b1),
		.I5(1'b1)
    );
		
endmodule
