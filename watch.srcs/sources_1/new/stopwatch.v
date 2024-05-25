
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

//testbench//
module stopwatch_tb();

// Inputs
	reg clk; 
	reg rstb; 
	reg sw_lap; 
	reg sw_stop;
	reg [31:0] prst;


// Outputs
wire [7:0] sw_lap_time;
wire [7:0] sw_stop_time;
wire sw_start_display;
wire [7:0] sw_time;	
wire [5:0] sec;
wire [5:0] min;
wire [5:0] hr; 
wire [5:0] day;
wire [5:0] mon; 
wire [5:0] yr;
wire [9:0] ms;
wire [31:0] ms_acc;

stopwatch stopwatch(.clk(clk), .rstb(rstb), .prst(prst), .sw_lap(sw_lap), .sw_stop(sw_stop), .sw_lap_time(sw_lap_time), .sw_stop_time(sw_stop_time), .sw_start_display(sw_start_display), .sw_time(sw_time));


  always #5 clk =~clk;
  
// Initialize Inputs
initial 
begin
  clk = 0;
  rstb = 0;
  sw_lap = 0;
  sw_stop = 0;
  prst = 32'b0;
  
  
  #10 rstb = 1;  

  #1000 sw_lap = 1;
  #10 sw_lap = 0;
  
  #1000 sw_stop = 1;
  #10 sw_stop = 0;
end
endmodule
