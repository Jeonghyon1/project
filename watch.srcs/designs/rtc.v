module rtc(input clk, rstb, [2:0] scale, output reg [9:0] ms, output reg iclk); //accumulated up to 2^32
/*
ms: time in milisecond, goes back to 0 with each 1s
ms_acc: total elapsed time after reset in milisecond
*/
	reg [19:0] cnt,icnt;
	parameter freq = 100;//in MHz
	parameter ifreq=50;
	
	always@(posedge clk) begin
		if(!rstb) begin //active L, sync
			cnt <= 0;
			ms <= 0;
		end
		else
		if(cnt * 2**scale == freq * 8000) begin //times of period equals 1 milisecond
			cnt <= 0;
			if(ms == 10'd999)
				ms <= 0;
			else
				ms <= ms + 1;
		end
		else
			cnt <= cnt +1;
	end
	
	always@(posedge clk) begin
		if(!rstb) begin
			icnt<=0;
			iclk<=0;
		end
		else
		if(icnt==ifreq*1000) begin
			icnt<=0;
			iclk<=~iclk;
		end
		else
			icnt<=icnt+1;
	end
endmodule
