`timescale 1ns / 1ps

module shift_register_TB(
    );
    //Defining interface for simulation module
    //Input
    reg CLK;
    reg IN;
    //Output - preceded by wire
    wire [15:0] OUT;
    
    //Here we will instantiate the unit under test (uut)
    shift_register uut (
        .CLK(CLK),
        .IN(IN),
        .OUT(OUT)
    );
    
    //Here we will create clock signal
    initial begin
        CLK = 0;
        forever #50 CLK = ~CLK;
    end
    
    //Initialise input
    initial begin
        IN = 0;
        #100
        #100 IN = 1;
    end
endmodule
