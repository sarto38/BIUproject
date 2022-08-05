`timescale 1ns / 1ps
module FSM #(parameter M = 8)(RxDone,AndDone,TxDone,RstFSM,clk,RxEn,SetReceive,RstUART,AndEnable,SetTransmit,TxEn,RstReceive,RstTransmit,Triger);

    input RxDone,AndDone,TxDone,RstFSM,clk; 
    output reg RxEn,SetReceive,RstUART,AndEnable,SetTransmit,TxEn,RstReceive,RstTransmit;
	output reg Triger = 1'b0;
	reg [3:0] State = 4'b0000;
	reg [7:0] cnt = 8'b0;
	reg [3:0] delay = 4'b0;
	reg flag = 1'b0;
	
	
	parameter  S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100, S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111, S8 = 4'b1000, S9 = 4'b1001; 
	
	
		
	always @ (posedge clk or negedge RstFSM)			
	begin
		
		
		if(RstFSM == 0)
		begin
		
		State = S0;
		end
		else if(State == S0)
		begin
		RxEn = 1;
		TxEn = 0;
		RstReceive = 0;
		RstTransmit = 0;
		RstUART = 0;
		cnt = 0;
		SetReceive = 1;
		SetTransmit = 1;
		AndEnable = 0;
		State = S1;
		end
		
		else if((State == S1 || State == S3) && RxDone)//S2
		begin
		SetReceive = 0;
		RstUART = 0;
		cnt = cnt + 1;
		State = S3;
		end
		
		else if(State == S1)
		begin
		
		RstReceive = 1;
		RstTransmit = 1;
		RstUART = 1;
		end
		
		
		
		else if(State == S3 && cnt >= (M/8))//S4
		begin
		RstUART = 1;
		
		if(delay < 10)
		begin
		delay = delay+1;
		if (flag == 0)
		begin
		Triger = 1;
		flag = 1;
		end
		else
		begin
		Triger = 0;
		end
		end
		
		else
		begin
		AndEnable = 1;
		cnt = 0;
		delay = 0;
		State = S4;
		end
		
		end
		
		else if(State == S3)//S3
		begin
		SetReceive = 1;
		RstUART = 1;
		end
		
		
		else if(State == S4 && AndDone)//S5
		begin
		AndEnable = 0;
		flag=0;
		State = S0;
		end
		
		
		
		
		
	end	
		
	
		
	
	
	
endmodule