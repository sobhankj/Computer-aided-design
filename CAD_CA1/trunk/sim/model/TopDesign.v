`timescale 1ns/1ns

module top_module(start, clk, rst, done);
input start, clk, rst;
output done;

wire in_add_inc, in_add_init, in_add_cout, shift_en_A, load_en_A, shift_en_B, load_en_B, shift_en_result, load_en_result,
    init_result, inc_cnt_round, init_cnt_round, cout_round, dec_cnt_ud, inc_cnt_ud, init_cnt_ud,
    zero_ud, inc_cnt_fo, init_cnt_fo, cout_fo, w_en_out_mem, out_add_inc, out_add_init,
    out_add_cout, A_last_element, B_last_element;


    datapath Datapath(.clk(clk), .rst(rst) , .in_add_inc(in_add_inc), .in_add_init(in_add_init), .in_add_cout(in_add_cout), .shift_en_A(shift_en_A), .load_en_A(load_en_A),
                .shift_en_B(shift_en_B), .load_en_B(load_en_B), .shift_en_result(shift_en_result), .load_en_result(load_en_result), .init_result(init_result),
                .inc_cnt_round(inc_cnt_round), .init_cnt_round(init_cnt_round), .cout_round(cout_round), .dec_cnt_ud(dec_cnt_ud), .inc_cnt_ud(inc_cnt_ud), .init_cnt_ud(init_cnt_ud),
                .zero_ud(zero_ud), .inc_cnt_fo(inc_cnt_fo), .init_cnt_fo(init_cnt_fo), .cout_fo(cout_fo), .w_en_out_mem(w_en_out_mem), .out_add_inc(out_add_inc), .out_add_init(out_add_init),
                .out_add_cout(out_add_cout), .A_last_element(A_last_element), .B_last_element(B_last_element));

    controller Controller(.clk(clk), .rst(rst), .start(start), .in_add_cout(in_add_cout), .cout_round(cout_round), .zero_ud(zero_ud), .cout_fo(cout_fo), .out_add_cout(out_add_cout), .A_reg_last(A_last_element), .B_reg_last(B_last_element),
                .shift_en_A(shift_en_A), .load_en_A(load_en_A), .shift_en_B(shift_en_B), .load_en_B(load_en_B), .shift_en_result(shift_en_result), .load_en_result(load_en_result), .init_result(init_result),
                .in_add_inc(in_add_inc), .in_add_init(in_add_init), .inc_cnt_round(inc_cnt_round), .init_cnt_round(init_cnt_round), .dec_cnt_ud(dec_cnt_ud), .inc_cnt_ud(inc_cnt_ud), .init_cnt_ud(init_cnt_ud),
                .inc_cnt_fo(inc_cnt_fo), .init_cnt_fo(init_cnt_fo), .w_en_out_mem(), .out_add_inc(out_add_inc), .out_add_init(out_add_init), .write_enable(w_en_out_mem), .done(done));
endmodule