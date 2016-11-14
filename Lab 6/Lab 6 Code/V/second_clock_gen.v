module second_clock_gen(clk1mhz, second_clock);
	
	input clk1mhz;
	output reg second_clock;
	
	reg [19:0] count;
	
	always @(posedge clk1mhz)
		begin
			if (count == 1'b0)
				begin
					count <= 19'd1000000;
					second_clock <= 1;
				end
			else
				begin
					count <= count - 1'b1;
					second_clock <= 0;
				end
		end
	
endmodule