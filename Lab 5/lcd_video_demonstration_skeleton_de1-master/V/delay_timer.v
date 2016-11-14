module delay_timer(clock, en, ready);
	
	input clock, en;
	output ready;
	
	parameter bits = 20;
	reg [bits-1:0] count;
	assign ready = (count == 20'b11111111111111111111);
	
	always @(posedge clock)
		begin
			if (!en)
				count <= 1'b0;
			else if (count != 20'b11111111111111111111)
				count <= count + 1'b1;
		end
		
endmodule