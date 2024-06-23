module sound(
        input clk, rstb,
        input [11:0] pitch,
        input is_ringing,
        output buzz
    );
    // clk_freq and clk_clount is for converting ns into ms
    parameter clk_freq = 100;
    reg [7:0] clk_count;
    reg buzz_temp;        
    // PITCH_CNT is used to count the pitch and compare the pitch given
    reg [11:0] PITCH_CNT;
    

    always@(posedge clk or negedge rstb)
    begin
    	// reset
        if (!rstb) begin
            clk_count <= 0;
            PITCH_CNT <= 0;
            buzz_temp <= 0;
        end
        // make a sound if is_ringing is 1
        else if (is_ringing) begin
        	// act only if clk_couont is equal to clk_freq, where 1ms has passed
            if (clk_count == clk_freq)
            begin
                clk_count <= 1;
                // if pitch is not 0 and PITCH_CNT is equal to given pitch number,
                // toggle buzz_temp to make a sound frequency
                if (pitch && PITCH_CNT == pitch)
                begin
                    PITCH_CNT <= 0;
                    buzz_temp <= ~buzz_temp;
                end
                // increment of PITCH_CNT
                else
                begin
                    PITCH_CNT <= PITCH_CNT + 1;
                end
            // increment of clk_count
            end
            else begin
                clk_count <= clk_count + 1;
            end
        end
    end
    
    
    assign buzz = buzz_temp;
endmodule