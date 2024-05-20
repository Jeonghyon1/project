module seconds(input clk, rstb, [31:0] ms_acc, [5:0] prst, output reg [5:0] sec);
/*
ms_acc: total elapsed time after reset in milisecond
prst: preset of sec

sec: current second, not representing minutes and hours
*/
	reg [31:0] ms_acc_old = 0; //to compare with past clk's ms_acc
	always@(posedge clk) begin
		if(!rstb)
			sec <= prst; //set present time, or desired timer
		else if(ms_acc % 10'd1000 == 0 && ms_acc > 0) begin //each 100ms
			if(ms_acc > ms_acc_old) begin //only if ms_acc changes
				if(sec == 6'd59)
					sec <= 0;
				else
					sec <= sec + 1;
			end
		end
		ms_acc_old <= ms_acc;
	end
endmodule