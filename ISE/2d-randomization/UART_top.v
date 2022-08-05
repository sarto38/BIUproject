`include "UART_rx.v"
`include "UART_tx.v"
`include "UART_baudrate_generator.v"

 module UART_top(
    	Clk                     ,
    	Rst_n                   ,   
   	Rx                      ,    
    	Tx                      ,
	RxData		        ,
	RxEn ,
	TxEn ,
	TxData,
	RxDone, 
	TxDone
	);

/////////////////////////////////////////////////////////////////////////////////////////
input           Clk             ; // Clock
input           Rst_n           ; // Reset
input           Rx              ; //   RX line.
input           RxEn              ; 
input           TxEn              ; 
input [7:0]    	TxData     	;
output          Tx              ; //   TX line.
output [7:0]    RxData          ; // Received data
output          RxDone          ; // Reception completed. Data is valid.
output          TxDone          ; // Trnasmission completed. Data sent.
/////////////////////////////////////////////////////////////////////////////////////////
 

wire            tick		; // Baud rate clock
wire [3:0]      NBits    	;
wire [15:0]    	BaudRate        ; //328; 162 etc... (Read comment in baud rate generator file)
/////////////////////////////////////////////////////////////////////////////////////////
assign 		BaudRate = 16'd26; 	//baud rate set to 9600, Why 26? (Read comment in baud rate generator file)
assign 		NBits = 4'b1000	;	//We send/receive 8 bits
/////////////////////////////////////////////////////////////////////////////////////////


//Make connections between Rx module and TOP inputs and outputs and the other modules
UART_rx I_RX(
    	.Clk(Clk)             	,
   	.Rst_n(Rst_n)         	,
    	.RxEn(RxEn)           	,
    	.RxData(RxData)       	,
    	.RxDone(RxDone)       	,
    	.Rx(Rx)               	,
    	.Tick(tick)           	,
    	.NBits(NBits)
    );

//Make connections between Tx module and TOP inputs and outputs and the other modules
UART_tx I_TX(
   	.Clk(Clk)            	,
    	.Rst_n(Rst_n)         	,
    	.TxEn(TxEn)           	,
    	.TxData(TxData)      	,
   	.TxDone(TxDone)      	,
   	.Tx(Tx)               	,
   	.Tick(tick)           	,
   	.NBits(NBits)
    );

//Make connections between tick generator module and TOP inputs and outputs and the other modules
UART_BaudRate_generator I_BAUDGEN(
    	.Clk(Clk)               ,
    	.Rst_n(Rst_n)           ,
    	.Tick(tick)             ,
    	.BaudRate(BaudRate)
    );



endmodule
