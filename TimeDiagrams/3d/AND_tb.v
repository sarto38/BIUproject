
`include "AND.v"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:56:05 01/14/2020 
// Design Name: 
// Module Name:    AND_tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module AND_tb();
wire[2:0] out;
reg[2:0] inb, ina;
reg[2:0] rin;
reg clk = 1'b0;
reg AndEnable;
wire AndDone;
AND #(.D(3)) my_gate ( .ina(ina), .inb(inb) ,.rin(rin) ,.AndEnable(AndEnable),.AndDone(AndDone), .out(out), .clk(clk) );

always #1 clk = ~clk;

initial
begin
AndEnable= 1'b0;
#1

ina = 3'b000;
inb = 3'b110;
rin = 3'b010;

#1
AndEnable= 1'b1;
#6
AndEnable= 1'b0;


end


endmodule
