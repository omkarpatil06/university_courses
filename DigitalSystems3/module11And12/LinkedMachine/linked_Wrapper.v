`timescale 1ns/1ps

module linked_Wrapper(
    input CLK,
    input RESET,
    input BTN_LEFT,
    input BTN_CENTRE,
    input BTN_RIGHT,
    output [7:0] HEX_TO_CELL,
    output [3:0] SEGMENT_SELECT,
    output [11:0] COLOUR_OUT,
    output SYNC_H,
    output SYNC_V
);

    wire [1:0] master_Control;
    wire [3:0] state_Out1;
    wire [3:0] state_Out2;

    master_State_Machine(
        .CLK(CLK),
        .RESET(RESET),
        .BTN_LEFT(BTN_LEFT),
        .BTN_CENTRE(BTN_CENTRE),
        .BTN_RIGHT(BTN_RIGHT),
        .STATE_OUT1(state_Out1),
        .STATE_OUT2(state_Out2),
        .MASTER_CONTROL(master_Control)
    );

    maze_SM_Wrapper (
        .CLK(CLK),
        .RESET(RESET),
        .BTN_LEFT(BTN_LEFT),
        .BTN_CENTRE(BTN_CENTRE),
        .BTN_RIGHT(BTN_RIGHT),
        .MASTER_CONTROL(master_Control),
        .STATE_OUT(state_Out1)
        .HEX_TO_CELL(HEX_TO_CELL),
        .SEGMENT_SELECT(SEGMENT_SELECT)
    );

    vga_Interface_Wrapper(
        .CLK(CLK),
        .MASTER_CONTROL(master_Control),
        .COLOUR_OUT(COLOUR_OUT),
        .SYNC_H(SYNC_H),
        .SYNC_V(SYNC_V)
    );

    led_State_Machine(
        .CLK(CLK),
        .RESET(RESET),
        .MASTER_CONTROL(master_Control),
        .LED_OUT(LED_OUT),
        .STATE_OUT(state_Out2)
    );
endmodule