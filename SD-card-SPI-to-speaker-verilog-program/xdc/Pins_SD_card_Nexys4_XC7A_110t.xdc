# Onboard crystal oscillator
set_property PACKAGE_PIN E3 [get_ports Clock_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports Clock_100MHz]


# Slide switches
 set_property PACKAGE_PIN U9 [get_ports Clear_n]
 set_property IOSTANDARD LVCMOS33 [get_ports Clear_n]

 set_property PACKAGE_PIN P4 [get_ports Response_MSB]
 set_property IOSTANDARD LVCMOS33 [get_ports Response_MSB]
 
 set_property PACKAGE_PIN U8 [get_ports CMD_resp_sel[0]]
 set_property IOSTANDARD LVCMOS33 [get_ports CMD_resp_sel[0]]
 
 set_property PACKAGE_PIN R7 [get_ports CMD_resp_sel[1]]
 set_property IOSTANDARD LVCMOS33 [get_ports CMD_resp_sel[1]]
  
 set_property PACKAGE_PIN R6 [get_ports CMD_resp_sel[2]]
 set_property IOSTANDARD LVCMOS33 [get_ports CMD_resp_sel[2]]


# LED
 set_property PACKAGE_PIN P2 [get_ports CARD_DETECT_out]
 set_property IOSTANDARD LVCMOS33 [get_ports CARD_DETECT_out]
 
 set_property PACKAGE_PIN T8 [get_ports CMD0_Pass]
 set_property IOSTANDARD LVCMOS33 [get_ports CMD0_Pass]

 set_property PACKAGE_PIN V9 [get_ports CMD8_Pass]
 set_property IOSTANDARD LVCMOS33 [get_ports CMD8_Pass]

 set_property PACKAGE_PIN T6 [get_ports CMD55_Pass]
 set_property IOSTANDARD LVCMOS33 [get_ports CMD55_Pass]

 set_property PACKAGE_PIN T5 [get_ports ACMD41_Pass]
 set_property IOSTANDARD LVCMOS33 [get_ports ACMD41_Pass]

 set_property PACKAGE_PIN T4 [get_ports CMD58_Pass]
 set_property IOSTANDARD LVCMOS33 [get_ports CMD58_Pass]

 set_property PACKAGE_PIN U7 [get_ports CMD18_Pass]
 set_property IOSTANDARD LVCMOS33 [get_ports CMD18_Pass]


# SD card
set_property PACKAGE_PIN A1 [get_ports CARD_DETECT]
set_property IOSTANDARD LVCMOS33 [get_ports CARD_DETECT]

set_property PACKAGE_PIN E2 [get_ports SD_RESET]
set_property IOSTANDARD LVCMOS33 [get_ports SD_RESET]

set_property PACKAGE_PIN D2 [get_ports DAT3]
set_property IOSTANDARD LVCMOS33 [get_ports DAT3]

set_property PACKAGE_PIN C1 [get_ports CMD]
set_property IOSTANDARD LVCMOS33 [get_ports CMD]

set_property PACKAGE_PIN C2 [get_ports DAT0]
set_property IOSTANDARD LVCMOS33 [get_ports DAT0]

set_property PACKAGE_PIN B1 [get_ports CLK]
set_property IOSTANDARD LVCMOS33 [get_ports CLK]


# Speaker
 set_property PACKAGE_PIN A11 [get_ports AUD_PWM]
 set_property IOSTANDARD LVCMOS33 [get_ports AUD_PWM]

 set_property PACKAGE_PIN D12 [get_ports AUD_SD]
 set_property IOSTANDARD LVCMOS33 [get_ports AUD_SD]


# 7-Segment LED
set_property PACKAGE_PIN N6 [get_ports AN0]
set_property IOSTANDARD LVCMOS33 [get_ports AN0]

set_property PACKAGE_PIN M6 [get_ports AN1]
set_property IOSTANDARD LVCMOS33 [get_ports AN1]

set_property PACKAGE_PIN M3 [get_ports AN2]
set_property IOSTANDARD LVCMOS33 [get_ports AN2]

set_property PACKAGE_PIN N5 [get_ports AN3]
set_property IOSTANDARD LVCMOS33 [get_ports AN3]

set_property PACKAGE_PIN N2 [get_ports AN4]
set_property IOSTANDARD LVCMOS33 [get_ports AN4]

set_property PACKAGE_PIN N4 [get_ports AN5]
set_property IOSTANDARD LVCMOS33 [get_ports AN5]

set_property PACKAGE_PIN L1 [get_ports AN6]
set_property IOSTANDARD LVCMOS33 [get_ports AN6]

set_property PACKAGE_PIN M1 [get_ports AN7]
set_property IOSTANDARD LVCMOS33 [get_ports AN7]

set_property PACKAGE_PIN L3 [get_ports CA]
set_property IOSTANDARD LVCMOS33 [get_ports CA]

set_property PACKAGE_PIN N1 [get_ports CB]
set_property IOSTANDARD LVCMOS33 [get_ports CB]

set_property PACKAGE_PIN L5 [get_ports CC]
set_property IOSTANDARD LVCMOS33 [get_ports CC]

set_property PACKAGE_PIN L4 [get_ports CD]
set_property IOSTANDARD LVCMOS33 [get_ports CD]

set_property PACKAGE_PIN K3 [get_ports CE]
set_property IOSTANDARD LVCMOS33 [get_ports CE]

set_property PACKAGE_PIN M2 [get_ports CF]
set_property IOSTANDARD LVCMOS33 [get_ports CF]

set_property PACKAGE_PIN L6 [get_ports CG]
set_property IOSTANDARD LVCMOS33 [get_ports CG]

set_property PACKAGE_PIN M4 [get_ports DP]
set_property IOSTANDARD LVCMOS33 [get_ports DP]
