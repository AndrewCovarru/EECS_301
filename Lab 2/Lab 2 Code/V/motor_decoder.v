// Module containing sub-modules for calculating measured speed from encoder outputs
module motor_decoder(clock, encoder_a, encoder_b, measured_speed);
	
	input clock, encoder_a, encoder_b;
	output [7:0] measured_speed;
	
	wire srst_clock, up_down_en, up_down;
	wire [7:0] up_down_count;
	
	srst_clock_generator(clock, 0, srst_clock);
	flipflops(clock, encoder_a, encoder_b, up_down_en, up_down);
	up_down_counter(clock, up_down_en, up_down, srst_clock, up_down_count);
	velocity_register(srst_clock, up_down_count, measured_speed);

endmodule