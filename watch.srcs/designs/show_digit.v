module show_digit(
		input clk, rstb,dot,
		input [31:0] numbers,
		output [7:0] digit,
		output reg [7:0] seg_data
	);
	wire [7:0]data[7:0];
	
	genvar i;
	generate for(i=0;i<8;i=i+1) begin
		seg7 seg(.n(numbers[4*i+3:4*i]),.seg(data[i]));
	end endgenerate
	reg [2:0]d;
	assign digit = 2**d;
	
	always@(posedge clk or negedge rstb) begin
		if (!rstb) begin
			d = 0;
			seg_data = 0;
		end
		else begin
			d = d + 1;
			seg_data = data[7-d];
			seg_data[7] = dot & (d==7 | d==5 | d==3);
		end
	end
endmodule
