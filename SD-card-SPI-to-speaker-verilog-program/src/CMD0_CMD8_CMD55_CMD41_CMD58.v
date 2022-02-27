`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 30.07.2020 18:11:53
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


module CMD0_CMD8_CMD55_ACMD41_CMD58(
         output reg [31:0] Response_out,
         output reg CMD0_pass, CMD8_pass, CMD55_pass, ACMD41_pass, CMD58_pass,    
         output reg CS, Data_Out, clock_100KHz, 
         output Init_pass, 
         input [2:0] CMD_resp_sel,
         input CMD18_out, Response_MSB, Data_In, Clock_100MHz, Clear_n);           
   
    reg count_en;
    reg [14:0] count; 
    reg [39:0] response;
    reg [47:0] cmd; 
    
    parameter [47:0] CMD0   = 48'h400000000095; // Send Card to Idle State
    parameter [47:0] CMD8   = 48'h48000001AA87; // Send Card Interface Condition
    parameter [47:0] CMD55  = 48'h770000000065; // Application Specific Command
    parameter [47:0] ACMD41 = 48'h694000000077; // High Capacity support(HCS) = 1
    parameter [47:0] CMD58 =  48'h7A00000000FD; // Read OCR(Operating Conditions Register)
    
    
 // Generate 100KHz clock
  // 100KHz = 10us
  // 10us clock = 5us ON + 5us OFF
  // 10ns = 1; 5us = x; x = 500;
  // 499 = 1 1111 0011b 
     
  reg [8:0] count_500; 
                                      
  always@(posedge Clock_100MHz, negedge Clear_n)
    if(!Clear_n)   
      begin             
        clock_100KHz <= 0;
        count_500 <= 0; 
      end
    else if(count_500 == 499)        
      begin             
        clock_100KHz <= ~clock_100KHz;
        count_500 <= 0; 
      end 
    else         
        count_500 <= count_500 + 1;           
           
         
 // FSM for SD card Initialization
    reg [7:0] present_state, next_state;
    parameter [7:0] 
      RESET = 8'd0, POWER_UP_TIME = 8'd1, 
          
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
                         
      RESP_39 = 8'd58,  RESP_38 = 8'd59,  RESP_37 = 8'd60,  RESP_36 = 8'd61,  
      RESP_35 = 8'd62,  RESP_34 = 8'd63,  RESP_33 = 8'd64,  RESP_32 = 8'd65,                                       
      RESP_31 = 8'd66,  RESP_30 = 8'd67,  RESP_29 = 8'd68,  RESP_28 = 8'd69,  
      RESP_27 = 8'd70,  RESP_26 = 8'd71,  RESP_25 = 8'd72,  RESP_24 = 8'd73,
      RESP_23 = 8'd74,  RESP_22 = 8'd75,  RESP_21 = 8'd76,  RESP_20 = 8'd77,
      RESP_19 = 8'd78,  RESP_18 = 8'd79,  RESP_17 = 8'd80,  RESP_16 = 8'd81,
      RESP_15 = 8'd82,  RESP_14 = 8'd83,  RESP_13 = 8'd84,  RESP_12 = 8'd85,
      RESP_11 = 8'd86,  RESP_10 = 8'd87,  RESP_9 = 8'd88,   RESP_8 = 8'd89,                                       
      RESP_7 = 8'd90,   RESP_6 = 8'd91,   RESP_5 = 8'd92,   RESP_4 = 8'd93,
      RESP_3 = 8'd94,   RESP_2 = 8'd95,   RESP_1 = 8'd96,   RESP_0 = 8'd97, 
                    
      IDLE_CLK_9 = 8'd98,   IDLE_CLK_10 = 8'd99,  IDLE_CLK_11 = 8'd100, IDLE_CLK_12 = 8'd101, 
      IDLE_CLK_13 = 8'd102, IDLE_CLK_14 = 8'd103, IDLE_CLK_15 = 8'd104, IDLE_CLK_16 = 8'd105,
      FINISH = 8'd106;                                     
                                        
                    
  // FSM Registers
     always@(negedge clock_100KHz, negedge Clear_n) 
       if(!Clear_n)
          present_state <= RESET;
       else
          present_state <= next_state;            
           
 // FSM combinational block
  always@(present_state, count, cmd, response, Data_In, CMD58_pass)
    case(present_state)
      RESET: begin CS = 1; Data_Out = 1; next_state = POWER_UP_TIME; end  
                               
      POWER_UP_TIME: begin 
                       CS = 1; Data_Out = 1; 
                       if(count == 25063)
                          next_state = IDLE_CLK_1;                         
                       else
                          next_state = present_state;                          
                     end
                            
      IDLE_CLK_1: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_2;  end  
      IDLE_CLK_2: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_3;  end  
      IDLE_CLK_3: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_4;  end  
      IDLE_CLK_4: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_5;  end  
      IDLE_CLK_5: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_6;  end  
      IDLE_CLK_6: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_7;  end  
      IDLE_CLK_7: begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_8;  end  
      IDLE_CLK_8: begin CS = 0; Data_Out = 1; next_state = CMD_47;  end  
                                    
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
      CMD_0:  begin CS = 0; Data_Out = cmd[0];  next_state = RESP_39; end           
     
      RESP_39: begin CS = 0; Data_Out = 1; 
                     if(!Data_In)      
                        next_state = RESP_38; 
                     else
                        next_state = present_state; 
               end
      RESP_38: begin CS = 0; Data_Out = 1; next_state = RESP_37; end
      RESP_37: begin CS = 0; Data_Out = 1; next_state = RESP_36; end          
      RESP_36: begin CS = 0; Data_Out = 1; next_state = RESP_35; end
      RESP_35: begin CS = 0; Data_Out = 1; next_state = RESP_34; end
      RESP_34: begin CS = 0; Data_Out = 1; next_state = RESP_33; end
      RESP_33: begin CS = 0; Data_Out = 1; next_state = RESP_32; end
      RESP_32: begin CS = 0; Data_Out = 1; next_state = RESP_31; end             
      RESP_31: begin CS = 0; Data_Out = 1; next_state = RESP_30; end
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
      RESP_0:  begin CS = 0; Data_Out = 1; next_state = IDLE_CLK_9; end          
       
      IDLE_CLK_9:  begin CS = 1; Data_Out = 1; next_state = IDLE_CLK_10; end  
      IDLE_CLK_10: begin CS = 1; Data_Out = 1; next_state = IDLE_CLK_11; end  
      IDLE_CLK_11: begin CS = 1; Data_Out = 1; next_state = IDLE_CLK_12; end  
      IDLE_CLK_12: begin CS = 1; Data_Out = 1; next_state = IDLE_CLK_13; end  
      IDLE_CLK_13: begin CS = 1; Data_Out = 1; next_state = IDLE_CLK_14; end  
      IDLE_CLK_14: begin CS = 1; Data_Out = 1; next_state = IDLE_CLK_15; end  
      IDLE_CLK_15: begin CS = 1; Data_Out = 1; next_state = IDLE_CLK_16; end  
      IDLE_CLK_16: begin CS = 1; Data_Out = 1; 
                         if(CMD58_pass)
                            next_state = FINISH;
                         else
                            next_state = IDLE_CLK_1; end 
                            
      FINISH: begin CS = 1; Data_Out = 1; next_state = present_state; end                      
      
      default: begin CS = 1; Data_Out = 1; next_state = RESET; end         
    endcase
    
 
 // Capture SD card output data  
  always@(posedge clock_100KHz, negedge Clear_n) 
   if(!Clear_n)
     response <= 0;
   else
     case(present_state) 
       RESP_39: response[39] <= Data_In;
       RESP_38: response[38] <= Data_In;
       RESP_37: response[37] <= Data_In;          
       RESP_36: response[36] <= Data_In;           
       RESP_35: response[35] <= Data_In;
       RESP_34: response[34] <= Data_In;
       RESP_33: response[33] <= Data_In;
       RESP_32: response[32] <= Data_In;            
       RESP_31: response[31] <= Data_In;
       RESP_30: response[30] <= Data_In;
       RESP_29: response[29] <= Data_In;          
       RESP_28: response[28] <= Data_In;
       RESP_27: response[27] <= Data_In;
       RESP_26: response[26] <= Data_In;
       RESP_25: response[25] <= Data_In;
       RESP_24: response[24] <= Data_In;
       RESP_23: response[23] <= Data_In;
       RESP_22: response[22] <= Data_In;
       RESP_21: response[21] <= Data_In;
       RESP_20: response[20] <= Data_In;
       RESP_19: response[19] <= Data_In;          
       RESP_18: response[18] <= Data_In;
       RESP_17: response[17] <= Data_In;
       RESP_16: response[16] <= Data_In;
       RESP_15: response[15] <= Data_In;
       RESP_14: response[14] <= Data_In;
       RESP_13: response[13] <= Data_In;
       RESP_12: response[12] <= Data_In;
       RESP_11: response[11] <= Data_In;
       RESP_10: response[10] <= Data_In;
       RESP_9:  response[9]  <= Data_In;          
       RESP_8:  response[8]  <= Data_In; 
       RESP_7:  response[7]  <= Data_In;
       RESP_6:  response[6]  <= Data_In;
       RESP_5:  response[5]  <= Data_In;
       RESP_4:  response[4]  <= Data_In;
       RESP_3:  response[3]  <= Data_In;
       RESP_2:  response[2]  <= Data_In;
       RESP_1:  response[1]  <= Data_In;
       RESP_0:  response[0]  <= Data_In; 
     endcase    
       
 
  reg [7:0]  CMD0_resp, CMD55_resp, ACMD41_resp;   
  reg [39:0] CMD8_resp, CMD58_resp;   
     
  always@(posedge clock_100KHz, negedge Clear_n) 
   if(!Clear_n)
     begin
       cmd <= CMD0; 
       CMD0_resp <= 0;   CMD0_pass   <= 0; 
       CMD8_resp <= 0;   CMD8_pass <= 0;
       CMD55_resp <= 0;  CMD55_pass  <= 0;
       ACMD41_resp <= 0; ACMD41_pass <= 0;
       CMD58_resp <= 0;  CMD58_pass <= 0;        
     end  
   else if(present_state == IDLE_CLK_10) 
     case(cmd)
       CMD0:  
         begin 
           CMD0_resp <= response[39:32]; 
           if(response[39:32] == 1)  
              begin
                CMD0_pass <= 1; 
                cmd <= CMD8; 
              end 
           else
             begin
               CMD0_pass <= 0; 
               cmd <= CMD0; 
             end                                             
         end 
       CMD8: 
         begin 
           CMD8_resp <= response;             
           if(response == 40'h01000001AA) 
              begin 
                CMD8_pass <= 1; 
                cmd <= CMD55;   
              end  
            else
              begin
                CMD8_pass <= 0; 
                cmd <= CMD8;  
              end 
         end        
       CMD55 :  
         begin
           CMD55_resp <= response[39:32]; 
           if(response[39:32] == 1)  
              begin
                CMD55_pass <= 1; 
                cmd <= ACMD41; 
              end  
           else
             begin
               CMD55_pass <= 0;
               cmd <= CMD55;   
             end                                 
         end           
       ACMD41:
         begin          
           ACMD41_resp <= response[39:32]; 
           if(response[39:32] == 0) 
              begin 
                ACMD41_pass <= 1; 
                cmd <= CMD58;  
              end   
           else
              begin 
                ACMD41_pass <= 0;
                cmd <= CMD55; // Repeat CMD55
              end   
         end  
       CMD58:  
         begin 
           CMD58_resp <= response;            
           if(response == 40'h00C0FF8000)
             begin
               CMD58_pass <= 1; 
               cmd <= CMD58;  
             end  
           else
             begin 
               CMD58_pass <= 0; 
               cmd <= CMD58; 
             end    
          end
     endcase                
 
   
 // Capture command responses
  always@(posedge Clock_100MHz, negedge Clear_n) 
    if(!Clear_n)
       Response_out <= 0; 
    else 
      case(CMD_resp_sel)
        0: Response_out <= CMD18_out; 
        1: Response_out <= CMD0_resp;
        2: if(Response_MSB) 
              Response_out <= CMD8_resp[39:32]; 
           else 
              Response_out <= CMD8_resp[31:0]; 
        3: Response_out <= CMD55_resp; 
        4: Response_out <= ACMD41_resp; 
        5: if(Response_MSB) 
              Response_out <= CMD58_resp[39:32]; 
           else 
              Response_out <= CMD58_resp[31:0];                 
      endcase 
 
  
  // Create a delay of 251ms
    // 100KHz = 0.01ms = 1; 251ms = x;
    // x = 25100 = 110_0010_0000_1100b
    always@(posedge clock_100KHz, negedge Clear_n) 
      if(!Clear_n)
         count <= 0;
      else if(present_state == POWER_UP_TIME)              
         count <= count + 1; 
      else 
         count <= 0;  
         
         
   assign Init_pass = (present_state == FINISH) ? 1 : 0;               
       
endmodule
