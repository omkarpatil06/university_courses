`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2022 09:33:22
// Design Name: 
// Module Name: Shift_register_TB
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


module Shift_register_TB(
    );
        //Defining interface for simulation module
    //Input
    reg CLK;
    reg IN;
    //Output - preceded by wire
    wire [15:0] OUT;
    
    //Here we will instantiate the unit under test (uut)
    Shift_register uut (
        .CLK(CLK),
        .IN(IN),
        .OUT(OUT)
    );
    
    //Here we will create clock signal
    initial begin
        CLK = 0;
        forever #50 CLK = ~CLK;
    end
    
    //Initialise input
    initial begin
        IN = 0;
        #100
        #100 IN = 1;
    end
endmodule
