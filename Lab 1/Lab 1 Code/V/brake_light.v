module brake_light(clock, brake, l_signal, r_signal, l_lights, c_lights, r_lights);

	input clock, brake;
	input [2:0] l_signal, r_signal;
	output reg [2:0] l_lights, r_lights;
	output reg [1:0] c_lights;
	
	// Internal register for brake active signal
	reg brake_active;
	// Internal register to store state
	reg [1:0] state;
	
	// State parameters
	parameter IDLE = 0, BRAKE1 = 1, BRAKE2 = 2;
	
	// Implement state transitions
	always @(posedge clock)
		begin
			case (state)
				IDLE:
					if (brake)
						begin
							brake_active = 1;
							state = BRAKE1;
						end
					else
						brake_active = 0;
				BRAKE1:
					if (!brake)
						state = BRAKE2;
				BRAKE2:
					if (!brake)
						state = IDLE;
					else
						state = BRAKE1;
				default:
					if (brake)
						begin
							brake_active = 1;
							state = BRAKE1;
						end
					else
						brake_active = 0;
			endcase
		end
	
	// Implement output
	always @(state)
		begin
			if (!brake_active)
				begin
					l_lights = l_signal;
					r_lights = r_signal;
					c_lights = 2'b00;
				end
			else
				begin
					l_lights = ~l_signal;
					r_lights = ~r_signal;
					c_lights = 2'b11;
				end
		end
	
endmodule