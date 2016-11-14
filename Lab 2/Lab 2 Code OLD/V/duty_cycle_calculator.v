module duty_cycle_calculator(clock, goal_speed, measured_speed, gain, duty_cycle);
	
	input clock;
	input [7:0] goal_speed, measured_speed, gain;
	output duty_cycle;
	
	wire [7:0] difference;
	
	adder(clock, 0, goal_speed, measured_speed, difference);
	multiplier(gain, difference, duty_cycle);
	
endmodule