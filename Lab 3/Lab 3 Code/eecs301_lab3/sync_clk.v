/* Syncs input to the clock
 */
module sync_clk (
					input clk,
					input in,
					output out
				);

//=======================================================
//  REG/WIRE declarations
//=======================================================

reg temp;

//=======================================================
//  Structural coding
//=======================================================

assign out = temp;
		
always @ (posedge clk)
begin
	temp <= in;	// set the output to the input only at every clock cycle
	
end

endmodule