module top_timeset(
    input clk,
    input rstb,
    input [4:0]push_switch,
    input [15:0]dip_switch,
    output [7:0] digit,
    output [7:0] seg_data
    
    //output [9:0] MS,
    //output [17:0] TIME_TMP,TIME_TARGET,T_REF,
    //output reg [7:0] EN,
    //output RST_TS,TIMESET_DONE
    );
    wire RST_TS,TIMESET_DONE;
	wire [9:0] MS;
    wire [4:0] push;
    debounce db0(.clk(MS[0]),.in(push_switch[0]),.out(push[0]));
    debounce db1(.clk(MS[0]),.in(push_switch[1]),.out(push[1]));
    debounce db2(.clk(MS[0]),.in(push_switch[2]),.out(push[2]));
    debounce db3(.clk(MS[0]),.in(push_switch[3]),.out(push[3]));
    debounce db4(.clk(MS[0]),.in(push_switch[4]),.out(push[4]));
    
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
    one_shot o1s(.clk(clk),.in(!dip_switch[TIMESET_SEL]),.out(TIMESET_DONE));
    one_shot o2s(.clk(clk),.in(dip_switch[TIMESET_SEL]),.out(RST_TS));
    rtc rtctmp(.clk(clk),.rstb(!RST_TS && !TIMESET_DONE),.scale(6'o1_0),.ms(MS),.ms_acc(MS_REF));
    time_setting ts3 (.clk(clk), .rstb(!RST_TS), .left(push[LEFT]), .right(push[RIGHT]), .inc(push[UP]), .dec(push[DOWN]), .mode(dip_switch[TIMESET_MODE_SEL]), .set(push[CENTER]), 
             .tmp(TIME_TMP), .digit(DIGIT),.t(TIME_TARGET));
    reg [7:0] EN;
    time_transform tt_normal(.rstb(!TIMESET_DONE),.mode(0),.ms_acc(MS_REF),.prst({18'o24_10_25,TIME_TARGET}),.date(DAY_REF),.t(T_REF));
    
    //assign led={2**DIGIT,EN}; //for debugging
    
    always@(posedge MS[9] or negedge rstb) begin
    	if(!rstb)
        	EN={3*dip_switch[TIMESET_MODE_SEL],6'b111111};
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
   show_digit vis_digit (.clk(MS[0]), .rstb(rstb), .numbers(dip_switch[TIMESET_SEL]? n: n2), .digit(digit), .seg_data(seg_data),.en(dip_switch[TIMESET_SEL]? EN:EN2));
    
    
    
endmodule
