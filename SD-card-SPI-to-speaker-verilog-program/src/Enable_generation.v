`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  RUAS
// Engineer: Dileep Nethrapalli
// 
// Create Date: 08/06/2020 11:21:25 AM
// Design Name: 
// Module Name: Enable_generation
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


module Enable_generation(
         output reg CS, Data_Out, CLK,
         output reg Init_Data_In, CMD18_Data_In,       
         input Data_In, Init_pass,         
         input Init_CS,  Init_Data_Out,  Init_CLK,       
         input CMD18_CS, CMD18_Data_Out, CMD18_CLK,
         input Clock_100MHz, Clear_n
       );
       
      
  always@(posedge Clock_100MHz, negedge Clear_n)
    if(!Clear_n) 
      begin 
        CS <= 1; Data_Out <= 1; CLK <= 0;
        Init_Data_In <= 1; CMD18_Data_In <= 1; 
      end  
    else if(Init_pass) // CMD18 module signals
      begin
        CS <= CMD18_CS; Data_Out <= CMD18_Data_Out; CLK <= CMD18_CLK; 
        CMD18_Data_In <= Data_In; Init_Data_In <= 1; 
      end
    else // CMD0_CMD8_CMD55_ACMD41_CMD58 module signals
      begin
        CS <= Init_CS; Data_Out <= Init_Data_Out; CLK <= Init_CLK; 
        Init_Data_In <= Data_In; CMD18_Data_In <= 1;
      end 
      
endmodule
