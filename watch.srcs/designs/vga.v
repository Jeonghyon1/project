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


 module vga
 #(
 parameter Tvw       = 12'd6   ,  //VSYNC Pulse Width
 parameter Tvbp      = 12'd29  ,  //VSYNC Back Porch
 parameter Tvfp      = 12'd3   ,   //Vertical Front Porch
 parameter Tvdw      = 12'd768 ,  //Vertical valid data width
 parameter Thw       = 12'd136 ,  //HSYNC Pulse Width        
parameter Thbp      = 12'd160 ,  //HSYNC Back Porch         
parameter Thfp      = 12'd24  ,   //Horizontal Front Porch     
parameter Thdw      = 12'd1024,  //Horizontal valid data width
 parameter Vsync_pol = 1'b1    ,   //VSync Polarity, 1 = Active Low  
parameter Hsync_pol = 1'b1       //HSync Polarity, 1 = Active Low 
)
 (
 /*****************************************************
 ** Input Signal Define                              **
 *****************************************************/
 input  wire            clk,
 input  wire            rstb,
 input  wire            pattern_en,
 input wire [5:0] sec,
 input wire [5:0] min, 
 input wire [5:0] hour,
 input wire [5:0] curr_hour,
 input wire [5:0] curr_min, 
 input wire [17:0] current, 
 input wire [17:0] sw_time, 
 input wire [17:0] date,
 input wire [17:0] t,
 
 /*****************************************************
 ** Output Signal Define                             **
 *****************************************************/ 
output wire            vga_vs      ,
 output wire            vga_hs      ,
 output wire [3:0]      vga_r       ,
 output wire [3:0]      vga_g       ,
 output wire [3:0]      vga_b
 );
 /*****************************************************
 ** Parameter Definition                             **
 *****************************************************/
 localparam Tvp   = Tvw + Tvbp + Tvfp + Tvdw;//VSYNC Period   
localparam Thp   = Thw + Thbp + Thfp + Thdw;//HSYNC Period   
localparam VSYNC_ACT = ~Vsync_pol;
 localparam HSYNC_ACT = ~Hsync_pol;
 /*****************************************************
 ** Reg Definition                                  **
 *****************************************************/
 reg   [11:0]   hcnt        ;
 reg   [11:0]   vcnt        ;
 //reg   [3:0]    pat_sel_buf;
 reg   [11:0]   pat_hcnt    ;
 reg   [11:0]   pat_vcnt    ;
 reg           pat_vs      ;
 reg           pat_hs      ;
 reg           pat_de      ;
 reg   [3:0]   pat_r       ;
 reg   [3:0]   pat_g       ;
 reg   [3:0]   pat_b       ;
 wire          clk_65       ;

  clk_wiz_0 clock_gen_65
   (
    .clk_out1(clk_65),     // output 65 MHz
    .clk_in1(clk) );        // input  100 MHz
    
  
 
/*****************************************************
 ** Pattern Select Buffering
 *****************************************************/
// always @(posedge clk_65 or negedge rstb) begin 
//   if (!rstb) begin
//       pat_sel_buf   <= 3'd0;
//   end
//   else begin
//       pat_sel_buf   <= pattern_sel;
//  end
// end
 
 /*****************************************************
 ** HSYNC Period/VSYNC Period Count
 *****************************************************/
 always @(posedge clk_65 or negedge rstb) begin 
   if (!rstb) begin
       hcnt   <= 12'd0;
       vcnt   <= 12'd0;
   end
   else begin
      /** HSYNC Period **/
      if (hcnt == (Thp - 1)) begin
         hcnt <= 12'd0;
      end
      else begin
         hcnt <= hcnt + 1'b1;
      end
      /** VSYNC Period **/
      if (hcnt == (Thp - 1)) begin
         if (vcnt == (Tvp - 1)) begin
            vcnt <= 12'd0;
         end
         else begin
            vcnt <= vcnt + 1'b1;
         end
      end
   end
 end

/*****************************************************
 ** VSYNC Signal Gen.
 *****************************************************/
 always @(posedge clk_65 or negedge rstb) begin 
   if (!rstb) begin
       pat_vs       <= VSYNC_ACT;
   end
   else begin
      if (hcnt == (Thp - 1)) begin
         if (vcnt == (Tvw - 1)) begin
            pat_vs <= ~VSYNC_ACT;
         end
         else if (vcnt == (Tvp - 1)) begin
            pat_vs <= VSYNC_ACT;
         end
      end
   end
 end
 /*****************************************************
 ** HSYNC Signal Gen.
 *****************************************************/
 always @(posedge clk_65 or negedge rstb) begin 
   if (!rstb) begin
       pat_hs <= HSYNC_ACT;
   end
   else begin
      if (hcnt == (Thw - 1)) begin
         pat_hs <= ~HSYNC_ACT;
      end
      else if (hcnt == (Thp - 1)) begin
         pat_hs <= HSYNC_ACT;
      end
   end
 end
 /*****************************************************
 ** HSYNC/VSYNC Data Enable Signal Gen.
 *****************************************************/
 always @(posedge clk_65 or negedge rstb) begin 
   if (!rstb) begin
       pat_de   <= 1'b0;
   end
   else begin
      if ((vcnt >= (Tvw + Tvbp)) && (vcnt <= (Tvp - Tvfp - 1))) begin
         if (hcnt == (Thw + Thbp - 1)) begin
            pat_de <= 1'b1;
         end
         else if (hcnt == (Thp - Thfp - 1))begin
            pat_de <= 1'b0;
         end
      end
   end
 end
 
 /*****************************************************
 ** Horizontal Valid Pixel Count
 *****************************************************/
 always @(posedge clk_65 or negedge rstb) begin 
   if (!rstb) begin
      pat_hcnt    <= 'd0;
   end
   else begin
      if (pat_de) begin
         pat_hcnt <= pat_hcnt + 'b1;
      end
      else begin
         pat_hcnt <= 'd0;
      end 
   end
 end
 /*****************************************************
 ** Vertical Valid Pixel Count
 *****************************************************/
 always @(posedge clk_65 or negedge rstb) begin 
   if (!rstb) begin
      pat_vcnt <= 'd0;
   end
   else begin
      if ((vcnt >= (Tvw + Tvbp)) && (vcnt <= (Tvp - Tvfp - 1))) begin
         if (hcnt == (Thp - 1)) begin
            pat_vcnt <= pat_vcnt + 'd1;
         end
      end
      else begin
      pat_vcnt <= 'd0;
      end
   end
 end
 /*****************************************************
 ** Color Generator
 *****************************************************/

 wire [3:0] R_data_int;
 wire [3:0] G_data_int;
 wire [3:0] B_data_int;
 
 
