module time_setting (
    input wire clk,
    input wire rstb,
    input wire [7:0] dip_switch,
    input wire [4:0] push_switch,
    output reg [31:0] time_value,
    output reg set_time_mode
);

// Internal time registers
reg [3:0] month_tens, month_units, day_tens, day_units;
reg [3:0] hour_tens, hour_units, minute_tens, minute_units, second_tens, second_units;

always @(posedge clk or negedge rstb) begin
    if (!rstb) begin
        month_tens <= 0;
        month_units <= 0;
        day_tens <= 0;
        day_units <= 0;
        hour_tens <= 0;
        hour_units <= 0;
        minute_tens <= 0;
        minute_units <= 0;
        second_tens <= 0;
        second_units <= 0;
    end else begin
        if (dip_switch[0]) begin
            if (push_switch[0]) month_tens <= (month_tens < 9) ? month_tens + 1 : month_tens;
            if (push_switch[1]) month_tens <= (month_tens > 0) ? month_tens - 1 : month_tens;
        end else if (dip_switch[1]) begin
            if (push_switch[0]) month_units <= (month_units < 9) ? month_units + 1 : month_units;
            if (push_switch[1]) month_units <= (month_units > 0) ? month_units - 1 : month_units;
        end else if (dip_switch[2]) begin
            if (push_switch[0]) day_tens <= (day_tens < 9) ? day_tens + 1 : day_tens;
            if (push_switch[1]) day_tens <= (day_tens > 0) ? day_tens - 1 : day_tens;
        end else if (dip_switch[3]) begin
            if (push_switch[0]) day_units <= (day_units < 9) ? day_units + 1 : day_units;
            if (push_switch[1]) day_units <= (day_units > 0) ? day_units - 1 : day_units;
        end else if (dip_switch[4]) begin
            if (push_switch[0]) hour_tens <= (hour_tens < 9) ? hour_tens + 1 : hour_tens;
            if (push_switch[1]) hour_tens <= (hour_tens > 0) ? hour_tens - 1 : hour_tens;
        end else if (dip_switch[5]) begin
            if (push_switch[0]) hour_units <= (hour_units < 9) ? hour_units + 1 : hour_units;
            if (push_switch[1]) hour_units <= (hour_units > 0) ? hour_units - 1 : hour_units;
        end else if (dip_switch[6]) begin
            if (push_switch[0]) minute_tens <= (minute_tens < 9) ? minute_tens + 1 : minute_tens;
            if (push_switch[1]) minute_tens <= (minute_tens > 0) ? minute_tens - 1 : minute_tens;
        end else if (dip_switch[7]) begin
            if (push_switch[0]) minute_units <= (minute_units < 9) ? minute_units + 1 : minute_units;
            if (push_switch[1]) minute_units <= (minute_units > 0) ? minute_units - 1 : minute_units;
        end

        if (push_switch[2]) begin
            set_time_mode <= 1;
            time_value <= {month_tens, month_units, day_tens, day_units, hour_tens, hour_units, minute_tens, minute_units};
        end
    end
end

endmodule
