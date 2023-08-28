`timescale 1ns / 1ps

// This module ties all the neccesary counters together in this project.

module DownCounter_Wrapper (
    input CLK,
    input RESET,
    input ENABLE,
    output [7:0] HEX_TO_CELL,
    output [3:0] SEGMENT_SELECT
    );

    // Wires to join the daisy chained counters
    wire bit17TriggOut;            // Trigger Output -> 4 bit counter 0
    wire [5:0] triggOut;         // Counter Output -> Trigg Outputs
    wire [16:0] decCounter0;         // Counter 0
    wire [1:0] decCounter1;          // Counter 1
    wire [3:0] decCounter2;          // Counter 2
    wire [3:0] decCounter3;          // Counter 3 -> Multiplexer
    wire [3:0] decCounter4;          // Counter 4 -> Multiplexer
    wire [3:0] decCounter5;          // Counter 5 -> Multiplexer
    wire [3:0] decCounter6;          // Counter 6 -> Multiplexer

    // 17 bit Counter
    UGeneric_Counter #(.COUNTER_WIDTH(17),
                    .COUNTER_MAX(99999))
                    Bit17Counter (
                    .CLK(CLK),
                    .RESET(1'b0),
                    .ENABLE(1'b1),
                    .TRIG_OUT(bit17TriggOut),
                    .COUNT(decCounter0)
                    );

    // Counter 0: 2-Bit Counter 
    UGeneric_Counter # (.COUNTER_WIDTH(2),
                    .COUNTER_MAX(3))
                    Bit2Counter (
                    .CLK(CLK),
                    .RESET(1'b0),
                    .ENABLE(bit17TriggOut),
                    .TRIG_OUT(triggOut[0]),
                    .COUNT(decCounter1)
                    );

    // Counter 1: 4-Bit Counter 
    DGeneric_Counter # (.COUNTER_WIDTH(4),
                    .COUNTER_MIN(0))
                    Bit4Counter0 (
                    .CLK(CLK),
                    .RESET(RESET),
                    .ENABLE(ENABLE & bit17TriggOut),
                    .TRIG_OUT(triggOut[1]),
                    .COUNT(decCounter2)
                    );
                    
    // Counter 2: 4-Bit Counter 
    DGeneric_Counter # (.COUNTER_WIDTH(4),
                    .COUNTER_MIN(0))
                    Bit4Counter1 (
                    .CLK(CLK),
                    .RESET(RESET),
                    .ENABLE(triggOut[1]),
                    .TRIG_OUT(triggOut[2]),
                    .COUNT(decCounter3)
                    );

    // Counter 3: 4-Bit Counter 
    DGeneric_Counter # (.COUNTER_WIDTH(4),
                    .COUNTER_MIN(0))
                    Bit4Counter2 (
                    .CLK(CLK),
                    .RESET(RESET),
                    .ENABLE(triggOut[2]),
                    .TRIG_OUT(triggOut[3]),
                    .COUNT(decCounter4)
                    );

    // Counter 4: 4-Bit Counter 
    DGeneric_Counter # (.COUNTER_WIDTH(4),
                    .COUNTER_MIN(0))
                    Bit4Counter3 (
                    .CLK(CLK),
                    .RESET(RESET),
                    .ENABLE(triggOut[3]),
                    .TRIG_OUT(triggOut[4]),
                    .COUNT(decCounter5)
                    );
                    
    // Counter 5: 4-Bit Counter               
    DGeneric_Counter # (.COUNTER_WIDTH(4),
                    .COUNTER_MIN(0))
                    Bit4Counter4 (
                    .CLK(CLK),
                    .RESET(RESET),
                    .ENABLE(triggOut[4]),
                    .TRIG_OUT(triggOut[5]),
                    .COUNT(decCounter6)
                    );

    // Wires to join the counters to multiplexer                  
    wire [4:0] decCounterAndDOT0;
    wire [4:0] decCounterAndDOT1;
    wire [4:0] decCounterAndDOT2;
    wire [4:0] decCounterAndDOT3;
    wire [4:0] muxOut;

    assign decCounterAndDOT0 = {1'b1, decCounter3};
    assign decCounterAndDOT1 = {1'b1, decCounter4};
    assign decCounterAndDOT2 = {1'b0, decCounter5};         // Decimal is set ON for the 3rd 7 Seg display from right.
    assign decCounterAndDOT3 = {1'b1, decCounter6};

    // Multiplexer to feed data into 7 segment display
    Multiplexer_4way Mux4 (
                .CONTROL(decCounter1),
                .IN0(decCounterAndDOT0),
                .IN1(decCounterAndDOT1),
                .IN2(decCounterAndDOT2),
                .IN3(decCounterAndDOT3),
                .OUT(muxOut)
                );

    // Multiplexer to 7 segment display
    wire [7:0] hexOut;
    wire [3:0] segmentSelectOut;

    // Seven segment display connections
    binary_to_hex_display Seg7 (
                .BINARY(muxOut[3:0]),
                .SEGMENT(decCounter1),
                .DOT(muxOut[4]),
                .HEX_TO_CELL(hexOut),
                .SEGMENT_SELECT(segmentSelectOut)
                );

    // Wiring Outputs to neccessary signals.
    assign HEX_TO_CELL = hexOut;
    assign SEGMENT_SELECT = segmentSelectOut;
endmodule