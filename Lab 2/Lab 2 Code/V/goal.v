// Implements a goal counter, with overflow protection 
module goal(clock, up, down, reset, goal_speed);
	
	input clock, up, down, reset;
	output reg signed [7:0] goal_speed;
	
	initial
		goal_speed = 8'sb00000000;

	always @(posedge clock)
		begin
			if (reset)
				goal_speed = 8'sb00000000;
			else if (up && goal_speed < 8'sb01111111)
				goal_speed = goal_speed + 1;
			else if (down && goal_speed > 8'sb10000000)
				goal_speed = goal_speed - 1;
		end

endmodule