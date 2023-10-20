`timescale 1ns / 1ps

module Colour_Logic (
        input CLK,
        input [9:0] ADDRESS_H,
        input [8:0] ADDRESS_V,
        output reg [11:0] COLOUR_OUT
        );
    
        // Specifying all necessary wires and reg.
        wire trigg25MHerz;
        wire trigg10Herz;
        wire triggColourP;
        wire triggImageMX;
        wire triggImageMY;
        wire [1:0] counterCase;
        wire [23:0] counterTimer;
        wire [11:0] infoColour;
        wire [8:0] pixelTimerY;
        wire [9:0] pixelTimerX;
    
        // A 25MHerz Counter. Required for syncing the modules for wrapper.
        UGeneric_Counter #(.COUNTER_WIDTH(2),
            .COUNTER_MAX(3))
            Counter25MHerz (
            .CLK(CLK),
            .RESET(1'b0),
            .ENABLE(1'b1),
            .TRIG_OUT(trigg25MHerz)
            );

        // A counter to keep track of time. Can be set 1, 0.1, 0.01 or any such number of seconds.           
        UGeneric_Counter #(.COUNTER_WIDTH(24),
            .COUNTER_MAX(10000000))
            TriggTimer (
            .CLK(CLK),
            .RESET(1'b0),
            .ENABLE(1'b1),
            .TRIG_OUT(trigg10Herz),
            .COUNT(counterTimer)
            );
        
        // A counter required for varying colour. 0 to 4095 in decimal cover all digits of a 12 bit binary number.
        UGeneric_Counter #(.COUNTER_WIDTH(12),
            .COUNTER_MAX(4095))
            ColourPicker (
            .CLK(CLK),
            .RESET(1'b0),
            .ENABLE(trigg10Herz),
            .TRIG_OUT(triggColourP),
            .COUNT(infoColour)
            ); 
        
        /* Displaying inversion boxes at edges.
        always@(posedge trigg25MHerz) begin
            if(((0 <= ADDRESS_H) & (ADDRESS_H <= 9)) | ((631 <= ADDRESS_H) & (ADDRESS_H <= 640))) begin
                if(((0 <= ADDRESS_V) & (ADDRESS_V <= 9)) | ((471 <= ADDRESS_V) & (ADDRESS_V <= 480)))
                    COLOUR_OUT <= ~infoColour;
                else
                    COLOUR_OUT <= infoColour;
            end
            else
                COLOUR_OUT <= infoColour;
        end 
        */
    
        
        /* Displaying my the first letter of my name.
        // Setting boundary parameters.
            parameter startInitialX = 10'd220;
            parameter endInitialX = 10'd420;
            parameter startInitialY = 10'd90;
            parameter endInitialY = 10'd390;

        // Conditions for the boundary of the letter O.
        always@(posedge CLK) begin
            if(((startInitialX  <= ADDRESS_H) & (ADDRESS_H <= endInitialX)) & ((startInitialY <= ADDRESS_V) & (ADDRESS_V <= startInitialY + 40)))
                COLOUR_OUT <= infoColour;
            else if(((startInitialX  <= ADDRESS_H) & (ADDRESS_H <= startInitialX + 40)) & ((startInitialY + 40 <= ADDRESS_V) & (ADDRESS_V <= endInitialY - 40)) | ((endInitialX - 40 <= ADDRESS_H) & (ADDRESS_H <= endInitialX)) & ((startInitialY + 40 <= ADDRESS_V) & (ADDRESS_V <= endInitialY - 40)))
                COLOUR_OUT <= infoColour;
            else if(((startInitialX  <= ADDRESS_H) & (ADDRESS_H <= endInitialX)) & ((endInitialY - 40 <= ADDRESS_V) & (ADDRESS_V <= endInitialY)))
                COLOUR_OUT <= infoColour;
            else
                COLOUR_OUT = ~infoColour;
        end 
        */
        
        // A counter to record the movement of an image on screen.
        reg resetf = 0;

        always@(posedge CLK) begin
            if (resetf == 0) begin
                if(pixelTimerY > 0 & triggImageMY == 0)
                    resetf == 0;
                else
                    resetf == 1;
            end
            else begin
                if(pixelTimerX > 0 & triggImageMX == 0)
                    resetf == 1;
                else
                    resetf == 0;
            end
        end

        UGeneric_Counter #(.COUNTER_WIDTH(9),
            .COUNTER_MAX(460))
            ImageMover1 (
            .CLK(CLK),
            .RESET(resetf),
            .ENABLE(trigg10Herz),
            .TRIG_OUT(triggImageMY),
            .COUNT(pixelTimerY)
            );
        
        UGeneric_Counter #(.COUNTER_WIDTH(9),
            .COUNTER_MAX(620))
            ImageMover2 (
            .CLK(CLK),
            .RESET(~resetf),
            .ENABLE(trigg10Herz),
            .TRIG_OUT(triggImageMX),
            .COUNT(pixelTimerX)
            );

        UGeneric_Counter #(.COUNTER_WIDTH(2),
            .COUNTER_MAX(3))
            ImageMover3 (
            .CLK(CLK),
            .RESET(1'b0),
            .ENABLE(triggImageMX | triggImageMY),
            .COUNT(counterCase)
            );

        // Setting parameters for transitions of an image.
            parameter leftEdgeX = 10'd0;
            parameter rightEdgeX = 10'd20;
            parameter topEdgeY = 10'd0;
            parameter bottomEdgeY = 10'd20;

        always@(posedge CLK) begin
            case(counterCase)
                2'b00 : begin
                            if((leftEdgeX <= ADDRESS_H) & (ADDRESS_H <= rightEdgeX)) begin
                                if((topEdgeY + pixelTimerY <= ADDRESS_V) & (ADDRESS_V < bottomEdgeY + pixelTimerY))
                                    COLOUR_OUT <= infoColour + 1;
                                else 
                                    COLOUR_OUT <= 0;
                            end
                            else
                                COLOUR_OUT <= 0;
                        end
                2'b01 : begin
                            if((leftEdgeX + pixelTimerX <= ADDRESS_H) & (ADDRESS_H <= rightEdgeX + pixelTimerX)) begin
                                if((topEdgeY  + 460 <= ADDRESS_V) & (ADDRESS_V < bottomEdgeY + 460))
                                    COLOUR_OUT <= infoColour + 1;
                                else 
                                    COLOUR_OUT <= 0;
                            end
                            else
                                COLOUR_OUT <= 0;
                        end
                2'b10 : begin
                            if((leftEdgeX  + 620 <= ADDRESS_H) & (ADDRESS_H <= rightEdgeX + 620)) begin
                                if((topEdgeY + 460 - pixelTimerY <= ADDRESS_V) & (ADDRESS_V < bottomEdgeY + 460 - pixelTimerY))
                                    COLOUR_OUT <= infoColour + 1;
                                else 
                                    COLOUR_OUT <= 0;
                            end
                            else
                                COLOUR_OUT <= 0;
                        end
                2'b11 : begin
                            if((leftEdgeX + 620 - pixelTimerX <= ADDRESS_H) & (ADDRESS_H <= rightEdgeX + 620 - pixelTimerX)) begin
                                if((topEdgeY <= ADDRESS_V) & (ADDRESS_V < bottomEdgeY))
                                    COLOUR_OUT <= infoColour + 1;
                                else 
                                    COLOUR_OUT <= 0;
                            end
                            else
                                COLOUR_OUT <= 0;
                        end  
            endcase
endmodule
