`timescale 1ns/1ns
module mux2_to_1 #(parameter size)(inp1, inp2, sel, out);
    input [size-1:0] inp1, inp2;
    input sel;
    output [size-1:0] out;
    assign out = sel ? inp2 : inp1;
endmodule