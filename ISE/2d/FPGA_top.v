`include "AND2.v"
`include "FSM.v"
`include "SR_receive.v"
`include "SR_transmit.v"
`include "UART_top.v"
`include "RingOscillator.v"


module FPGA_top #(parameter integer D = 2,M = 8) (FTDI_BDBUS,M_CLK_OSC,M_RESET_B, M_header);

localparam totalBits=2*D+D*(D-1)/2;
/////////////////////////////////////////////////////////////////////////////////////////
inout           FTDI_BDBUS[0:1]             ; // input
input           M_CLK_OSC       ; // Clock
input           M_RESET_B             ; // Reset
output [3:0]     M_header;
/////////////////////////////////////////////////////////////////////////////////////////

wire Triger;
wire clk; 
wire RxDone;
wire TxDone;
wire RxEn;
wire RstUART;
wire TxEn;
wire [7:0]RxData;
wire SetReceive;
wire RstReceive;
wire [M-1:0]OutReceive;
wire AndEnable;
wire AndDone;
wire [D-1:0]OutAnd;
wire SetTransmit;
wire RstTransmit;
wire [7:0]OutTransmit;
wire in;
wire out;
wire [1:0] OutAndFinel;

//osi
//reg en_osi=3'b111;


assign M_header[0] = Triger;
assign M_header[1] = OutAndFinel[0];
assign M_header[2] = OutAndFinel[1];
assign M_header[3] = AndEnable;

assign in = FTDI_BDBUS[0];
assign FTDI_BDBUS[1] = out;

clk_4Mhz newClk(
.CLK_IN1(M_CLK_OSC),
.CLK_OUT1(clk),
.RESET( M_RESET_B)
);


//osi
//RingOscillator I_RingOscillator(
//	.en(en_osi)
//);


UART_top I_UART_top(
    .Clk(clk),
    .Rst_n(RstUART),   
   	.Rx(in),    
    .Tx(out),
	.RxData(RxData),
	.RxEn(RxEn) ,
	.TxEn(TxEn) ,
	.TxData(OutTransmit),
	.RxDone(RxDone), 
	.TxDone(TxDone)
	
	);


FSM #(.M(M))I_FSM(
	.RxDone(RxDone),
	.AndDone(AndDone),
	.TxDone(TxDone),
	.RstFSM( ~M_RESET_B),
	.clk(clk),
	.RxEn(RxEn),
	.SetReceive(SetReceive),
	.RstUART(RstUART),
	.AndEnable(AndEnable),
	.SetTransmit(SetTransmit),
	.TxEn(TxEn),
	.RstReceive(RstReceive),
	.RstTransmit(RstTransmit),
	.Triger(Triger)
	);

SR_receive #(.M(M))I_SR_receive(
	.in(RxData),
	.set(SetReceive),
	.rst(RstReceive),
	.out(OutReceive)
	);


AND2 #(.D(D))I_AND(
	.ina(OutReceive[D-1:0]),
	.inb(OutReceive[2*D-1:D]),
	.rin(OutReceive[totalBits-1:2*D]),
	.AndEnable(AndEnable),
	.AndDone(AndDone),
	.out(OutAnd),
	.clk(clk)
	);
	
	
SR_transmit #(.D(D))I_SR_transmit(
	.in(OutAndFinel),
	.set(SetTransmit),
	.rst(RstTransmit),
	.out(OutTransmit)
	);

	
endmodule
