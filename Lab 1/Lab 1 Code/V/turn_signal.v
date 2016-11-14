module turn_signal(clock, left, right, l_signal, r_signal, error);

	input clock, left, right;
	output reg [2:0] l_signal, r_signal;
	output reg error;
	
	// Internal register to store state
	reg [4:0] state;
	
	// State parameters
	parameter IDLE = 0, L0 = 1, L1_0 = 2, L1_1 = 3, L1_2 = 4, L2_0 = 5, L2_1 = 6, L2_2 = 7,
	L3_0 = 8, L3_1 = 9, L3_2 = 10, R0 = 11, R1_0 = 12, R1_1 = 13, R1_2 = 14, R2_0 = 15,
	R2_1 = 16, R2_2 = 17, R3_0 = 18, R3_1 = 19, R3_2 = 20, ERROR_STATE = 21;
	
	// Implement output
	always @(state)
		begin
			case (state)
				IDLE:
					begin
						l_signal = 3'b000;
						r_signal = 3'b000;
						error = 0;
					end
				L0:
					l_signal = 3'b000;
				L1_0:
					l_signal = 3'b001;
				L1_1:
					l_signal = 3'b001;
				L1_2:
					l_signal = 3'b001;
				L2_0:
					l_signal = 3'b011;
				L2_1:
					l_signal = 3'b011;
				L2_2:
					l_signal = 3'b011;
				L3_0:
					l_signal = 3'b111;
				L3_1:
					l_signal = 3'b111;
				L3_2:
					l_signal = 3'b111;
				R0:
					r_signal = 3'b000;
				R1_0:
					r_signal = 3'b100;
				R1_1:
					r_signal = 3'b100;
				R1_2:
					r_signal = 3'b100;
				R2_0:
					r_signal = 3'b110;
				R2_1:
					r_signal = 3'b110;
				R2_2:
					r_signal = 3'b110;
				R3_0:
					r_signal = 3'b111;
				R3_1:
					r_signal = 3'b111;
				R3_2:
					r_signal = 3'b111;
				ERROR_STATE:
					begin
						l_signal = 3'b000;
						r_signal = 3'b000;
						error = 1;
					end
				default:
					begin
						l_signal = 3'b000;
						r_signal = 3'b000;
					end
			endcase
		end
	
	// Implement state transitions
	always @(posedge clock)
		begin
			case (state)
				IDLE:
					begin
						if (left && right)
							state <= ERROR_STATE;
						else if (left)
							state <= L0;
						else if (right)
							state <= R0;
					end
				L0:
					begin
						if (left && right)
							state <= ERROR_STATE;
						else if (left)
							state <= L1_0;
						else
							state <= IDLE;
					end
				L1_0:
					state <= L1_1;
				L1_1:
					state <= L1_2;
				L1_2:
					begin
						if (left && right)
							state <= ERROR_STATE;
						else if (left)
							state <= L2_0;
						else
							state <= IDLE;
					end
				L2_0:
					state <= L2_1;
				L2_1:
					state <= L2_2;
				L2_2:
					begin
						if (left && right)
							state <= ERROR_STATE;
						else if (left)
							state <= L3_0;
						else
							state <= IDLE;
					end
				L3_0:
					state <= L3_1;
				L3_1:
					state <= L3_2;
				L3_2:
					begin
						if (left && right)
							state <= ERROR_STATE;
						else if (left)
							state <= L0;
						else
							state <= IDLE;
					end
				R0:
					begin
						if (left && right)
							state <= ERROR_STATE;
						else if (right)
							state <= R1_0;
						else
							state <= IDLE;
					end
				R1_0:
					state <= R1_1;
				R1_1:
					state <= R1_2;
				R1_2:
					begin
						if (left && right)
							state <= ERROR_STATE;
						else if (right)
							state <= R2_0;
						else
							state <= IDLE;
					end
				R2_0:
					state <= R2_1;
				R2_1:
					state <= R2_2;
				R2_2:
					begin
						if (left && right)
							state <= ERROR_STATE;
						else if (right)
							state <= R3_0;
						else
							state <= IDLE;
					end
				R3_0:
					state <= R3_1;
				R3_1:
					state <= R3_2;
				R3_2:
					begin
						if (left && right)
							state <= ERROR_STATE;
						else if (right)
							state <= R0;
						else
							state <= IDLE;
					end
				ERROR_STATE:
					if (!left || !right)
						state <= IDLE;
			endcase
		end
	
endmodule