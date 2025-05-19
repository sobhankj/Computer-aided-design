`timescale 1ns/1ns
// `include "shared_parameters.vh"

module top_module #(parameter NUM_BIT = 4, NUM_REG = 4, ADDR_REG = 2, PAR_WRITE = 2, PAR_READ = 1)
(clk, rst, write_en, read_en, din, dout, full, empty, ready, valid);

    input clk, rst, write_en, read_en;
    input [(PAR_WRITE * NUM_BIT ) - 1 : 0] din;
    output [(PAR_READ * NUM_BIT ) - 1 : 0] dout;
    output full, empty, ready, valid;

    wire init, ready, valid, inc_w, inc_r;

    datapath datapath(.clk(clk), .rst(rst), .init(init), .wen(wen), .din(din), .dout(dout), .full(full), .empty(empty), .ready(ready), .valid(valid), .inc_w(inc_w), .inc_r(inc_r));
    controller controller(.clk(clk), .rst(rst), .write_en(write_en), .read_en(read_en), .ready(ready), .valid(valid), .init(init), .inc_w(inc_w), .inc_r(inc_r), .wen(wen));

endmodule