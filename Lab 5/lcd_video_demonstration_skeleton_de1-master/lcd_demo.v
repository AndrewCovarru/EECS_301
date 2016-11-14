
// The top-level Verilog file for lcd_demo
// This code was initially generated by Terasic System Builder

module lcd_demo(

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

// =======================================================
// REG/WIRE declarations
// =======================================================
wire pll_lock;

wire [ 9: 0 ] h_pos, v_pos;
wire valid_draw, v_blank;

wire en_switch;
wire ready;
wire video_enable;

wire [ 7: 0 ] disp_red, disp_green, disp_blue;
wire disp_clk, disp_en, disp_vsync, disp_hsync;

wire [ 27: 0 ] aggregate_video;

//=======================================================
// Input/Output assignments
//=======================================================

// Hello!! BIG HINT HERE! (It'll make your life easier)
assign { GPIO_1[ 31: 19 ], GPIO_1[ 17 ], GPIO_1[ 15: 3 ], GPIO_1[ 1 ] } = aggregate_video;
assign aggregate_video = { disp_vsync, disp_hsync, disp_en, disp_clk, disp_blue, disp_green, disp_red };
assign disp_en = pll_lock; // Enable the display just after PLL has locked

// Operation of system:
// Set SW[0] low, program device, set SW[0] high.
assign en_switch = SW[ 0 ];
assign video_en = en_switch && ready;
assign LEDR[2] = en_switch;
assign LEDR[1] = ready;
assign LEDR[0] = video_en;


// =======================================================
// Structural coding
// =======================================================

video_pll pll(
            .refclk( CLOCK_50 ),
            .rst( 1'b0 ),
            .outclk_0( disp_clk ),
            .locked( pll_lock )
          );

delay_timer delay(disp_clk, pll_lock, ready);

// Control the video side of the world
video_position_sync video_sync (
                      .disp_clk( disp_clk ),
                      .en( pll_lock ),
                      .valid_draw( valid_draw ),
                      .v_blank( v_blank ),
                      .h_pos( h_pos ),
                      .v_pos( v_pos ),
                      .disp_hsync( disp_hsync ),
                      .disp_vsync( disp_vsync )
                    );

demo_video video_gen
           (
             .clk( disp_clk ),
             .en( video_en ),
             .x_pos( h_pos ),
             .y_pos( v_pos ),
             .valid_region( valid_draw ),
             .v_blank( v_blank ),
             .value_red( disp_red ),
             .value_green( disp_green ),
             .value_blue( disp_blue )
           );

endmodule
