module Generic_counter(
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
    
    //Begining of synthesis list.
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
    
    assign COUNT = count_value;
    assign TRIG_OUT = Trigger_out;
endmodule