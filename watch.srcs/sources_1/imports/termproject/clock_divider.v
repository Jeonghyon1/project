module clock_divider(
    input clk_in,
    input rst,
    output reg clk_out
);

reg [26:0] counter;

always @(posedge clk_in or posedge rst) begin
    if (rst) begin
        counter <= 0;
        clk_out <= 0;
    end else if (counter == 50_000_000) begin // 100MHz / 2 = 50MHz for 1Hz toggle
        counter <= 0;
        clk_out <= ~clk_out;
    end else begin
        counter <= counter + 1;
    end
end

endmodule
