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
