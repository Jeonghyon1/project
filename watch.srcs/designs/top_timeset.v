module top_timeset(
    input clk,
    input rstb,
    input [4:0]push_switch,
    input [15:0]dip_switch,
    output [7:0] digit,
    output [7:0] seg_data
    ,output [15:0] led
    
    //output [9:0] MS,
    //output [17:0] TIME_TMP,TIME_TARGET,T_REF,
    //output reg [7:0] EN,
    //output RST_TS,TIMESET_DONE
    );
    wire RST_TS,TIMESET_DONE;
	wire [9:0] MS;
    wire [4:0] push;
    wire [15:0]dip;
    debounce db0(.clk(MS[0]),.in(push_switch[0]),.out(push[0]));
    debounce db1(.clk(MS[0]),.in(push_switch[1]),.out(push[1]));
    debounce db2(.clk(MS[0]),.in(push_switch[2]),.out(push[2]));
    debounce db3(.clk(MS[0]),.in(push_switch[3]),.out(push[3]));
    debounce db4(.clk(MS[0]),.in(push_switch[4]),.out(push[4]));
    
    debounce ddb0(.clk(MS[0]),.in(dip_switch[0]),.out(dip[0]));
    debounce ddb1(.clk(MS[0]),.in(dip_switch[1]),.out(dip[1]));
    debounce ddb2(.clk(MS[0]),.in(dip_switch[2]),.out(dip[2]));
    debounce ddb3(.clk(MS[0]),.in(dip_switch[3]),.out(dip[3]));
    debounce ddb4(.clk(MS[0]),.in(dip_switch[4]),.out(dip[4]));
    debounce ddb5(.clk(MS[0]),.in(dip_switch[5]),.out(dip[5]));
    debounce ddb6(.clk(MS[0]),.in(dip_switch[6]),.out(dip[6]));
    debounce ddb7(.clk(MS[0]),.in(dip_switch[7]),.out(dip[7]));
    debounce ddb8(.clk(MS[0]),.in(dip_switch[8]),.out(dip[8]));
	debounce ddb9(.clk(MS[0]),.in(dip_switch[9]),.out(dip[9]));
	debounce ddb10(.clk(MS[0]),.in(dip_switch[10]),.out(dip[10]));
	debounce ddb11(.clk(MS[0]),.in(dip_switch[11]),.out(dip[11]));
	debounce ddb12(.clk(MS[0]),.in(dip_switch[12]),.out(dip[12]));
	debounce ddb13(.clk(MS[0]),.in(dip_switch[13]),.out(dip[13]));
	debounce ddb14(.clk(MS[0]),.in(dip_switch[14]),.out(dip[14]));
	debounce ddb15(.clk(MS[0]),.in(dip_switch[15]),.out(dip[15]));
    
    parameter LEFT=1,RIGHT=3;
    parameter UP=0,DOWN=4; //please match with hw(pushbutton)
	parameter CENTER=2;
	parameter TIMESET_MODE_SEL=6;
	parameter TIMESET_SEL=7;
	
    wire [2:0] DIGIT;
    wire [31:0] MS_REF;
    wire [17:0]TIME_TMP;
    wire [17:0]TIME_TARGET;
    wire [17:0] T_REF;
    wire [17:0] DAY_REF;
    one_shot o1s(.clk(clk),.in(!dip[TIMESET_SEL]),.out(TIMESET_DONE));
    one_shot o2s(.clk(clk),.in(dip[TIMESET_SEL]),.out(RST_TS));
    rtc rtctmp(.clk(clk),.rstb(!RST_TS && !TIMESET_DONE),.scale(6'o1_0),.ms(MS),.ms_acc(MS_REF));
    time_setting ts3 (.clk(clk), .rstb(!RST_TS), .left(push[LEFT]), .right(push[RIGHT]), .inc(push[UP]), .dec(push[DOWN]), .mode(dip[TIMESET_MODE_SEL]), .set(push[CENTER]), 
             .tmp(TIME_TMP), .digit(DIGIT),.t(TIME_TARGET),.set_done(led[15]));
    reg [7:0] EN;
    time_transform tt_normal(.clk(clk),.rstb(!TIMESET_DONE),.mode(0),.ms(MS),.prst({18'o24_10_25,TIME_TARGET}),.date(DAY_REF),.t(T_REF));
    
    wire [17:0] T_REF_SW,T_SW,T_TARGET_SW;
    parameter PAUSE_SEL=10;
    wire [71:0]LAPS;
    time_transform ttsw(.clk(clk),.rstb(),.mode(0),.ms(MS),.prst({18'b0,T_TARGET_SW}),.t(T_REF_SW));
    stopwatch swm(.clk(clk),.rstb(),.current(T_REF_SW),.sw_time(T_SW),.laps(LAPS),.sw_lap(push[CENTER]),.sw_pause(dip[PAUSE_SEL]));
    
    wire [17:0]T_REF_T,T_T,T_TARGET_SW;
    wire AL1;
    time_transform ttt(.clk(clk),.rstb(),.mode(0),.ms(MS),.prst({18'b0,T_TARGET_T}),.t(T_REF_T));
    timer tt(.clk(clk),.rstb(),.current(T_REF_T),.pause(dip[PAUSE_SEL]),.rem_t(T_T),.alarm(AL1));
    //assign led={2**DIGIT,EN}; //for debugging
    
    parameter MODE_SW=8,MODE_TIMER=5,MODE_ALARM=1;
    
    
    
    assign led[11:0]=T_REF[11:0];
    assign led[14:12]=MS_REF[10:8];
    
    always@(posedge MS[9] or negedge rstb) begin
    	if(!rstb)
        	EN={3*dip[TIMESET_MODE_SEL],6'b111111};
		else begin
    	  	EN[DIGIT==5? 0: DIGIT+1]=1;
	      	EN[DIGIT==0? 5: DIGIT-1]=1;
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
    assign n = {8'h20, b2d(TIME_TMP[17:12]),b2u(TIME_TMP[17:12]), b2d(TIME_TMP[11:6]),b2u(TIME_TMP[11:6]), b2d(TIME_TMP[5:0]),b2u(TIME_TMP[5:0])};
    wire [31:0] n2;
    assign n2={8'h00,b2d(T_REF[17:12]),b2u(T_REF[17:12]),b2d(T_REF[11:6]),b2u(T_REF[11:6]),b2d(T_REF[5:0]),b2u(T_REF[5:0])};
    parameter [7:0] EN2=8'b00_111111;
   show_digit vis_digit (.clk(MS[0]), .rstb(rstb), .numbers(dip[TIMESET_SEL]? n: n2), .digit(digit), .seg_data(seg_data),.en(dip[TIMESET_SEL]? EN:EN2));
    
endmodule
