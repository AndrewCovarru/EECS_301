module flipflops(clock, encoder_a, encoder_b, en, up_down);
	
	input clock, encoder_a, encoder_b;
	output en, up_down;
	
	reg a, a2, b;
	
	always @(posedge clock)
		begin
			a2 = a;
			a <= encoder_a;
			b <= encoder_b;
		end
	
	assign en = ~a2 && a;
	assign up_down = b;
	
endmodule