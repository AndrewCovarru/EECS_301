// Loads the RAM with data at the appropriate point
module loader(clock, en, char, cursor_h_pos, cursor_v_pos, ram_write_addr, ram_in);
	
	input clock, en;
	input [6:0] char;
	input [5:0] cursor_h_pos;
	input [4:0] cursor_v_pos;
	output reg [10:0] ram_write_addr;
	output reg [6:0] ram_in;
	
	always @(posedge clock)
		begin
			if (en)
				begin
					ram_write_addr = {cursor_h_pos, cursor_v_pos};
					ram_in = char;
				end
		end
	
endmodule