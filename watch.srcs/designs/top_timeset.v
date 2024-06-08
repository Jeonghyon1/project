
module top_timeset(
    input clk,
    input rstb,
    input [4:0]push_switch,
    input [15:0]dip_switch,
    output [7:0] digit,
    output [7:0] seg_data
    );
    
    parameter LEFT=3,RIGHT=4;
    parameter UP=0,DOWN=1; //please match with hw(pushbutton)
        parameter CENTER=2;
        parameter TIMESET_MODE_SEL=6;
    wire [9:0] MS;
    wire [17:0]TIME_TMP;
    rtc rtctmp(.clk(clk),.rstb(rstb),.scale(6'o1_0),.ms(MS));
    time_setting ts3 (.clk(clk), .rstb(rstb), .left(push_switch[LEFT]), .right(push_switch[RIGHT]), .inc(push_switch[UP]), .dec(push_switch[DOWN]), .mode(dip_switch[TIMESET_MODE_SEL]), .set(push_switch[CENTER]), 
             .tmp(TIME_TMP), .digit(DIGIT));
    
    reg [7:0] EN;
    always@(posedge MS[9] or negedge rstb) begin
		if(!rstb) begin
			EN=8'hFF;
			EN[7]=TIMESET_MODE_SEL;
			EN[6]=TIMESET_MODE_SEL;
		end
		else
			EN[DIGIT]<=~EN[DIGIT];
    end
    wire [31:0] n;
    function [3:0] b2d(input [5:0]b);
    	b2d=b/10;
    endfunction
    function [3:0] b2u(input [5:0]b);
    	b2u=b%10;
    endfunction
    assign n = {8'h20, b2d(TIME_TMP[17:12]),b2u(TIME_TMP[17:12]), b2d(TIME_TMP[11:6]),b2u(TIME_TMP[11:6]), b2d(TIME_TMP[5:0]),b2u(TIME_TMP[5:0])};
    
	show_digit vis_digit (.clk(MS[0]), .rstb(rstb), .numbers(n), .digit(digit), .seg_data(seg_data),.en(EN));
    
    
    
endmodule
