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

    scale scale1(.rstb(rstb),.faster(push[UP]),.slower(push[DOWN]),.scale(SCALE),.en(dip[MODE_NORMAL]));
    reg RSTB_TS;
    reg TS_MODE;
    time_setting ts2(.clk(clk),.rstb(RSTB_TS),.left(push[LEFT]),.right(push[RIGHT]),.inc(push[UP]),.dec(push[DOWN]),.mode(TS_MODE),.set(push[CENTER]),.tmp(TS_TMP),.digit(TS_DIGIT),.t(TIME_TARGET));
    
    reg [7:0]SEG[7:0];
    reg [3:0]N[7:0];
    always@(dip[TIMESET_SEL]) begin
    	if(dip[TIMESET_SEL]) begin
			RSTB_TS=0;
			TS_MODE=0;
			@(posedge clk);@(negedge clk);
			RSTB_TS=1;
			
			
		end
		else begin
		end    	
    end
    always@(dip[TIMESET_MODE_SEL]) begin
    	if(dip[TIMESET_MODE_SEL]) begin
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
