`timescale 1ns / 1ns
module rtc_tb;
    wire [31:0] MS_ACC;
    reg CLK;
    reg RSTB;
    reg [41:0] PRESET_TEST;
    wire [5:0] SEC,MIN,HR;
    real SCALE;

    rtc rtc1(.clk(CLK),.rstb(RSTB),.scale(SCALE),.ms_acc(MS_ACC));
    time_transform tt1(.clk(CLK),.rstb(RSTB),.ms_acc(MS_ACC),.prst(PRESET_TEST),.sec(SEC),.min(MIN),.hr(HR));
    
    initial begin
        CLK=0;
        RSTB=0;
        SCALE=100;
        PRESET_TEST=42'o0001_01_01_10_20_30; //test initial time in oct
        #30 RSTB=1;
    end
    always #0.5 CLK = ~CLK;
    
endmodule