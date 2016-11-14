//Sets values from the motor encoder 
module values (
					input clk, 
					input reset_button, 
					input A, 
					input B, 
					input change_switch, 
					output [8 : 0] amp_out, 
					output [31 : 0] freq_out);

	
 reg [8 : 0] temp_amp = 9'b011111111;
 reg [31 : 0] temp_freq = 32'd1000;
 
 reg last_a;
	 
=======================================================

 assign amp_out = temp_amp;
 assign freq_out = temp_freq;
 
 always @ (posedge clk) 
	begin
		last_a <= A;
		
	if(reset_button)
		begin
			temp_amp <= 9'b011111111;
			temp_freq <= 32'd1000;
		end
		
	else
		begin
			if(change_switch)
				begin
					if (A & ~last_a)
						begin
							if (B & temp_amp < 9'b011111111)
								begin
									temp_amp <= temp_amp + 1'b1;
								end
							else if (~B & temp_amp > 9'b000000000)
								begin
									temp_amp <= temp_amp - 1'b1;
								end
						end
				end
			else
				begin
					if (A & ~last_a)
						begin
							if (B & temp_freq < 32'd19998)
								begin
									temp_freq <= temp_freq + 2'd3;
								end
							else if (~B & temp_freq > 32'd22)
								begin
									temp_freq <= temp_freq - 2'd3;
								end
						end
				end
		end
	end
endmodule