// always @(posedge clk_65 or negedge rstb) begin
//   if (!rstb) begin
//      pat_r    <= 4'd0;
//      pat_g    <= 4'd0;
//    pat_b    <= 4'd0;
//   end
//   else begin
//     if (pattern_en) begin 
//       case (pat_sel_buf) 
//          // RED Pattern
//          3'd0 : begin pat_r <= 'd15; pat_g <= 'd0; pat_b <= 'd0; end
          // GREEN Pattern
//          3'd1 : begin pat_r <= 'd0; pat_g <= 'd15; pat_b <= 'd0; end
//          // BLUE Pattern
//          3'd2 : begin pat_r <= 'd0; pat_g <= 'd0;  pat_b <= 'd15; end
//                   // White Pattern
//         3'd3 : begin pat_r <= 'd15; pat_g <= 'd15; pat_b <= 'd15;  end
//         // Black Pattern
//         3'd4 : begin pat_r <= 'd0; pat_g <= 'd0;  pat_b <= 'd0;    end
//         // Column Color Bar Pattern
//         3'd5 : begin
//             if (pat_hcnt < (Thdw/4)*1) begin
//                  pat_r <= 'd15;  pat_g <= 'd0;    pat_b <= 'd0;  end
//             else if (pat_hcnt >= (Thdw/4)*1 && pat_hcnt < (Thdw/4)*2)
//                 begin pat_r <= 'd0; pat_g <= 'd15; pat_b <= 'd0;  end
//             else if (pat_hcnt >= (Thdw/4)*2 && pat_hcnt < (Thdw/4)*3)
//                 begin pat_r <= 'd0; pat_g <= 'd0;  pat_b <= 'd15; end
//             else if (pat_hcnt >= (Thdw/4)*3 && pat_hcnt < (Thdw/4)*4)
//                 begin pat_r <= 'd15; pat_g <= 'd15; pat_b <= 'd15; end
//             else begin pat_r <= 'd0; pat_g <= 'd0; pat_b <= 'd0;  end
//           end           
//         // Row Color Bar Pattern
//         3'd6 : begin
//             if (pat_vcnt < (Tvdw/4)*1) begin
//                  pat_r <= 'd15;  pat_g <= 'd0;    pat_b <= 'd0; end
//             else if (pat_vcnt >= (Tvdw/4)*1 && pat_vcnt < (Tvdw/4)*2)
//                 begin pat_r <= 'd0; pat_g <= 'd15; pat_b <= 'd0; end
//             else if (pat_vcnt >= (Tvdw/4)*2 && pat_vcnt < (Tvdw/4)*3)
//                 begin pat_r <= 'd0; pat_g <= 'd0; pat_b <= 'd15; end 
//             else if (pat_vcnt >= (Tvdw/4)*3 && pat_vcnt < (Tvdw/4)*4)
//                 begin pat_r <= 'd15; pat_g <= 'd15; pat_b <= 'd15; end
//             else begin  pat_r <= 'd0; pat_g <= 'd0; pat_b <= 'd0; end
//           end
//         default : begin 
//             pat_r <= 'd15; pat_g <= 'd15; pat_b <= 'd0; end
///                      
//         endcase
//      end
//      else begin
//         pat_r <= 'd0;   pat_g <= 'd0;    pat_b <= 'd0;
//      end
//   end
 //end
 
 
 pixel_clk_generation pixel_clk_gen(.clk(clk_65), .display_on(pattern_en), .pixel_x(pat_hcnt), .pixel_y(pat_vcnt), .sec(sec), .min(min), .hour(hour), .curr_hour(curr_hour), .curr_min(curr_min), .current(current), .sw_time(sw_time), .date(date), .t(t), .R_data(vga_r), .G_data(vga_g), .B_data(vga_b));
 
 /*****************************************************
 ** Signal Interconnect
 *****************************************************/
 assign vga_vs  = pat_vs;
 assign vga_hs  = pat_hs;
 //assign vga_r   = (pat_de == 1'b1) ? pat_r : 4'd0;
 //assign vga_g   = (pat_de == 1'b1) ? pat_g : 4'd0;
 //assign vga_b   = (pat_de == 1'b1) ? pat_b : 4'd0;

 
 endmodule 
