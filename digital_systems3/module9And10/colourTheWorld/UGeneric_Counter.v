`timescale 1ns / 1ps

/* The purpose of this module is to increment a counter by unity, starting from 0 when enable is set to high.
 * The counter is constrainted by an upper limit, after which it resets back to 0.
 * Also, when this upper limit is reached, a trigger signal is set to high.
 */

module UGeneric_Counter(
    CLK,
    RESET, 
    ENABLE,
    TRIG_OUT,
    COUNT
    );

    // Parameters are what differentiate generics from modules.
    parameter COUNTER_WIDTH = 4;        //Bit length of counter
    parameter COUNTER_MAX = 9;          //Max counter number, before it resets
    
    // I/O's stated outside of module.
    input CLK;
    input RESET;
    input ENABLE;
    output TRIG_OUT;
    output [COUNTER_WIDTH - 1:0] COUNT;
    
    // Registers to store data.
    reg [COUNTER_WIDTH - 1:0] count_value;
    reg Trigger_out;
    
    // Begining of synthesis list. Counter adds by 1 if ENABLE changes.
    always@(posedge CLK) begin
        if(RESET)
            count_value <= 0;
        else begin
            if(ENABLE) begin
                if(count_value == COUNTER_MAX)
                    count_value <= 0;
                else
                    count_value <= count_value + 1;
            end
        end
    end
    
    // If counter reaches max value, TRIG_OUT is set to 1.
    always@(posedge CLK) begin
        if(RESET)
            Trigger_out <= 0;
        else begin
            if(ENABLE && (count_value == COUNTER_MAX))
                Trigger_out <= 1;
            else
                Trigger_out <= 0;
        end
    end
    // End of synthesis list
    
    // Wiring everything together.
    assign COUNT = count_value;
    assign TRIG_OUT = Trigger_out;
endmodule