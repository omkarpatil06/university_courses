module d_ff(input d, clk, output reg q, reg q_bar);

    always @ (posedge clk) begin
        q = d;
        q_bar = ~q;
    end

endmodule

module fa(input a, b, c_in, clk, output reg sum, reg c_out):
    

module ripple_adder(input c_in, 
                    input [3:0] a, 
                    input [3:0] b,
                    output [3:0] sum, 
                    output c_out);
    
    wire [3:0] c_o;

    d_ff d1 ();
    d_ff d2 ();
    d_ff d3 ();
    d_ff d4 ();

