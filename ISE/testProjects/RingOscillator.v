`timescale 1ns / 1ps


////////////////////////////////////////////////////////////////////
module RingOscillator (en,out);


/////////////////////////////////////////////////////////////////////////////////////////
input[0:2]      en            ; // input
output		out ;
/////////////////////////////////////////////////////////////////////////////////////////


wire [0:4] in;
wire [0:3] rec;
reg [0:3]enable;
reg out = 1'b0;


  always @ (en) begin
    case(en)
      3'b100    : begin
		enable = 4'b1000; 
		out = in[1];
		end
      3'b101    : begin
		enable = 4'b1100; 
		out = in[2];
		end
      3'b110	: begin
		enable = 4'b1110;
		out = in[3];
		end
	  3'b111    : begin
	  enable = 4'b1111;
	  out = in[4];
	  end
      default  : begin
		enable = 4'b0000;
		out = 1'b0;
		end
    endcase
	
  end

(* BEL="D6LUT", LOC="SLICE_X12Y133", DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h777777770F0F0F0F)
    )nand1(
        .O6(rec[0]), 
		  .O5(in[0]),		
        .I0(enable[0]),
        .I1(out),
        .I2(rec[0]),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	 
(* BEL="C6LUT", LOC="SLICE_X12Y133", DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h5555555555555555)
    )inv1(
        .O6(), 
		  .O5(in[1]),		
        .I0(in[0]),
        .I1(1'b1),
        .I2(1'b1),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );

	
	
(* BEL="B6LUT", LOC="SLICE_X12Y133", DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h777777770F0F0F0F)
    )nand2(
        .O6(rec[1]), 
		  .O5(in[2]),		
        .I0(enable[1]),
        .I1(in[1]),
        .I2(rec[1]),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	
	(* BEL="A6LUT", LOC="SLICE_X12Y133", DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h777777770F0F0F0F)
    )nand3(
        .O6(rec[2]), 
		  .O5(in[3]),		
        .I0(enable[2]),
        .I1(in[2]),
        .I2(rec[2]),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	
	(* BEL="D6LUT", LOC="SLICE_X12Y132", DONT_TOUCH = "true" , LOCK_PINS="ALL" , KEEP_HIERARCHY = "TRUE" *) LUT6_2 # (
    .INIT (64'h777777770F0F0F0F)
    )nand4(
        .O6(rec[3]), 
		  .O5(in[4]),		
        .I0(enable[3]),
        .I1(in[3]),
        .I2(rec[3]),
        .I3(1'b1),
        .I4(1'b1),
		  .I5(1'b1)
    );
	
	
endmodule
////////////////////////////////////////////////////////////////////

