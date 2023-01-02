`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2022 23:48:06
// Design Name: 
// Module Name: Counting_the_world
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


module Counting_the_world(
    input pushButton,
    input slideSwitch,
    output [15:0] LEDS
    );
    
    reg [15:0] Value = 0;
    
    always@(posedge pushButton) begin
        if(slideSwitch)
            Value <= Value + 1;
        else
            Value <= Value - 1;
    end
    
    assign LEDS = Value;
endmodule
