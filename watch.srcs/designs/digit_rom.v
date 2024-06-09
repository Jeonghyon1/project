`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/07 13:30:02
// Design Name: 
// Module Name: digit_rom
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


module digit_rom(
    input [3:0] rom,
    input [6:0] row, 
    input [6:0] col, //8*8 bitmap
    output reg digit
     );
 
    
    always @ *
    begin
      case (rom) 
        4'd0: digit <= (row <= 6 || row >= 121 || col <= 6 || col >= 57);
        4'd1: digit <= ((row>=0 && row <= 127) && (col>=28 && col <= 34));
        4'd2: digit <= (row <= 6 || row >= 121 || (row >= 60 && row <= 66) || (col <=6 && row >=66) || (col >= 57 && row <=60));
        4'd3: digit <= (row <=6 || row >= 121 || (row >= 60 && row <= 66) || col >= 57);
        4'd4: digit <= ((row >= 60 && row <= 66) || (col <=6 && row <= 60) || col >= 57); 
        4'd5: digit <= (row <= 6 || row >= 121 || (row >= 60 && row <= 66) || (col <=6 && row <=60) || (col >= 57 && row >= 66));
        4'd6: digit <= (row <=6 || row >= 121 || (row >= 60 && row <= 66) || col<=6 || (col >= 57 && row >= 66));
        4'd7: digit <= ((row <= 6 && row > 0) || col >= 57); 
        4'd8: digit <= (row <= 6 || row >= 121 || (row >= 60 && row <= 66) || col <= 6 || col >= 57); 
        4'd9: digit <= (row <= 6 || row >= 121 || (row >= 60 && row <= 66) || col >= 57 || (col <= 6 && row <= 60));
        4'd10: digit <= (((col>=28 && col <= 34) && (row >= 50 && row <= 55)) || ((col>=28 && col <= 34) && (row >= 71 && row <= 76))); // colon (:)
        4'd11: digit <= ((col>=28 && col <= 34) && row >=121) ? 1:0; // period (.)
        default: digit = 0;    
      endcase
    end  

endmodule




