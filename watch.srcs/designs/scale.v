module scale(
	input clk,
    input rstb,
    input faster,
    input slower,
    input en,
    output reg [3:0] scale
    );
/*
	en: enable to change scale
	scale: in octal number, 1's digit indicates decimal and 8's digit does integer
*/  
	one_shot o43897598347s(.clk(clk),.in(faster&&en),.out(f_trig));
	one_shot o201s(.clk(clk),.in(slower&&en),.out(s_trig));
    always@(posedge clk) begin
    	if(!rstb)
        	scale<=4'b01_00;
    	else begin
    		if(f_trig) begin
				if(scale > 4'b00_11)
					scale <= scale + 4'b01_00;
				else
					scale <= scale + 4'b00_01;
			end
			else if(s_trig) begin
				if(scale < 4'b10_00)
					scale <= scale - 4'b00_01;
				else
					scale <= scale - 4'b01_00;
			end
    	end
    end			
endmodule
