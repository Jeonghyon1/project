module alarm(
        input clk, rstb,
        input [5:0] curr_hour,
        input [5:0] curr_min,
        input is_alarm_setting,
        input [4:0] push_switch,
        output reg is_finished
    );
    
    reg [5:0] HOUR_SET;
    reg [5:0] MIN_SET;
    // wheter an alarm is being set
    reg IS_ALARM_SETTING;
    // whether an alarm have been set
    reg IS_ALARM_SET;
    
   
    
    always@(posedge is_alarm_setting)
    begin
        IS_ALARM_SETTING <= 1;
        IS_ALARM_SET <= 0;
        is_finished <= 0;
    end
    
    always@(curr_hour or curr_min)
    begin
        if (IS_ALARM_SET && curr_hour == HOUR_SET && curr_min == MIN_SET)
        begin
            is_finished <= 1;
        end
    end
    
    always@(posedge push_switch[2])
    begin
        if (IS_ALARM_SETTING)
        begin
            IS_ALARM_SETTING <= 0;
            IS_ALARM_SET <= 1;
        end
        else if (is_finished)
        begin
            is_finished <= 0;
        end
    end      
    
endmodule
