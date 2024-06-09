module one_shot(
    input clk,
    input in,
    output reg out
    );
    reg buff;
    always@(posedge clk) begin
    	buff<=in;
    	out<=in&&!buff;
    end
endmodule
