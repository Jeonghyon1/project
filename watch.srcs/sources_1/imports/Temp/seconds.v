module seconds(input clk, rstb, [31:0] ms_acc, [5:0] prst, output reg [5:0] sec);
	reg [31:0] ms_acc_old = 0;
	always@(posedge clk) begin
		if(!rstb)
			sec <= prst;
		else if(ms_acc % 10'd1000 == 0 && ms_acc > 0) begin
			if(ms_acc > ms_acc_old) begin
				if(sec == 6'd59)
					sec <= 0;
				else
					sec <= sec + 1;
			end
		end
		ms_acc_old <= ms_acc;
	end
endmodule