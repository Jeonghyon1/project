`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/03 16:53:52
// Design Name: 
// Module Name: vga_port_tb
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


module vga_port_testbench;

    reg clk, rstb;
    reg sw1, sw2, sw3;
    wire HSYNC, VSYNC;
    wire display_on;
    wire [3:0] R_data;
    wire [3:0] G_data;
    wire [3:0] B_data;    
    wire [9:0] x;
    wire [9:0] y;

vga_port vga_port(.clk(clk), .rstb(rstb), .sw1(sw1), .sw2(sw2), .sw3(sw3), .HSYNC(HSYNC), .VSYNC(VSYNC), .display_on(display_on), .R_data(R_data), .G_data(G_data), .B_data(B_data), .x(x), .y(y));

always #5 clk=~clk;

initial begin
clk=0; rstb=0; //sw1=0; sw2=0; sw3=0; 
#20 rstb=1; 
#20 sw1=1; 
#40 sw1=0; sw2=1; 
#40 sw2=0; sw3=1; 
#40 sw1=1;
#40 sw1=0; sw2=1;
#40 sw1=1; sw3=0;
#40 sw3=1; 
end

endmodule

