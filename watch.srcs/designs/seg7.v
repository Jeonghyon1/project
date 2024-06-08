module seg7(
	input clk,
	input en,
	input [31:0] numbers,
	output reg [7:0] seg,
	output reg [7:0] digit
	);
/*

*/
	reg [3:0] n;
    integer i;
	always@(numbers) begin
		@(negedge clk);
    	for(i=0;i<8;i=i+1) begin
    		digit=0;
			n = {numbers[4*i+3],numbers[4*i+2],numbers[4*i+1],numbers[4*i]}; // can't slice with variable
			seg[0] <= en?(n==0 || n==2 || n==3 || n==5 || n==6 || n==7 || n==8 || n==9):1'bz;
			seg[1] <= en?(n==0 || n==1 || n==2 || n==3 || n==4 || n==7 || n==8 || n==9):1'bz;
			seg[2] <= en?(n==0 || n==1 || n==3 || n==5 || n==4 || n==6 || n==7 || n==8 || n==9):1'bz;
			seg[3] <= en?(n==0 || n==2 || n==3 || n==5 || n==6 || n==8 || n==9):1'bz;
			seg[4] <= en?(n==0 || n==2 || n==6 || n==8):1'bz;
			seg[5] <= en?(n==0 || n==4 || n==5 || n==6 || n==7 || n==8 || n==9):1'bz;
			seg[6] <= en?(n==2 || n==3 || n==4 || n==5 || n==6 || n==8 || n==9):1'bz;
			seg[7] <= 1'b0;
			
			digit[i]<=1;
			@(posedge clk);@(negedge clk);
    	end
    end
endmodule
