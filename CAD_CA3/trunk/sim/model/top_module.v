`timescale 1ns/1ns

module top_module(clk, rst, A, B, start, Y, done);
    input clk, rst, start;
    input[15:0] A, B;
    output done;
    output[15:0] Y;

    wire init_cnt, load_a, load_b, inc_cnt, shift_a, shift_b, load_r, shift_r, dec_cnt, all_zero, a15, b15, all_one;

    datapath datapath(.clk(clk), .rst(rst), .A(A), .B(B), .init_cnt(init_cnt), .loadA(load_a), .loadB(load_b), .inc_cnt(inc_cnt), .shiftA(shift_a),
                      .shiftB(shift_b), .loadR(load_r), .shiftR(shift_r), .dec_cnt(dec_cnt), .Y(Y), .a15(a15), .b15(b15), .all_zero(all_zero), .all_one(all_one));
    
    controller controller(.clk(clk), .rst(rst), .start(start), .A15(a15), .B15(b15), .all_zero(all_zero), .init_cnt(init_cnt), .ldA(load_a),
                        .ldB(load_b), .inc_cnt(inc_cnt), .dec_cnt(dec_cnt), .shA(shift_a), .shB(shift_b), .ld_res(load_r), .sh_res(shift_r), .done(done), .all_one(all_one));
endmodule