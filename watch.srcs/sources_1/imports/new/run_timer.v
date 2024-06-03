module run_timer(
        input clk, rstb,
        input is_timer_running,
        input pause,        
        input [5:0] init_hour,
        input [5:0] init_min,
        input [5:0] init_sec,
        output reg [5:0] hour,
        output reg [5:0] min,
        output reg [5:0] sec,
        output reg is_end
    );
    reg IS_PAUSED;
    reg [16:0] cnt;
    reg [9:0] ms_acc;
    // max second is 86,399
    reg [17:0] remain_time;
    reg [17:0] hour_sec;
    reg [11:0] min_sec;
    
    parameter freq = 100;
    
    // Initialize
    always@(posedge is_timer_running)
    begin
        hour_sec = 3600;
        min_sec = 60;
        remain_time = hour_sec * init_hour + min_sec * init_min + init_sec;
        IS_PAUSED <= 0;
        is_end <= 0;
    end
    
    always@(posedge clk)
    begin
        if (!rstb)
        begin
            cnt <= 0;
            ms_acc <= 0;
        end
        if(!IS_PAUSED & !is_end)
        begin
            if (cnt == freq * 1000)
            begin
                cnt <= 0;
                
                if (ms_acc == 10'd999)
                begin
                    ms_acc <= 0;
                    if (remain_time == 0)
                    begin
                        is_end <= 1;
                    end
                    else
                    begin
                        remain_time <= remain_time - 1;
                    end
                end
                else
                begin
                    ms_acc <= ms_acc + 1;
                end
            end
            else begin
                cnt <= cnt + 1;
            end
        end
    end
        
    always@(posedge pause)
    begin
        IS_PAUSED <= ~IS_PAUSED;
    end
    
    always@(remain_time)
    begin
        hour <= remain_time / 3600;
        min <= (remain_time % 3600) / 60;
        sec <= (remain_time % 60);
    end
    
endmodule
