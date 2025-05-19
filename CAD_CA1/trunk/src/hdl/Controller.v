`timescale 1ns/1ns


module controller(clk, rst, start, in_add_cout, cout_round, zero_ud, cout_fo, out_add_cout, A_reg_last, B_reg_last,
                shift_en_A, load_en_A, shift_en_B, load_en_B, shift_en_result, load_en_result, init_result,
                in_add_inc, in_add_init, inc_cnt_round, init_cnt_round, dec_cnt_ud, inc_cnt_ud, init_cnt_ud,
                inc_cnt_fo, init_cnt_fo, w_en_out_mem, out_add_inc, out_add_init, write_enable, done);
input clk, rst, start;
input in_add_cout, cout_round, zero_ud, cout_fo, out_add_cout, A_reg_last, B_reg_last;
output reg shift_en_A, load_en_A, shift_en_B, load_en_B, shift_en_result, load_en_result, init_result,
        in_add_inc, in_add_init, inc_cnt_round, init_cnt_round, dec_cnt_ud, inc_cnt_ud, init_cnt_ud,
        inc_cnt_fo, init_cnt_fo, w_en_out_mem, out_add_inc, out_add_init, write_enable, done;

reg[3:0] ps, ns;
parameter[0:4]
Idle = 0, PreProc = 1, LoadA = 2, LoadB = 3, ProcA = 4, ShiftA = 5, InitCount8 = 6,
ProcB = 7, ShiftB = 8, Mult = 9, LoadRes = 10, ShiftRes = 11, SaveRes = 12, Done = 13 , ShiftR = 14;
    
always @(ps, start, A_reg_last, cout_fo, B_reg_last, zero_ud, cout_round) begin
    case(ps)
        Idle: ns = start ? PreProc : Idle;
        PreProc: ns = start ? PreProc : LoadA;
        LoadA: ns = LoadB;
        LoadB: ns = ProcA;
        ProcA: ns = (A_reg_last || cout_fo) ? InitCount8 : ShiftA;
        ShiftA: ns = ProcA;
        InitCount8: ns = ProcB;
        ProcB: ns = (B_reg_last || cout_fo) ? Mult : ShiftB;
        ShiftB: ns = ProcB;
        Mult: ns = LoadRes;
        LoadRes: ns = ShiftRes;
        ShiftRes: ns = zero_ud ? SaveRes : ShiftR;
        SaveRes: ns = cout_round ? Done : LoadA;
        Done: ns = Idle;
        ShiftR : ns = ShiftRes;
    endcase
end
    
always @(ps) begin
    {in_add_init, init_cnt_round, init_cnt_ud, init_cnt_fo, out_add_init, load_en_A, in_add_inc,
     init_result, load_en_B, shift_en_A, inc_cnt_fo, inc_cnt_ud, shift_en_B, load_en_result, inc_cnt_round,
     shift_en_result, dec_cnt_ud, out_add_inc, write_enable, done , w_en_out_mem} = 21'b00000_00000_00000_00000_0;
    case(ps)
    Idle: ;
    PreProc: {in_add_init, init_cnt_round, init_cnt_ud, init_cnt_fo, out_add_init} = 5'b11111;
    LoadA: {load_en_A, in_add_inc, init_result} = 3'b111;
    LoadB: load_en_B = 1'b1;
    ProcA: ;
    ShiftA: {shift_en_A, inc_cnt_fo, inc_cnt_ud} = 3'b111;
    InitCount8: init_cnt_fo = 1'b1;
    ProcB: ;
    ShiftB: {shift_en_B, inc_cnt_fo, inc_cnt_ud} = 3'b111;
    Mult: {init_cnt_fo , in_add_inc} = 2'b11;
    LoadRes: {load_en_result , inc_cnt_round} = 2'b11;
    ShiftRes: ;
    SaveRes: {init_cnt_ud, out_add_inc, write_enable} = 3'b111;
    Done: done = 1'b1;
    ShiftR : {shift_en_result, dec_cnt_ud} = 2'b11;
    endcase
end

always @(posedge clk) begin
    if(rst == 1'b1)
        ps <= Idle;
    else
        ps <= ns;
end

endmodule
