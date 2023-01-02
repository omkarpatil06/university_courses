`timescale 1ns/1ps

module basic_State_Machine (
    input CLK,
    input RESET,
    input BTN_LEFT,
    input BTN_CENTRE,
    input BTN_RIGHT,
    output [2:0] STATE_OUT
);

    // Registers for current state
    reg [2:0] current_State;
    reg [2:0] next_State;

    // Sequential logic: Control signal for state machine
    always@(posedge CLK) begin
        if(RESET)
            current_State <= 3'b000;
        else
            current_State <= next_State;
    end

    // Combinatorial logic: State machine next state assignment
    always@(posedge CLK) begin
        case(current_State)
            3'd0 : begin
                if(BTN_CENTRE)
                    next_State <= 3'd6;
                else
                    next_State <= 3'd0;
            end

            3'd1 : begin
                if(BTN_LEFT)
                    next_State <= 3'd5;
                else if(BTN_RIGHT)
                    next_State <= 3'd2;
                else
                    next_State <= 3'd1;
            end

            3'd2 : begin
                if(BTN_CENTRE)
                    next_State <= 3'd1;
                else if(BTN_LEFT)
                    next_State <= 3'd0;
                else
                    next_State <= 3'd2;
            end

            3'd3 : begin
                if(BTN_LEFT)
                    next_State <= 3'd4;
                else if(BTN_RIGHT)
                    next_State <= 3'd2;
                else
                    next_State <= 3'd3;
            end

            3'd4 : begin
                if(BTN_RIGHT)
                    next_State <= 3'd7;
                else if(BTN_CENTRE)
                    next_State <= 3'd6;
                else
                    next_State <= 3'd4;
            end

            3'd5 : begin
                if(BTN_CENTRE)
                    next_State <= 3'd3;
                else if(BTN_RIGHT)
                    next_State <= 3'd0;
                else
                    next_State <= 3'd5;
            end
            
            3'd6 : begin
                if(BTN_RIGHT)
                    next_State <= 3'd2;
                else if(BTN_LEFT)
                    next_State <= 3'd0;
                else
                    next_State <= 3'd6;
            end

            3'd7 : begin
                if(BTN_RIGHT)
                    next_State <= 3'd7;
                else
                    next_State <= 3'd7;
            end
        endcase
    end

    // Output is wired to the register current state
    assign STATE_OUT = current_State;
endmodule