`timescale 1ns / 1ps

// This module aims to create a D flip-flop.
module hello_synchronous_world(
    input CLK,
    input IN,
    output reg OUT
    );
    
    // Creating a synthesis list which starts after begin and terminates at end.
    always@(posedge CLK) begin
        OUT <= IN;
    end
endmodule
