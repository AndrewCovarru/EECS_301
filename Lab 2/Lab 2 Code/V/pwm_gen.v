// Generates a PWM based on an 8-bit 2s complement duty cycle value
module pwm_gen(clock, duty_cycle, waveform);
	
	input clock;
	input signed [7:0] duty_cycle;
	output reg [1:0] waveform;
	
	reg signed [7:0] count = 0;
	
	always @(posedge clock)
		begin
			if (duty_cycle == 8'sb10000000) // Handles edge case
				waveform = 2'b10;
			else if (count > duty_cycle)
				waveform = 2'b10;
			else
				waveform = 2'b01;
			count <= count + 1;
		end
	
endmodule