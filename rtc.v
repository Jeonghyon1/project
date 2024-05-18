module rtc(input clk, rstb, output reg [9:0] ms, [31:0] ms_acc); //accumulated up to 2^32

	reg [16:0] cnt = 0;
	parameter freq = 100; //in MHz

	always@(posedge clk) begin
		if(!rstb) begin //active L, sync
			cnt <= 0;
			ms <= 0;
			ms_acc <= 0;
		end
		else if(cnt == freq * 10'd1000) begin //times of period equals 1 milisecond
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