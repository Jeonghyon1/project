module top_timeset(
    input clk,
    input rstb,
    input [4:0]push_switch,
    input [15:0]dip_switch,
    output [7:0] digit,
    output [7:0] seg_data
    ,output [15:0] led
    ,output buzzer,
    output wire            vga_vs      ,
     output wire            vga_hs      ,
     output wire [3:0]      vga_r       ,
     output wire [3:0]      vga_g       ,
     output wire [3:0]      vga_b
     
    );
    wire RST_TS,TIMESET_DONE;
	wire [9:0] MS;
    wire [4:0] push;
    wire [15:0]dip;
    wire ICLK;
    
    genvar i;
    generate for(i=0;i<5;i=i+1) begin
    	debounce db(.clk(ICLK),.in(push_switch[i]),.out(push[i]));
    end endgenerate
    
    generate for(i=0;i<16;i=i+1) begin
    	debounce ddb(.clk(ICLK),.in(dip_switch[i]),.out(dip[i]));
    end endgenerate
    
    parameter LEFT=1,RIGHT=3;
    parameter UP=0,DOWN=4; //please match with hw(pushbutton)
	parameter CENTER=2;
	parameter TIMESET_MODE_SEL=6;
	parameter TIMESET_SEL=7;
	parameter MODE_SW=8,MODE_TIMER=5,MODE_ALARM=1;
	
    wire [2:0] DIGIT;
    wire [17:0]TIME_TMP;
    wire [17:0]TIME_TARGET,DATE_TARGET;
    wire [17:0] T_REF;
    wire [17:0] DATE_REF;
    wire [2:0] SCALE;
    scale scale1(.clk(clk),.rstb(rstb),.faster(push[UP]),.slower(push[DOWN]),.en(!dip[TIMESET_SEL]),.scale(SCALE));

    wire [17:0] T_REF_SW,T_SW,T_TARGET_SW;
    parameter PAUSE_SEL=10;
    one_shot o1s(.clk(clk),.in(!dip[TIMESET_SEL]),.out(TIMESET_DONE));
    one_shot o2s(.clk(clk),.in(dip[TIMESET_SEL]),.out(RST_TS));
    rtc rtctmp(.clk(clk),.rstb(!RST_TS && (!TIMESET_DONE || (dip[MODE_SW]||dip[MODE_TIMER]))),.scale(SCALE),.ms(MS),.iclk(ICLK));
    time_setting ts3 (.clk(clk), .rstb(!RST_TS), .left(push[LEFT]), .right(push[RIGHT]), .inc(push[UP]), .dec(push[DOWN]), .mode(dip[TIMESET_MODE_SEL]), .set(push[CENTER]), 
             .tmp(TIME_TMP), .digit(DIGIT),.t(TIME_TARGET),.set_done(led[15]),.date(DATE_TARGET),.prst_d(DATE_REF),.prst_t(dip[MODE_TIMER]?0:T_REF));
    reg [7:0] EN;
    time_transform tt_normal(.clk(clk),.rstb(!TIMESET_DONE || (dip[MODE_SW]||dip[MODE_TIMER] || dip[MODE_ALARM])),.mode(0),.ms(MS),.prst({DATE_TARGET,TIME_TARGET}),.date(DATE_REF),.t(T_REF));
    wire RST_SW,RST_TIMER,RESUME_SW,RESUME_TIMER;
    one_shot O235S(.clk(clk),.in(dip[MODE_SW]),.out(RST_SW));
    one_shot O2S(.clk(clk),.in(dip[MODE_TIMER]),.out(RST_TIMER));
    wire RESUME;
    one_shot O9S(.clk(clk),.in(!dip[PAUSE_SEL]),.out(RESUME));
    assign RESUME_SW=RESUME && dip[MODE_SW];
    assign RESUME_TIMER=RESUME && dip[MODE_TIMER];
    
    wire [71:0]LAPS;
    time_transform ttsw(.clk(clk),.rstb(!RST_SW && !RESUME_SW),.mode(0),.ms(MS),.prst({18'b0,T_TARGET_SW}),.t(T_REF_SW));
    stopwatch swm(.clk(clk),.rstb(!RST_SW),.current(T_REF_SW),.sw_time(T_SW),.laps(LAPS),.sw_lap(push[CENTER]),.sw_pause(dip[PAUSE_SEL]));
    
    wire [17:0]T_REF_T,T_T,T_TARGET_T;
    wire AL1;
    wire AL2;
    assign T_TARGET_T=TIMESET_DONE?TIME_TARGET:(RESUME_TIMER?T_T:18'o27_73_73);
    assign T_TARGET_SW=RESUME_SW?T_SW:0;
    
    time_transform ttt(.clk(clk),.rstb(!(TIMESET_DONE&&dip[MODE_TIMER]) && !RESUME_TIMER && rstb &&!RST_TIMER),.mode(1),.ms(MS),.prst({18'b0,T_TARGET_T}),.t(T_REF_T));
    timer tt(.clk(clk),.rstb(!RST_TIMER && rstb),.current(T_REF_T),.pause(dip[PAUSE_SEL]),.rem_t(T_T),.alarm(AL1));
    //assign led={2**DIGIT,EN}; //for debugging
    reg [17:0]T_TARGET_A;
    always@(posedge clk)
    	if(dip[MODE_ALARM] && TIMESET_DONE)
    		T_TARGET_A<=TIME_TARGET;

    one_shot dsjlfk(.clk(clk),.in(dip[MODE_ALARM] && T_REF==T_TARGET_A),.out(AL2));
	reg AL;
	parameter STOP=15;
	always@(posedge clk) begin
		if(!rstb)
			AL<=0;
		else begin
			if(dip[STOP])
				AL<=0;
			else if(AL1|AL2)
				AL<=1;
		end
	end
	assign led[14:12]={AL,AL2,AL1};
    music musaic(.clk(clk),.rstb(rstb&!(AL1|AL2)),.is_ringing(AL),.buzz(buzzer));
    
    
//    assign led[11:0]=T_REF[11:0];
//    assign led[14:12]=MS[9:7];
assign led[2:0]=SCALE;
    always@(posedge MS[8] or negedge rstb) begin
    	if(!rstb)
    		EN<=8'hff;
		else begin
    	  	EN[DIGIT==5? 0: DIGIT+1]<=1;
	      	EN[DIGIT==0? 5: DIGIT-1]<=1;
			EN[DIGIT]<=~EN[DIGIT];
		end
    end
    wire [31:0] n;
    function [3:0] b2d(input [5:0]b);
       b2d=b/10;
    endfunction
    function [3:0] b2u(input [5:0]b);
       b2u=b%10;
    endfunction
    assign n = {dip[TIMESET_MODE_SEL]? 8'h20 : 8'haa, EN[5]?b2d(TIME_TMP[17:12]):4'hf,EN[4]?b2u(TIME_TMP[17:12]):4'hf, EN[3]?b2d(TIME_TMP[11:6]):4'hf,EN[2]?b2u(TIME_TMP[11:6]):4'hf, EN[1]?b2d(TIME_TMP[5:0]):4'hf,EN[0]?b2u(TIME_TMP[5:0]):4'hf};
    wire [31:0] n2;
    assign n2={8'hff,b2d(T_REF[17:12]),b2u(T_REF[17:12]),b2d(T_REF[11:6]),b2u(T_REF[11:6]),b2d(T_REF[5:0]),b2u(T_REF[5:0])};
    
    wire [31:0] n3={8'hff,b2d(T_T[17:12]),b2u(T_T[17:12]),b2d(T_T[11:6]),b2u(T_T[11:6]),b2d(T_T[5:0]),b2u(T_T[5:0])};
	wire [31:0] n4={8'hff,b2d(T_SW[17:12]),b2u(T_SW[17:12]),b2d(T_SW[11:6]),b2u(T_SW[11:6]),b2d(T_SW[5:0]),b2u(T_SW[5:0])};
        
	wire [31:0]N_DISP = dip[TIMESET_SEL]? n : (dip[MODE_TIMER]?n3 : (dip[MODE_SW]?n4 : n2));
	show_digit vis_digit (.clk(ICLK), .rstb(rstb), .numbers(N_DISP), .digit(digit), .seg_data(seg_data), .dot(dip[TIMESET_SEL]&dip[TIMESET_MODE_SEL]));
    
    
    parameter VGA_EN=12;
    vga vga1(.clk(clk),.rstb(rstb),.pattern_en(dip[VGA_EN]),.date(DATE_REF),.t(T_REF),
    .vga_vs(vga_vs),.vga_hs(vga_hs),.vga_r(vga_r),.vga_g(vga_g),.vga_b(vga_b));
endmodule
