// Basic multiplier
module multiplier(gain, difference, result);

	input [7:0] gain;
	input signed [7:0] difference;
	output signed [7:0] result;
	
	wire signed [15:0] product;
	
	assign product = gain * difference;
	assign result = product[15:8] + 8'b00000001;

endmodule