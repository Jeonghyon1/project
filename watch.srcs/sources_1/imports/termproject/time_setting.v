module time_setting (
    input clk,
    input rstb,
    input left,right,
    input inc, dec,
    input set,mode,
    output reg [17:0] t,
    output reg [17:0] tmp,
    output reg [2:0] digit
);
/*

*/

reg [3:0] val [5:0];
integer i;
reg [5:0] yr,mon,day,hr,min,sec;

function [6:0] d2b(input [3:0] tens,units);
    d2b = 10 * tens + units;
endfunction

always @(posedge clk) begin
    if (!rstb) begin
        digit=0;
        for(i=0;i<6;i=i+1)
            val[i]=0;
    end
    if(mode) begin
        yr<=d2b(val[5],val[4]);
        mon<=d2b(val[3],val[2]);
        day<=d2b(val[1],val[0]);
        
        if(mon>12)
            mon<=12;
        else if(mon==0)
            mon<=1;
        if(day>31)
            day<=31;
        else if(day==0)
            day<=1;
            
        tmp<={yr,mon,day};
    end
    else begin
        hr<=d2b(val[5],val[4]);
        min<=d2b(val[3],val[2]);
        sec<=d2b(val[1],val[0]);
        
        if(hr>23)
            hr<=23;
        if(min>59)
            min<=59;
        if(sec>59)
            sec<=59;
            
        tmp<={hr,min,sec};
    end
end

always@(posedge set)
    t<=tmp;

always@(posedge inc)
    if(val[digit]==9)
        val[digit]<=0;
    else
        val[digit]<=val[digit]+1;
        
always@(posedge dec)
    if(val[digit]==0)
        val[digit]<=9;
    else
        val[digit]<=val[digit]-1;

always@(posedge left)
    if(digit==5)
        digit<=0;
    else
        digit<=digit+1;

always@(posedge right)
    if(digit==0)
        digit<=5;
    else
        digit<=digit-1;

endmodule