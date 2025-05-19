`timescale 1ns/1ns
module register_group_outside(clk, rst, ld, init, inp_x, inp_n,
                            out_y, out_t, out_x, out_n, out_ovf, out_valid);
    input clk, rst, init, ld;
    input [7:0] inp_x;
    input [3:0] inp_n;

    output [31:0] out_y, out_t;
    output [7:0] out_x;
    output [3:0] out_n;
    output out_ovf, out_valid;

    register #(.size(32)) reg_y(.clk(clk), .rst(rst), .ld(ld), .init(init), .inp(32'b0), .out(out_y));
    register #(.size(8)) reg_x(.clk(clk), .rst(rst), .ld(ld), .init(init), .inp(inp_x), .out(out_x));
    register #(.size(4)) reg_n(.clk(clk), .rst(rst), .ld(ld), .init(init), .inp(inp_n), .out(out_n));
    register #(.size(1)) reg_ovf(.clk(clk), .rst(rst), .ld(ld), .init(init), .inp(1'b0), .out(out_ovf));
    register #(.size(1)) reg_valid(.clk(clk), .rst(rst), .ld(ld), .init(init), .inp(1'b0), .out(out_valid));
    register_temp #(.size(32)) reg_t(.clk(clk), .rst(rst), .ld(ld), .init(init), .inp({1'b0, 31'b1111111111111111111111111111111}), .out(out_t));
endmodule