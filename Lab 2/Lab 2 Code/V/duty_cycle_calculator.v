// Module containing sub-modules for calculating the duty cycle
module duty_cycle_calculator(goal_speed, measured_speed, gain, duty_cycle);
	
	input signed [7:0] goal_speed, measured_speed;
	input [7:0] gain;
	output [7:0] duty_cycle;
	
	wire [7:0] difference;
	
	adder(goal_speed, measured_speed, difference);
	multiplier(gain, difference, duty_cycle);
	
endmodule