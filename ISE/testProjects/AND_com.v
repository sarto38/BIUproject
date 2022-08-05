`timescale 1ns / 1ps

module  AND_com #(parameter integer D = 2) (ina,inb,rin,AndEnable,AndDone,out,clk);
	
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
	
	
	wire os1;
	wire os2;
	wire os3;
	wire os4;
	wire os11;
	wire os21;
	wire os31;
	wire os41;
	wire [3:0] mid1; 
	wire [1:0] out_wire1;
	reg [3:0] mid_reg1;
	(* DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h0F0F0F0F88888888)
    )And1(
		  .O6(os1),
		  .O5(mid[0]),		
        .I0(ina[0]),
        .I1(inb[0]),
        .I2(os1),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	
	(*  DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h8778787887787878)
    )And2(
	.O5(mid[1]),		
        .I0(inb[0]),
        .I1(ina[1]),
        .I2(rin[0]),
        .I3(inb[1]),
        .I4(ina[0]),
		.I5(1'b1)
    );

	 (* DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h0F0F0F0F88888888)
    )And3(
		  .O6(os2),
		  .O5(mid[2]),		
        .I0(ina[1]),
        .I1(inb[1]),
        .I2(os2),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	 //-----------------------not----------------------
	 (* DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h0F0F0F0F77777777)
    )And11(
		  .O6(os11),
		  .O5(mid1[0]),		
        .I0(ina[0]),
        .I1(inb[0]),
        .I2(os11),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	
	(*  DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h7887878778878787)
    )And21(
	.O5(mid1[1]),		
        .I0(inb[0]),
        .I1(ina[1]),
        .I2(rin[0]),
        .I3(inb[1]),
        .I4(ina[0]),
		.I5(1'b1)
    );

	 (* DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h0F0F0F0F77777777)
    )And31(
		  .O6(os21),
		  .O5(mid1[2]),		
        .I0(ina[1]),
        .I1(inb[1]),
        .I2(os21),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	 //---------------------------------------------
	assign mid[3] = rin[0];
	assign mid1[3] = rin[0];
		always @(posedge clk)
	begin
	
	for(ii=0; ii<4; ii=ii+1)
	begin
		mid_reg[ii] <= mid[ii];
		mid_reg1[ii] <= mid[ii];
	end
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
    .INIT (64'h0F0F0F0F66666666)
    )And5(
		  .O6(os3),
        .O5(out_wire[0]), 
		  .I0(mid_reg[0]),
        .I1(mid_reg[1]),
        .I2(os3),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	 	(*  DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h0F0F0F0F66666666)
    )And6(
		  .O6(os4),
        .O5(out_wire[1]), 
		  .I0(mid_reg[2]),
        .I1(mid_reg[3]),
        .I2(os4),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
//----------------------------------not--------------------------------------
	(* DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h0F0F0F0F99999999)
    )And51(
		  .O6(os31),
        .O5(out_wire1[0]), 
		  .I0(mid_reg1[0]),
        .I1(mid_reg1[1]),
        .I2(os31),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	 	(*  DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h0F0F0F0F99999999)
    )And61(
		  .O6(os41),
        .O5(out_wire1[1]), 
		  .I0(mid_reg1[2]),
        .I1(mid_reg1[3]),
        .I2(os41),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	//-----------------------------------------	
endmodule
