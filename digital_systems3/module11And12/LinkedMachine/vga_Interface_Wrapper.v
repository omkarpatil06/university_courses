`timescale 1ns / 1ps

module vga_Interface_Wrapper(
    input CLK,
    input [1:0] MASTER_CONTROL,
    output [11:0] COLOUR_OUT,
    output SYNC_H,
    output SYNC_V
    );
    
    //Specifying all wires and regs
    wire [9:0] X;
    wire [8:0] Y;
    wire [11:0] Colour;
    
    vga_Interface (
        .CLK(CLK),
        .COLOUR_IN(Colour),
        .COLOUR_OUT(COLOUR_OUT),
        .ADDRESS_H(X),
        .ADDRESS_V(Y),
        .SYNC_H(SYNC_H),
        .SYNC_V(SYNC_V)
        ); 
    
    vga_State_Machine (
        .CLK(CLK),
        .ADDRESS_X(X),
        .ADDRESS_Y(Y),
        .MASTER_CONTROL(MASTER_CONTROL)
        .COLOUR_IN(Colour)
        );
endmodule