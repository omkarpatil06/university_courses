`timescale 1ns/1ps

module led_State_Machine(
    input CLK,
    input RESET,
    input [1:0] MASTER_CONTROL,
    output [7:0] LED_OUT,
    output [3:0] STATE_OUT
);

    // Registers for current counter
    reg [25:0] current_Count;
    reg [25:0] next_Count;

    // Register for current state
    reg [3:0] current_State;
    reg [3:0] next_State;

    // Register for current LED
    reg [7:0] current_LED;
    reg [7:0] next_LED;

    // Sequential logic: Control signal for state machine
    always@(posedge CLK) begin
        if(RESET) begin
            current_Count <= 26'd0;
            current_State <= 4'd0;
            current_LED <= 8'h0;
        end
        else begin
            current_Count <= next_Count;
            current_State <= next_State;
            current_LED <= next_LED;
        end
    end

    // Combinatorial logic: State machine next state assignment
    always@(posedge CLK) begin
        case(current_State)
            4'd0 : begin
                if(MASTER_CONTROL == 2'b11)
                    next_State <= 4'd1;
                else
                    next_State <= 2'b00;
                
                next_Count <= 0;
                next_LED <= 4'h0;
            end

            4'd1 : begin
                if(current_Count == 50000000) begin
                    next_State <= 4'd2;
                    next_Count <= 0;
                end
                else begin
                    next_State <= current_State;
                    next_Count <= current_Count + 1;
                end

                next_LED <= 8'h1;
            end

            4'd2 : begin
                if(current_Count == 50000000) begin
                    next_State <= 4'd3;
                    next_Count <= 0;
                end
                else begin
                    next_State <= current_State;
                    next_Count <= current_Count + 1;
                end

                next_LED <= 8'h2;
            end

            4'd3 : begin
                if(current_Count == 50000000) begin
                    next_State <= 4'd4;
                    next_Count <= 0;
                end
                else begin
                    next_State <= current_State;
                    next_Count <= current_Count + 1;
                end

                next_LED <= 8'h4;
            end
                        
            4'd4 : begin
                if(current_Count == 50000000) begin
                    next_State <= 4'd5;
                    next_Count <= 0;
                end
                else begin
                    next_State <= current_State;
                    next_Count <= current_Count + 1;
                end

                next_LED <= 8'h8;
            end

            4'd5 : begin
                if(current_Count == 50000000) begin
                    next_State <= 4'd6;
                    next_Count <= 0;
                end
                else begin
                    next_State <= current_State;
                    next_Count <= current_Count + 1;
                end

                next_LED <= 8'h10;
            end

            4'd6 : begin
                if(current_Count == 50000000) begin
                    next_State <= 4'd7;
                    next_Count <= 0;
                end
                else begin
                    next_State <= current_State;
                    next_Count <= current_Count + 1;
                end

                next_LED <= 8'h20;
            end

            4'd7 : begin
                if(current_Count == 50000000) begin
                    next_State <= 4'd8;
                    next_Count <= 0;
                end
                else begin
                    next_State <= current_State;
                    next_Count <= current_Count + 1;
                end

                next_LED <= 8'h60;
            end

            4'd8 : begin
                if(current_Count == 50000000) begin
                    next_State <= current_State;
                    next_Count <= 0;
                end
                else begin
                    next_State <= current_State;
                    next_Count <= current_Count + 1;
                end

                next_LED <= 8'h80;
            end
        endcase
    end

    // Output is wired to the register current state
    assign STATE_OUT = current_State;
endmodule