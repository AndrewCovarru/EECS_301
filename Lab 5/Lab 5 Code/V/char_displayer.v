module char_displayer(clock, en, h_pos, v_pos, ram_out, rom_data, ram_read_addr, rom_addr, char_area);
	
	input clock, en;
	input [9:0] h_pos, v_pos;
	input [6:0] ram_out;
	input [7:0] rom_data;
	output [10:0] ram_read_addr;
	output [10:0] rom_addr;
	output char_area;
	
	// Regs and wires for storing previous, adjusted, and normalized values
	reg [9:0] h_pos_prev, h_pos_adjusted, h_pos_prev_2, h_pos_prev_3;
	wire [6:0] h_pos_normalized, v_pos_normalized
	
	// Wires for ROM row and column
	wire [3:0] rom_row_address;
	wire [2:0] rom_col_address;
	
	// Wire assignments
	assign h_pos_normalized = h_pos_adjusted >> 10'd3;
	assign v_pos_normalized = v_pos >> 10'd4;
	assign rom_row_address = v_pos % 10'd16;
	assign rom_col_address = 10'd7 - (h_pos_prev_3 % 10'd8);
	assign rom_addr = {ram_out, rom_row_address};
	assign ram_read_addr = {h_pos_normalized[5:0], v_pos_normalized[4:0]};
	
	assign char_area = rom_data[rom_col_address];
	
	// Properly align displayed character
	always @(posedge clock)
		begin
			h_pos_adjusted <= h_pos + 10'd3;
			h_pos_prev <= h_pos_adjusted;
			h_pos_prev_2 <= h_pos_prev;
			h_pos_prev_3 <= h_pos_prev_2;
		end
	
endmodule