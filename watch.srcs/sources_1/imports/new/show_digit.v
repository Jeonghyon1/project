module show_digit(
        input clk, rstb,
        input [17:0] t,
        output reg [7:0] digit,
        output reg [7:0] seg_data
    );
    
    reg [16:0] clk_cnt;
    reg seg_clk;
    
    wire [3:0] hr_tens, hr_units, min_tens, min_units, sec_tens, sec_units;
    bin2dec hr (.bin(t[17:12]), .tens(hr_tens), .units(hr_units));
    bin2dec min (.bin(t[11:6]), .tens(min_tens), .units(min_units));
    bin2dec sec (.bin(t[5:0]), .tens(sec_tens), .units(sec_units));
    
    wire [7:0] seg_hr_t, seg_hr_u, seg_min_t, seg_min_u, seg_sec_t, seg_sec_u;
    seg7 hr_t(.n(hr_tens), .seg(seg_hr_t));
    seg7 hr_u(.n(hr_units), .seg(seg_hr_u));
    seg7 min_t(.n(min_tens), .seg(seg_min_t));
    seg7 min_u(.n(min_units), .seg(seg_min_u));
    seg7 sec_t(.n(sec_tens), .seg(seg_sec_t));
    seg7 sec_u(.n(sec_units), .seg(seg_sec_u));

    
    always@(posedge clk) 
    begin
        if (clk_cnt == 17'd99999)
        begin
            clk_cnt <= 17'd0;
            seg_clk <= ~seg_clk;
        end
        else
        begin
            clk_cnt <= clk_cnt + 1;
        end
    end
    
    
    always@(posedge seg_clk or negedge rstb)
    begin
        if (!rstb) begin
            digit <= 8'b1000_0000;
        end
        else begin
            digit <= {digit[0], digit[7:1]};
        end
    end
    
    always@(posedge seg_clk or negedge rstb) 
    begin
        if(!rstb)
        begin
            seg_data <= 8'd0;
        end
        else
        begin
            case(digit)
                8'b0000_1000: begin seg_data <= seg_hr_t; end
                8'b0001_0000: begin seg_data <= seg_hr_u; end
                8'b0010_0000: begin seg_data <= seg_min_t; end
                8'b0100_0000: begin seg_data <= seg_min_u; end
                8'b1000_0000: begin seg_data <= seg_sec_t; end
                8'b0000_0001: begin seg_data <= seg_sec_u; end
                default: begin seg_data <= 8'd0; end
            endcase
        end
    end   
    
endmodule
