module scale(
    input rstb,
    input faster,
    input slower,
    output reg [5:0] scale
    );
/*
  scale: in octal number, 1's digit indicates decimal and 8's digit does integer
*/  
    always@(negedge rstb)
        scale=6'o1_0;
    
    always@(posedge faster)
        if(scale > 6'o0_7)
            scale <= scale + 6'o1_0;
        else
            scale <= scale + 6'o0_1;
            
    always@(posedge slower)
        if(scale<6'o2_0)
            scale <= scale - 6'o0_1;
        else
            scale <= scale - 6'o1_0;
endmodule
