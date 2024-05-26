module rtc_test(
    input clk,
    input rstb,
    output [9:0] ms_1,
    output [9:0] ms_2,
    output [9:0] ms_3
    );
    
    rtc RTC1(.clk(clk),.rstb(rstb),.scale($realtobits(0.2)),.ms(ms_1));
    rtc RTC2(.clk(clk),.rstb(rstb),.scale($realtobits(1.0)),.ms(ms_2));
    rtc RTC3(.clk(clk),.rstb(rstb),.scale($realtobits(3.5)),.ms(ms_3));
endmodule
