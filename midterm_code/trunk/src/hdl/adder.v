`timescale 1ns/1ns

module adder #(parameter size) (inp1, inp2, out);
    input signed[size-1:0] inp1, inp2;
    output signed[size-1:0] out;
    assign out = inp1 + inp2;
endmodule