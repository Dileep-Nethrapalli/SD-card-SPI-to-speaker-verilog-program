`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 18.02.2022 18:11:53
// Design Name: 
// Module Name: SD_card
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CMD18(
         output reg CMD18_pass, CS, Data_Out, clock_1412KHz, AUD_PWM,     
         input  Init_pass, Data_In, Clock_100MHz, Clear_n);  
         
   
    reg count_en;
    reg [9:0]  Bytes;
    reg [47:0] response;
   // reg [47:0] cmd = 48'h520008000001; // CMD18 (Read Multile Blocks) 
    reg [47:0] cmd = 48'h520000C84101;  // First song start address

  //  Bitrate = bits per sample * samples per second
   // Bitrate = 16 * 44100 = 705600Hz = 706KHz           
   // Generate a clock twice as Bitrate(706KHz) = 1412KHz(0.71us)
   // 0.71us clock = 0.355us ON + 0.355us OFF
   // 100MHz = 10ns = 1;  0.355us = x;  x = 35.5 = 36;
   // 36 = 10_0100b             
   reg [5:0] count_36;
                                
   always@(posedge Clock_100MHz, negedge Clear_n)
     if(!Clear_n)
        begin
          clock_1412KHz <= 0;
          count_36 <= 0;
        end         
     else if(count_36 == 35)
        begin
          clock_1412KHz <= ~clock_1412KHz;
          count_36 <= 0;
        end 
     else 
          count_36 <= count_36 + 1;
             
         
 // FSM for SD card Initialization
    reg [7:0] present_state, next_state;
    parameter [7:0] 
      RESET = 8'd0, INIT_PASS = 8'd1, 
          
      IDLE_CLK_1 = 8'd2, IDLE_CLK_2 = 8'd3, IDLE_CLK_3 = 8'd4, IDLE_CLK_4 = 8'd5,  
      IDLE_CLK_5 = 8'd6, IDLE_CLK_6 = 8'd7, IDLE_CLK_7 = 8'd8, IDLE_CLK_8 = 8'd9,  
    
      CMD_47 = 8'd10, CMD_46 = 8'd11, CMD_45 = 8'd12, CMD_44 = 8'd13,  
      CMD_43 = 8'd14, CMD_42 = 8'd15, CMD_41 = 8'd16, CMD_40 = 8'd17,
      CMD_39 = 8'd18, CMD_38 = 8'd19, CMD_37 = 8'd20, CMD_36 = 8'd21,
      CMD_35 = 8'd22, CMD_34 = 8'd23, CMD_33 = 8'd24, CMD_32 = 8'd25,
      CMD_31 = 8'd26, CMD_30 = 8'd27, CMD_29 = 8'd28, CMD_28 = 8'd29,
      CMD_27 = 8'd30, CMD_26 = 8'd31, CMD_25 = 8'd32, CMD_24 = 8'd33,
      CMD_23 = 8'd34, CMD_22 = 8'd35, CMD_21 = 8'd36, CMD_20 = 8'd37,
      CMD_19 = 8'd38, CMD_18 = 8'd39, CMD_17 = 8'd40, CMD_16 = 8'd41,
      CMD_15 = 8'd42, CMD_14 = 8'd43, CMD_13 = 8'd44, CMD_12 = 8'd45,
      CMD_11 = 8'd46, CMD_10 = 8'd47, CMD_9  = 8'd48, CMD_8  = 8'd49,
      CMD_7  = 8'd50, CMD_6  = 8'd51, CMD_5  = 8'd52, CMD_4  = 8'd53,
      CMD_3  = 8'd54, CMD_2  = 8'd55, CMD_1  = 8'd56, CMD_0  = 8'd57, 
      
      RESP_47 = 8'd58,  RESP_46 = 8'd59,  RESP_45 = 8'd60,  RESP_44 = 8'd61,  
      RESP_43 = 8'd62,  RESP_42 = 8'd63,  RESP_41 = 8'd64,  RESP_40 = 8'd65,                         
      RESP_39 = 8'd66,  RESP_38 = 8'd67,  RESP_37 = 8'd68,  RESP_36 = 8'd69,  
      RESP_35 = 8'd70,  RESP_34 = 8'd71,  RESP_33 = 8'd72,  RESP_32 = 8'd73,                                       
      RESP_31 = 8'd74,  RESP_30 = 8'd75,  RESP_29 = 8'd76,  RESP_28 = 8'd77,  
      RESP_27 = 8'd78,  RESP_26 = 8'd79,  RESP_25 = 8'd80,  RESP_24 = 8'd81,
      RESP_23 = 8'd82,  RESP_22 = 8'd83,  RESP_21 = 8'd84,  RESP_20 = 8'd85,
      RESP_19 = 8'd86,  RESP_18 = 8'd87,  RESP_17 = 8'd88,  RESP_16 = 8'd89,
      RESP_15 = 8'd90,  RESP_14 = 8'd91,  RESP_13 = 8'd92,  RESP_12 = 8'd93,
      RESP_11 = 8'd94,  RESP_10 = 8'd95,  RESP_9 = 8'd96,   RESP_8 = 8'd97,                                       
      RESP_7 = 8'd98,   RESP_6 = 8'd99,   RESP_5 = 8'd100,  RESP_4 = 8'd101,
      RESP_3 = 8'd102,  RESP_2 = 8'd103,  RESP_1 = 8'd104,  RESP_0 = 8'd105,
      
      CRC_15 = 8'd106, CRC_14 = 8'd107, CRC_13 = 8'd108, CRC_12 = 8'd109,  
      CRC_11 = 8'd110, CRC_10 = 8'd111, CRC_9 = 8'd112,  CRC_8 = 8'd113,
      CRC_7 = 8'd114,  CRC_6 = 8'd115,  CRC_5 = 8'd116,  CRC_4 = 8'd117,  
      CRC_3 = 8'd118,  CRC_2 = 8'd119,  CRC_1 = 8'd120,  CRC_0 = 8'd121;                                            
                                        
                    
  // FSM Registers
     always@(negedge clock_1412KHz, negedge Clear_n) 
       if(!Clear_n)
          present_state <= RESET;
       else
          present_state <= next_state;            
           
 // FSM combinational block
  always@(present_state, cmd, Init_pass, Data_In, Bytes, CMD18_pass)
    case(present_state)
      RESET: begin CS = 1; Data_Out = 1; next_state = INIT_PASS; end  
                               
      INIT_PASS: begin 
                   CS = 1; Data_Out = 1; 
                   if(Init_pass)
                      next_state = IDLE_CLK_1;                         
                   else
                      next_state = present_state;                          
                 end
                            
      IDLE_CLK_1: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_2; end  
      IDLE_CLK_2: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_3; end  
      IDLE_CLK_3: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_4; end  
      IDLE_CLK_4: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_5; end  
      IDLE_CLK_5: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_6; end  
      IDLE_CLK_6: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_7; end  
      IDLE_CLK_7: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_8; end  
      IDLE_CLK_8: begin CS = 0; Data_Out = 1; next_state = CMD_47;     end  
                                    
      CMD_47: begin CS = 0; Data_Out = cmd[47]; next_state = CMD_46; end          
      CMD_46: begin CS = 0; Data_Out = cmd[46]; next_state = CMD_45; end
      CMD_45: begin CS = 0; Data_Out = cmd[45]; next_state = CMD_44; end
      CMD_44: begin CS = 0; Data_Out = cmd[44]; next_state = CMD_43; end
      CMD_43: begin CS = 0; Data_Out = cmd[43]; next_state = CMD_42; end
      CMD_42: begin CS = 0; Data_Out = cmd[42]; next_state = CMD_41; end
      CMD_41: begin CS = 0; Data_Out = cmd[41]; next_state = CMD_40; end
      CMD_40: begin CS = 0; Data_Out = cmd[40]; next_state = CMD_39; end
      CMD_39: begin CS = 0; Data_Out = cmd[39]; next_state = CMD_38; end          
      CMD_38: begin CS = 0; Data_Out = cmd[38]; next_state = CMD_37; end
      CMD_37: begin CS = 0; Data_Out = cmd[37]; next_state = CMD_36; end
      CMD_36: begin CS = 0; Data_Out = cmd[36]; next_state = CMD_35; end
      CMD_35: begin CS = 0; Data_Out = cmd[35]; next_state = CMD_34; end
      CMD_34: begin CS = 0; Data_Out = cmd[34]; next_state = CMD_33; end
      CMD_33: begin CS = 0; Data_Out = cmd[33]; next_state = CMD_32; end
      CMD_32: begin CS = 0; Data_Out = cmd[32]; next_state = CMD_31; end
      CMD_31: begin CS = 0; Data_Out = cmd[31]; next_state = CMD_30; end
      CMD_30: begin CS = 0; Data_Out = cmd[30]; next_state = CMD_29; end
      CMD_29: begin CS = 0; Data_Out = cmd[29]; next_state = CMD_28; end           
      CMD_28: begin CS = 0; Data_Out = cmd[28]; next_state = CMD_27; end 
      CMD_27: begin CS = 0; Data_Out = cmd[27]; next_state = CMD_26; end
      CMD_26: begin CS = 0; Data_Out = cmd[26]; next_state = CMD_25; end
      CMD_25: begin CS = 0; Data_Out = cmd[25]; next_state = CMD_24; end
      CMD_24: begin CS = 0; Data_Out = cmd[24]; next_state = CMD_23; end
      CMD_23: begin CS = 0; Data_Out = cmd[23]; next_state = CMD_22; end
      CMD_22: begin CS = 0; Data_Out = cmd[22]; next_state = CMD_21; end
      CMD_21: begin CS = 0; Data_Out = cmd[21]; next_state = CMD_20; end
      CMD_20: begin CS = 0; Data_Out = cmd[20]; next_state = CMD_19; end
      CMD_19: begin CS = 0; Data_Out = cmd[19]; next_state = CMD_18; end           
      CMD_18: begin CS = 0; Data_Out = cmd[18]; next_state = CMD_17; end 
      CMD_17: begin CS = 0; Data_Out = cmd[17]; next_state = CMD_16; end 
      CMD_16: begin CS = 0; Data_Out = cmd[16]; next_state = CMD_15; end 
      CMD_15: begin CS = 0; Data_Out = cmd[15]; next_state = CMD_14; end 
      CMD_14: begin CS = 0; Data_Out = cmd[14]; next_state = CMD_13; end 
      CMD_13: begin CS = 0; Data_Out = cmd[13]; next_state = CMD_12; end 
      CMD_12: begin CS = 0; Data_Out = cmd[12]; next_state = CMD_11; end 
      CMD_11: begin CS = 0; Data_Out = cmd[11]; next_state = CMD_10; end 
      CMD_10: begin CS = 0; Data_Out = cmd[10]; next_state = CMD_9;  end 
      CMD_9:  begin CS = 0; Data_Out = cmd[9];  next_state = CMD_8;  end           
      CMD_8:  begin CS = 0; Data_Out = cmd[8];  next_state = CMD_7;  end 
      CMD_7:  begin CS = 0; Data_Out = cmd[7];  next_state = CMD_6;  end
      CMD_6:  begin CS = 0; Data_Out = cmd[6];  next_state = CMD_5;  end
      CMD_5:  begin CS = 0; Data_Out = cmd[5];  next_state = CMD_4;  end
      CMD_4:  begin CS = 0; Data_Out = cmd[4];  next_state = CMD_3;  end
      CMD_3:  begin CS = 0; Data_Out = cmd[3];  next_state = CMD_2;  end
      CMD_2:  begin CS = 0; Data_Out = cmd[2];  next_state = CMD_1;  end
      CMD_1:  begin CS = 0; Data_Out = cmd[1];  next_state = CMD_0;  end
      CMD_0:  begin CS = 0; Data_Out = cmd[0];  next_state = RESP_47; end 
      
      RESP_47: begin CS = 0; Data_Out = 1; 
                     if(!Data_In)      
                        next_state = RESP_46; 
                     else
                        next_state = present_state; 
               end
      RESP_46: begin CS = 0; Data_Out = 1; next_state = RESP_45; end
      RESP_45: begin CS = 0; Data_Out = 1; next_state = RESP_44; end          
      RESP_44: begin CS = 0; Data_Out = 1; next_state = RESP_43; end
      RESP_43: begin CS = 0; Data_Out = 1; next_state = RESP_42; end
      RESP_42: begin CS = 0; Data_Out = 1; next_state = RESP_41; end
      RESP_41: begin CS = 0; Data_Out = 1; next_state = RESP_40; end
      RESP_40: begin CS = 0; Data_Out = 1; next_state = RESP_39; end                  
      RESP_39: begin CS = 0; Data_Out = 1; next_state = RESP_38; end
      RESP_38: begin CS = 0; Data_Out = 1; next_state = RESP_37; end
      RESP_37: begin CS = 0; Data_Out = 1; next_state = RESP_36; end          
      RESP_36: begin CS = 0; Data_Out = 1; next_state = RESP_35; end
      RESP_35: begin CS = 0; Data_Out = 1; next_state = RESP_34; end
      RESP_34: begin CS = 0; Data_Out = 1; next_state = RESP_33; end
      RESP_33: begin CS = 0; Data_Out = 1; next_state = RESP_32; end
      RESP_32: begin CS = 0; Data_Out = 1; 
                     if(!Data_In)      
                        next_state = RESP_31; 
                     else
                        next_state = present_state; 
               end 
      RESP_31: begin CS = 0; Data_Out = 1; 
                     if(CMD18_pass)
                        next_state = RESP_30; 
                     else
                        next_state = IDLE_CLK_1;  
               end
      RESP_30: begin CS = 0; Data_Out = 1; next_state = RESP_29; end
      RESP_29: begin CS = 0; Data_Out = 1; next_state = RESP_28; end          
      RESP_28: begin CS = 0; Data_Out = 1; next_state = RESP_27; end
      RESP_27: begin CS = 0; Data_Out = 1; next_state = RESP_26; end
      RESP_26: begin CS = 0; Data_Out = 1; next_state = RESP_25; end
      RESP_25: begin CS = 0; Data_Out = 1; next_state = RESP_24; end
      RESP_24: begin CS = 0; Data_Out = 1; next_state = RESP_23; end            
      RESP_23: begin CS = 0; Data_Out = 1; next_state = RESP_22; end   
      RESP_22: begin CS = 0; Data_Out = 1; next_state = RESP_21; end
      RESP_21: begin CS = 0; Data_Out = 1; next_state = RESP_20; end
      RESP_20: begin CS = 0; Data_Out = 1; next_state = RESP_19; end
      RESP_19: begin CS = 0; Data_Out = 1; next_state = RESP_18; end         
      RESP_18: begin CS = 0; Data_Out = 1; next_state = RESP_17; end
      RESP_17: begin CS = 0; Data_Out = 1; next_state = RESP_16; end
      RESP_16: begin CS = 0; Data_Out = 1; next_state = RESP_15; end      
      RESP_15: begin CS = 0; Data_Out = 1; next_state = RESP_14; end
      RESP_14: begin CS = 0; Data_Out = 1; next_state = RESP_13; end
      RESP_13: begin CS = 0; Data_Out = 1; next_state = RESP_12; end
      RESP_12: begin CS = 0; Data_Out = 1; next_state = RESP_11; end
      RESP_11: begin CS = 0; Data_Out = 1; next_state = RESP_10; end
      RESP_10: begin CS = 0; Data_Out = 1; next_state = RESP_9;  end
      RESP_9:  begin CS = 0; Data_Out = 1; next_state = RESP_8;  end         
      RESP_8:  begin CS = 0; Data_Out = 1; next_state = RESP_7;  end         
      RESP_7:  begin CS = 0; Data_Out = 1; next_state = RESP_6;  end
      RESP_6:  begin CS = 0; Data_Out = 1; next_state = RESP_5;  end
      RESP_5:  begin CS = 0; Data_Out = 1; next_state = RESP_4;  end
      RESP_4:  begin CS = 0; Data_Out = 1; next_state = RESP_3;  end
      RESP_3:  begin CS = 0; Data_Out = 1; next_state = RESP_2;  end
      RESP_2:  begin CS = 0; Data_Out = 1; next_state = RESP_1;  end
      RESP_1:  begin CS = 0; Data_Out = 1; next_state = RESP_0;  end
      RESP_0:  begin CS = 0; Data_Out = 1; 
                     if(Bytes == 512)
                       next_state = CRC_15;
                     else
                       next_state = RESP_31; 
                    
               end  
      
      CRC_15: begin CS = 0; Data_Out = 1; next_state = CRC_14; end
      CRC_14: begin CS = 0; Data_Out = 1; next_state = CRC_13; end
      CRC_13: begin CS = 0; Data_Out = 1; next_state = CRC_12; end
      CRC_12: begin CS = 0; Data_Out = 1; next_state = CRC_11; end
      CRC_11: begin CS = 0; Data_Out = 1; next_state = CRC_10; end
      CRC_10: begin CS = 0; Data_Out = 1; next_state = CRC_9;  end
      CRC_9:  begin CS = 0; Data_Out = 1; next_state = CRC_8;  end         
      CRC_8:  begin CS = 0; Data_Out = 1; next_state = CRC_7;  end         
      CRC_7:  begin CS = 0; Data_Out = 1; next_state = CRC_6;  end
      CRC_6:  begin CS = 0; Data_Out = 1; next_state = CRC_5;  end
      CRC_5:  begin CS = 0; Data_Out = 1; next_state = CRC_4;  end
      CRC_4:  begin CS = 0; Data_Out = 1; next_state = CRC_3;  end
      CRC_3:  begin CS = 0; Data_Out = 1; next_state = CRC_2;  end
      CRC_2:  begin CS = 0; Data_Out = 1; next_state = CRC_1;  end
      CRC_1:  begin CS = 0; Data_Out = 1; next_state = CRC_0;  end
      CRC_0:  begin CS = 0; Data_Out = 1; next_state = RESP_31; end        
          
      default: begin CS = 1; Data_Out = 1; next_state = RESET; end         
    endcase
    
 
 // Capture SD card output data  
  always@(posedge clock_1412KHz, negedge Clear_n) 
   if(!Clear_n)
     response <= 0;
   else
     case(present_state)
       RESP_47: response[47] <= Data_In;
       RESP_46: response[46] <= Data_In;
       RESP_45: response[45] <= Data_In;          
       RESP_44: response[44] <= Data_In;           
       RESP_43: response[43] <= Data_In;
       RESP_42: response[42] <= Data_In;
       RESP_41: response[41] <= Data_In;
       RESP_40: response[40] <= Data_In;     
       RESP_39: response[39] <= Data_In;
       RESP_38: response[38] <= Data_In;
       RESP_37: response[37] <= Data_In;          
       RESP_36: response[36] <= Data_In;           
       RESP_35: response[35] <= Data_In;
       RESP_34: response[34] <= Data_In;
       RESP_33: response[33] <= Data_In;
       RESP_32: response[32] <= Data_In;  
       RESP_31: response[31] <= Data_In; // Left channel LSB first
       RESP_30: response[30] <= Data_In;
       RESP_29: response[29] <= Data_In;          
       RESP_28: response[28] <= Data_In;
       RESP_27: response[27] <= Data_In;
       RESP_26: response[26] <= Data_In;
       RESP_25: response[25] <= Data_In;
       RESP_24: response[24] <= Data_In;
       RESP_23: response[23] <= Data_In; // Left channel MSB last
       RESP_22: response[22] <= Data_In;
       RESP_21: response[21] <= Data_In;
       RESP_20: response[20] <= Data_In;
       RESP_19: response[19] <= Data_In;          
       RESP_18: response[18] <= Data_In;
       RESP_17: response[17] <= Data_In;
       RESP_16: response[16] <= Data_In;
       RESP_15: response[15] <= Data_In;  // Right channel LSB first
       RESP_14: response[14] <= Data_In;
       RESP_13: response[13] <= Data_In;
       RESP_12: response[12] <= Data_In;
       RESP_11: response[11] <= Data_In;
       RESP_10: response[10] <= Data_In;
       RESP_9:  response[9]  <= Data_In;          
       RESP_8:  response[8]  <= Data_In; 
       RESP_7:  response[7]  <= Data_In; // Right channel MSB last
       RESP_6:  response[6]  <= Data_In;
       RESP_5:  response[5]  <= Data_In;
       RESP_4:  response[4]  <= Data_In;
       RESP_3:  response[3]  <= Data_In;
       RESP_2:  response[2]  <= Data_In;
       RESP_1:  response[1]  <= Data_In;
       RESP_0:  response[0]  <= Data_In; 
     endcase        
   
   
  // Generate CMD18 pass signal
   // response[47:40] Response R1 (shuold be zero0
   // response[39:32] Data Token (shuold be FE for Multiple Block Read)
  always@(negedge Clock_100MHz, negedge Clear_n) 
    if(!Clear_n)
       CMD18_pass <= 0;
    else if((present_state == RESP_32) && clock_1412KHz && (count_36 == 18))   
      if(response[47:32] == 16'h00FE)
        CMD18_pass <= 1;
      else
        CMD18_pass <= 0; 
        
        
  // Generate number of bytes received per block
   always@(negedge Clock_100MHz, negedge Clear_n)  
     if(!Clear_n)       
        Bytes <= 0;  
     else if((present_state == CRC_0) && clock_1412KHz && (count_36 == 18)) 
        Bytes <= 0; 
     else if((present_state == RESP_0) && clock_1412KHz && (count_36 == 18)) 
        Bytes <= Bytes + 4; 
        
   
// Set audio negative data value to zero
   reg [15:0] Left_channel_data, Right_channel_data;
   
   always@(negedge Clock_100MHz, negedge Clear_n)  
     if(!Clear_n)       
        Left_channel_data <= 0;
     else if((present_state == RESP_16) && clock_1412KHz && (count_36 == 18))
          if(response[23])  // Left channel audio negative value
             Left_channel_data <= 0;
          else   
             Left_channel_data <= {response[23:16], response[31:24]}; 
          
   always@(negedge Clock_100MHz, negedge Clear_n) 
     if(!Clear_n)
        Right_channel_data <= 0; 
     else if((present_state == RESP_0) && clock_1412KHz && (count_36 == 18) && response[7])  
          if(response[7])  // Right channel audio negative value
             Right_channel_data <= 0;
          else
             Right_channel_data <= {response[7:0], response[15:8]};                    
    
     
  // Assign converted sd card audio data to speaker
    always@(posedge clock_1412KHz, negedge Clear_n)  
       if(!Clear_n)       
          AUD_PWM <= 0;  
       else 
         case(present_state) 
               RESP_15 : AUD_PWM <= Left_channel_data[15]; 
               RESP_13 : AUD_PWM <= Left_channel_data[14];
               RESP_11 : AUD_PWM <= Left_channel_data[13];
               RESP_9  : AUD_PWM <= Left_channel_data[12];
               RESP_7  : AUD_PWM <= Left_channel_data[11]; 
               RESP_5  : AUD_PWM <= Left_channel_data[10];
               RESP_3  : AUD_PWM <= Left_channel_data[9];
               RESP_1  : AUD_PWM <= Left_channel_data[8];         
               RESP_31 : AUD_PWM <= Left_channel_data[7]; 
               RESP_29 : AUD_PWM <= Left_channel_data[6];
               RESP_27 : AUD_PWM <= Left_channel_data[5];
               RESP_25 : AUD_PWM <= Left_channel_data[4];
               RESP_23 : AUD_PWM <= Left_channel_data[3]; 
               RESP_21 : AUD_PWM <= Left_channel_data[2];
               RESP_19 : AUD_PWM <= Left_channel_data[1];
               RESP_17 : AUD_PWM <= Left_channel_data[0]; 
              
             /*  RESP_30 : AUD_PWM <= Right_channel_data[15];
               RESP_28 : AUD_PWM <= Right_channel_data[14];
               RESP_26 : AUD_PWM <= Right_channel_data[13];
               RESP_24 : AUD_PWM <= Right_channel_data[12];
               RESP_22 : AUD_PWM <= Right_channel_data[11];
               RESP_20 : AUD_PWM <= Right_channel_data[10];
               RESP_18 : AUD_PWM <= Right_channel_data[9]; 
               RESP_16 : AUD_PWM <= Right_channel_data[8];
               RESP_14 : AUD_PWM <= Right_channel_data[7];
               RESP_12 : AUD_PWM <= Right_channel_data[6];
               RESP_10 : AUD_PWM <= Right_channel_data[5];
               RESP_8  : AUD_PWM <= Right_channel_data[4];
               RESP_6  : AUD_PWM <= Right_channel_data[3];
               RESP_4  : AUD_PWM <= Right_channel_data[2];
               RESP_2  : AUD_PWM <= Right_channel_data[1];
               RESP_0  : AUD_PWM <= Right_channel_data[0];  */              
              
               CRC_15, CRC_14, CRC_13, CRC_12, CRC_11, CRC_10, 
               CRC_9,  CRC_8,  CRC_7,  CRC_6,  CRC_5,  CRC_4, 
               CRC_3,  CRC_2,  CRC_1,  CRC_0 : AUD_PWM <= 0; 
         endcase  

endmodule
