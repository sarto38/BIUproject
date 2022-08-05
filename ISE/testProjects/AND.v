`timescale 1ns / 1ps

module  AND #(parameter integer D = 2) (ina,inb,rin,AndEnable,AndDone,out,clk);
	
	localparam randSize=D*(D-1)/2;

	input AndEnable;
	input  [0:D-1] ina, inb;
	input  [0:randSize-1] rin;
	wire [D-1:0] in_mat [D-1:0];
	wire [D-1:0] r_mat [D-1:0]; 
	reg [D-1:0] reg_mat [D-1:0]; 
    input clk;
	output reg [0:D-1] out;
	output reg AndDone = 0;
	integer x,y;
	
	
	
	//
	genvar i,j;
	generate
	for (j = 0; j < D; j = j + 1)
	begin
		assign r_mat[j][j] = 0;
		for (i = j + 1 ; i < D; i = i + 1)
		begin : num1
			assign r_mat[i][j] = rin[(i*(i-1)/2 + j)];
			assign r_mat[j][i] = rin[(i*(i-1)/2 + j)];
		end
 	end
	endgenerate
	
	generate
	for (i = 0; i < D; i = i + 1)
	begin : num2
		for (j = 0 ; j < D; j = j + 1)
		begin
			assign in_mat[i][j] = ina[j]&inb[i];
		end
 	end
	endgenerate
	
	generate
	for (i = 0; i < D; i = i + 1)
	begin : num3
		for (j = 0 ; j < D; j = j + 1)
		begin : num4
			always@(posedge clk)
			begin
				reg_mat[i][j] = in_mat[i][j] ^ r_mat[i][j];
				if (AndEnable == 1)
					AndDone = 1;
			end
		end
 	end
	endgenerate
	
	generate
	for (i = 0; i < D; i = i + 1)
	begin : num5
		
		always@(*)
		begin
		if (AndEnable == 0)
			out[i] <= 0;
		else
			out[i] <= ^reg_mat[i];
		end
	end
	endgenerate
	
	
	
	
	
	
	
	
	
	
	
	
	
endmodule
