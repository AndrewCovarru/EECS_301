/* 
Slows the count to match the DAC output
 */
module slow_down(
         input clk,
         output reg out,
         output [ 7 : 0 ] counter_internal_byte
       );

reg [ 9: 0 ] internal_counter = 10'b0;



always @( posedge clk ) begin

		
	if (internal_counter == 10'd1023)
		begin
			out <= 1'b1;
			internal_counter <= internal_counter + 1'b1;
		end
		
	else
		begin
			internal_counter <= internal_counter + 1'b1;
			out <= 1'b0;
		end
	end

endmodule