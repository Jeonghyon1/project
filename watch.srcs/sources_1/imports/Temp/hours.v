module hours(input clk, rstb, [31:0] ms_acc, [5:0] prst, output reg [5:0] hr);
/*
ms_acc: total elapsed time after reset in milisecond
prst: preset of hr

hr: current hour
*/
	reg [31:0] ms_acc_old = 0;
	always@(posedge clk) begin
		if(!rstb)
			hr <= prst;
		else if(ms_acc % 22'd3600000 == 0 && ms_acc > 0) begin
			if(ms_acc > ms_acc_old) begin
				if(hr == 6'd23)
					hr <= 0;
				else
					hr <= hr + 1;
			end
		end
		ms_acc_old <= ms_acc;
	end
endmodule