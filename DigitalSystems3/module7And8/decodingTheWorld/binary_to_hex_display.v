`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2022 14:34:05
// Design Name: 
// Module Name: binary_to_hex_display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module binary_to_hex_display(
    input [3:0] BINARY,
    input [1:0] SEGMENT,
    input DOT,
    output [7:0] HEX_TO_CELL,
    input [3:0] SEGMENT_SELECT
    );
    
    wire A, B, C, D, E, F;
    
    assign B = BINARY[0];
    assign A = BINARY[1];
    assign D = BINARY[2];
    assign C = BINARY[3];
    assign E = SEGMENT[0];
    assign F = SEGMENT[1];
    
    assign HEX_TO_CELL[0] = ((~A)&B&(~C)&(~D))|((~A)&(~B)&(~C)&D)|((~A)&B&C&D)|(A&B&C&(~D));
    assign HEX_TO_CELL[1] = ((~A)&B&(~C)&D)|((~B)&C&D)|(A&B&C)|(A&(~B)&D);
    assign HEX_TO_CELL[2] = (A&(~B)&(~C)&(~D))|((~B)&C&D)|(A&C&D);
    assign HEX_TO_CELL[3] = ((~A)&B&(~D))|((~A)&(~B)&(~C)&D)|(A&B&D)|(A&(~B)&C&(~D));
    assign HEX_TO_CELL[4] = (B&(~C))|((~A)&B&(~D))|((~A)&(~C)&D);
    assign HEX_TO_CELL[5] = (B&(~C)&(~D))|(A&(~C)&(~D))|(A&B&(~C))|((~A)&B&C&D);
    assign HEX_TO_CELL[6] = ((~A)&(~C)&(~D))|(A&B&(~C)&D)|((~A)&(~B)&C&D);
    assign HEX_TO_CELL[7] = DOT;
    
    assign SEGMENT_SELECT[0] = E|F;
    assign SEGMENT_SELECT[1] = E|(~F);
    assign SEGMENT_SELECT[2] = (~E)|F;
    assign SEGMENT_SELECT[3] = (~E)|(~F);
endmodule
