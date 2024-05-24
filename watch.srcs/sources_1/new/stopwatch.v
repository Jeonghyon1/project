`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 00:54:05
// Design Name: 
// Module Name: stopwatch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




module stopwatch(
input wire clk, rstb, sw_lap, sw_stop, sw_start, 
input wire [15:0] dip_switch,
input wire [4:0] push_switch,

output wire [7:0] seg_data,
output wire [7:0] digit,
output reg [7:0] sw_lap_time,
output reg [7:0] sw_stop_time,
output reg sw_start_display,
output wire [15:0] led,
output reg [7:0] sw_time);

reg [7:0] current_time_reg;


clock_counter clock_counter(.clk(clk), .rstb(rstb), .dip_switch(dip_switch), .push_switch(push_switch), .seg_data(seg_data), .digit(digit), .led(led));

always @(posedge clk or negedge rstb) begin
  if (!rstb) 
    begin
      sw_lap_time <= 8'b0;
      sw_stop_time <= 8'b0;
      sw_start_display <= 1'b0;
      sw_time <= 8'b0;
      current_time_reg <= 8'b0;
    end
  else 
    begin
      if (sw_lap == 1'b1) 
        begin 
          sw_lap_time <= current_time_reg;
        end
      if (sw_stop == 1'b1)
        begin 
          sw_stop_time <= current_time_reg;
          sw_start_display <= 1'b0;
        end 
      if (sw_start == 1'b1)
        begin 
          sw_start_display <= 1'b1; 
          current_time_reg <= sw_stop_time+1;
        end
      sw_time <= current_time_reg;
    end 
end

endmodule 