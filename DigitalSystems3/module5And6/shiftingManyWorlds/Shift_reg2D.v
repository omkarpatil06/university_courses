`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2022 23:15:48
// Design Name: 
// Module Name: Shift_reg2D
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


module Shift_reg2D(
    input CLK,
    input [3:0] IN,
    output [3:0] OUT_0,
    output [3:0] OUT_1,
    output [3:0] OUT_2,
    output [3:0] OUT_3,
    output [3:0] OUT_4,
    output [3:0] OUT_5,
    output [3:0] OUT_6,
    output [3:0] OUT_7,
    output [3:0] OUT_8,
    output [3:0] OUT_9,
    output [3:0] OUT_10,
    output [3:0] OUT_11,
    output [3:0] OUT_12,
    output [3:0] OUT_13,
    output [3:0] OUT_14,
    output [3:0] OUT_15
    );
    
    reg [3:0] DTypes [15:0];
    
    always@(posedge CLK) begin
        DTypes[15] <= DTypes[14];
        DTypes[14] <= DTypes[13];
        DTypes[13] <= DTypes[12];
        DTypes[12] <= DTypes[11];
        DTypes[11] <= DTypes[10];
        DTypes[10] <= DTypes[9];
        DTypes[9] <= DTypes[8];
        DTypes[8] <= DTypes[7];
        DTypes[7] <= DTypes[6];
        DTypes[6] <= DTypes[5];
        DTypes[5] <= DTypes[4];
        DTypes[4] <= DTypes[3];
        DTypes[3] <= DTypes[2];
        DTypes[2] <= DTypes[1];
        DTypes[1] <= DTypes[0];
        DTypes[0] <= IN;
    end
    
    assign OUT_0 = DTypes[0];
    assign OUT_1 = DTypes[1];
    assign OUT_2 = DTypes[2];
    assign OUT_3 = DTypes[3];
    assign OUT_4 = DTypes[4];
    assign OUT_5 = DTypes[5];
    assign OUT_6 = DTypes[6];
    assign OUT_7 = DTypes[7];
    assign OUT_8 = DTypes[8];
    assign OUT_9 = DTypes[9];
    assign OUT_10 = DTypes[10];
    assign OUT_11 = DTypes[11];
    assign OUT_12 = DTypes[12];
    assign OUT_13 = DTypes[13];
    assign OUT_14 = DTypes[14];
    assign OUT_15 = DTypes[15];
endmodule
