
// The top-level Verilog file for eecs301_lab3
// This code was initially generated by Terasic System Builder

module eecs301_lab3(

         //////////// ADC //////////
         output ADC_CONVST,
         output ADC_DIN,
         input ADC_DOUT,
         output ADC_SCLK,

         //////////// CLOCK //////////
         input CLOCK_50,
         input CLOCK2_50,
         input CLOCK3_50,
         input CLOCK4_50,

         //////////// SEG7 //////////
         output [ 6: 0 ] HEX0,
         output [ 6: 0 ] HEX1,
         output [ 6: 0 ] HEX2,
         output [ 6: 0 ] HEX3,
         output [ 6: 0 ] HEX4,
         output [ 6: 0 ] HEX5,

         //////////// KEY //////////
         input [ 3: 0 ] KEY,

         //////////// LED //////////
         output [ 9: 0 ] LEDR,

         //////////// SW //////////
         input [ 9: 0 ] SW,

         //////////// VGA //////////
         output [ 7: 0 ] VGA_B,
         output VGA_BLANK_N,
         output VGA_CLK,
         output [ 7: 0 ] VGA_G,
         output VGA_HS,
         output [ 7: 0 ] VGA_R,
         output VGA_SYNC_N,
         output VGA_VS,

         //////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
         inout [ 35: 0 ] GPIO_0,

         //////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
         inout [ 35: 0 ] GPIO_1
       );

//=======================================================
//  REG/WIRE declarations
//=======================================================

// Zero hex displays
assign HEX0[6:0] = 7'b1111111;
assign HEX1[6:0] = 7'b1111111;
assign HEX2[6:0] = 7'b1111111;
assign HEX3[6:0] = 7'b1111111;
assign HEX4[6:0] = 7'b1111111;
assign HEX5[6:0] = 7'b1111111;

wire pulse;
wire out_valid; 

// input to set_values
wire enable_switch;
wire reset_button;
wire change_switch;
wire encoder_a;
wire encoder_b;

// output from set_values
wire [8 : 0] amp_out;
wire [/*15*/31 : 0] freq_out;

// DAC inputs
wire DAC_sync;
wire DAC_clk;  
wire DAC_in;

// output from NCO
wire [11 : 0] orig_sine;

// output from mult
wire [11 : 0] gain_sine;

//=======================================================
//  Structural coding
//=======================================================

/////////////////////////////////////////////////////////          
// Synchronize important inputs to the 50 MHz clock    //
															
clock_sync sync_enable (					
				.clk(CLOCK_50),									
				.in(SW[1]),										
				.out(enable_switch)								
			);														
																	
clock_sync sync_change (			
				.clk(CLOCK_50),								
				.in(SW[0]),										
				.out(change_switch)								
			);													
															
clock_sync sync_reset (						
				.clk(CLOCK_50),									
				.in(~KEY[0]),										 
				.out(reset_button)								 
			);															 
																	
clock_sync sync_a (						
				.clk(CLOCK_50),									
				.in(GPIO_0[6]),									 
				.out(encoder_a)									 
			);												
																		
clock_sync sync_b (				
				.clk(CLOCK_50),									 
				.in(GPIO_0[7]),									
				.out(encoder_b)									 
			);															

/////////////////////////////////////////////////////////
assign GPIO_0[9] = DAC_in;
assign GPIO_0[10] = DAC_sync;
assign GPIO_0[11] = 1'b0;  
assign GPIO_0[8] = DAC_clk;
assign DAC_clk = CLOCK_50;

// Set values
set_values set_v (
				.clk(CLOCK_50), 
				.reset_button(reset_button), 
				.A(encoder_a), 
				.B(encoder_b), 
				.change_switch(change_switch), 
				.amp_out(amp_out), 
				.freq_out(freq_out)
			);

count_slow cs (
				.clk(CLOCK_50),
				.out(pulse),
				.counter_internal_byte()
			);

// NCO generates sine wave
NCO_Lab3 u0 (
				.clk       (CLOCK_50),
				.clken     (pulse),     
				.phi_inc_i (freq_out),
				.fsin_o    (orig_sine),
				.out_valid (out_valid),
				.reset_n   (1'b1)
			);
			
// multiply the amplitude to the sine wave
gain_mult gm (
				.clk(CLOCK_50),
				.sine(orig_sine), 
				.gain(amp_out), 
				.gain_sine(gain_sine)
			);

// sends the sine wave data to the DAC 
data_to_dac dd ( 
				.clk(CLOCK_50),
				.sine_data(gain_sine),
				.dac_out(DAC_in),
				.sync(DAC_sync)
			);	
endmodule
