`timescale 1ns / 1ps
module timeset_tb;
    reg CLK,RSTB,INC,DEC,MODE,LEFT,RIGHT,SET;
    wire [2:0]DIGIT;
    wire [17:0]T,TMP;

    time_setting ts1(.clk(CLK),.rstb(RSTB),.digit(DIGIT),.inc(INC),.dec(DEC),.mode(MODE),.t(T),.left(LEFT),.right(RIGHT),.set(SET),.tmp(TMP));
    
    always #0.1 CLK=~CLK;
    
    initial begin
        CLK=0;
        RSTB=0;
        MODE=0;
        INC=0;
        DEC=0;
        LEFT=0;RIGHT=0;SET=0;
        
        #20 RSTB=1;
        #1 INC=1; #1 INC=0; #1 INC=1; #1 INC=0;
        #5 LEFT=1; #1 LEFT=0;
        #1 INC=1; #1 INC=0;
        #5 LEFT=1; #1 LEFT=0; #1 LEFT=1; #1 LEFT=0;
        #1 DEC=1; #1 DEC=0;
        #5 RIGHT=1; #1 RIGHT=0;
        #1 INC=1; #1 INC=0;
        
        #10 SET=1; #1 SET=0;
    end
endmodule
