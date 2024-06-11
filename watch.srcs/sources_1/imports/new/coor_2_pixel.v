module coor_2_pixel(
		input [31:0] coor,
		output [19:0] pixel
	);
	wire [9:0] tmp_x, tmp_y;
	assign tmp_x = coor[31] ? 512 - coor[25:16] : 512 + coor[25:16];
	assign tmp_y = coor[16] ? 384 - coor[9:0] : 384 + coor[9:0];
	assign pixel = {tmp_x, tmp_y};
	
endmodule