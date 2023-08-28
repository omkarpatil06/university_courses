`timescale 1ns/1ps

module vga_State_Machine(
    input CLK,
    input [9:0] ADDRESS_X,
    input [8:0] ADDRESS_Y,
    input [1:0] MASTER_CONTROL,
    output [11:0] COLOUR_IN
);

    // Register for frame count
    reg [15:0] frame_Count;

    // Frame count counter
    always@(posedge CLK) begin
        if(ADDRESS_Y == 480)
            frame_Count <= frame_Count + 1;
    end

    // Combinatorial logic: State machine next state assignment
    always@(posedge CLK) begin
        if(MASTER_CONTROL == 2'b10) begin
            if(ADDRESS_Y[8:0] > 240) begin
                if(ADDRESS_X[9:0] > 320)
                    COLOUR_IN <= frame_Count[15:8] + ADDRESS_Y[7:0] + ADDRESS_X[7:0] - 240 - 320;
                else 
                    COLOUR_IN <= frame_Count[15:8] + ADDRESS_Y[7:0] - ADDRESS_X[7:0] - 240 + 320;
            end
            else begin
                if(ADDRESS_X[9:0] > 320)
                    COLOUR_IN <= frame_Count[15:8] - ADDRESS_Y[7:0] + ADDRESS_X[7:0] + 240 - 320;
                else 
                    COLOUR_IN <= frame_Count[15:8] - ADDRESS_Y[7:0] - ADDRESS_X[7:0] + 240 + 320;
            end
        end
        else
            COLOUR_IN <= 8'd0;
    end
endmodule