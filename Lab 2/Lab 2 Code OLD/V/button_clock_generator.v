module button_clock_generator(clock, reset, slow_clock);

	input clock, reset;
	output wire slow_clock;
	
	parameter BITS = 22;
	reg [BITS-1:0] count;
	assign slow_clock = count[BITS-1];
	
	always @(posedge clock, posedge reset)
		begin
			if (reset == 1) count = 0;
			else count = count + 1;
		end

endmodule