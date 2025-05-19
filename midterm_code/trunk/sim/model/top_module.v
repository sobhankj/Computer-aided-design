`timescale 1ns/1ns
module top_module(clk, rst, n, x, Reset, start, y, valid, ready, overflow);
    input clk, rst, Reset, start;
    input [2:0] n;
    input [7:0] x;
    output [31:0] y;
    output valid, ready, overflow;
    wire init , sel , temp_ready;
    assign temp_ready = ready;
    datapath dp(.clk(clk), .rst(rst), .init(init), .x(x), .n(n), .ready(ready), .overflow(overflow), .valid(valid), .y(y) , .sel(sel));
    controller cnt(.clk(clk), .rst(rst), .start(start), .Reset(Reset), .init(init) , .sel(sel) , .ready(temp_ready));
endmodule