module automatic b2d(input [5:0]bin, output [3:0]tens, units);
    assign tens=bin%10;
    assign units=bin/10;
endmodule