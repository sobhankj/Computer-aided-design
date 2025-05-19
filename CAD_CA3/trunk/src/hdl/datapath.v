`timescale 1ns/1ns

module datapath(clk, rst, A, B, init_cnt, loadA, loadB, inc_cnt, shiftA, shiftB, loadR, shiftR, dec_cnt, Y, a15, b15, all_zero, all_one);
    input clk, rst, init_cnt, loadA, loadB, inc_cnt, shiftA, shiftB, loadR, shiftR, dec_cnt;
    input[15:0] A, B;
    output a15, b15, all_zero, all_one;
    output[15:0] Y;
    wire[7:0] Aout, Bout;
    wire[15:0] Mult_out;

    shift_reg16_left shA(.clk(clk), .rst(rst), .ld(loadA), .sh(shiftA), .reg_in(A), .reg_out(Aout));
    shift_reg16_left shB(.clk(clk), .rst(rst), .ld(loadB), .sh(shiftB), .reg_in(B), .reg_out(Bout));
    assign a15 = Aout[7];
    assign b15 = Bout[7];

    multiplier mult(.x(Aout), .y(Bout), .z(Mult_out));
    // assign Mult_out = Aout * Bout;

    counter16 counter(.clk(clk), .rst(rst), .init(init_cnt), .inc(inc_cnt), .dec(dec_cnt), .all_one(all_one), .all_zero(all_zero));


    shift_reg16_right shR(.clk(clk), .rst(rst), .ld(loadR), .sh(shiftR), .reg_in(Mult_out), .reg_out(Y));
endmodule;
