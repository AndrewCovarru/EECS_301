module timer(second_clock, count_set, min_hr, reset, up, down, bcd_digits, alarm);

	input second_clock, count_set, min_hr, reset, up, down;
	output [23:0] bcd_digits;
	output reg alarm;
	
	reg [3:0] hr1, hr0, min1, min0, sec1, sec0;
	assign bcd_digits = {hr1, hr0, min1, min0, sec1, sec0};
	
	reg has_reset;
	wire zero_check = (hr1 == 10'd0 && hr0 == 10'd0 && min1 == 10'd0 && min0 == 10'd0 &&
					sec1 == 10'd0 && sec0 == 10'd0);
	
	always @(posedge second_clock)
		begin
			if (~count_set)
				begin
					if (!zero_check)
						begin
							if (sec0 > 0)
								sec0 <= sec0 - 1'b1;
							else
								begin
									sec0 <= 10'd9;
									if (sec1 > 0)
										sec1 <= sec1 - 1'b1;
									else
										begin
											sec1 <= 10'd5;
											if (min0 > 0)
												min0 <= min0 - 1'b1;
											else
												begin
													min0 <= 10'd9;
													if (min1 > 0)
														min1 <= min1 - 1'b1;
													else
														begin
															min1 <= 10'd5;
															if (hr0 > 0)
																hr0 <= hr0 - 1'b1;
															else
																begin
																	hr0 <= 10'd9;
																	hr1 <= hr1 - 1'b1;
																end
														end
												end
										end
								end
						end
					else
						begin
							if (!has_reset)
								alarm <= 1;
							else
								alarm <= 0;
						end
				end
			else
				begin
					alarm <= 0;
					sec1 <= 0;
					sec0 <= 0;
					
					if (~min_hr && down)
						begin
							if (min0 > 0)
								min0 <= min0 - 1'b1;
							else
								begin
									min0 <= 9;
									if (min1 > 0)
										min1 <= min1 - 1;
									else
										min1 <= 5;
								end
						end
					else if (~min_hr && up)
						begin
							if (min0 < 9)
								min0 <= min0 + 1'b1;
							else
								begin
									min0 <= 0;
									if (min1 < 5)
										min1 <= min1 + 1;
									else
										min1 <= 0;
								end
						end
					else if (min_hr && down)
						begin
							if (hr0 > 0)
								hr0 <= hr0 - 1'b1;
							else
								begin
									hr0 <= 9;
									if (hr1 > 0)
										hr1 <= hr1 - 1;
									else
										hr1 <= 5;
								end
						end
					else if (min_hr && up)
						begin
							if (hr0 < 9)
								hr0 <= hr0 + 1'b1;
							else
								begin
									hr0 <= 0;
									if (hr1 < 9)
										hr1 <= hr1 + 1;
									else
										hr1 <= 0;
								end
						end
				end
			end
		
	
	always @(posedge reset, posedge count_set)
		begin
			if (count_set)
				has_reset <= 0;
			else if (reset)
				has_reset <= 1;
		end

endmodule