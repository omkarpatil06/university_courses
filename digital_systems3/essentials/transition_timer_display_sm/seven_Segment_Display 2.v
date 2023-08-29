`timescale 1ns/1ps

module seven_Segment_Display(
    input [3:0] BINARY,
    input [1:0] SEGMENT,
    input DOT,
    output [7:0] HEX_TO_CELL,
    output [3:0] SEGMENT_SELECT
);

    // Wires for all 7 LEDs of a segment
    wire A, B, C, D, E, F;
    
    // Assigning input to boolean variables
    assign B = BINARY[0];
    assign A = BINARY[1];
    assign D = BINARY[2];
    assign C = BINARY[3];
    assign E = SEGMENT[0];
    assign F = SEGMENT[1];
    
    // Assigning boolean function to output
    assign HEX_TO_CELL[0] = ((~A)&B&(~C)&(~D))|((~A)&(~B)&(~C)&D)|((~A)&B&C&D)|(A&B&C&(~D));
    assign HEX_TO_CELL[1] = ((~A)&B&(~C)&D)|((~B)&C&D)|(A&B&C)|(A&(~B)&D);
    assign HEX_TO_CELL[2] = (A&(~B)&(~C)&(~D))|((~B)&C&D)|(A&C&D);
    assign HEX_TO_CELL[3] = ((~A)&B&(~D))|((~A)&(~B)&(~C)&D)|(A&B&D)|(A&(~B)&C&(~D));
    assign HEX_TO_CELL[4] = (B&(~C))|((~A)&B&(~D))|((~A)&(~C)&D);
    assign HEX_TO_CELL[5] = (B&(~C)&(~D))|(A&(~C)&(~D))|(A&B&(~C))|((~A)&B&C&D);
    assign HEX_TO_CELL[6] = ((~A)&(~C)&(~D))|(A&B&(~C)&D)|((~A)&(~B)&C&D);
    assign HEX_TO_CELL[7] = DOT;
    
    // Assigning boolean function to select segment for each output at refresh rate
    assign SEGMENT_SELECT[0] = E|F;
    assign SEGMENT_SELECT[1] = E|(~F);
    assign SEGMENT_SELECT[2] = (~E)|F;
    assign SEGMENT_SELECT[3] = (~E)|(~F);
endmodule