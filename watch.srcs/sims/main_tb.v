`timescale 1us / 1ns

module main_tb;
reg CLK,RSTB;
reg [4:0] PUSH;
reg [15:0] DIP;

wire [7:0] DIGIT, SEG;
//wire [9:0] ms;
//wire [17:0] t_tmp,t_tar,t_ref;
//wire rstts,td;

top_timeset TTTTT(CLK,RSTB,PUSH,DIP,DIGIT,SEG);

always #0.5 CLK=~CLK;

initial begin
CLK=0;RSTB=0;PUSH=0;DIP=0;

#5 RSTB=1;
#5 DIP[7]=1;
#5 PUSH[1]=1;#25 PUSH[1]=0;
#5 PUSH[0]=1; #25 PUSH[0]=0;
#5 PUSH[2]=1; #25 PUSH[2]=0;
#5 DIP[7]=0;
end


endmodule
