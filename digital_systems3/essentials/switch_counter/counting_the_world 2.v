`timescale 1ns / 1ps

module counting_the_world(
    input pushButton,
    input slideSwitch,
    output [15:0] LEDS
    );
    
    reg [15:0] Value = 0;
    
    always@(posedge pushButton) begin
        if(slideSwitch)
            Value <= Value + 1;
        else
            Value <= Value - 1;
    end
    
    assign LEDS = Value;
endmodule
