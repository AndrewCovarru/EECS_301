module video_position_sync(disp_clk, en, valid_draw, v_blank, h_pos, v_pos, disp_hsync, disp_vsync);
	
	input disp_clk, en;
	output reg disp_hsync, disp_vsync, valid_draw, v_blank;
	output reg [9:0] h_pos, v_pos;
	
	// Parameters obtained from LCM-05042 spec sheet, page 12 (timing characterstics)
	
	// Resolution (period) parameters for 480x272 display
	parameter H_PERIOD = 10'd480;
	parameter V_PERIOD = 10'd272;
	
	// Pulse width parameters
	parameter H_PULSE_WIDTH = 10'd41;
	parameter V_PULSE_WIDTH = 10'd10;
	
	// Horizontal and vertical total periods, including pulse widths and porches
	// Sequence: sync->back porch->period->front porch
	parameter H_PERIOD_TOTAL = H_PULSE_WIDTH + H_BACK_PORCH + H_PERIOD + H_FRONT_PORCH; //=286
	parameter V_PERIOD_TOTAL = V_PULSE_WIDTH + V_BACK_PORCH + V_PERIOD + V_FRONT_PORCH; //=525
	
	// Porch parameters
	parameter V_BACK_PORCH = 10'd2;
	parameter V_FRONT_PORCH = 10'd2;
	parameter H_BACK_PORCH = 10'd2;
	parameter H_FRONT_PORCH = 10'd2;
	
	// Values extrapolated from the timing characteristics:
	
	// Minimum and maximum values for validity
	parameter H_MIN = H_PULSE_WIDTH + H_BACK_PORCH; //=43
	parameter H_MAX = H_PERIOD_TOTAL - H_FRONT_PORCH; //=523
	parameter V_MIN = V_PULSE_WIDTH + V_BACK_PORCH; //=12
	parameter V_MAX = V_PERIOD_TOTAL - V_FRONT_PORCH; //=284
	
	// Internal wires
	wire h_off_screen, v_off_screen;
	
	// Internal registers for counters
	reg [9:0] h_counter, v_counter;
	
	// Logic for determining horizontal/vertical off-screen status
	assign h_off_screen = (h_counter < H_MIN) || (h_counter > H_MAX);
	assign v_off_screen = (v_counter < V_MIN) || (v_counter > V_MAX);
	
	// Initial values for counters
	initial
		begin
			h_counter <= 1'b0;
			v_counter <= 1'b0;
		end
	
	always @(posedge disp_clk)
		begin
			// When not enabled, all counters and outputs are driven low
			if (!en)
				begin
					disp_hsync <= 1'b0;
					disp_vsync <= 1'b0;
					valid_draw <= 1'b0;
					v_blank <= 1'b0;
					h_pos <= 1'b0;
					v_pos <= 1'b0;
					h_counter <= 1'b0;
					v_counter <= 1'b0;
				end
			// When enabled
			else
				begin
					// Synchronize v_blank and valid_draw with respective logic
					v_blank <= v_off_screen;
					valid_draw = (!h_off_screen && !v_off_screen);
					
					// Determine "actual" horizontal and vertical position
					h_pos = h_counter - H_MIN;
					v_pos = v_counter - V_MIN;
					
					// Handle disp_hsync
					if (h_counter < H_PULSE_WIDTH)
						disp_hsync = 1'b0;
					else
						disp_hsync = 1'b1;
					
					// Handle disp_vsync
					if (v_counter < V_PULSE_WIDTH)
						disp_vsync = 1'b0;
					else
						disp_vsync = 1'b1;
					
					// Handle counter incrementation
					if (h_counter == H_PERIOD_TOTAL)
						begin
							if (v_counter == V_PERIOD_TOTAL)
								v_counter <= 1'b0;
							else
								v_counter <= v_counter + 1;
							h_counter <= 1'b0;
						end
					else
						h_counter <= h_counter + 1'b1;
				end
		end

endmodule