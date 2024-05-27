module dec2bin(input [3:0] tens, units, output [5:0] bin);
	assign bin = 10 * tens + units;
endmodule