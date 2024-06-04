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
reg [6:0] yr,mon,day,hr,min,sec;

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
        
        if(mon>12) begin
            mon=12;
            val[3]<=mon/10;
            val[2]<=mon%10;
        end
        else if(mon==0) begin
            mon=1;
            val[3]<=mon/10;
            val[2]<=mon%10;
        end
        if(day>31) begin
            day=31;
            val[1]<=day/10;
            val[0]<=day%10;
        end
        else if(day==0) begin
            day=1;
            val[1]<=day/10;
            val[0]<=day%10;
        end
            
        tmp<={yr[5:0],mon[5:0],day[5:0]};
    end
    else begin
        hr<=d2b(val[5],val[4]);
        min<=d2b(val[3],val[2]);
        sec<=d2b(val[1],val[0]);
        
        if(hr>23) begin
            hr=23;
            val[5]<=hr/10;
            val[4]<=hr%10;
        end
        if(min>59) begin
            min=59;
            val[3]<=min/10;
            val[2]<=min%10;
        end
        if(sec>59) begin
            sec=59;
            val[1]<=sec/10;
            val[0]<=sec%10;
        end
            
        tmp<={hr[5:0],min[5:0],sec[5:0]};
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