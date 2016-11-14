
// The top-level Verilog file for eecs301_lab5
// This code was initially generated by Terasic System Builder

module eecs301_lab5(

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

// Wire for PLL
wire pll_locked;

// Wires for display
wire [27:0] video_bus;
wire [7:0] disp_red, disp_green, disp_blue;
wire disp_clock, disp_en, disp_hsync, disp_vsync;

// Wires for video position synchronization
wire [9:0] h_pos, v_pos;
wire valid_draw, v_blank;

// Wires to be used with switches
wire cursor_write;
wire video_en;

// Output assignments for the display
assign {GPIO_1[31:19], GPIO_1[17], GPIO_1[15:3], GPIO_1[1]} = video_bus;
assign video_bus = {disp_vsync, disp_hsync, disp_en, disp_clock, disp_blue, disp_green, disp_red};
assign disp_en = pll_locked;

// Input assignments for switches
assign cursor_write = SW[0];
assign video_en = SW[1];

//=======================================================
//  Structural coding
//=======================================================

pll video_freq_gen(CLOCK_50, 1'b0, disp_clock, pll_locked);
video_position_sync sync_display(disp_clock, pll_locked, valid_draw, v_blank, h_pos, v_pos, disp_hsync, disp_vsync);
video_controller control(disp_clock, video_en, cursor_write, KEY[3:0], SW[9:3], valid_draw, v_blank, h_pos, v_pos, disp_red, disp_green, disp_blue);

endmodule
