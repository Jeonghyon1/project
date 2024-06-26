module debounce(
    input clk,
    input in,
    output reg out
    );
    reg buff;
    parameter MAX=16;
    integer cnt;
    always@(posedge clk or negedge in) begin
    	if(!in) begin
    		out=0;
    		cnt=0;
    	end
    	else begin
    		buff <= in;
    		if(cnt==MAX)
    			out<=buff;
    		else if(buff != out)
    			cnt <= cnt+1;
    	end
    end
endmodule
