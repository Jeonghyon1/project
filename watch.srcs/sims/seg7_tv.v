`timescale 1ms / 1ps
module seg7_tv;
	wire [7:0] SEG, DIGIT;
	reg MS;
	reg RSTB;
	reg [31:0] NUMBERS;
	
	show_digit show1(.clk(MS),.numbers(NUMBERS),.seg_data(SEG),.digit(DIGIT),.rstb(RSTB));
	
	initial begin
		MS=0;RSTB=0;
		#1 RSTB=1;
		
		#10 NUMBERS=32'h0000_1357;
		#25 NUMBERS=32'h0040_6789;
	end
	always #0.5 MS=~MS;
endmodule
