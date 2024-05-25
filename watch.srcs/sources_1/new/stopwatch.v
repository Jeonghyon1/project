
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
input wire clk, rstb, sw_lap, sw_stop, 
input wire prst,

output reg [31:0] sw_lap_time,
output reg [31:0] sw_stop_time,
output reg sw_start_display,
output reg [31:0] sw_time);

reg [31:0] clock_counter;
wire [5:0] sec, min, hr;


rtc rtc(.clk(clk), .rstb(rstb), .ms(ms), .ms_acc(ms_acc));
time_transform time_transform(.clk(clk), .rstb(rstb), .ms_acc(ms_acc), .prst(prst), .sec(sec), .min(min), .hr(hr), .day(), .mon(), .yr());


always @ (*)
  begin 
    clock_counter = {hr, min, sec};
  end

always @(posedge clk or negedge rstb) begin
  if (!rstb) 
    begin
      sw_lap_time <= 32'b0;
      sw_stop_time <= 32'b0;
      sw_start_display <= 1'b0;
      sw_time <= 32'b0;
      clock_counter <= 32'b0;
    end
  else 
    begin
      if (sw_lap == 1'b1) 
        begin 
          sw_lap_time <= clock_counter;
        end
      if (sw_stop == 1'b1)
        begin 
          sw_stop_time <= clock_counter;
          sw_start_display <= 1'b0;
        end 
      else
        begin 
          sw_start_display <= 1'b1; 
          clock_counter <= sw_stop_time;
        end
      sw_time <= clock_counter;
    end 
end

endmodule 
