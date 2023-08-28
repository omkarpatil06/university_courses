`timescale 1ns / 1ps

module VGA_Interface_Wrapper(
    input CLK,
    input [11:0] COLOUR_IN,
    output [11:0] COLOUR_OUT,
    output SYNC_H,
    output SYNC_V
    );
    
    //Specifying all wires and regs
    wire [9:0] X;
    wire [8:0] Y;
    wire [11:0] Colour;
    
    VGA_Interface VGA (
        .CLK(CLK),
        .COLOUR_IN(Colour),
        .COLOUR_OUT(COLOUR_OUT),
        .ADDRESS_H(X),
        .ADDRESS_V(Y),
        .SYNC_H(SYNC_H),
        .SYNC_V(SYNC_V)
        ); 
    
    Colour_Logic CL (
        .CLK(CLK),
        .ADDRESS_H(X),
        .ADDRESS_V(Y),
        .COLOUR_OUT(Colour)
        );
endmodule