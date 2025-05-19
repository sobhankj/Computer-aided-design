`timescale 1ns/1ns

module shift_reg16_left(clk, rst, ld, sh, reg_in, reg_out);//208
    input clk, rst, ld, sh;
    input[15:0] reg_in;
    output [7:0] reg_out;
    wire [15:0] out;

    s2 reg_15(.D00(out[15]) , .D01(reg_in[15]) , .D10(out[14]) , .D11(reg_in[15]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[15]));
    s2 reg_14(.D00(out[14]) , .D01(reg_in[14]) , .D10(out[13]) , .D11(reg_in[14]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[14]));
    s2 reg_13(.D00(out[13]) , .D01(reg_in[13]) , .D10(out[12]) , .D11(reg_in[13]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[13]));
    s2 reg_12(.D00(out[12]) , .D01(reg_in[12]) , .D10(out[11]) , .D11(reg_in[12]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[12]));
    s2 reg_11(.D00(out[11]) , .D01(reg_in[11]) , .D10(out[10]) , .D11(reg_in[11]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[11]));
    s2 reg_10(.D00(out[10]) , .D01(reg_in[10]) , .D10(out[9]) , .D11(reg_in[10]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[10]));
    s2 reg_9(.D00(out[9]) , .D01(reg_in[9]) , .D10(out[8]) , .D11(reg_in[9]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[9]));
    s2 reg_8(.D00(out[8]) , .D01(reg_in[8]) , .D10(out[7]) , .D11(reg_in[8]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[8]));
    s2 reg_7(.D00(out[7]) , .D01(reg_in[7]) , .D10(out[6]) , .D11(reg_in[7]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[7]));
    s2 reg_6(.D00(out[6]) , .D01(reg_in[6]) , .D10(out[5]) , .D11(reg_in[6]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[6]));
    s2 reg_5(.D00(out[5]) , .D01(reg_in[5]) , .D10(out[4]) , .D11(reg_in[5]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[5]));
    s2 reg_4(.D00(out[4]) , .D01(reg_in[4]) , .D10(out[3]) , .D11(reg_in[4]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[4]));
    s2 reg_3(.D00(out[3]) , .D01(reg_in[3]) , .D10(out[2]) , .D11(reg_in[3]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[3]));
    s2 reg_2(.D00(out[2]) , .D01(reg_in[2]) , .D10(out[1]) , .D11(reg_in[2]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[2]));
    s2 reg_1(.D00(out[1]) , .D01(reg_in[1]) , .D10(out[0]) , .D11(reg_in[1]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[1]));
    s2 reg_0(.D00(out[0]) , .D01(reg_in[0]) , .D10(1'b0) , .D11(reg_in[0]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[0]));

    assign reg_out = out[15:8];
    
endmodule

module shift_reg16_right(clk, rst, ld, sh, reg_in, reg_out);//208
    input clk, rst, ld, sh;
    input[15:0] reg_in;
    output [15:0] reg_out;
    wire [15:0] out;

    s2 reg_15(.D00(out[15]) , .D01(reg_in[15]) , .D10(1'b0) , .D11(reg_in[15]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[15]));
    s2 reg_14(.D00(out[14]) , .D01(reg_in[14]) , .D10(out[15]) , .D11(reg_in[14]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[14]));
    s2 reg_13(.D00(out[13]) , .D01(reg_in[13]) , .D10(out[14]) , .D11(reg_in[13]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[13]));
    s2 reg_12(.D00(out[12]) , .D01(reg_in[12]) , .D10(out[13]) , .D11(reg_in[12]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[12]));
    s2 reg_11(.D00(out[11]) , .D01(reg_in[11]) , .D10(out[12]) , .D11(reg_in[11]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[11]));
    s2 reg_10(.D00(out[10]) , .D01(reg_in[10]) , .D10(out[11]) , .D11(reg_in[10]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[10]));
    s2 reg_9(.D00(out[9]) , .D01(reg_in[9]) , .D10(out[10]) , .D11(reg_in[9]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[9]));
    s2 reg_8(.D00(out[8]) , .D01(reg_in[8]) , .D10(out[9]) , .D11(reg_in[8]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[8]));
    s2 reg_7(.D00(out[7]) , .D01(reg_in[7]) , .D10(out[8]) , .D11(reg_in[7]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[7]));
    s2 reg_6(.D00(out[6]) , .D01(reg_in[6]) , .D10(out[7]) , .D11(reg_in[6]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[6]));
    s2 reg_5(.D00(out[5]) , .D01(reg_in[5]) , .D10(out[6]) , .D11(reg_in[5]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[5]));
    s2 reg_4(.D00(out[4]) , .D01(reg_in[4]) , .D10(out[5]) , .D11(reg_in[4]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[4]));
    s2 reg_3(.D00(out[3]) , .D01(reg_in[3]) , .D10(out[4]) , .D11(reg_in[3]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[3]));
    s2 reg_2(.D00(out[2]) , .D01(reg_in[2]) , .D10(out[3]) , .D11(reg_in[2]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[2]));
    s2 reg_1(.D00(out[1]) , .D01(reg_in[1]) , .D10(out[2]) , .D11(reg_in[1]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[1]));
    s2 reg_0(.D00(out[0]) , .D01(reg_in[0]) , .D10(out[1]) , .D11(reg_in[0]), .A1(sh), .B1(sh), .A0(ld), .B0(ld), .clr(rst), .clk(clk) , .out(out[0]));

    assign reg_out = out[15:0];

endmodule

module OR(a, b, c);//10
    input a, b;
    output c;
    c1 or_gate(.A0(b), .A1(b), .SA(1), .B0(1), .B1(1), .SB(1), .S0(a), .S1(a), .f(c));
endmodule

module AND(a, b, c);//10
    input a, b;
    output c;
    c1 and_gate(.A0(0), .A1(a), .SA(b), .B0(0), .B1(0), .SB(0), .S0(0), .S1(0), .f(c));
endmodule

module AND5(a, b, c, d, e, res);//21
    input a, b, c, d, e;
    output res;
    wire res4;

    c2 and4(.D00(0), .D01(0), .D10(0), .D11(a), .A1(b), .B1(0), .A0(c), .B0(d), .out(res4));
    AND and5(.a(res4), .b(e), .c(res));
endmodule

module XOR(a, b, c);//10
    input a, b;
    output c;
    c1 xor_gate(.A0(0), .A1(1), .SA(b), .B0(1), .B1(0), .SB(b), .S0(0), .S1(a), .f(c));
endmodule

module NOT(a, not_a);//10
    input a;
    output not_a;
    c1 not_gate(.A0(1), .A1(1), .SA(1), .B0(0), .B1(0), .SB(1), .S0(a), .S1(a), .f(not_a));
endmodule

module FA(a, b, cin, sum, cout);//31
    input a, b, cin;
    output sum, cout;
    wire sum1_out;

    XOR sum1(.a(a), .b(b), .c(sum1_out));
    XOR sum2(.a(sum1_out), .b(cin), .c(sum));
    c2 carry(.D00(0), .D01(1), .D10(b), .D11(1), .A1(0), .B1(a), .A0(sum1_out), .B0(cin), .out(cout));
endmodule

module counter16(clk, rst, init, inc, dec, all_one, all_zero);//287
    input clk, rst, init, inc, dec;
    output all_one, all_zero;
    wire[3:0] count_out, full_adder;
    wire a0b0, carry_in;
    wire [3:0] b, co, not_c;

    OR A0B0(.a(init), .b(dec), .c(a0b0));
    s2 count_3(.D00(count_out[3]), .D01(full_adder[3]), .D10(full_adder[3]), .D11(1'b0), .A1(init), .B1(inc), .A0(a0b0), .B0(a0b0), .clr(rst), .clk(clk), .out(count_out[3]));
    s2 count_2(.D00(count_out[2]), .D01(full_adder[2]), .D10(full_adder[2]), .D11(1'b0), .A1(init), .B1(inc), .A0(a0b0), .B0(a0b0), .clr(rst), .clk(clk), .out(count_out[2]));
    s2 count_1(.D00(count_out[1]), .D01(full_adder[1]), .D10(full_adder[1]), .D11(1'b0), .A1(init), .B1(inc), .A0(a0b0), .B0(a0b0), .clr(rst), .clk(clk), .out(count_out[1]));
    s2 count_0(.D00(count_out[0]), .D01(full_adder[0]), .D10(full_adder[0]), .D11(1'b0), .A1(init), .B1(inc), .A0(a0b0), .B0(a0b0), .clr(rst), .clk(clk), .out(count_out[0]));

    c1 CARRY_IN(.A0(1), .A1(0), .SA(inc), .B0(1), .B1(0), .SB(inc), .S0(dec), .S1(dec), .f(carry_in));
    XOR xo3(.a(1'b0), .b(carry_in), .c(b[3]));
    XOR xo2(.a(1'b0), .b(carry_in), .c(b[2]));
    XOR xo1(.a(1'b0), .b(carry_in), .c(b[1]));
    XOR xo0(.a(1'b1), .b(carry_in), .c(b[0]));

    FA fa3(.a(count_out[3]), .b(b[3]), .cin(co[2]), .sum(full_adder[3]), .cout(co[3]));
    FA fa2(.a(count_out[2]), .b(b[2]), .cin(co[1]), .sum(full_adder[2]), .cout(co[2]));
    FA fa1(.a(count_out[1]), .b(b[1]), .cin(co[0]), .sum(full_adder[1]), .cout(co[1]));
    FA fa0(.a(count_out[0]), .b(b[0]), .cin(carry_in), .sum(full_adder[0]), .cout(co[0]));

    NOT not3(.a(count_out[3]), .not_a(not_c[3]));
    NOT not2(.a(count_out[2]), .not_a(not_c[2]));
    NOT not1(.a(count_out[1]), .not_a(not_c[1]));
    NOT not0(.a(count_out[0]), .not_a(not_c[0]));

    AND5 ALL_ONE(.a(count_out[3]), .b(count_out[2]), .c(count_out[1]), .d(count_out[0]), .e(1), .res(all_one));
    AND5 ALL_ZERO(.a(not_c[3]), .b(not_c[2]), .c(not_c[1]), .d(not_c[0]), .e(1), .res(all_zero));

endmodule

module bit_multiplier(xi, yi, pi, ci, xo, yo, po, co);
    input xi, yi, pi, ci;
    output xo, yo, po, co;

    wire xy, temp, and1, and2, and3;

    AND XY(.a(xi), .b(yi), .c(xy));

    AND AND1(.a(pi), .b(xy), .c(and1));
    AND AND2(.a(pi), .b(ci), .c(and2));
    AND AND3(.a(xy), .b(ci), .c(and3));
    c1 OR3(.A0(and1), .A1(1), .SA(and2), .B0(1), .B1(1), .SB(1), .S0(and3), .S1(and3), .f(co));

    XOR xor1(.a(pi), .b(xy), .c(temp));
    XOR xor2(.a(temp), .b(ci), .c(po));

    assign xo = xi;
    assign yo = yi;

endmodule


module multiplier(x, y, z);
    parameter N = 8;
    input[N-1:0] x, y;
    output [2*N-1:0] z;

    wire xv [N:0][N:0];
    wire yv [N:0][N:0];
    wire cv [N:0][N:0];
    wire pv [N:0][N:0];

    genvar i, j;
    generate // Instancing bit_multipliers
    for (i = 0; i < N; i = i + 1)
    begin: gen_rows
        for (j = 0; j < N; j = j + 1)
        begin: gen_cols

            bit_multiplier inst(
                .xi(xv[i][j]),
                .yi(yv[i][j]),
                .pi(pv[i][j+1]),
                .ci(cv[i][j]),
                .xo(xv[i][j+1]),
                .yo(yv[i+1][j]),
                .po(pv[i+1][j]),
                .co(cv[i][j+1])
            );

        end
    end
    endgenerate
    generate // Side Ports Connections
    for (i = 0; i < N; i = i + 1)
    begin: sides
        assign xv[i][0] = x[i];
        assign cv[i][0] = 1'b0;
        assign pv[0][i+1] = 1'b0;
        assign pv[i+1][N] = cv[i][N];
        assign yv[0][i] = y[i];
        assign z[i] = pv[i+1][0];
        assign z[i+N] = pv[N][i+1];
    end
    endgenerate
endmodule
