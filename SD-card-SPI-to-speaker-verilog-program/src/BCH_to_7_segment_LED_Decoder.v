`timescale 1ns/1ns

//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 26.09.2021 15:00:05
// Design Name: 
// Module Name: BCH_to_7_segment_LED_Decoder
// Project Name: 
// Target Devices: Device Independent 
// Tool Versions: 
// Description: 
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module BCH_to_7_segment_LED_Decoder( 
         output reg DP,             // Decimal point selection for 7_seg_LED Display
         output reg [6:0] Cathodes, // Cathode selection for 7_seg_LED Display
         output reg [7:0] Anodes,   //Anode selection for 7_seg_LED Display
         input  Enable, Clock_100MHz, Clear_n,
         input  [31:0] In); 
         
        
 // This program uses 1ms refresh scheme for 7-segment_LED display,
   // i.e all eight digits are driven once every 1ms
   // There are 8 digits, so create a clock of 1ms/8 = 125 탎(8 KHz)
   // 125 탎 clock = 62.5 탎 on + 62.5 탎 off
   // 10 ns = 1; 62.5 탎 = x; x = 6250; 
   // 6249 = 1_1000_0110_1001b
    
    reg [12:0] count_6250; 
    reg clock_8KHz;  
  
    always@(posedge Clock_100MHz, negedge Clear_n)
       if(!Clear_n)
          begin
            count_6250  <= 0;
            clock_8KHz  <= 0;
          end          
       else if(count_6250 == 6249)
            begin
              count_6250  <= 0;
              clock_8KHz <= ~clock_8KHz;                                
            end 
        else if(Enable)
             count_6250 <= count_6250 + 1;
          
          
 // Generate Anode assert for 7-segment LED
  // 7 for Digit 7, ------  0 for Digit 0   
     reg [2:0] Digit;
     
     always@(posedge clock_8KHz, negedge Clear_n)
        if(!Clear_n)
           Digit <= 3'b000;          
        else if(Digit == 7) 
           Digit <= 3'b000;                    
        else if(Enable)
           Digit <= Digit + 1;  
           
          
// Make assignments to Anodes and cathodes based on In
  always@(negedge clock_8KHz, negedge Clear_n)
    if(!Clear_n)
       begin 
         DP <= 1;
         Anodes   <= 8'b11111110;
         Decoder(4'd0);  // 0
       end   
    else if(In <= 4'hF)  
       case(Digit) // Assert AN0 
               0 : Digit_0;
         default : Digit_disable;          
       endcase         
    else if((In >= 8'h10) && (In <= 8'hFF)) 
       case(Digit) // Assert AN0,AN1
               0 : Digit_0;
               1 : Digit_1;
         default : Digit_disable;  
       endcase         
    else if((In >= 12'h100) && (In <= 12'hFFF))       
       case(Digit) // Assert AN0,AN1,AN2
               0 : Digit_0;
               1 : Digit_1;
               2 : Digit_2;
         default : Digit_disable; 
       endcase        
    else if((In >= 16'h1000) && (In <= 16'hFFFF)) 
        case(Digit) // Assert AN0,AN1,AN2,AN3
                0 : Digit_0;
                1 : Digit_1;
                2 : Digit_2;
                3 : Digit_3;
          default : Digit_disable;       
        endcase         
    else if((In >= 20'h10000) && (In <= 20'hFFFFF))
        case(Digit) // Assert AN0,AN1,AN2,AN3,AN4
                0 : Digit_0;
                1 : Digit_1;
                2 : Digit_2;
                3 : Digit_3;
                4 : Digit_4;
          default : Digit_disable;      
        endcase         
    else if((In >= 24'h100000) && (In <= 24'hFFFFFF))
        case(Digit) // Assert AN0,AN1,AN2,AN3,AN4,AN5
                0 : Digit_0;
                1 : Digit_1;
                2 : Digit_2;
                3 : Digit_3;
                4 : Digit_4;
                5 : Digit_5;
          default : Digit_disable;      
        endcase  
   else if((In >= 28'h1000000) && (In <= 28'hFFFFFFF))
        case(Digit) // Assert AN0,AN1,AN2,AN3,AN4,AN5,AN6
                0 : Digit_0;
                1 : Digit_1;
                2 : Digit_2;
                3 : Digit_3;
                4 : Digit_4;
                5 : Digit_5;
                6 : Digit_6;
          default : Digit_disable;      
        endcase
   else if((In >= 32'h10000000) && (In <= 32'hFFFFFFFF)) 
        case(Digit) // Assert AN0,AN1,AN2,AN3,AN4,AN5,AN6,AN7 
                0 : Digit_0;
                1 : Digit_1;
                2 : Digit_2;
                3 : Digit_3;
                4 : Digit_4;
                5 : Digit_5;
                6 : Digit_6;
                7 : Digit_7;
        endcase    
   else // Disable All Anodes and Cathodes if In is NOT between 0 and FFFFFFFF
       Digit_disable;  
       
      
 task Digit_disable;
   begin  
     DP <= 1;
     Anodes   <= 8'b11111111; // Disble all 
     Cathodes <= 7'b1111111; // Disble all 
   end  
 endtask        
                     
 task Digit_0;
   begin
     DP <= 1;
     Anodes <= 8'b11111110;
     Decoder(In[3:0]);
   end  
 endtask  
          
 task Digit_1;
   begin
     DP <= 1;
     Anodes <= 8'b11111101;
     Decoder(In[7:4]);
   end  
 endtask     
          
 task Digit_2;
   begin          
     DP <= 1;
     Anodes <= 8'b11111011;
     Decoder(In[11:8]);
   end  
 endtask 
          
 task Digit_3;
   begin
    DP <= 1;
    Anodes <= 8'b11110111;
    Decoder(In[15:12]);
   end  
 endtask  
          
 task Digit_4;
   begin
     DP <= 1;
     Anodes <= 8'b11101111;
     Decoder(In[19:16]);
   end  
 endtask 
          
 task Digit_5;
   begin
     DP <= 1;
     Anodes <= 8'b11011111;
     Decoder(In[23:20]);
   end  
 endtask 
      
 task Digit_6;
   begin
     DP <= 1;
     Anodes <= 8'b10111111;
     Decoder(In[27:24]);
   end  
 endtask 
          
 task Digit_7;
   begin
     DP <= 1;
     Anodes <= 8'b01111111;
     Decoder(In[31:28]);
   end  
 endtask  
         
  
 // Enable Cathodes of a digit       
    task Decoder;
     input [3:0] BCH_Number;
      case(BCH_Number)  //Assign values to Cathodes, A as MSB and G as LSB
           0:  Cathodes <= 7'b0000001; // 0
           1:  Cathodes <= 7'b1001111; // 1
           2:  Cathodes <= 7'b0010010; // 2
           3:  Cathodes <= 7'b0000110; // 3
           4:  Cathodes <= 7'b1001100; // 4
           5:  Cathodes <= 7'b0100100; // 5
           6:  Cathodes <= 7'b0100000; // 6
           7:  Cathodes <= 7'b0001111; // 7
           8:  Cathodes <= 7'b0000000; // 8
           9:  Cathodes <= 7'b0000100; // 9
           10: Cathodes <= 7'b0001000; // A
           11: Cathodes <= 7'b1100000; // b
           12: Cathodes <= 7'b0110001; // C
           13: Cathodes <= 7'b1000010; // d
           14: Cathodes <= 7'b0110000; // E
           15: Cathodes <= 7'b0111000; // F
       endcase                 
     endtask   
   
 endmodule