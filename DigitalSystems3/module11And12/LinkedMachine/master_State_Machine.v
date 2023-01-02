`timescale 1ns/1ps

module master_State_Machine(
    input CLK,
    input RESET,
    input BTN_LEFT,
    input BTN_CENTRE,
    input BTN_RIGHT,
    input [3:0] STATE_OUT1,
    input [3:0] STATE_OUT2,
    output [1:0] MASTER_CONTROL
);

    // Registers for current state information
    reg [1:0] current_State;
    reg [1:0] next_State;

    // Sequential logic: Control signal for state machine
    always@(posedge CLK) begin
        if(RESET)
            current_State <= 2'd0;
        else
            current_State <= next_State;
    end

    // Combinatorial logic: State machine next state assignment
    always@(posedge CLK) begin
        case(current_State)
            2'd0 : begin
                if(BTN_RIGHT)
                    next_State <= 2'd1;
                else if(BTN_CENTRE)
                    next_State <= 2'd2;
                else if(BTN_LEFT)
                    next_State <= 2'd3;
                else
                    next_State <= 2'd0;
            end

            2'd1 : begin
                if(STATE_OUT1 == 4'b0111)
                    next_State <= 2'd2;
                else
                    next_State <= 2'd1;
            end

            2'd2 : begin
                next_State <= 2'd2;
            end

            2'd3 : begin
                if(STATE_OUT2 == 4'b1000)
                    next_State <= 2'd2;
                else
                    next_State <= 2'd3;
            end
        endcase
    end

    // Output is wired to the register current state
    assign MASTER_CONTROL = current_State;
endmodule