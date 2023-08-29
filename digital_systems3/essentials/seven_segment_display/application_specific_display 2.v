`timescale 1ns / 1ps

module application_specific_display(
    input [3:0] BINARY,
    output [7:0] HEX_TO_CELL,
    output [3:0] SEGMENT_SELECT
    );
    
    reg SEGMENT = 2'b00;
    reg DOT = 1'b1;
    wire [7:0] HEX_OUT;
    wire [3:0] SEG_OUT;
    
    binary_to_hex_display (
        .BINARY(BINARY),
        .SEGMENT(SEGMENT),
        .DOT(DOT),
        .HEX_TO_CELL(HEX_OUT),
        .SEGMENT_SELECT(SEG_OUT)
        );
    
    assign HEX_TO_CELL = HEX_OUT;
    assign SEGMENT_SELECT = SEG_OUT;
endmodule
