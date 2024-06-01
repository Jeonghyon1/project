module time_setting (
    input clk,
    input rstb,
    input [5:0] digits,
    input inc,
    input dec,
    input mode,
    output [41:0] t
);
/*
    digits: decoded selection(not sure if multiple bits are true), tens&units, hr&min&sec or yr&mon&day
    mode: true for date, false for time
    
    t: concat date&time
*/

reg [3:0] val_y [5:0];
reg [3:0] val_t [5:0];
integer i,n;

function [6:0] d2b(input [3:0] tens,units);
    d2b = 10 * tens + units;
endfunction

reg [5:0] yr,mon,day,hr,min,sec;
assign t={1970+yr,1+mon,1+day,hr,min,sec};

always @(posedge clk) begin
    if (!rstb) begin
        for(i=0;i<6;i=i+1) begin
            val_y[i]=0;
            val_t[i]=0;
        end
    end
    
    n=digits[1]+2*digits[2]+3*digits[3]+4*digits[4]+5*digits[5];
    
    yr<=d2b(val_y[5],val_y[4]);
    mon<=d2b(val_y[3],val_y[2]);
    day<=d2b(val_y[1],val_y[0]);
    
    hr<=d2b(val_t[5],val_t[4]);
    min<=d2b(val_t[3],val_t[2]);
    sec<=d2b(val_t[1],val_t[0]);
    
    
end

always@(posedge inc)
    if(mode)
        val_y[n]<=val_y[n]+1;
    else
        val_t[n]<=val_t[n]+1;
        
always@(posedge dec)
    if(mode)
        val_y[n]<=val_y[n]-1;
    else
        val_t[n]<=val_t[n]-1;

endmodule
