module light_controller(clock, error, error_hex);

	input clock, error;
	output reg [6:0] error_hex;
	
	always @(posedge clock)
		begin
			if (error) error_hex = 7'b0000110;
			else error_hex = 7'b1111111;
		end

endmodule