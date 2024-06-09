module stopwatch(
input clk, rstb, sw_lap, sw_pause,
input [17:0] current,
output reg [71:0] laps,
output reg [17:0] sw_time);
/*
sw_lap: to record a laptime, press triggered
sw_pause: to pause, activate. to release, supress
current: input time, must be re-initialized to sw_time when pause is released
 
lap_0 - lap_3: multiple stroage
sw_time: represent stopwatch time
*/

wire trig;
one_shot o2135s(.clk(clk),.in(sw_lap),.out(trig));

always @(posedge clk) begin
	if (!rstb) begin 
		laps=0;
		sw_time = 18'b0;
	end
	else begin
		if(!sw_pause)
			sw_time<=current;
		if(trig) begin
			laps=laps<<18;
			laps[17:0]<=sw_time;
		end
	end
end
endmodule
