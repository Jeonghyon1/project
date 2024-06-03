module timer_timeset(
        input clk,
        input rstb,
        input is_timer_setting,
        input left_btn,
        input right_btn,
        input inc,
        input dec,
        output reg [5:0] hour,
        output reg [5:0] minute,
        output reg [5:0] second,
        output reg is_timer_running
    );
    
    reg [2:0] target;
    reg [5:0] set_val;
    parameter HOUR_SETTING = 3'b100, MIN_SETTING = 3'b010, SEC_SETTING = 3'b001;
    
    always@(posedge clk)
    begin
        if (is_timer_setting)
        begin
            if (rstb)
            begin
                is_timer_running <= 0;
                hour <= 0; minute <= 0; second <= 0;
                target <= SEC_SETTING; set_val <= 0;
            end
            
            case (target)
                HOUR_SETTING: begin hour <= set_val; end
                MIN_SETTING: begin minute <= set_val; end
                SEC_SETTING: begin second <= set_val; end
            endcase      
            is_timer_running <= 0;               
        end
    
    end
    
    always@(posedge left_btn)
    begin
        if (is_timer_setting)
        begin
            case (target)
                SEC_SETTING: begin target <= MIN_SETTING; end
                MIN_SETTING: begin target <= HOUR_SETTING; end
            endcase
        end
    end
    
    always@(posedge right_btn)
    begin
        if (is_timer_setting)
        begin
            case (target)
                HOUR_SETTING: begin target <= MIN_SETTING; end
                MIN_SETTING: begin target <= SEC_SETTING; end
            endcase
        end
    end
    
    always@(posedge inc)
    begin
        if (set_val == 6'd59 || (target == HOUR_SETTING && set_val == 6'd23))
        begin
            set_val <= 0;
        end
        else 
        begin
            set_val <= set_val + 1;
        end
    end
    
    always@(posedge dec)
    begin
        if (set_val == 0)
        begin
            set_val <= (target == HOUR_SETTING ? 6'd23 : 6'd59);
        end
        else
        begin
            set_val <= set_val - 1;
        end
    end
    
endmodule
