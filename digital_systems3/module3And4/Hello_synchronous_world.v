`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer: Electronic and Electrical 3
// 
// Create Date: 29.09.2022 23:41:33
// Design Name: Module 3
// Module Name: Hello_synchronous_world
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Creating a D flip-flop
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// This module aims to create a D flip-flop.
module Hello_synchronous_world(
    input CLK,
    input IN,
    output reg OUT
    );
    
    // Creating a synthesis list which starts after begin and terminates at end.
    always@(posedge CLK) begin
        OUT <= IN;
    end
    
endmodule
