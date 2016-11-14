module video_controller(disp_clock, en, count_set, bcd_digits, alarm, valid_draw, v_blank, h_pos, v_pos, disp_red, disp_green, disp_blue);

	input disp_clock, en, count_set, alarm, valid_draw, v_blank;
	input [23:0] bcd_digits;
	input [9:0] h_pos, v_pos;
	output reg [7:0] disp_red, disp_green, disp_blue;
	
	// Color parameters
	parameter no_color = 8'b00000000;
	parameter light_green = 8'b10111111;
	parameter light_red = 8'b10111111;
	
	// ROM address and output and ou wires
	wire [10:0] rom_addr;
	wire [7:0] rom_data;
	
	// Character area wire
	wire char_area;
	
	font_rom font(disp_clock, rom_addr, rom_data);
	char_displayer(disp_clock, ~v_blank, h_pos, v_pos, bcd_digits, rom_data, rom_addr, char_area);
	
	always @(*)
		begin
			if (!en || !valid_draw)
					disp_green <= no_color;
			else if (alarm)
				begin
					disp_green <= no_color;
					disp_red <= (char_area) ? light_green : no_color;
				end
			else
				begin
					disp_green <= (char_area) ? light_green : no_color;
					disp_red <= no_color;
				end
		end
	
endmodule