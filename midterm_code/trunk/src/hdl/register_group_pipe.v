`timescale 1ns/1ns
module register_group_pipe(clk, rst, init, inp_y, inp_t, inp_x, inp_n, inp_ovf, inp_valid,
                            out_y, out_t, out_x, out_n, out_ovf, out_valid);
    input clk, rst, init, inp_ovf, inp_valid;
    input [31:0] inp_y, inp_t;
    input [7:0] inp_x;
    input [3:0] inp_n;

    output [31:0] out_y, out_t;
    output [7:0] out_x;
    output [3:0] out_n;
    output out_ovf, out_valid;

    register #(.size(32)) reg_y(.clk(clk), .rst(rst), .ld(1'b1), .init(init), .inp(inp_y), .out(out_y));
    register #(.size(8)) reg_x(.clk(clk), .rst(rst), .ld(1'b1), .init(init), .inp(inp_x), .out(out_x));
    register #(.size(4)) reg_n(.clk(clk), .rst(rst), .ld(1'b1), .init(init), .inp(inp_n), .out(out_n));
    register #(.size(1)) reg_ovf(.clk(clk), .rst(rst), .ld(1'b1), .init(init), .inp(inp_ovf), .out(out_ovf));
    register #(.size(1)) reg_valid(.clk(clk), .rst(rst), .ld(1'b1), .init(init), .inp(inp_valid), .out(out_valid));
    register_temp #(.size(32)) reg_t(.clk(clk), .rst(rst), .ld(1'b1), .init(init), .inp(inp_t), .out(out_t));

endmodule