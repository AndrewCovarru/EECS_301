/* For some reason, as I discovered, this inferred to only 4 bits of addressing
without parameters. Using parameters solved the issue. */
module char_ram #(parameter DATA = 7, parameter ADDR = 11) (clock, we, write_addr, d, read_addr, q);
	
	input clock, we;
	input [ADDR-1:0] write_addr, read_addr;
	input [DATA-1:0] d;
	output reg [DATA-1:0] q;
	
	reg [DATA-1:0] ram[(2**ADDR)-1:0];
	
	always @(posedge clock)
		begin
			q <= ram[read_addr];
			if(we)
				begin
					ram[write_addr] <= d;
				end
		end
	
endmodule