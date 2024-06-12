module timer(
        input clk, rstb,
        input pause,
        input [17:0]current,
        output reg[17:0] rem_t,
        output wire alarm
    );
reg [17:0] buff;
always@(posedge clk or negedge rstb) begin
	if(!rstb) begin
		rem_t<=18'o27_73_73;
		buff<=18'o27_73_73;
	end
	else begin
		if(!pause) begin
			buff<=current;
			rem_t<=buff;
		end
		else begin
			buff<=buff;
			rem_t<=rem_t;
		end
	end
end
one_shot sdkf(.clk(clk),.in(rem_t==0),.out(alarm));
endmodule
