module char_displayer(clock, en, h_pos, v_pos, bcd_digits, rom_data, rom_addr, char_area);

	input clock, en;
	input [9:0] h_pos, v_pos;
	input [23:0] bcd_digits;
	input [7:0] rom_data;
	output [10:0] rom_addr;
	output char_area;

	parameter blank = 16'h0;
	parameter zero_addr = 16'h30;
	parameter colon_addr = 16'h3A;
	
	// Regs and wires for storing previous, adjusted, and normalized values
	reg [9:0] h_pos_prev, h_pos_adjusted, h_pos_prev_2, h_pos_prev_3;
	wire [6:0] h_pos_normalized, v_pos_normalized;
	
	// Wires for ROM row and column
	wire [3:0] rom_row_address;
	wire [2:0] rom_col_address;
	
	wire [6:0] hr1_addr, hr0_addr, min1_addr, min0_addr, sec1_addr, sec0_addr;
	reg [6:0] selected_addr;
	
	// Wire assignments
	assign h_pos_normalized = h_pos_adjusted >> 10'd3;
	assign v_pos_normalized = v_pos >> 10'd4;
	assign rom_row_address = v_pos % 10'd16;
	assign rom_col_address = 10'd7 - (h_pos_prev_3 % 10'd8);
	assign rom_addr = {selected_addr, rom_row_address};
	
	// Addresses for digits
	assign hr1_addr = bcd_digits[23:20] + zero_addr;
	assign hr0_addr = bcd_digits[19:16] + zero_addr;
	assign min1_addr = bcd_digits[15:12] + zero_addr;
	assign min0_addr = bcd_digits[11:8] + zero_addr;
	assign sec1_addr = bcd_digits[7:4] + zero_addr;
	assign sec0_addr = bcd_digits[3:0] + zero_addr;
	
	assign char_area = rom_data[rom_col_address];
	
	// Properly align displayed character
	always @(posedge clock)
		begin
			h_pos_adjusted <= h_pos + 10'd3;
			h_pos_prev <= h_pos_adjusted;
			h_pos_prev_2 <= h_pos_prev;
			h_pos_prev_3 <= h_pos_prev_2;
		end
	
	always @(*)
		begin
			if (v_pos_normalized == 0)
				begin
					if (h_pos_normalized == 10'd0)
						selected_addr <= hr1_addr;
					else if (h_pos_normalized == 10'd1)
						selected_addr <= hr0_addr;
					else if (h_pos_normalized == 10'd2)
						selected_addr <= colon_addr;
					else if (h_pos_normalized == 10'd3)
						selected_addr <= min1_addr;
					else if (h_pos_normalized == 10'd4)
						selected_addr <= min0_addr;
					else if (h_pos_normalized == 10'd5)
						selected_addr <= colon_addr;
					else if (h_pos_normalized == 10'd6)
						selected_addr <= sec1_addr;
					else if (h_pos_normalized == 10'd7)
						selected_addr <= sec0_addr;
					else
						selected_addr <= blank;
				end
			else
				selected_addr <= blank;
		end
		
endmodule