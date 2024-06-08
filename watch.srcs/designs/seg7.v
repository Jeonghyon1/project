module seg7(
    input [3:0] n,
    input en,
    output [7:0] seg
    );
/*
n: number to display
*/
    
    assign seg[0] = en? (n==0 || n==2 || n==3 || n==5 || n==6 || n==7 || n==8 || n==9) : 1'bz;
    assign seg[1] = en? (n==0 || n==1 || n==2 || n==3 || n==4 || n==7 || n==8 || n==9) : 1'bz;
    assign seg[2] = en? (n==0 || n==1 || n==3 || n==4 || n==5 || n==6 || n==7 || n==8 || n==9) : 1'bz;
    assign seg[3] = en? (n==0 || n==2 || n==3 || n==5 || n==6 || n==8 || n==9) : 1'bz;
    assign seg[4] = en? (n==0 || n==2 || n==6 || n==8) : 1'bz;
    assign seg[5] = en? (n==0 || n==4 || n==5 || n==6 || n==7 || n==8 || n==9) : 1'bz;
    assign seg[6] = en? (n==2 || n==3 || n==4 || n==5 || n==6 || n==8 || n==9) : 1'bz;
    assign seg[7] = en? 0 : 1'bz;
endmodule
