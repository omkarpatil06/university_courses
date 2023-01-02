`timescale 1ns/1ps

module maze_SM_Wrapper (
    input CLK,
    input RESET,
    input BTN_LEFT,
    input BTN_CENTRE,
    input BTN_RIGHT,
    input [1:0] MASTER_CONTROL,
    output [1:0] STATE_OUT,
    output [7:0] HEX_TO_CELL,
    output [3:0] SEGMENT_SELECT
);
    
    // Wiring both modules
    wire [2:0] state_Out;

    // First module in wrapper
    basic_State_Machine(
        .CLK(CLK),
        .RESET(RESET),
        .BTN_LEFT(BTN_LEFT),
        .BTN_CENTRE(BTN_CENTRE),
        .BTN_RIGHT(BTN_RIGHT),
        .MASTER_CONTROL(MASTER_CONTROL),
        .STATE_OUT(state_Out)
    );

    // Second module in wrapper
    seven_Segment_Display(
        .BINARY(state_Out),
        .SEGMENT(2'd0),
        .DOT(1'd1),
        .HEX_TO_CELL(HEX_TO_CELL),
        .SEGMENT_SELECT(SEGMENT_SELECT)
    );

    assign STATE_OUT = state_Out;
endmodule