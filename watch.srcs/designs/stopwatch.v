module stopwatch(
input clk, rstb, sw_lap, sw_pause,
input [17:0] current,
output [17:0] lap_0,lap_1,lap_2,lap_3,
output reg [17:0] sw_time);
/*
sw_lap: to record a laptime, press triggered
sw_pause: to pause, activate. to release, supress
current: input time, must be re-initialized to sw_time when pause is released
 
lap_0 - lap_3: multiple stroage
sw_time: represent stopwatch time
*/

reg [17:0] lap [3:0];
assign lap_0=lap[0];
assign lap_1=lap[1];
assign lap_2=lap[2];
assign lap_3=lap[3];
integer i;

always @(posedge clk) begin
  if (!rstb)
    begin 
      for(i=0;i<4;i=i+1)
        lap[i] = 18'bz;
      sw_time = 18'b0;
    end
  else if(!sw_pause)
    sw_time<=current;
end

always@(posedge sw_lap) begin
    lap[0]<=sw_time;
    lap[1]<=lap[0];
    lap[2]<=lap[1];
    lap[3]<=lap[2];
    @(negedge sw_lap);
end
endmodule