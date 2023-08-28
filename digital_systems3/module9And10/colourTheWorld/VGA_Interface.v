`timescale 1ns / 1ps

module VGA_Interface(
        input CLK,
        input [11:0] COLOUR_IN,
        output reg [11:0] COLOUR_OUT,                 // FPGA internal 150MHz Clock
        output reg [9:0] ADDRESS_H,
        output reg [8:0] ADDRESS_V,
        output reg SYNC_H,                  // Sync horizontal data
        output reg SYNC_V                   // Sync vertical data
        );
        
        // Time is Front Horizontal Lines
        parameter HorzTimeToPulseWidthEnd = 10'd96;
        parameter HorzTimeToBackPorchEnd = 10'd144;
        parameter HorzTimeToDisplayTimeEnd = 10'd784;
        parameter HorzTimeToFrontPorchEnd = 10'd800;
        
        // Time is Vertical Lines
        parameter VertTimeToPulseWidthEnd = 10'd2;
        parameter VertTimeToBackPorchEnd = 10'd31;
        parameter VertTimeToDisplayTimeEnd = 10'd511;
        parameter VertTimeToFrontPorchEnd = 10'd521;
        
        //Wires and register required
        wire trigg25MHerz;
        wire triggHorz;
        wire triggVert;
        wire [1:0] counter25Herz;
        wire [9:0] counterHorz;
        wire [8:0] counterVert;
        
        // Generating a 25MHz Counter
        UGeneric_Counter #(.COUNTER_WIDTH(2),
                          .COUNTER_MAX(3))
                          Counter25MHerz (
                          .CLK(CLK),
                          .RESET(1'b0),
                          .ENABLE(1'b1),
                          .TRIG_OUT(trigg25MHerz),
                          .COUNT(counter25Herz)
                          );
        
        // Generating a horizontal line counter
        UGeneric_Counter #(.COUNTER_WIDTH(10),
                          .COUNTER_MAX(HorzTimeToFrontPorchEnd))    //Counts upto 800
                          CounterHorz (
                          .CLK(CLK),
                          .RESET(1'b0),
                          .ENABLE(trigg25MHerz),
                          .TRIG_OUT(triggHorz),
                          .COUNT(counterHorz)
                          );
                          
        // Generating a vetical line counter
        UGeneric_Counter #(.COUNTER_WIDTH(9),
                          .COUNTER_MAX(VertTimeToFrontPorchEnd))    //Counts upto 520
                           CounterVert (
                          .CLK(CLK),
                          .RESET(1'b0),
                          .ENABLE(triggHorz),
                          .TRIG_OUT(triggVert),
                          .COUNT(counterVert)
                          );
        
        // Logic to set VS and HS low and high
        always@(posedge trigg25MHerz) begin
            if(counterHorz < HorzTimeToPulseWidthEnd)
                SYNC_H <= 0;
            else
                SYNC_H <= 1;
        end
        
        always@(posedge trigg25MHerz) begin
            if(counterVert < VertTimeToPulseWidthEnd)
                SYNC_V <= 0;
            else 
                SYNC_V <= 1;
        end
        
        // Setting colour of the display to the COLOUR_LOGIC value when electron beam on the display size.
        always@(posedge trigg25MHerz) begin
            if((HorzTimeToBackPorchEnd < counterHorz) & (counterHorz <= HorzTimeToDisplayTimeEnd)) begin
                if((VertTimeToBackPorchEnd < counterVert) & (counterVert <= VertTimeToDisplayTimeEnd))
                    COLOUR_OUT <= COLOUR_IN;
                else
                    COLOUR_OUT <= 0;
            end
            else
                COLOUR_OUT <= 0;
        end
        
        // Identifying the electron beam pixel location as it moves across the display.
        always@(posedge trigg25MHerz) begin
            if((HorzTimeToBackPorchEnd < counterHorz) & (counterHorz <= HorzTimeToDisplayTimeEnd)) begin
                ADDRESS_H <= counterHorz - HorzTimeToBackPorchEnd;
                if((VertTimeToBackPorchEnd < counterVert) & (counterVert <= VertTimeToDisplayTimeEnd))
                    ADDRESS_V <= counterVert - VertTimeToBackPorchEnd;
                else
                    ADDRESS_V <= 0;
             end
             else
                ADDRESS_H <= 0;
        end
endmodule