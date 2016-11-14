// Register to store velocity, with enable
module velocity_register(en, up_down_count, velocity);
	
	input en;
	input [7:0] up_down_count;
	output reg signed [7:0] velocity;
	
	always @(posedge en)
		velocity = up_down_count;

endmodule