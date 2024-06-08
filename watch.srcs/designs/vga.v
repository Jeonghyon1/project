`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/07 13:32:05
// Design Name: 
// Module Name: vga
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



module vga(
    input clk, rstb,
    output wire HSYNC,VSYNC, 
    output wire [3:0] R_data, 
    output wire [3:0] G_data,
    output wire [3:0] B_data
    );
    
    wire display_on;
    wire [9:0] pixel_x;
    wire [9:0] pixel_y; 
    wire [5:0] sec;
    wire [5:0] min; 
    wire [5:0] hour;
    wire [5:0] curr_hour;
    wire [5:0] curr_min; 
    wire [17:0] current;
    wire [17:0] sw_time;
    wire [17:0] date;
    wire [17:0] t;
    
    vga_port vga_port(.clk(clk), .rstb(rstb), .display_on(display_on), .HSYNC(HSYNC), .VSYNC(VSYNC), .pixel_x(pixel_x), .pixel_y(pixel_y));
   
    pixel_clk_generation pixel_gener(.clk(clk), .display_on(display_on), .pixel_x(pixel_x), .pixel_y(pixel_y), 
    .sec(sec), .min(min), .hour(hour), .curr_min(curr_min), .curr_hour(curr_hour), .current(current), .sw_time(sw_time), .date(date), .t(t), 
    .R_data(R_data), .G_data(G_data), .B_data(B_data));
        
    
endmodule

