module time_setting (
    input clk,
    input rstb,
    input left, right,
    input inc, dec,
    input set,mode,
    input [17:0] prst_d,
    input [17:0] prst_t,
    output reg [17:0] t, date,
    output reg [17:0] tmp,
    output reg [2:0] digit
    ,output reg set_done
);
/*

*/
//reg [3:0] val [5:0];
integer i;
reg [5:0] yr,mon,day,hr,min,sec;
reg btn_pushed;
reg btn_prev;
wire [5:0] btns;
//reg VAL_CHANGED;

wire [5:0] trig;
assign trig[5]=0;
one_shot o3s(.clk(clk),.in(left),.out(trig[4]));
one_shot o4s(.clk(clk),.in(right),.out(trig[3]));
one_shot o5s(.clk(clk),.in(inc),.out(trig[2]));
one_shot o6s(.clk(clk),.in(dec),.out(trig[1]));
one_shot o7s(.clk(clk),.in(set),.out(trig[0]));

//assign btns = {1'b0, left, right, inc, dec, set};

//function [6:0] d2b(input [3:0] tens,units);
//    d2b = 10 * tens + units;
//endfunction

always@(posedge clk or negedge rstb) begin
if(!rstb) begin
digit <= 0;
tmp <= 0;
if(prst_d)begin
{yr,mon,day}<=prst_d;
date<=prst_d;
end else begin
{yr,mon,day}<={6'd24,6'd1,6'd1};
date<={6'd24,6'd1,6'd1};
end
if(prst_t)begin
{hr,min,sec}<=prst_t;
t<=prst_t;
end else begin
{hr,min,sec}<=0;
t<=0;
end

//VAL_CHANGED <= 1;
set_done=0;
end
else begin
//    if (btns) 
//    begin
//        btn_pushed <= 1;
//    end
//    else
//    begin
//        btn_pushed <= 0;
//        btn_prev <= 0;
//    end
    
//    if (!btn_prev && btn_pushed)
//    begin
//        btn_prev <= 1;
        case (trig)
//            6'b100000: begin // rstb
//                digit <= 0;
//                tmp <= 0;
//                t <= 0;
//                sec <= 0;
//                min <= 0;
//                hr <= 0;
//                day <= 1;
//                mon <= 1;
//                yr <= 24;
//                VAL_CHANGED <= 1;
//            end
            6'b010000: begin // left
                if (digit == 3'd5)
                    digit <= 0;
                else
                    digit <= digit + 1;
            end
            6'b001000: begin // right
                if (digit == 3'b0)
                    digit <= 3'd5;
                else
                    digit <= digit - 1;
            end
            6'b000100: begin // inc
                case ({mode, digit})
                    4'b0_000: begin
                        if (sec == 6'd59)
                            sec <= 0;
                        else
                            sec <= (sec + 1);
                    end
                    4'b0_001: begin
                        if (sec >= 6'd50)
                            sec <= (sec - 6'd50);
                        else
                            sec <= (sec + 10);
                    end
                    4'b0_010: begin
                        if (min == 6'd59)
                            min <= 0;
                        else
                            min <= (min + 1);
                    end
                    4'b0_011: begin
                        if (min  >= 6'd50)
                            min <= (min - 6'd50);
                        else
                            min <= (min + 10);
                    end
                    4'b0_100: begin
                        if (hr ==6'd23)
                            hr <= 0;
                        else
                            hr <= (hr + 1);
                    end
                    4'b0_101: begin
                        if (hr < 6'd14)
                            hr <= (hr + 10);
                        else
                            hr <= 6'd23;
                    end
                    4'b1_000: begin
                        case (mon)
                            6'd4, 6'd6, 6'd9, 6'd11: begin
                                day <= ((day == 6'd30) ? 1 : (day + 1));
                            end
                            6'd2: begin
                                if (yr & 6'b000011) begin   // if year % 4 != 0
                                    day <= ((day == 6'd28) ? 1 : (day + 1));
                                end
                                else begin
                                    day <= ((day == 6'd29) ? 1 : (day + 1));
                                end
                            end
                            default: begin
                                day <= ((day == 6'd31) ? 1 : (day + 1));
                            end
                        endcase
                    end
                    4'b1_001: begin
                        case (mon)
                            6'd4, 6'd6, 6'd9, 6'd11: begin
                                day <= ((day >= 6'd20) ? 6'd30 : (day + 10));
                            end
                            6'd2: begin
                                if (yr & 6'b000011) begin   // if year % 4 != 0
                                    day <= ((day >= 6'd18) ? 6'd28 : (day + 10));
                                end
                                else begin
                                    day <= ((day >= 6'd19) ? 6'd29 : (day + 10));
                                end
                            end
                            default: begin
                                day <= ((day >= 6'd21) ? 6'd31 : (day + 10));
                            end
                        endcase
                    end
                    4'b1_010: begin
                        mon <= ((mon == 6'd12) ? 6'd1 : (mon + 1));
                    end
                    4'b1_011: begin
                        mon <= ((mon >= 6'd3) ? 6'd12 : (mon + 10));
                    end
                    4'b1_100: begin
                        yr <= (yr + 1);
                    end
                    4'b1_101: begin
                        yr <= ((yr >= 6'd53) ? 6'd63 : (yr + 6'd10));
                    end
                    default: begin
                        sec <= 0;
                        min <= 0;
                        hr <= 0;
                        day <= 1;
                        mon <= 1;
                        yr <= 24;
                    end
                endcase
//                VAL_CHANGED <= 1;
            end
            6'b000010: begin // dec
                case ({mode, digit})
                    4'b0_000: begin
                        sec <= ((sec == 0) ? 6'd59 : (sec - 1));
                    end
                    4'b0_001: begin
                        sec <= ((sec <= 6'd9) ? (sec + 6'd50) : (sec - 6'd10));
                    end
                    4'b0_010: begin
                        min <= ((min == 0) ? 6'd59 : (min - 1));
                    end
                    4'b0_011: begin
                        min <= ((min <= 6'd9) ? (min + 6'd50) : (min - 6'd10));
                    end
                    4'b0_100: begin
                        hr <= ((hr == 0) ? 6'd23 : (hr - 1));
                    end
                    4'b0_101: begin
                        hr <= ((hr <= 6'd10) ? 0 : (hr - 6'd10));
                    end
                    4'b1_000: begin
                        case (mon)
                            6'd4, 6'd6, 6'd9, 6'd11: begin
                                day <= ((day == 6'd1) ? 6'd30 : (day - 1));
                            end
                            6'd2: begin
                                if (yr & 6'b000011) begin   // if year % 4 != 0
                                    day <= ((day == 6'd1) ? 6'd28 : (day - 1));
                                end
                                else begin
                                    day <= ((day == 6'd1) ? 6'd29 : (day - 1));
                                end
                            end
                            default: begin
                                day <= ((day == 6'd1) ? 6'd31 : (day - 1));
                            end
                        endcase
                    end
                    4'b1_001: begin
                        day <= ((day <= 6'd11) ? 6'd1 : (day - 10));
                    end
                    4'b1_010: begin
                        mon <= ((mon == 6'd1) ? 6'd12 : (mon - 1));
                    end
                    4'b1_011: begin
                        mon <= ((mon == 6'd12) ? 6'd2 : 6'd1);
                    end
                    4'b1_100: begin
                        yr <= (yr - 1);
                    end
                    4'b1_101: begin
                        yr <= ((yr <= 6'd10) ? 6'd0 : (yr - 6'd10));
                    end
                    default: begin
                        sec <= 0;
                        min <= 0;
                        hr <= 0;
                        day <= 1;
                        mon <= 1;
                        yr <= 24;
                    end
                endcase
//                VAL_CHANGED <= 1;
            end
            6'b000001: begin // set
                if(mode)
                	date<=tmp;
                else
                	t <= tmp;
                set_done<=1;
            end
            default: begin
            
            end
        endcase 
    	if(mode)
    		tmp<={yr,mon,day};
    	else
    		tmp<={hr,min,sec};
    end
end



/*always @(posedge clk) begin
    if (!rstb) begin
        signal <= 5'b11010;
        digit<=0;
        signal<=5'b0;
        for(i=0;i<6;i=i+1)
            val[i]<=0;
    end
    else if(mode) begin
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
            
        tmp<={yr,mon,day};
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
            
        tmp<={hr,min,sec};
    end
end

always@(posedge clk or posedge set)
begin
    if (set) begin
        t<=tmp;
        signal[0] <= 1;
    end
    else begin
        signal[0] <= 0;
    end
end

always@(posedge clk or posedge inc)
begin
    if (inc) begin
        signal[1] <= 1;
        if(val[digit]==4'd9)
            val[digit]<=0;
        else
            val[digit]<=val[digit]+1;
    end
    else begin
        signal[1] <= 0;
    end
end
                
always@(posedge clk or posedge dec)
begin
    if (dec) begin
        signal[2] <= 1;
        /f(val[digit]==0)
            val[digit]<=4'd9;
        else
            val[digit]<=val[digit]-1;
    end
    else begin
        signal[2] <= 0;
    end
end

always@(posedge clk or posedge left)
begin
    if (left) begin
        signal[3] <= 1;
        if(digit==3'd5)
            digit<=0;
        else
            digit<=digit+1;
    end
    else begin
        signal[3] <= 0;
    end
end

always@(posedge clk or posedge right)
begin
    if (right) begin
        signal[4] <= 1;
        if(digit==0)
            digit<=3'd5;
        else
            digit<=digit-1;
    end
    else begin
        signal[4] <= 0;
    end
end*/

endmodule