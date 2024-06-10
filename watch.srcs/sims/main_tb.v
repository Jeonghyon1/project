`timescale 1us / 100ns

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
#5 PUSH[0]=1; #25 PUSH[0]=0;#5 PUSH[0]=1; #25 PUSH[0]=0;#5 PUSH[0]=1; #25 PUSH[0]=0;
#5 PUSH[2]=1; #25 PUSH[2]=0;

#5 DIP[6]=1;
#5 PUSH[4]=1; #25 PUSH[4]=0;
#5 PUSH[2]=1; #25 PUSH[2]=0;

#5 DIP[6]=0;
#5 DIP[7]=0;


#5000000 DIP[5]=1;

#5 DIP[7]=1;
#5 PUSH[0]=1; #25 PUSH[0]=0;#5 PUSH[0]=1; #25 PUSH[0]=0;#5 PUSH[0]=1; #25 PUSH[0]=0;#5 PUSH[0]=1; #25 PUSH[0]=0;
#5 PUSH[2]=1; #25 PUSH[2]=0;

#5 DIP[7]=0;
#1500000 DIP[10]=1;
#2000000 DIP[10]=0;

#3000000 DIP[5]=0;
#100 DIP[8]=1;
#3000000 PUSH[2]=1; #25 PUSH[2]=0;
#1000000 DIP[10]=1;
#2000000 DIP[10]=0;

#100 DIP[1]=1;
#5 DIP[7]=1;
#5 PUSH[1]=1; #25 PUSH[1]=0;#5 PUSH[1]=1; #25 PUSH[1]=0;
#5 PUSH[0]=1; #25 PUSH[0]=0;
#5 PUSH[2]=1; #25 PUSH[2]=0;

#5 DIP[7]=0;
end


endmodule
