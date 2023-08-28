`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.10.2022 01:21:09
// Design Name: 
// Module Name: Timing_the_world
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


module Timing_the_world(
    input CLK,
    input RESET,
    input CTR_ENABLE,
    input CTR_CNTRL,
    output [7:0] LEDS
    );
    
    reg [26:0] Bit27Counter;
    reg [7:0] Value;
    
    always@(posedge CLK) begin
        if(RESET)
            Bit27Counter <= 0;
        else begin
            if(CTR_ENABLE) begin
                if(CTR_CNTRL) begin
                    if(Bit27Counter == 100000000)
                        Bit27Counter <= 0;
                    else
                        Bit27Counter = Bit27Counter + 1;
                end
                else begin
                    if(Bit27Counter == 0)
                        Bit27Counter <= 100000000;
                    else
                        Bit27Counter = Bit27Counter - 1;
                end
            end
        end
    end
    
    always@(posedge CLK) begin
        if(RESET)
            Value <= 0;
        else begin
            if(CTR_CNTRL) begin
                if(Bit27Counter == 0)
                    Value = Value + 1;
            end
            else begin
                if(Bit27Counter == 0)
                    Value = Value - 1;
            end
        end
    end
    
    assign LEDS = Value;
endmodule
