module alarm_timeset(
        input clk, rstb,
        input is_alarm_setting,
        input left_btn, right_btn,
        input inc, dec,
        output reg [5:0] hour,
        output reg [5:0] min
    );
    
    reg target;
    reg [5:0] set_val;
    parameter HOUR_SETTING = 1, MIN_SETTING = 0;
    
    always@(posedge clk)
    begin
        if (is_alarm_setting)
        begin
            if (rstb)
            begin
                hour <= 0;
                min <= 0;
                set_val <= 0;
                target <= MIN_SETTING;
            end
            case (target)
                HOUR_SETTING: begin hour <= set_val; end
                MIN_SETTING: begin min <= set_val; end
            endcase
        end
    end    
    
    always@(posedge left_btn)
    begin
        if (target == MIN_SETTING)
        begin
            target <= HOUR_SETTING;
        end
    end
    
    always@(posedge right_btn)
    begin
        if (target == HOUR_SETTING)
        begin
            target <= MIN_SETTING;
        end
    end
    
    always@(posedge inc)
    begin
        if (set_val == 6'd59 || (target == HOUR_SETTING && set_val == 6'd23)) begin
            set_val <= 0;
        end
        else begin
            set_val <= set_val + 1;
        end
    end
    
    always@(posedge dec)
    begin
        if (set_val == 0) begin
            set_val <= (target == HOUR_SETTING ? 6'd23 : 6'd59);
        end
        else begin
            set_val <= set_val - 1;
        end
    end
    
endmodule
