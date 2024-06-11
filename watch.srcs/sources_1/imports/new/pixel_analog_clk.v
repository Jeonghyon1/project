module pixel_analog_clk(
		input wire clk,
		//input clk_65,
		input en,
		input [17:0] t, 
		input [9:0] pixel_x,
		input [9:0] pixel_y,		
		output reg [3:0] R,
		output reg [3:0] G,		
		output reg [3:0] B,
		output [15:0] signal
    );
    
    wire signed [19:0] x;
    wire signed [19:0] y;
    assign x = pixel_x - 512;
    assign y = pixel_y - 384;
    
    
    wire [17:0] sec_f, sec_i, diff;
    assign sec_f = t[17:12] * 3600 + t[11:6] * 60 + t[5:0];
    assign sec_i = 0;
    
    wire sign;
    assign sign = sec_i > sec_f ? 1 : 0; // negative sign
    assign diff = sign ? (sec_i - sec_f) : (sec_f - sec_i);
    
    parameter WIDTH = 31;
    wire [40:0] ph_sec, ph_min, ph_hr;
    assign ph_sec = (((diff) % 60) << (WIDTH-2)) / 15;
    assign ph_min = (((diff) % 3600) << (WIDTH-2)) / 900;
    assign ph_hr = (((diff) % 43200) << (WIDTH-2)) / 10800;
    
    wire signed [31:0] phase_sec, phase_min, phase_hr;
    assign phase_sec = {sign, ph_sec[30:0]};
    assign phase_min = {sign, ph_min[30:0]};
    assign phase_hr = {sign, ph_hr[30:0]};
    
    wire signed [31:0] sec1, sec2, sec3, sec4, min1, min2, min3, min4, hr1, hr2, hr3, hr4;
    cordic rotate1 (.clk(clk), .x_start(6), .y_start(109), .angle(phase_sec), .cos(sec1[31:16]), .sin(sec1[15:0]));
    cordic rotate2 (.clk(clk), .x_start(-6), .y_start(109), .angle(phase_sec), .cos(sec2[31:16]), .sin(sec2[15:0]));
    cordic rotate3 (.clk(clk), .x_start(-6), .y_start(-12), .angle(phase_sec), .cos(sec3[31:16]), .sin(sec3[15:0]));
    cordic rotate4 (.clk(clk), .x_start(6), .y_start(-12), .angle(phase_sec), .cos(sec4[31:16]), .sin(sec4[15:0]));
    cordic rotate5 (.clk(clk), .x_start(4), .y_start(152), .angle(phase_min), .cos(min1[31:16]), .sin(min1[15:0]));
    cordic rotate6 (.clk(clk), .x_start(-4), .y_start(152), .angle(phase_min), .cos(min2[31:16]), .sin(min2[15:0]));
    cordic rotate7 (.clk(clk), .x_start(-4), .y_start(-18), .angle(phase_min), .cos(min3[31:16]), .sin(min3[15:0]));
    cordic rotate8 (.clk(clk), .x_start(4), .y_start(-18), .angle(phase_min), .cos(min4[31:16]), .sin(min4[15:0]));
    cordic rotate9 (.clk(clk), .x_start(3), .y_start(170), .angle(phase_hr), .cos(hr1[31:16]), .sin(hr1[15:0]));
    cordic rotate10 (.clk(clk), .x_start(-3), .y_start(170), .angle(phase_hr), .cos(hr2[31:16]), .sin(hr2[15:0]));
    cordic rotate11 (.clk(clk), .x_start(-3), .y_start(-18), .angle(phase_hr), .cos(hr3[31:16]), .sin(hr3[15:0]));
    cordic rotate12 (.clk(clk), .x_start(3), .y_start(-18), .angle(phase_hr), .cos(hr4[31:16]), .sin(hr4[15:0]));

	wire [39:0] sec_x, sec_y, min_x, min_y, hr_x, hr_y;

	coor_2_pixel pix1 (.coor(sec1), .pixel({sec_x[9:0], sec_y[9:0]}));
	coor_2_pixel pix2 (.coor(sec2), .pixel({sec_x[19:10], sec_y[19:10]}));
	coor_2_pixel pix3 (.coor(sec3), .pixel({sec_x[29:20], sec_y[29:20]}));
 	coor_2_pixel pix4 (.coor(sec4), .pixel({sec_x[39:30], sec_y[39:30]}));
	coor_2_pixel pix5 (.coor(min1), .pixel({min_x[9:0], min_y[9:0]}));
	coor_2_pixel pix6 (.coor(min2), .pixel({min_x[19:10], min_y[19:10]}));
	coor_2_pixel pix7 (.coor(min3), .pixel({min_x[29:20], min_y[29:20]}));
 	coor_2_pixel pix8 (.coor(min4), .pixel({min_x[39:30], min_y[39:30]}));
 	coor_2_pixel pix9 (.coor(hr1), .pixel({hr_x[9:0], hr_y[9:0]}));
	coor_2_pixel pix10 (.coor(hr2), .pixel({hr_x[19:10], hr_y[19:10]}));
	coor_2_pixel pix11 (.coor(hr3), .pixel({hr_x[29:20], hr_y[29:20]}));
 	coor_2_pixel pix12 (.coor(hr4), .pixel({hr_x[39:30], hr_y[39:30]}));
    
    wire is_sec_hand, is_min_hand, is_hr_hand;
    assign is_sec_hand = (sec_x[19:10]-sec_x[9:0])*(pixel_y-sec_y[19:10]) >= (sec_y[19:10]-sec_y[9:0])*(pixel_x-sec_x[19:10])
    					&& (sec_x[29:20]-sec_x[19:10])*(pixel_y-sec_y[29:20]) >= (sec_y[29:20]-sec_y[19:10])*(pixel_x-sec_x[29:20])
    					&& (sec_x[39:30]-sec_x[29:20])*(pixel_y-sec_y[39:30]) >= (sec_y[39:30]-sec_y[29:20])*(pixel_x-sec_x[39:30])
    					&& (sec_x[9:0]-sec_x[39:30])*(pixel_y-sec_y[9:0]) >= (sec_y[9:0]-sec_y[39:30])*(pixel_x-sec_x[9:0]);
    assign is_min_hand = (min_x[19:10]-min_x[9:0])*(pixel_y-min_y[19:10]) >= (min_y[19:10]-min_y[9:0])*(pixel_x-min_x[19:10])
    					&& (min_x[29:20]-min_x[19:10])*(pixel_y-min_y[29:20]) >= (min_y[29:20]-min_y[19:10])*(pixel_x-min_x[29:20])
    					&& (min_x[39:30]-min_x[29:20])*(pixel_y-min_y[39:30]) >= (min_y[39:30]-min_y[29:20])*(pixel_x-min_x[39:30])
    					&& (min_x[9:0]-min_x[39:30])*(pixel_y-min_y[9:0]) >= (min_y[9:0]-min_y[39:30])*(pixel_x-min_x[9:0]);
   	assign is_hr_hand = (hr_x[19:10]-hr_x[9:0])*(pixel_y-hr_y[19:10]) >= (hr_y[19:10]-hr_y[9:0])*(pixel_x-hr_x[19:10])
    					&& (hr_x[29:20]-hr_x[19:10])*(pixel_y-hr_y[29:20]) >= (hr_y[29:20]-hr_y[19:10])*(pixel_x-hr_x[29:20])
    					&& (hr_x[39:30]-hr_x[29:20])*(pixel_y-hr_y[39:30]) >= (hr_y[39:30]-hr_y[29:20])*(pixel_x-hr_x[39:30])
    					&& (hr_x[9:0]-hr_x[39:30])*(pixel_y-hr_y[9:0]) >= (hr_y[9:0]-hr_y[39:30])*(pixel_x-hr_x[9:0]);
    
    always@(posedge clk) begin
    	if (en) begin
    	if (is_sec_hand) begin
    		R <= 4'b1111;
    		G <= 4'b0;
    		B <= 4'b0;
    	end
    	else if (is_min_hand) begin
    		R <= 4'b0;
    		G <= 4'b1111;
    		B <= 4'b0;
    	end
    	else if (is_hr_hand) begin
    		R <= 4'b1111;
    		G <= 4'b0;
    		B <= 4'b1111;
    	end
    	else if (x*x + y*y <= 90000) begin
    		R <= 4'b1111;
    		G <= 4'b1111;
    		B <= 4'b1111;
    	end
    	else begin
    		R <= 4'b1111;
    		G <= 4'b1000;
    		B <= 4'b1000;
    	end
    	end
    end

    assign signal[15:0] = {sign, phase_hr[16:1]};
    
endmodule
