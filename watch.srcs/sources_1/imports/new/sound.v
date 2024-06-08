module sound(
        input clk, rstb,
        input [11:0] pitch,
        input is_ringing,
        output buzz_clk,
        output buzz
    );    
    parameter clk_freq = 100;
    reg [7:0] clk_count;
    reg buzz_temp;        
    
    reg CLK;
    reg [11:0] PITCH_CNT;
    

    always@(posedge clk or negedge rstb)
    begin
        if (!rstb) begin
            clk_count <= 0;
            PITCH_CNT <= 0;
            CLK <= 0;
            buzz_temp <= 0;
        end
        else if (is_ringing) begin
            if (clk_count == clk_freq)
            begin
                clk_count <= 1;
                if (pitch && PITCH_CNT == pitch)
                begin
                    PITCH_CNT <= 0;
                    buzz_temp <= ~buzz_temp;
                end
                else
                begin
                    PITCH_CNT <= PITCH_CNT + 1;
                end
            end
            else begin
                clk_count <= clk_count + 1;
            end
        end
    end
    
    
    assign buzz = buzz_temp;
endmodule