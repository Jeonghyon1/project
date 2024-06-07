module Top_Module (
    input wire clk,
    input wire rstb,
    input wire [15:0] dip_switch,
    input wire [4:0] push_switch,
    output wire [7:0] seg_data,
    output wire [7:0] digit,
    output wire [15:0] led,
    output wire [7:0] lcd_d,
    output wire lcd_rs,
    output wire lcd_rw,
    output wire lcd_e
);

// 인스턴스화
wire clk_1hz;
wire [31:0] current_time;

clock_divider clock_divider_inst (
    .clk_in(clk),
    .rst(rstb),
    .clk_out(clk_1hz)
);

clock_counter clock_counter_inst (
    .clk(clk_1hz),
    .rstb(rstb),
    .dip_switch(dip_switch),
    .push_switch(push_switch),
    .seg_data(seg_data),
    .digit(digit),
    .led(led)
);

time_setting time_setting_inst (
    .clk(clk),
    .rstb(rstb),
    .dip_switch(dip_switch[7:0]),
    .push_switch(push_switch),
    .time_value(current_time),
    .set_time_mode()
);

clcd clcd_inst (
    .clk(clk),
    .rstb(rstb),
    .lcd_d(lcd_d),
    .lcd_rs(lcd_rs),
    .lcd_rw(lcd_rw),
    .lcd_e(lcd_e)
);

endmodule
