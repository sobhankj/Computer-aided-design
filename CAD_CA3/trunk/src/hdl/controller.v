`timescale 1ns/1ns

module controller(clk, rst, start, A15, B15, all_zero, init_cnt, ldA,
                  ldB, inc_cnt, dec_cnt, shA, shB, ld_res, sh_res, done, all_one);
    input clk, rst, start, A15, B15, all_zero, all_one;
    output init_cnt, ldA, ldB, inc_cnt, dec_cnt, shA, shB, ld_res, sh_res, done;

    wire Idle, Init, Load, ProcA, Pa, ProcB, Pb, Mult, LoadRes, Shift, Sh, Done, not_start, not_A15, not_B15, not_all_zero, not_all_one , temp_1;

    NOT notSTART(.a(start), .not_a(not_start));
    NOT notA15(.a(A15), .not_a(not_A15));
    NOT notB15(.a(B15), .not_a(not_B15));
    NOT notALLZERO(.a(all_zero), .not_a(not_all_zero));
    NOT notALLONE(.a(all_one), .not_a(not_all_one));
    AND temp1(.a(all_one), .b(ProcA), .c(temp_1));

    s2  IDLE(.D00(0), .D01(Idle), .D10(1), .D11(1), .A1(done), .B1(rst), .A0(1), .B0(not_start), .clr(0), .clk(clk), .out(Idle));
    s2  INIT(.D00(0), .D01(1), .D10(Idle), .D11(1), .A1(0), .B1(start), .A0(start), .B0(Init), .clr(rst), .clk(clk), .out(Init));
    s2  LOAD(.D00(0), .D01(1), .D10(0), .D11(1), .A1(1), .B1(1), .A0(not_start), .B0(Init), .clr(rst), .clk(clk), .out(Load));
    s2  PROCA(.D00(0), .D01(0), .D10(1), .D11(1), .A1(Load), .B1(Pa), .A0(1), .B0(1), .clr(rst), .clk(clk), .out(ProcA));
    s2  PA(.D00(0), .D01(0), .D10(0), .D11(not_A15), .A1(0), .B1(1), .A0(ProcA), .B0(not_all_one), .clr(rst), .clk(clk), .out(Pa));
    s2  PROCB(.D00(0), .D01(1), .D10(1), .D11(1), .A1(temp_1), .B1(Pb), .A0(ProcA), .B0(A15), .clr(rst), .clk(clk), .out(ProcB));
    s2  PB(.D00(0), .D01(0), .D10(0), .D11(not_B15), .A1(0), .B1(1), .A0(ProcB), .B0(not_all_one), .clr(rst), .clk(clk), .out(Pb));
    s2  MULT(.D00(0), .D01(1), .D10(B15), .D11(1), .A1(0), .B1(ProcB), .A0(ProcB), .B0(all_one), .clr(rst), .clk(clk), .out(Mult));
    s2  LOADRES(.D00(1), .D01(0), .D10(0), .D11(1), .A1(Mult), .B1(Mult), .A0(1), .B0(1), .clr(rst), .clk(clk), .out(LoadRes));
    s2  SHIFT(.D00(0), .D01(0), .D10(1), .D11(1), .A1(LoadRes), .B1(Sh), .A0(1), .B0(1), .clr(rst), .clk(clk), .out(Shift));
    s2  SH(.D00(0), .D01(1), .D10(0), .D11(1), .A1(1), .B1(1), .A0(not_all_zero), .B0(Shift), .clr(rst), .clk(clk), .out(Sh));
    s2  DONE(.D00(0), .D01(1), .D10(0), .D11(1), .A1(1), .B1(1), .A0(all_zero), .B0(Shift), .clr(rst), .clk(clk), .out(Done));

    assign init_cnt = Init;
    assign ldA = Load;
    assign ldB = Load;
    c2 INC(.D00(0), .D01(0), .D10(0), .D11(1), .A1(Pa), .B1(Pb), .A0(not_all_one), .B0(not_all_one), .out(inc_cnt));
    assign shA = Pa;
    assign shB = Pb;
    assign ld_res = LoadRes;
    assign dec_cnt = Sh;
    assign sh_res = Sh;
    assign done = Done;
endmodule