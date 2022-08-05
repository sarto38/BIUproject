`timescale 1ns / 1ps
module SR_receive #(parameter M = 8)(in,set,rst,out);

	
	input [7:0] in;
    input set, rst; 
	reg [7:0] reg_mat [(M/8)-1:0]; 
    output reg [M-1:0] out; 
	integer ii,jj,xx = 0;
		
	
		
		always @(negedge set or negedge rst)               
        begin
			if(set == 0)
			begin
				for(ii=0; ii<(M/8)-1 ; ii=ii+1)
					reg_mat[ii]=reg_mat[ii+1];
				reg_mat[(M/8)-1]=in;
			end
			else
			begin
				for (xx = 0; xx < (M/8); xx = xx+ 1)
				begin
					reg_mat[xx]= 8'b0;
				end
			end
        end
		
		
		always @(*) 
		begin
		for(jj=0; jj< (M/8); jj=jj+1)
		begin
			if(rst == 1)
			out [8*jj +: 8]<= reg_mat[jj];	
			else
			out [8*jj +: 8]<= 8'b0;
		end
			 
		end
	
	
	
endmodule