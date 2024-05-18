module minutes(input clk, rstb, [31:0] ms_acc, [5:0] prst, output reg [5:0] min);
	reg [31:0] ms_acc_old = 0;
	always@(posedge clk) begin
		if(!rstb)
			min <= prst;
		else if(ms_acc % 16'd60000 == 0 && ms_acc > 0) begin
			if(ms_acc > ms_acc_old) begin
				if(min == 6'd59)
					min <= 0;
				else
					min <= min + 1;
			end
		end
		ms_acc_old <= ms_acc;
	end
endmodule