`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/07 13:31:21
// Design Name: 
// Module Name: pixel_clk_generation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pixel_clk_generation(
    input clk,
    input display_on,
    input [9:0] pixel_x, 
    input [9:0] pixel_y,
    input [5:0] sec,
    input [5:0] min, 
    input [5:0] hour,
    input [5:0] curr_hour,
    input [5:0] curr_min, 
    input [17:0] current, 
    input [17:0] sw_time, 
    input [17:0] date,
    input [17:0] t,
    output reg [3:0] R_data,
    output reg [3:0] G_data,
    output reg [3:0] B_data
    );
//
//alarm - [5:0] hour
//        [5:0] min
//        [5:0] curr_hour
//        [5:0] curr_min
//timer - [5:0] hour
//        [5:0] min 
//        [5:0] sec
//stopwatch - [17:0] current 
//            [17:0] sw_time
//time_transform - [17:0] date(yr,mon,day)
//                 [17:0] t(hr,min,sec)
         
    wire [3:0] hr10, hr1, min10, min1, sec10, sec1, yr1000, yr100, yr10, yr1, mon10, mon1, day10, day1, c1, c2, p1, p2; 
    
    assign hr10 = (hour / 10) | (curr_hour / 10) | (current[17:12] / 10) | (sw_time[17:12] / 10) | (t[17:12] / 10);
    assign hr1 = (hour % 10) | (curr_hour % 10) | (current[17:12] % 10) | (sw_time[17:12] % 10) | (t[17:12] % 10);
    
    assign min10 = (min / 10) | (curr_min / 10) | (current[11:6] / 10) | (sw_time[11:6] / 10) | (t[11:6] / 10);
    assign min1 = (min % 10) | (curr_min % 10) | (current[11:6] % 10) | (sw_time[11:6] % 10) | (t[11:6] % 10); 
    
    assign sec10 = (sec / 10) | (current[5:0] / 10) | (sw_time[5:0] / 10) | (t[5:0] / 10);
    assign sec1 = (sec % 10) | (current[5:0] % 10) | (sw_time[5:0] % 10) | (t[5:0] % 10);
    
    assign yr1000 = (date[17:12] / 1000) % 10;
    assign yr100 = (date[17:12] / 100) % 10;
    assign yr10 = (date[17:12] / 10) % 10;
    assign yr1 = date[17:12] % 10;
    
    assign mon10 = date[11:6] / 10;
    assign mon1 = date[11:6] % 10; 
    
    assign day10 = date[11:6] / 10;
    assign day1 = date[11:6] % 10;
    
    wire digit;
    reg [3:0] rom;
    wire [2:0] row;
    wire [2:0] col;
    reg [9:0] rom_x;
    reg [9:0] rom_y;
    
    digit_rom digit_rom_inst(.rom(rom), .row(row), .col(col), .digit(digit));
    
         
    //640*480 pixel location of digital num 
    //hr10 digit pixel location = 32 * 64  (s:start, e:end)
    localparam hr10_x_s = 192;
    localparam hr10_x_e = 223;
    
    //hr11 digit pixel location = 32 * 64
    localparam hr1_x_s = 226;
    localparam hr1_x_e = 257;
    
    //min10 digit pixel location = 32 * 64
    localparam min10_x_s = 394;
    localparam min10_x_e = 325;
    
    //min1 digit pixel location = 32 * 64
    localparam min1_x_s = 328;
    localparam min1_x_e = 359;
    
    //sec10 digit pixel location = 32 * 64
    localparam sec10_x_s = 408;
    localparam sec10_x_e = 439;
    
    //sec1 digit pixel location = 32 * 64
    localparam sec1_x_s = 408;
    localparam sec1_x_e = 439;
    
    //yr1000 digit pixel location = 32 * 64
    localparam yr1000_x_s = 160;
    localparam yr1000_x_e = 191;
    
    //yr100 digit pixel location = 32 * 64
    localparam yr100_x_s = 193;
    localparam yr100_x_e = 224;
    
    //yr10 digit pixel location = 32 * 64
    localparam yr10_x_s = 226;
    localparam yr10_x_e = 257;
    
    //yr1 digit pixel location = 32 * 64
    localparam yr1_x_s = 259;
    localparam yr1_x_e = 290;
    
    //mon10 digit pixel location = 32 * 64
    localparam mon10_x_s = 325;
    localparam mon10_x_e = 356;
    
    //mon1 digit pixel location = 32 * 64
    localparam mon1_x_s = 358;
    localparam mon1_x_e = 389;
    
    //day10 digit pixel location = 32 * 64
    localparam day10_x_s = 424;
    localparam day10_x_e = 455;
    
    //day1 digit pixel location = 32 * 64
    localparam day1_x_s = 457;
    localparam day1_x_e = 488;
    
    //:colon1 digit pixel location = 32 * 64
    localparam c1_x_s = 260;
    localparam c1_x_e = 291;
    
    //:colon2 digit pixel location = 32 * 64
    localparam c2_x_s = 362;
    localparam c2_x_e = 391;    
    
    //.period1 digit pixel location = 32 * 64
    localparam p1_x_s = 292;
    localparam p1_x_e = 323;
    
    //.period2 digit pixel location = 32 * 64
    localparam p2_x_s = 391;
    localparam p2_x_e = 422;
    
    //character bitmaps - rom 
    //map time digits to display positions
    //up: 260-320 down: 166-230
    always @ (posedge clk) 
    begin 
        if (pixel_y >= 166 && pixel_y <= 230) 
        begin 
           rom_y = pixel_y - 166;
           if (pixel_x >= hr10_x_e && pixel_x <= hr10_x_s)
           begin 
               rom_x = pixel_x - hr10_x_e; 
               rom = hr10;
           end
           else if (pixel_x >= hr1_x_e && pixel_x <= hr1_x_s)
           begin
               rom_x = pixel_x - hr1_x_e;
               rom = hr1;
           end
           else if (pixel_x >= min10_x_e && pixel_x <= min10_x_s)
           begin
               rom_x = pixel_x - min10_x_e;
               rom = min10;
           end
           else if (pixel_x >= min1_x_e && pixel_x <= min1_x_s)
           begin
               rom_x = pixel_x - min1_x_e;
               rom = min1;
           end
           else if (pixel_x >= sec10_x_e && pixel_x <= sec10_x_s)
           begin
               rom_x = pixel_x - sec10_x_e;
               rom = sec10;
           end
           else if (pixel_x >= sec1_x_e && pixel_x <= sec1_x_s)
           begin
               rom_x = pixel_x - sec1_x_e;
               rom = sec1;
           end
           else if (pixel_x >= c1_x_e && pixel_x <= c1_x_s)
           begin
               rom_x = pixel_x - c1_x_e;
               rom = c1;
           end
           else if (pixel_x >= c2_x_e && pixel_x <= c2_x_s)
           begin
               rom_x = pixel_x - c2_x_e;
               rom = c2;
           end
           else
           begin 
               rom = 4'b1111;
           end
        end
        else if (pixel_y >= 260 && pixel_y <= 320) 
        begin
           rom_y = pixel_y - 260;
           if (pixel_x >= yr1000_x_e && pixel_x <= yr1000_x_s)
           begin 
               rom_x = pixel_x - yr1000_x_e;
               rom = yr1000;
           end
           else if (pixel_x >= yr100_x_e && pixel_x <= yr100_x_s)
           begin
               rom_x = pixel_x - yr100_x_e;
               rom = yr100;
           end
           else if (pixel_x >= yr10_x_e && pixel_x <= yr10_x_s)
           begin
               rom_x = pixel_x - yr10_x_e;
               rom = yr10;
           end
           else if (pixel_x >= yr1_x_e && pixel_x <= yr1_x_s)
           begin
               rom_x = pixel_x - yr1_x_e;
               rom = yr1;
           end
           else if (pixel_x >= mon10_x_e && pixel_x <= mon10_x_s)
           begin
               rom_x = pixel_x - mon10_x_e;
               rom = mon10;
           end
           else if (pixel_x >= mon1_x_e && pixel_x <= mon1_x_s)
           begin
               rom_x = pixel_x - mon1_x_e;
               rom = mon1;
           end
           else if (pixel_x >= day10_x_e && pixel_x <= day10_x_s)
           begin
               rom_x = pixel_x - day10_x_e;
               rom = day10;
           end
           else if (pixel_x >= day1_x_e && pixel_x <= day1_x_s)
           begin
               rom_x = pixel_x - day1_x_e;
               rom = day1;
           end
           else if (pixel_x >= p1_x_e && pixel_x <= p1_x_s)
           begin
               rom_x = pixel_x - p1_x_e;
               rom = p1;
           end
           else if (pixel_x >= p2_x_e && pixel_x <= p2_x_s)
           begin
               rom_x = pixel_x - p2_x_e;
               rom = p2;
           end
           else
           begin 
               rom = 4'b1111;
           end
        end
        else
        begin 
           rom = 4'b1111;
        end
    end    

//pixel output generation 
    always @ (posedge clk)
    begin 
        if (display_on) 
        begin 
            R_data = 4'hf;
            G_data = 4'hf; 
            B_data = 4'hf;
        end
        else 
        begin 
            R_data = 4'h0;
            G_data = 4'h0;
            B_data = 4'h0;
        end
    end
    
    assign row = rom_x [2:0];
    assign col = rom_y [2:0];

endmodule
