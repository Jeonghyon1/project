module timer(
        input clk, rstb,
        input is_timer_setting,
        input [4:0] push_switch,
        output reg [5:0] hour,
        output reg [5:0] min,
        output reg [5:0] sec,
        output reg is_end
    );
    
    reg IS_TIMER_SETTING;
    reg IS_TIMER_RUNNING;
    reg [5:0] HOUR_SET;
    reg [5:0] MIN_SET;
    reg [5:0] SEC_SET;
    reg IS_PAUSED;    
    
    timer_timeset timeset (.clk(clk), .rstb(rstb), .is_timer_setting(is_timer_setting), 
        .left_btn(push_switch[1]), .right_btn(push_switch[3]), .inc(push_switch[0]), .dec(push_switch[4]),
        .hour(HOUR_SET), .minute(MIN_SET), .second(SEC_SET), .is_timer_running(IS_TIMER_RUNNING));
    
    run_timer run (.clk(clk), .rstb(rstb), .is_timer_running(IS_TIMER_RUNNING), .pause(IS_PAUSED),
        .init_hour(HOUR_SET), .init_min(MIN_SET), .init_sec(SEC_SET), 
        .hour(hour), .min(min), .sec(sec), .is_end(is_end));
    
    always@(posedge is_timer_setting)
    begin
        HOUR_SET <= 0;
        MIN_SET <= 0;
        SEC_SET <= 0;
        IS_TIMER_SETTING <= 1;
        IS_TIMER_RUNNING <= 0;
        IS_PAUSED <= 1;
        is_end <= 0;
    end
    
    always@(posedge push_switch[2])
    begin
        if (IS_TIMER_SETTING)
        begin
            IS_TIMER_SETTING <= 0;
            IS_TIMER_RUNNING <= 1;
            IS_PAUSED <= 0;
        end
        else if (is_end)
        begin
            IS_TIMER_RUNNING <= 0;
            IS_TIMER_SETTING <= 1;
        end
        else if (IS_TIMER_RUNNING)
        begin
            IS_PAUSED <= ~IS_PAUSED;
        end
    end    
    
endmodule
