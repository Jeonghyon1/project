module main(
    input clk,
    input rstb,
    input [15:0] dip_switch,
    input [4:0] push_switch,
    output [7:0] digit,
    output [7:0] seg_data,
    output [15:0] led,
    output buzzer
    );
    
    wire [5:0] SCLAE;
    wire [41:0] TIME_TARGET;
    reg [41:0] TIME_TARGET_SW;
    wire [41:0] TIME_REF, TIME_SW_REF, TIME_SW;
    wire [31:0] MS_REF;
    wire MODE_SW;
    
    parameter UP=0,DOWN=1; //please match with hw(pushbutton)
    parameter CENTER=2;
    parameter LEFT=3,RIGHT=4;
    
    parameter TIMESET_MODE_SEL=6;
    parameter TIMESET_SEL=7;
    parameter MODE_NORMAL=0;
    
    rtc rtc_normal(.clk(clk),.rstb(RSTB_NORMAL),.scale(SCLAE),.ms(),.ms_acc(MS_REF));
    rtc rtc_stopwatch(.clk(clk),.rstb(),.scale(SCLAE),.prst(),.ms(MS_STOPWATCH),.ms_acc());
    
    time_transform tt_normal(.clk(clk),.rstb(rstb),.prst(TIME_TARGET),.t(TIME_REF));
    time_transform tt_stopwatch(.clk(clk),.rstb(rstb),.prst(TIME_TARGET_SW),.t(TIME_SW));
    
    stopwatch sw_main(.clk(clk),.rstb(rstb),.current(TIME_SW_REF),.sw_time(TIME_SW),.sw_lap(SW_LAP),.sw_pause());
    always@(posedge MODE_SW)
        TIME_TARGET_SW=0;
    always@(negedge SW_LAP)
        TIME_TARGET_SW<=TIME_SW_REF;

    //scale scale1(.rstb(rstb),.faster(push[UP]),.slower(push[DOWN]),.scale(SCALE),.en(dip[MODE_NORMAL]));
    reg RSTB_TS;
    reg TS_MODE;
    //time_setting ts2(.clk(clk),.rstb(RSTB_TS),.left(push[LEFT]),.right(push[RIGHT]),.inc(push[UP]),.dec(push[DOWN]),.mode(TS_MODE),.set(push[CENTER]),.tmp(TS_TMP),.digit(TS_DIGIT),.t(TIME_TARGET));
    
    /*
    THIS SHOULD BE INTEGRATED
    */
    time_setting ts3 (.clk(clk), .rstb(rstb), .left(push_switch[LEFT]), .right(push_switch[RIGHT]), .inc(push_switch[UP]), .dec(push_switch[DOWN]), .mode(dip_switch[TIMESET_MODE_SEL]), .set(push_switch[CENTER]), 
        .t(TIMESET), .tmp(timeset_temp), .digit(led[2:0]));
    show_digit vis_digit (.clk(clk), .rstb(rstb), .t(timeset_temp), .digit(digit), .seg_data(seg_data));

    
    reg [7:0]SEG[7:0];
    reg [3:0]N[7:0];
    always@(dip_switch[TIMESET_SEL]) begin
    	if(dip_switch[TIMESET_SEL]) begin
			RSTB_TS=0;
			TS_MODE=0;
			@(posedge clk);@(negedge clk);
			RSTB_TS=1;
			
			
		end
		else begin
		end    	
    end
    always@(dip_switch[TIMESET_MODE_SEL]) begin
    	if(dip_switch[TIMESET_MODE_SEL]) begin
			RSTB_TS=0;
			TS_MODE=1;
			@(posedge clk);@(negedge clk);
			RSTB_TS=1;
			
			N[7]=2;
			N[6]=0;
		end
		else begin
		end
    end
    seg7 s0(N[0],SEG[0]);
    seg7 s1(N[1],SEG[1]);
	seg7 s2(N[2],SEG[2]);
    seg7 s3(N[3],SEG[3]);
    seg7 s4(N[4],SEG[4]);
    seg7 s5(N[5],SEG[5]);
	seg7 s6(N[6],SEG[6]);
    seg7 s7(N[7],SEG[7]);
    
    
    
endmodule
