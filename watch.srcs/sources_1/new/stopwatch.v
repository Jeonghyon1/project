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

module stopwatch(input sw_rstb, clk,[31:0]ms_acc, [5:0]prst,sw_lap, output [5:0]sw_sec, [5:0]sw_min,[3:0]sw_hr, reg [5:0]sw_sec, [5:0]sw_min, [4:0]sw_hr);

	always@(posedge clk)
	begin
		if(sw_rstb==1'b1)
		begin
		   sw_sec<=prst;
		   sw_min<=prst;
		   sw_hr<=prst; 
		end
		else 
		begin
		   if (sw_lap==1'b0) //record time 
		   begin
		       sw_sec <= sw_sec;
		       sw_min <= sw_min;
		       sw_hr <= sw_hr;
		   end
		   else
		   begin
		       if (ms_acc>=0)
		       begin
		           if (sw_sec == 6'b111100)
		              sw_sec <= 0;
		           else 
		           begin
		              sw_sec <= sw_sec+1;
		           end
		           if (ms_acc>=16'd60000)
		           begin
		              if (sw_min == 6'b111100)
		                 sw_min <= 0;
		              else 
		              begin 
		                 sw_min <= sw_min+1;
		              end
		              if (ms_acc>=22'd3600000)
		              begin
		                 if (sw_hr == 5'b11000)
		                    sw_hr <= 0;
		              else
		                    sw_hr <= sw_hr+1;
		              end
		           end   
		       end               
		   end
		end   
	end
endmodule
