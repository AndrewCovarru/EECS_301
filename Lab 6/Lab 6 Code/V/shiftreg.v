//Shifts every bit to the MSB and replaces it with a 0
module shiftreg (
					input clk,
					input [11:0] sine_data,
					output wire dac_out,
					output sync 
					);
					
reg temp_sync = 1'b1;
reg [31 : 0] temp_dac_out;

reg [9 : 0] count = 1'b0;

assign dac_out = temp_dac_out[31]; 

assign sync = temp_sync;

always @(posedge clk)
	begin
	
	count = count + 10'd1;
	
	if (count == 10'd0) 
		begin
			temp_sync = 1'b0;
			temp_dac_out <= {4'b1000, 4'b0011, 4'b0000, sine_data, 8'b00000000 };
	
		end
	
	else if (count >= 10'd1 && count <= 10'd31) 
		begin
			temp_dac_out <= { temp_dac_out [30:0], 1'b0};
		end
	else if (count == 10'd32)
		begin
			temp_sync = 1'b1;
		end
	end
endmodule