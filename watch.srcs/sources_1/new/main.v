module main(
    input clk,
    input rstb,
    input [13:0] dip,
    input [4:0] push
    );
    
    wire [5:0] SCLAE;
    wire [41:0] TIME_TARGET;
    reg [41:0] TIME_TARGET_SW;
    wire [41:0] TIME_REF, TIME_SW_REF, TIME_SW;
    wire [31:0] MS_REF;
    wire MODE_SW;
    
    parameter UP=0,DOWN=1; //please match with hw(pushbutton)
    parameter SW_LAP=2;
    parameter TIMESET_MSB=5, TIMESET_LSB=0; //below are dipswitches
    parameter TIMESET_MODE_SEL=6;
    parameter TIMESET_SEL=7;
    
    rtc rtc_normal(.clk(clk),.rstb(rstb),.scale(SCLAE),.ms(),.ms_acc(MS_REF));
    rtc rtc_stopwatch(.clk(clk),.rstb(),.scale(SCLAE),.prst(),.ms(MS_STOPWATCH),.ms_acc());
    
    time_transform tt_normal(.clk(clk),.rstb(rstb),.prst(TIME_TARGET),.t(TIME_REF));
    time_transform tt_stopwatch(.clk(clk),.rstb(rstb),.prst(TIME_TARGET_SW),.t(TIME_SW));
    
    stopwatch sw_main(.clk(clk),.rstb(rstb),.current(TIME_SW_REF),.sw_time(TIME_SW),.sw_lap(SW_LAP),.sw_pause());
    always@(posedge MODE_SW)
        TIME_TARGET_SW=0;
    always@(negedge SW_LAP)
        TIME_TARGET_SW<=TIME_SW_REF;
        
    scale scale1(.rstb(rstb),.faster(push[UP]),.slower(push[DOWN]),.scale(SCALE));
    time_setting ts2(.clk(clk),.rstb(RSTB_TS),.digits(dip[TIMESET_MSB:TIMESET_LSB]),.inc(push[UP]),.dec(push[DOWN]),.mode(dip[TIMESET_MODE_SEL]),.t(TIME_TARGET));
    
endmodule
