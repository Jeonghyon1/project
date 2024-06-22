
module pixel_clk_generation(
    input clk,input display_on,input [9:0] pixel_x,input [9:0] pixel_y,
    input [5:0] sec,input [5:0] min,input [5:0] hour,input [5:0] curr_hour,input [5:0] curr_min,input [17:0] current,input [17:0] sw_time, 
    input [17:0] date,input [17:0] t,
    output reg [3:0] R_data,output reg [3:0] G_data,output reg [3:0] B_data
    );
//declaration module with clk, display_on, pixel_x, pixel_y, sec, min, hour, curr_hour, curr_min, current, sw_time, date, t as input values 
//and R_data, G_data, B_data as output values
//display on: swtich on to display the monitor 
//pixel_x and pixel_y: the coordinate of the monitor   
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
//R_data, G_data, B_data: the output to display the digital number with colors 
         
    wire [3:0] hr10, hr1, min10, min1, sec10, sec1, yr1000, yr100, yr10, yr1, mon10, mon1, day10, day1, c1, c2, p1, p2;
    // wire in order to  enter the numbers to each digital location  
    
    assign p1 = 4'd11; //period: digital rom 4'd11
    assign p2 = 4'd11; 
    assign c1 = 4'd10; //colon: digital rom 4'd10
    assign c2 = 4'd10;
    
    assign hr10 = (hour / 10) | (curr_hour / 10) | (current[17:12] / 10) | (sw_time[17:12] / 10) | (t[17:12] / 10); 
    //hr10: tens digit of hour - divide the input of all hours by 10 to obtain a tens digit 
    assign hr1 = (hour % 10) | (curr_hour % 10) | (current[17:12] % 10) | (sw_time[17:12] % 10) | (t[17:12] % 10);
    //hr1: units digit of hour - a number with the remainder of 10 of all hours input as a units digit
    assign min10 = (min / 10) | (curr_min / 10) | (current[11:6] / 10) | (sw_time[11:6] / 10) | (t[11:6] / 10);
    //min10: tens digit of minutes - divide the input of all minutes by 10 to obtain a tens digit
    assign min1 = (min % 10) | (curr_min % 10) | (current[11:6] % 10) | (sw_time[11:6] % 10) | (t[11:6] % 10);
    //min1: units digit of minutes - a number with the remainder of 10 of all minutes input as a units digit  
    assign sec10 = (sec / 10) | (current[5:0] / 10) | (sw_time[5:0] / 10) | (t[5:0] / 10);
    //sec10: tens digit of seconds - divide the input of all seconds by 10 to obtain a tens digit
    assign sec1 = (sec % 10) | (current[5:0] % 10) | (sw_time[5:0] % 10) | (t[5:0] % 10);
    //sec1: units digit of seconds - a number with the remainder of 10 of all seconds input as a units digit 
    
    assign yr1000 = 4'b0010;//(date[17:12] / 1000) % 10; 
    //by setting the year to start with 20--, assigned thousands digit of years as 2 and hundreds digit of years as 0
    assign yr100 = 4'b0000;//(date[17:12] / 100) % 10;
    assign yr10 = (date[17:12] / 10) % 10; //tens digit of years - divide the input of years by 10 to obtain a tens digit
    assign yr1 = date[17:12] % 10; //units digit of years - a number with the remainder of 10 of years input as a units digit
    assign mon10 = date[11:6] / 10; //tens digit of months - divide the input of months by 10 to obtain a tens digit 
    assign mon1 = date[11:6] % 10; //units digit of months - a number with the remainder of 10 of months input as a units digit
    assign day10 = date[5:0] / 10; //tens digit of day - divide the input of days by 10 to obtain a tens digit
    assign day1 = date[5:0] % 10; //units digit of day - a number with the remainder of 10 of day input as a units digit
    
    wire digit; //digit numerical shape
    reg [3:0] rom; //the representations of number in 4 bits
    wire [6:0] row; //the column of the digit numerical shapes 
    wire [6:0] col; //the row of the digit numerical shapes
    reg [9:0] rom_x; //the horizontal length of digit numerical shape 
    reg [9:0] rom_y; //the vertical length of digit numerical shape
    digit_rom digit_rom_inst(.rom(rom), .row(col), .col(row), .digit(digit));
    //use digit_rom module to display a digital numerical shape
    
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
    
    always @ (posedge clk) //always operating when posedge clock change (begin-end essential)
    begin //run condition between begin-end if sensitivity list of always is satisfied
      if (display_on) //whe display on is 1 which means when turn on the swith (if-else if-else)
      begin 
        if (pixel_y >= 478 && pixel_y <= 605) //pixel location of y_coordinate of time 
        begin 
           rom_y <= pixel_y - 478; //subtract the bottom end pixel position from the position of the pixel to obtain vertical position in bitmap
           if (pixel_x >= hr10_x_s && pixel_x <= hr10_x_e) //if hr10 pixel location is in the right position 
           begin 
               rom_x <= pixel_x - hr10_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= hr10; //assigned rom as the number of hr10
           end
           else if (pixel_x >= hr1_x_s && pixel_x <= hr1_x_e) //if hr1 pixel location is in the right position 
           begin
               rom_x <= pixel_x - hr1_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= hr1; //assigned rom as the number of hr1
           end
           else if (pixel_x >= min10_x_s && pixel_x <= min10_x_e) //if min10 pixel location is in the right position
           begin
               rom_x <= pixel_x - min10_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= min10; //assigned rom as the number of min10 
           end
           else if (pixel_x >= min1_x_s && pixel_x <= min1_x_e) //if min1 pixel location is in the right position
           begin
               rom_x <= pixel_x - min1_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= min1; //assigned rom as the number of min1
           end
           else if (pixel_x >= sec10_x_s && pixel_x <= sec10_x_e) //if sec10 pixel location is in the right position
           begin
               rom_x <= pixel_x - sec10_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= sec10; //assigned rom as the number of sec10
           end
           else if (pixel_x >= sec1_x_s && pixel_x <= sec1_x_e) //if sec1 pixel location is in the right position 
           begin
               rom_x <= pixel_x - sec1_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= sec1; //assigned rom as the number of sec1
           end
           else if (pixel_x >= c1_x_s && pixel_x <= c1_x_e) //if colon1 pixel location is in the right position
           begin
               rom_x <= pixel_x - c1_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= c1; //assigned rom as the number of c1 which is 4'd10
           end
           else if (pixel_x >= c2_x_s && pixel_x <= c2_x_e) //if colon2 pixel location is in the right position 
           begin
               rom_x <= pixel_x - c2_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= c2; //assigned rom as the number of c2 which is 4'd10
           end
           else
           begin 
               rom = 4'b1111; //if nothing applies, nothing is set to be marked
           end
        end
        else if (pixel_y >= 100 && pixel_y <= 228) //pixel location of y_coordinate of date 
        begin
           rom_y <= pixel_y - 100; //subtract the bottom end pixel position from the position of the pixel to obtain vertical position in bitmap
           if (pixel_x >= yr1000_x_s && pixel_x <= yr1000_x_e) //if yr1000 pixel location is in the right position 
           begin 
               rom_x <= pixel_x - yr1000_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= yr1000; //assigned rom as the number of yr1000
           end
           else if (pixel_x >= yr100_x_s && pixel_x <= yr100_x_e) //if yr100 pixel location is in the right position 
           begin
               rom_x <= pixel_x - yr100_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= yr100; //assigned rom as the number of yr100
           end
           else if (pixel_x >= yr10_x_s && pixel_x <= yr10_x_e) //if yr10 pixel location is in the right position
           begin
               rom_x <= pixel_x - yr10_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= yr10; //assigned rom as the number of yr10
           end
           else if (pixel_x >= yr1_x_s && pixel_x <= yr1_x_e) //if yr1 pixel location is in the right position
           begin
               rom_x <= pixel_x - yr1_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= yr1; //assigned rom as the number of yr1
           end
           else if (pixel_x >= mon10_x_s && pixel_x <= mon10_x_e) //if mon10 pixel location is in the right position 
           begin
               rom_x <= pixel_x - mon10_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= mon10; //assigned rom as the number of mon10
           end
           else if (pixel_x >= mon1_x_s && pixel_x <= mon1_x_e) //if mon1 pixel location is in the right position
           begin
               rom_x <= pixel_x - mon1_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= mon1; //assigned rom as the number of mon1
           end
           else if (pixel_x >= day10_x_s && pixel_x <= day10_x_e) //if day10 pixel location is in the right position
           begin
               rom_x <= pixel_x - day10_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= day10; //assigned rom as the number of day10
           end
           else if (pixel_x >= day1_x_s && pixel_x <= day1_x_e) //if day1 pixel location is in the right position
           begin
               rom_x <= pixel_x - day1_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= day1; //assigned rom as the number of day1
           end
           else if (pixel_x >= p1_x_s && pixel_x <= p1_x_e) //if p1 pixel location is in the right position 
           begin
               rom_x = pixel_x - p1_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom = p1; //assigned rom as the number of p1 which is 4'd11
           end
           else if (pixel_x >= p2_x_s && pixel_x <= p2_x_e) //if p2 pixel location is in the right position 
           begin
               rom_x <= pixel_x - p2_x_s; //subtract the left end pixel position from the position of the pixel to obtain horizontal position in bitmap
               rom <= p2; //assigned rom as the number of p2 which is 4'd11
           end
           else
           begin 
               rom <= 4'b1111; //if nothing applies, nothing is set to be marked
           end
        end
        else
        begin 
           rom <= 4'b1111; //if nothing applies, nothing is set to be marked
        end
        
        if (digit) //a digit shows a number or character
        begin 
            R_data <= 4'b1111;
            G_data <= 4'b1111;
            B_data <= 4'b1111;
            //set all the value as 1 to be displayed in white (red=1, green=1, blue=1)
        end 
        else 
        begin 
            R_data <= 4'b0000;
            G_data <= 4'b0000;
            B_data <= 4'b0000;
            //set all the value as 0 to be displayed in black (red=0, green=0, blue=0)
        end
      end
      else 
      begin 
        R_data <= 4'b0000;
        G_data <= 4'b0000;
        B_data <= 4'b0000;
        ///if nothing applies, nothing is set to be marked, so set all the value as 0 to be displayed in black (red=0, green=0, blue=0)
      end 
    end    


    assign row = rom_x [6:0]; //assigned rom_x as the row for the digit_rom
    assign col = rom_y [6:0]; //assigned rom_y as the colom for the digit_rom

endmodule