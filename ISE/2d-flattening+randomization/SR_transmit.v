`timescale 1ns / 1ps
module SR_transmit #(parameter D = 8)(in,set,rst,out);

	
	input [D-1:0] in;
    input set, rst; 
	reg [7:0] reg_mat; 
    output reg [7:0] out; 
		
		always@(negedge rst or negedge set) //reset the gate
		begin
				if (rst == 0)
				begin
				reg_mat= 8'b0;
				end
				else
				begin
				reg_mat[D-1:0]=in;
				end
				
		end
		
		
		
		always @(*) 
		begin
			out <= reg_mat;
		end
	
	
	
endmodule