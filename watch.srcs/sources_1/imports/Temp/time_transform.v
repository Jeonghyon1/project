module time_transform(input clk, rstb, [31:0] ms_acc, [41:0] prst, output [41:0] t);
	reg [5:0] sec, min, hr, day, mon;
	reg [11:0] yr;
	assign t = {yr,mon,day,hr,min,sec};
	
	always@(posedge clk)
		if(!rstb) begin
			sec = prst[5:0];
			min = prst[11:6];
			hr = prst[17:12];
			day = prst[23:18];
			mon = prst[29:24];
			yr = prst[41:30];
		end
	
	always @(ms_acc) begin
		if (ms_acc % 1000 == 0 && ms_acc > 0) begin
			
			if(sec == 6'd59) begin
				sec <= 0;
				if(min == 6'd59) begin
					min <= 0;
					if(hr == 6'd23) begin
						hr <= 0;
						if(day == 6'd31 || day == 6'd30 && (mon % 2 == 1 && mon > 8 || mon % 2 == 0 && mon < 7) || day == 6'd29 && (mon == 2 && (yr % 4 != 0 || yr % 100 == 0 && yr % 400 != 0))) begin
							day <= 1;
							if(mon == 6'd12) begin
								mon <= 1;
								yr <= yr + 1;
							end
							else
							mon <= mon + 1;
						end
						else
						day <= day + 1;
					end
					else
						hr <= hr + 1;
				end
				else
					min <= min + 1;
			end
			else
				sec <= sec + 1;
		end
	end
endmodule