module wrapping_decimal_timing_world (
    input CLK,
    input RESET,
    input ENABLE,
    output [7:0] HEX_TO_CELL,
    output [3:0] SEGMENT_SELECT
);

// Wires to join the daisy chained counters
wire bit17TriggOut;             // Trigger Output -> 4 bit counter 0
wire [5:0] counterOut;         // Counter Output -> Trigg Outputs
wire [16:0] decCount0;         // Counter 0
wire [1:0] decCount1;          // Counter 1
wire [3:0] decCount2;          // Counter 2
wire [3:0] decCount3;          // Counter 3 -> Multiplexer
wire [3:0] decCount4;          // Counter 4 -> Multiplexer
wire [3:0] decCount5;          // Counter 5 -> Multiplexer
wire [3:0] decCount6;          // Counter 6 -> Multiplexer

// 17 bit Counter
UGeneric_Counter #(.COUNTER_WIDTH(17),
                  .COUNTER_MAX(99999))
                  Bit17Counter (
                  .CLK(CLK),
                  .RESET(1'b0),
                  .ENABLE(1'b1),
                  .TRIG_OUT(bit17TriggOut),
                  .COUNT(decCount0)
                  );

// Counter 0: 2-Bit Counter 
UGeneric_Counter # (.COUNTER_WIDTH(2),
                   .COUNTER_MAX(3))
                   Bit2Counter (
                   .CLK(CLK),
                   .RESET(1'b0),
                   .ENABLE(bit17TriggOut),
                   .TRIG_OUT(counterOut[0]),
                   .COUNT(decCount1)
                   );

// Counter 1: 4-Bit Counter 
DGeneric_Counter # (.COUNTER_WIDTH(4),
                   .COUNTER_MIN(0))
                   Bit4Counter0 (
                   .CLK(CLK),
                   .RESET(RESET),
                   .ENABLE(ENABLE & bit17TriggOut),
                   .TRIG_OUT(counterOut[1]),
                   .COUNT(decCount2)
                   );
                  
// Counter 2: 4-Bit Counter 
DGeneric_Counter # (.COUNTER_WIDTH(4),
                   .COUNTER_MIN(0))
                   Bit_4_Counter2 (
                   .CLK(CLK),
                   .RESET(RESET),
                   .ENABLE(counterOut[1]),
                   .TRIG_OUT(counterOut[2]),
                   .COUNT(decCount3)
                   );

// Counter 3: 4-Bit Counter 
DGeneric_Counter # (.COUNTER_WIDTH(4),
                   .COUNTER_MIN(0))
                   Bit_4_Counter3 (
                   .CLK(CLK),
                   .RESET(RESET),
                   .ENABLE(counterOut[2]),
                   .TRIG_OUT(counterOut[3]),
                   .COUNT(decCount4)
                   );

// Counter 4: 4-Bit Counter 
DGeneric_Counter # (.COUNTER_WIDTH(4),
                   .COUNTER_MIN(0))
                   Bit_4_Counter4 (
                   .CLK(CLK),
                   .RESET(RESET),
                   .ENABLE(counterOut[3]),
                   .TRIG_OUT(counterOut[4]),
                   .COUNT(decCount5)
                   );
                
// Counter 5: 4-Bit Counter               
DGeneric_Counter # (.COUNTER_WIDTH(4),
                  .COUNTER_MIN(0))
                  Bit_4_Counter5 (
                  .CLK(CLK),
                  .RESET(RESET),
                  .ENABLE(counterOut[4]),
                  .TRIG_OUT(counterOut[5]),
                  .COUNT(decCount6)
                  );

// Wires to join the counters to multiplexer                  
wire [4:0] decCountAndDOT0;
wire [4:0] decCountAndDOT1;
wire [4:0] decCountAndDOT2;
wire [4:0] decCountAndDOT3;
wire [4:0] muxOut;

assign decCountAndDOT0 = {1'b1, decCount3};
assign decCountAndDOT1 = {1'b1, decCount4};
assign decCountAndDOT2 = {1'b0, decCount5};
assign decCountAndDOT3 = {1'b1, decCount6};

// Multiplexer to feed data into 7 segment display
Multiplexer Mux4 (
            .CONTROL(decCount1),
            .IN0(decCountAndDOT0),
            .IN1(decCountAndDOT1),
            .IN2(decCountAndDOT2),
            .IN3(decCountAndDOT3),
            .OUT(muxOut)
            );

// Multiplexer to 7 segment display
wire [7:0] hexOut;
wire [3:0] segmentSelectOut;

// Seven segment display connections
binary_to_hex_display Seg7 (
            .BINARY(muxOut[3:0]),
            .SEGMENT(decCount1),
            .DOT(muxOut[4]),
            .HEX_TO_CELL(hexOut),
            .SEGMENT_SELECT(segmentSelectOut)
            );
            
assign HEX_TO_CELL = hexOut;
assign SEGMENT_SELECT = segmentSelectOut;
endmodule