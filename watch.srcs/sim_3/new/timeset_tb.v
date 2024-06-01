`timescale 1ns / 1ps
module timeset_tb;
    reg CLK,RSTB,INC,DEC,MODE;
    reg [5:0]DIGITS;
    wire [41:0]T;
    wire [3:0] N;

    time_setting ts1(.clk(CLK),.rstb(RSTB),.digits(DIGITS),.inc(INC),.dec(DEC),.mode(MODE),.t(T),.n(N));
    
    always #0.1 CLK=~CLK;
    
    initial begin
        CLK=0;
        RSTB=0;
        MODE=0;
        DIGITS=0;
        INC=0;
        DEC=0;
        
        #20 RSTB=1; DIGITS=6'b00_00_01;
        #1 INC=1; #1 INC=0; #3 INC=1; #1 INC=0;
        #5 DEC=1; #1 DEC=0;
        
        #10 DIGITS=6'b01_00_00;
        #1 INC=1; #1 INC=1; #3 INC=1; #1 INC=0;
        
        #20 DIGITS=6'b00_00_10;
        #1 INC=1; #1 INC=1; #3 INC=1; #1 INC=0; #1 INC=1; #1 INC=1; #3 INC=1; #1 INC=0;
    end
endmodule
