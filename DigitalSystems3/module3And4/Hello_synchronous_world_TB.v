`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer: Electronic and Electrical 3
// 
// Create Date: 29.09.2022 23:55:09
// Design Name: Module 3
// Module Name: Hello_synchronous_world_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Simulating a D flip-flop
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Hello_synchronous_world_TB(
    );
    //Defining interface for simulation module
    //Input
    reg CLK;
    reg IN;
    //Output - preceded by wire
    wire OUT;
    
    //Here we will instantiate the unit under test (uut)
    Hello_synchronous_world uut (
        .CLK(CLK),
        .IN(IN),
        .OUT(OUT)
    );
    
    //Here we will create clock signal
    initial begin
        CLK = 0;
        forever #100 CLK = ~CLK;
    end
    
    //Initialise input
    initial begin
        IN = 0;
        #100
        #50 IN = 1;
        #50 IN = 0;
        #200 IN = 1;
        #200 IN = 1;
        #20 IN = ~IN;
        #20 IN = ~IN;
        #20 IN = ~IN;
        #20 IN = ~IN;
        #20 IN = ~IN;
        #20 IN = ~IN;
        #20 IN = ~IN;
        #20 IN = ~IN;
        #20 IN = ~IN;
        #20 IN = ~IN;
    end
endmodule
