
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
    
    assign p1 = 4'd11;
    assign p2 = 4'd11;
    assign c1 = 4'd10;
    assign c2 = 4'd10;
    
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
    
    assign day10 = date[5:0] / 10;
    assign day1 = date[5:0] % 10;
    
    wire digit;
    reg [3:0] rom;
    wire [6:0] row;
    wire [6:0] col;
    reg [9:0] rom_x;
    reg [9:0] rom_y;
    
    digit_rom digit_rom_inst(.rom(rom), .row(col), .col(row), .digit(digit));
    
 
         
    //640*480 pixel location of digital num 
    //hr10 digit pixel location = 64*128  (s:start, e:end)
    localparam hr10_x_s = 70;
    localparam hr10_x_e = 134;
    
    //hr11 digit pixel location = 64*128
    localparam hr1_x_s = 140;
    localparam hr1_x_e = 204;
    
    //min10 digit pixel location = 64*128
    localparam min10_x_s = 280;
    localparam min10_x_e = 344;
    
    //min1 digit pixel location = 64*128
    localparam min1_x_s = 350;
    localparam min1_x_e = 414;
    
    //sec10 digit pixel location = 64*128
    localparam sec10_x_s = 490;
    localparam sec10_x_e = 554;
    
    //sec1 digit pixel location = 64*128
    localparam sec1_x_s = 560;
    localparam sec1_x_e = 624;
    
    //yr1000 digit pixel location = 64*128
    localparam yr1000_x_s = 100;
    localparam yr1000_x_e = 164;
    
    //yr100 digit pixel location = 64*128
    localparam yr100_x_s = 170;
    localparam yr100_x_e = 234;
    
    //yr10 digit pixel location = 64*128
    localparam yr10_x_s = 240;
    localparam yr10_x_e = 304;
    
    //yr1 digit pixel location = 64*128
    localparam yr1_x_s = 310;
    localparam yr1_x_e = 374;
    
    //mon10 digit pixel location = 64*128
    localparam mon10_x_s = 450;
    localparam mon10_x_e = 514;
    
    //mon1 digit pixel location = 64*128
    localparam mon1_x_s = 520;
    localparam mon1_x_e = 584;
    
    //day10 digit pixel location = 64*128
    localparam day10_x_s = 660;
    localparam day10_x_e = 724;
    
    //day1 digit pixel location = 64*128
    localparam day1_x_s = 730;
    localparam day1_x_e = 794;
    
    //:colon1 digit pixel location = 64*128
    localparam c1_x_s = 210;
    localparam c1_x_e = 274;
    
    //:colon2 digit pixel location = 64*128
    localparam c2_x_s = 420;
    localparam c2_x_e = 484;    
    
    //.period1 digit pixel location = 64*128
    localparam p1_x_s = 380;
    localparam p1_x_e = 444;
    
    //.period2 digit pixel location = 64*128
    localparam p2_x_s = 590;
    localparam p2_x_e = 654;
    
    //character bitmaps - rom 
    //map time digits to display positions
    //up: 260-320 down: 166-230
    
    
    always @ (posedge clk) 
    begin
      if (display_on) 
      begin 
        if (pixel_y >= 478 && pixel_y <= 605) 
        begin 
           rom_y <= pixel_y - 478;
           if (pixel_x >= hr10_x_s && pixel_x <= hr10_x_e)
           begin 
               rom_x <= pixel_x - hr10_x_s; 
               rom <= hr10;
           end
           else if (pixel_x >= hr1_x_s && pixel_x <= hr1_x_e)
           begin
               rom_x <= pixel_x - hr1_x_s;
               rom <= hr1;
           end
           else if (pixel_x >= min10_x_s && pixel_x <= min10_x_e)
           begin
               rom_x <= pixel_x - min10_x_s;
               rom <= min10;
           end
           else if (pixel_x >= min1_x_s && pixel_x <= min1_x_e)
           begin
               rom_x <= pixel_x - min1_x_s;
               rom <= min1;
           end
           else if (pixel_x >= sec10_x_s && pixel_x <= sec10_x_e)
           begin
               rom_x <= pixel_x - sec10_x_s;
               rom <= sec10;
           end
           else if (pixel_x >= sec1_x_s && pixel_x <= sec1_x_e)
           begin
               rom_x <= pixel_x - sec1_x_s;
               rom <= sec1;
           end
           else if (pixel_x >= c1_x_s && pixel_x <= c1_x_e)
           begin
               rom_x <= pixel_x - c1_x_s;
               rom <= c1;
           end
           else if (pixel_x >= c2_x_s && pixel_x <= c2_x_e)
           begin
               rom_x <= pixel_x - c2_x_s;
               rom <= c2;
           end
           else
           begin 
               rom = 4'b1111;
           end
        end
        else if (pixel_y >= 100 && pixel_y <= 228) 
        begin
           rom_y <= pixel_y - 100;
           if (pixel_x >= yr1000_x_s && pixel_x <= yr1000_x_e)
           begin 
               rom_x <= pixel_x - yr1000_x_s;
               rom <= yr1000;
           end
           else if (pixel_x >= yr100_x_s && pixel_x <= yr100_x_e)
           begin
               rom_x <= pixel_x - yr100_x_s;
               rom <= yr100;
           end
           else if (pixel_x >= yr10_x_s && pixel_x <= yr10_x_e)
           begin
               rom_x <= pixel_x - yr10_x_s;
               rom <= yr10;
           end
           else if (pixel_x >= yr1_x_s && pixel_x <= yr1_x_e)
           begin
               rom_x <= pixel_x - yr1_x_s;
               rom <= yr1;
           end
           else if (pixel_x >= mon10_x_s && pixel_x <= mon10_x_e)
           begin
               rom_x <= pixel_x - mon10_x_s;
               rom <= mon10;
           end
           else if (pixel_x >= mon1_x_s && pixel_x <= mon1_x_e)
           begin
               rom_x <= pixel_x - mon1_x_s;
               rom <= mon1;
           end
           else if (pixel_x >= day10_x_s && pixel_x <= day10_x_e)
           begin
               rom_x <= pixel_x - day10_x_s;
               rom <= day10;
           end
           else if (pixel_x >= day1_x_s && pixel_x <= day1_x_e)
           begin
               rom_x <= pixel_x - day1_x_s;
               rom <= day1;
           end
           else if (pixel_x >= p1_x_s && pixel_x <= p1_x_e)
           begin
               rom_x = pixel_x - p1_x_s;
               rom = p1;
           end
           else if (pixel_x >= p2_x_s && pixel_x <= p2_x_e)
           begin
               rom_x <= pixel_x - p2_x_s;
               rom <= p2;
           end
           else
           begin 
               rom <= 4'b1111;
           end
        end
        else
        begin 
           rom <= 4'b1111;
        end
        
        if (digit) 
        begin 
            R_data <= 4'b1111;
            G_data <= 4'b1111;
            B_data <= 4'b1111;
        end 
        else 
        begin 
            R_data <= 4'b0000;
            G_data <= 4'b0000;
            B_data <= 4'b0000;
        end
      end
      else 
      begin 
        R_data <= 4'b0000;
        G_data <= 4'b0000;
        B_data <= 4'b0000;
      end 
    end    


    assign row = rom_x [6:0];
    assign col = rom_y [6:0];

endmodule