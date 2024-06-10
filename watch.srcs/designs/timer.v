module timer(
        input clk, rstb,
        input pause,
        input [17:0]current,
        output reg[17:0] rem_t,
        output alarm
    );
reg [17:0] buff;
always@(posedge clk) begin
	if(!rstb) begin
		rem_t=18'o77_77_77;
	end
	else begin
		if(!pause)
			buff<=current;
		rem_t<=buff;
	end
end
assign alarm=rem_t==0;
endmodule
