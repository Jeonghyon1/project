`timescale 1ns / 1ps
module seg7_tv;
	wire [7:0] SEG, DIGIT;
	reg CLK,EN;
	reg [31:0] NUMBERS;
	
	seg7 seg_t(.clk(CLK),.en(EN),.numbers(NUMBERS),.seg(SEG),.digit(DIGIT));
	
	initial begin
		CLK=0;EN=1;
		
		#10 NUMBERS=32'h0000_1357;
		#20 NUMBERS=32'h0040_6789;
	end
	always #0.5 CLK=~CLK;
endmodule
