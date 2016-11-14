module mult (
				input clk,
				input [11 : 0] sine, 
				input [8 : 0] gain, 
				output [11 : 0]gain_sine
			);
			

//=======================================================
//  REG/WIRE declarations
//=======================================================

reg signed [11 : 0] sine_reg;
reg signed [8 : 0] gain_reg;

wire signed [20 : 0] full_mult;
reg unsigned [11 : 0] out_mult;


assign gain_sine = out_mult;
assign full_mult = sine_reg * gain_reg;

always @ (posedge clk)
begin
	
	sine_reg <= sine;
	gain_reg <= gain;
	
	out_mult <= {full_mult[20], full_mult[18 : 8]} + 12'b100000000000;
end

endmodule