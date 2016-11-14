// Implements an up/down counter with synchronous reset
module up_down_counter(clock, en, up_down, srst, count);
	
	input clock, en, up_down, srst;
	output reg signed [7:0] count;
	
	always @(posedge clock, posedge srst)
		begin
			if (srst == 1)
				count <= 8'sb00000000;
			else if (up_down == 1 && en == 1)
				count = count - 1;
			else if (en == 1)
				count = count + 1;
		end

endmodule