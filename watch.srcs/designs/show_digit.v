module show_digit(
		input clk, rstb,
		input [7:0] en,
		input [31:0] numbers,
		output [7:0] digit,
		output reg [7:0] seg_data
	);
	wire [7:0]data[7:0];
	seg7 s0(.n(numbers[3:0]),.seg(data[0]),.en(en[0]));
	seg7 s1(.n(numbers[7:4]),.seg(data[1]),.en(en[1]));
	seg7 s2(.n(numbers[11:8]),.seg(data[2]),.en(en[2]));
	seg7 s3(.n(numbers[15:12]),.seg(data[3]),.en(en[3]));
	seg7 s4(.n(numbers[19:16]),.seg(data[4]),.en(en[4]));
	seg7 s5(.n(numbers[23:20]),.seg(data[5]),.en(en[5]));
	seg7 s6(.n(numbers[27:24]),.seg(data[6]),.en(en[6]));
	seg7 s7(.n(numbers[31:28]),.seg(data[7]),.en(en[7]));
	
	reg [2:0]d;
	assign digit = 2**d;
	
	always@(posedge clk or negedge rstb) begin
		if (!rstb) begin
			d = 0;
			seg_data = 0;
		end
		else begin
			d = d + 1;
			seg_data <= data[7-d];
		end
	end
	
//	always@(posedge clk or negedge rstb)
//	begin
//		if(!rstb)
//			seg_data <= 0;
//		else
//			seg_data <= data[d];
//	end

endmodule
