module scale(
	input clk,
    input rstb,
    input faster,
    input slower,
    input en,
    output reg [2:0] scale
    );
/*
	en: enable to change scale
	scale: in octal number, 1's digit indicates decimal and 8's digit does integer
*/  
	one_shot o43897598347s(.clk(clk),.in(faster&&en),.out(f_trig));
	one_shot o201s(.clk(clk),.in(slower&&en),.out(s_trig));
    always@(posedge clk) begin
    	if(!rstb)
        	scale<=3;
    	else begin
    		if(f_trig) begin
				if(scale == 7)
					scale <= scale;
				else
					scale <= scale + 1;
			end
			else if(s_trig) begin
				if(scale == 0)
					scale <= scale;
				else
					scale <= scale - 1;
			end
			else
				scale<=scale;
    	end
    end			
endmodule
