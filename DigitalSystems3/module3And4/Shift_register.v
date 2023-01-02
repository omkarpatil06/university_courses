`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2022 09:16:03
// Design Name: 
// Module Name: Shift_register
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Shift_register(
    input CLK,
    input IN,
    output [15:0] OUT
    );
    
    /* FIRST CODE: Long and tedious. Creating a wire bus using the [x] notation
    wire [15:0] W;
    
    //Instantiating all the D flip-flops.
    Hello_synchronous_world D0 (.CLK(CLK), .IN(IN), .OUT(W[0]));
    Hello_synchronous_world D1 (.CLK(CLK), .IN(W[0]), .OUT(W[1]));
    Hello_synchronous_world D2 (.CLK(CLK), .IN(W[1]), .OUT(W[2]));
    Hello_synchronous_world D3 (.CLK(CLK), .IN(W[2]), .OUT(W[3]));
    Hello_synchronous_world D4 (.CLK(CLK), .IN(W[3]), .OUT(W[4]));
    Hello_synchronous_world D5 (.CLK(CLK), .IN(W[4]), .OUT(W[5]));
    Hello_synchronous_world D6 (.CLK(CLK), .IN(W[5]), .OUT(W[6]));
    Hello_synchronous_world D7 (.CLK(CLK), .IN(W[6]), .OUT(W[7]));
    Hello_synchronous_world D8 (.CLK(CLK), .IN(W[7]), .OUT(W[8]));
    Hello_synchronous_world D9 (.CLK(CLK), .IN(W[8]), .OUT(W[9]));
    Hello_synchronous_world D10 (.CLK(CLK), .IN(W[9]), .OUT(W[10]));
    Hello_synchronous_world D11 (.CLK(CLK), .IN(W[10]), .OUT(W[11]));
    Hello_synchronous_world D12 (.CLK(CLK), .IN(W[11]), .OUT(W[12]));
    Hello_synchronous_world D13 (.CLK(CLK), .IN(W[12]), .OUT(W[13]));
    Hello_synchronous_world D14 (.CLK(CLK), .IN(W[13]), .OUT(W[14]));
    Hello_synchronous_world D15 (.CLK(CLK), .IN(W[14]), .OUT(W[15])); 
    
    assign OUT = W; */
    
    /* SECOND CODE: // Creating a bus of wires, tied to I/Os as specified by instatiation.
    wire [16:0] W;
    
    // Declaring a variable to exploit repeated pattern.
    genvar DtypeNo;
    
    // Using generate and for loop to instantiate
    generate
        for (DtypeNo = 0; DtypeNo < 16; DtypeNo = DtypeNo + 1)
        begin: DtypeInstantiation
            Hello_synchronous_world DTypeNo (.CLK(CLK), .IN(W[DTypeNo]), .OUT(W[DtypeNo + 1]));
        end
    endgenerate
        
    //Ties the wires to 16 bit output
    assign OUT = W[16:1];
    assign W[0] = IN; */
    
    /* THIRD CODE: // Behavioral level design
    reg [15:0] DTypes;
    
    // Concatenated form
    always@(posedge CLK) begin
        DTypes = {DTypes[14:0], IN};
    end
    
    assign OUT = DTypes; */
endmodule
