module adder(clock, add_sub, a, b, result);
	
	input clock, add_sub;
	input signed [7:0] a, b;
	output reg signed [7:0] result;
	
	always @(posedge clock)
		begin
			if (add_sub)
				result <= a + b;
			else
				result <= a - b;
		end

endmodule