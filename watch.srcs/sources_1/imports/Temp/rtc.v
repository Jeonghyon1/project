module rtc(input clk, rstb, [63:0] scale, output reg [9:0] ms, reg [31:0] ms_acc); //accumulated up to 2^32
/*
ms: time in milisecond, goes back to 0 with each 1s
ms_acc: total elapsed time after reset in milisecond
*/
	reg [16:0] cnt = 0;
	parameter freq = 100;//in MHz

	always@(posedge clk) begin
		if(!rstb) begin //active L, sync
			cnt <= 0;
			ms <= 0;
			ms_acc <= 0;
		end
		else if(cnt * $bitstoreal(scale) == freq * 10'd1000) begin //times of period equals 1 milisecond
			cnt <= 0;
			ms_acc <= ms_acc + 1;

			if(ms == 10'd999)
				ms <= 0;
			else
				ms <= ms + 1;
		end
		else
			cnt <= cnt +1;
	end
endmodule