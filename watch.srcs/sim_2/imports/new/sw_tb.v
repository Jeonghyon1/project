`timescale 1ns / 1ps
module stopwatch_tb;
    reg CLK, RSTB, SW_LAP, SW_PAUSE;
    reg [5:0] HR, MIN, SEC;
    wire [17:0] LAP_0,LAP_1,LAP_2,LAP_3,SW_TIME;
    
    stopwatch sw1(.clk(CLK),.rstb(RSTB),.sw_lap(SW_LAP),.sw_pause(SW_PAUSE),.hr(HR),.min(MIN),.sec(SEC),.lap_0(LAP_0),.lap_1(LAP_1),.lap_2(LAP_2),.lap_3(LAP_3),.sw_time(SW_TIME));
    
    initial begin
        CLK = 0;
        RSTB=0;
        SW_LAP=0;
        SW_PAUSE=0;
        
        HR=6'o10;
        MIN=6'o21;
        SEC=6'o00;
    end
    
    always #0.1 CLK<=~CLK;
    always #10 SEC<=SEC+1;
    
    initial begin
        #1 RSTB=1;
        #15 SW_LAP=1;
        #1 SW_LAP=0;
        
        #50 SW_PAUSE=1;
        #50 SW_PAUSE=0;
        {HR,MIN,SEC}<=SW_TIME;
        
        #35 SW_LAP=1;
        #1 SW_LAP=0;
    end
endmodule
