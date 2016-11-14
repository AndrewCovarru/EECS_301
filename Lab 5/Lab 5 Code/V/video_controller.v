module video_controller(disp_clock, en, cursor_write, input_keys, input_switches, valid_draw, v_blank, h_pos, v_pos, disp_red, disp_green, disp_blue);

	input disp_clock, en, cursor_write, valid_draw, v_blank;
	input [9:0] h_pos, v_pos;
	input [6:0] input_switches;
	input [3:0] input_keys;
	output reg [7:0] disp_red, disp_green, disp_blue;
	
	// Color parameters
	parameter no_color = 8'b00000000;
	parameter light_green = 8'b10111111;
	
	// RAM and ROM input, output, and address wires
	wire [6:0] ram_in, ram_out;
	wire [10:0] ram_read_addr, ram_write_addr; // IS THIS CORRECT?
	wire [10:0] rom_addr;
	wire [7:0] rom_data;
	
	// Cursor wires
	wire [5:0] cursor_h_pos;
	wire [4:0] cursor_v_pos;
	wire in_cursor_area;
	assign in_cursor_area = (h_pos >= (cursor_h_pos * 8) && h_pos < (cursor_h_pos * 8 + 8)) && (v_pos >= (cursor_v_pos * 16) && v_pos < (cursor_v_pos * 16 + 16));
	
	// Character area wire
	wire char_area;
	
	// The button clock is used to obtain a reasonable speed for scrolling
	button_clock_generator gen(disp_clock, 1'b0, button_clock);
	wire button_clock;
	
	input_handler handle_input(button_clock, ~cursor_write, input_keys, cursor_h_pos, cursor_v_pos, edit);
	char_ram store(disp_clock, edit, ram_write_addr, ram_in, ram_read_addr, ram_out);
	font_rom font(disp_clock, rom_addr, rom_data);
	char_displayer disp(disp_clock, ~v_blank, h_pos, v_pos, ram_out, rom_data, ram_read_addr, rom_addr, char_area);
	loader ram_loader(disp_clock, edit, input_switches, cursor_h_pos, cursor_v_pos, ram_write_addr, ram_in);
	
	// Implement color
	always @(*)
		begin
			disp_red <= no_color;
			disp_blue <= no_color;
			if (!en || !valid_draw)
				disp_green <= no_color;
			else if (in_cursor_area)
				disp_green <= (char_area) ? no_color : light_green;
			else
				disp_green <= (char_area) ? light_green : no_color;
		end
	
endmodule