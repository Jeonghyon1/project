`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/11/18 05:15:40
// Design Name: 
// Module Name: seg7
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

module seg7 (
    input wire rstb,
    input wire clk,
    output reg [7:0] digit,
    output reg [6:0] seg_data
);

// ���� ��ȣ ����
reg [16:0] clk_cnt;
reg seg_clk;

// 7 ���׸�Ʈ ���÷��̸� ���� Ŭ�� ���� (500 Hz)
always @(posedge clk or negedge rstb) begin 
   if (!rstb) begin
      clk_cnt <= 17'd0;
      seg_clk <= 0;  
   end else begin
      if (clk_cnt == 17'd99999) begin
         clk_cnt <= 17'd0;
         seg_clk <= ~seg_clk; 
      end else begin
         clk_cnt <= clk_cnt + 1;
      end
   end
end

// 7 ���׸�Ʈ ���÷��� �ڸ��� ����
always @(posedge seg_clk or negedge rstb) begin 
   if (!rstb) begin
      digit <= 8'b10000000;   
   end else begin
      digit <= {digit[0],digit[7:1]}; 
   end
end

// 7 ���׸�Ʈ ���÷��� ������ ���
always @(posedge seg_clk or negedge rstb) begin 
   if (!rstb) begin
      seg_data <= 7'd0;   
   end else begin
     case(digit)   // ������ �ڸ��� �´� ���� ������ ���
         8'b10000000 : seg_data <= 7'b0110000;  // 1 ���
         8'b01000000 : seg_data <= 7'b1101101;  // 2 ���
         8'b00100000 : seg_data <= 7'b1111001;  // 3 ���
         8'b00010000 : seg_data <= 7'b0110011;  // 4 ���
         8'b00001000 : seg_data <= 7'b1011011;  // 5 ���
         8'b00000100 : seg_data <= 7'b1011111;  // 6 ���
         8'b00000010 : seg_data <= 7'b1110010;  // 7 ���
         8'b00000001 : seg_data <= 7'b1111111;  // 8 ���
         default : seg_data <= 7'd0;
     endcase
   end
end

endmodule
