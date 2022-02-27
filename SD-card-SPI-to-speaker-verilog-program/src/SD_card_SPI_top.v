`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 28.02.2022 22:23:24
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: SD card output to speaker 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SD_card_SPI_to_Speaker_top(
         output AN7, AN6, AN5, AN4, AN3, AN2, AN1, AN0,
         output CA, CB, CC, CD, CE, CF, CG, DP,          
         output CLK, CARD_DETECT_out, SD_RESET,  
         output DAT3,  // DAT3 = CS
         output CMD,   // CMD = Data Out
         input  DAT0,  // DAT0 = Data In
         output CMD0_Pass,  CMD8_Pass,  CMD55_Pass, ACMD41_Pass, 
                CMD58_Pass, CMD18_Pass,
         output AUD_PWM, AUD_SD,           
         input  [2:0] CMD_resp_sel, 
         input  CARD_DETECT, Response_MSB, Clock_100MHz, Clear_n); 
   
     
    assign CARD_DETECT_out = ~CARD_DETECT; 
    assign SD_RESET = ~Clear_n;
    assign AUD_SD = Clear_n;
  
    wire clock_100KHz, clock_1412KHz, init_pass;
    wire [8:0]  count_500; 
    wire [31:0] sd_card_out;    
    wire init_din, init_cs, init_dout;      
    wire cmd18_din, cmd18_cs, cmd18_dout;
  
     
    Enable_generation en_DUT(
      .CS(DAT3), .Data_Out(CMD), .CLK(CLK), 
      .Init_Data_In(init_din), .CMD18_Data_In(cmd18_din),
      .Data_In(DAT0), .Init_pass(init_pass),      
      .Init_CS(init_cs), .Init_Data_Out(init_dout),
        .Init_CLK(clock_100KHz),         
      .CMD18_CS(cmd18_cs), .CMD18_Data_Out(cmd18_dout),            
        .CMD18_CLK(clock_1412KHz), 
      .Clock_100MHz(Clock_100MHz), .Clear_n(Clear_n)); 
  
    
    CMD0_CMD8_CMD55_ACMD41_CMD58 init_DUT (
      .Response_out(sd_card_out), 
      .CMD0_pass(CMD0_Pass), .CMD8_pass(CMD8_Pass),
      .CMD55_pass(CMD55_Pass), .ACMD41_pass(ACMD41_Pass),
      .CMD58_pass(CMD58_Pass),  
      .CS(init_cs), .Data_Out(init_dout), 
      .CMD18_out(AUD_PWM), .CMD_resp_sel(CMD_resp_sel), 
      .Response_MSB(Response_MSB), .Data_In(init_din), 
      .clock_100KHz(clock_100KHz), .Init_pass(init_pass),     
      .Clock_100MHz(Clock_100MHz), .Clear_n(Clear_n));  
      
      
    CMD18 cmd18_DUT(
        .CMD18_pass(CMD18_Pass),     
        .CS(cmd18_cs), .Data_Out(cmd18_dout), .AUD_PWM(AUD_PWM),   
        .Init_pass(init_pass), .Data_In(cmd18_din), 
        .clock_1412KHz(clock_1412KHz),                     
        .Clock_100MHz(Clock_100MHz), .Clear_n(Clear_n));   
      
 
    BCH_to_7_segment_LED_Decoder bch_to_7_seg_LED_DUT(
    	 .DP(DP),
    	 .Cathodes({CA,CB,CC,CD,CE,CF,CG}), 
    	 .Anodes({AN7,AN6,AN5,AN4,AN3,AN2,AN1,AN0}),                  
    	 .Clock_100MHz(Clock_100MHz), .Enable(1'b1),
    	 .Clear_n(Clear_n), .In(sd_card_out));

endmodule
