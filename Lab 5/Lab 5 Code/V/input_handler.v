module input_handler(clock, cursor_en, input_keys, cursor_h_pos, cursor_v_pos, edit);
	
	input clock, cursor_en;
	input [3:0] input_keys;
	output reg [5:0] cursor_h_pos;
	output reg [4:0] cursor_v_pos;
	output reg edit;
	
	// Parameters for horizontal and vertical grid size
	parameter H_GRID_SIZE = 10'd60;
	parameter V_GRID_SIZE = 10'd17;
	
	// Wires for up, down, left, and right signals
	wire up, down, left, right;
	assign up = ~input_keys[3];
	assign down = ~input_keys[2];
	assign left = ~input_keys[1];
	assign right = ~input_keys[0];
	
	// Wire for the button clock
	wire button_clock;
	
	always @(posedge clock)
		begin
			if (cursor_en)
				begin
					edit <= 0;

					if (up)
						begin
							if (cursor_v_pos == 0)
								cursor_v_pos <= V_GRID_SIZE - 1;
							else
								cursor_v_pos <= cursor_v_pos - 1;
						end
					if (down)
						begin
							if (cursor_v_pos == V_GRID_SIZE - 1)
								cursor_v_pos <= 0;
							else
								cursor_v_pos <= cursor_v_pos + 1;
						end
				end
			else
				edit <= up;

			if (left)
				begin
					if (cursor_h_pos == 0)
						cursor_h_pos <= H_GRID_SIZE - 1;
					else
						cursor_h_pos <= cursor_h_pos - 1;
				end
			if (right)
				begin
					if (cursor_h_pos == H_GRID_SIZE - 1)
						cursor_h_pos <= 0;
					else
						cursor_h_pos <= cursor_h_pos + 1;
				end
		end
		
endmodule