`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2022 23:54:08
// Design Name: 
// Module Name: Counting_the_world_TB
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


module Counting_the_world_TB(
    );
    reg pushButton;
    reg slideSwitch;
    
    wire [15:0] LEDS;
    
    Counting_the_world uut(
        .pushButton(pushButton),
        .slideSwitch(slideSwitch),
        .LEDS(LEDS)
     );
     
     initial begin
        pushButton = 0;
        forever #10 pushButton = ~pushButton;
     end
     
     initial begin
        slideSwitch = 0;
        #100;
        #100 slideSwitch = 1;
        #100 slideSwitch = 0;
     end
    
endmodule
