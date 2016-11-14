module pwm_gen(clock, duty_cycle, );
	
	input clock;
	input [7:0] duty_cycle;
	output [1:0] waveform;
	
	reg [7:0] count = 0;
	
	always @(posedge clock)
		begin
			if (counter < duty_cycle)
				waveform = 2'b01;
			else
				waveform = 2'b10;
			count <= count + 1;
		end
	
endmodule