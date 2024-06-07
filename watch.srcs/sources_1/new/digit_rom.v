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
    input [2:0] row, 
    input [2:0] col, //8*8 bitmap
    output reg digit
     );
 
    
    always @ *
    begin
      case (rom) 
        4'd0: digit = (row==0 || row==7 || col==0 || col==4) ? 1:0;
        4'd1: digit = (col==4) ? 1:0;
        4'd2: digit = (row==0 || row==3 || row==7 || (col==4 && row<3) || (col==0 && row>3)) ? 1:0;
        4'd3: digit = (row==0 || row==3 || row==7 || col==4) ? 1:0;
        4'd4: digit = (row==3 || (col==0 && row<3) || col==2) ? 1:0;
        4'd5: digit = (row==0 || row==3 || row==7 || (col==0 && row<3) || (col==4 && row>3)) ? 1:0;
        4'd6: digit = (row==0 || row==3 || row==7 || col==0 || (col==4 && row>3)) ? 1:0;
        4'd7: digit = (row==0 || col==4) ? 1:0;
        4'd8: digit = (row==0 || row==3 || row==7 || col==0 || col==4) ? 1:0;
        4'd9: digit = (row==0 || row==3 || row==7 || (col==0 && row<3) || col==4) ? 1:0;
        4'd10: digit = ((col==2 && row>1 && row<3) || (col==2 && row>4 && row<6)) ? 1:0; //colon (:) 
        4'd11: digit = (col==2 && row>6) ? 1:0; //period (.)
        default: digit = 0;         
      endcase
    end  

endmodule


