module main(
    input clk,
    input rstb,
    input [13:0] dip,
    input [4:0] push
    );
    
    real SCLAE;
    wire [41:0] TIME_TARGET;
    reg [41:0] TIME_TARGET_SW;
    wire [41:0] TIME_REF, TIME_SW_REF, TIME_SW;
    wire [31:0] MS_REF;
    wire MODE_SW;
    wire SW_LAP;
    
    rtc rtc_normal(.clk(clk),.rstb(rstb),.scale(SCLAE),.ms(),.ms_acc(MS_REF));
    rtc rtc_stopwatch(.clk(clk),.rstb(rstb),.scale(SCLAE),.prst(),.ms(MS_STOPWATCH),.ms_acc());
    
    time_transform tt_normal(.clk(clk),.rstb(rstb),.prst(TIME_TARGET),.t(TIME_REF));
    time_transform tt_stopwatch(.clk(clk),.rstb(rstb),.prst(TIME_TARGET_SW),.t(TIME_SW));
    
    stopwatch sw_main(.clk(clk),.rstb(rstb),.current(TIME_SW_REF),.sw_time(TIME_SW),.sw_lap(SW_LAP),.sw_pause());
    always@(posedge MODE_SW)
        TIME_TARGET_SW=0;
    always@(negedge SW_LAP)
        TIME_TARGET_SW<=TIME_SW_REF;    
endmodule
