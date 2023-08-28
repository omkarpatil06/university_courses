`timescale 1ns / 1ps

module counting_the_world_TB(
    );
    reg pushButton;
    reg slideSwitch;
    
    wire [15:0] LEDS;
    
    counting_the_world uut(
        .pushButton(pushButton),
        .slideSwitch(slideSwitch),
        .LEDS(LEDS)
     );
     
     initial begin
        pushButton = 0;
        forever #10 pushButton = ~pushButton;
     end
     
     initial begin
        slideSwitch = 0;
        #100;
        #100 slideSwitch = 1;
        #100 slideSwitch = 0;
     end
    
endmodule
