// Basic adder
module adder(a, b, out);
	
	input signed [7:0] a, b;
	output signed [7:0] out;
	
	wire signed [8:0] result;

	assign result = a - b;
	assign out = result[7:0];

endmodule