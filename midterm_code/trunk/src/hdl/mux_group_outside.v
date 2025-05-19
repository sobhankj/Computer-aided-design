`timescale 1ns/1ns
module mux_group_outside(select, y_past, y_new, t_past, t_new, x_past, x_new, ovf_past, ovf_new,
                        valid_past, valid_new, n_past, n_new, y, t, x, ovf, v, n);
    input select, ovf_new, ovf_past, valid_new, valid_past;
    input [31:0] y_past, y_new, t_past, t_new;
    input [7:0] x_past, x_new;
    input [3:0] n_past, n_new;

    output [31:0] t, y;
    output [7:0] x;
    output [3:0] n;
    output v, ovf;

    mux2_to_1 #(.size(32)) mux_y(.inp1(y_past), .inp2(y_new), .sel(select), .out(y));
    mux2_to_1 #(.size(32)) mux_t(.inp1(t_past), .inp2(t_new), .sel(select), .out(t));
    mux2_to_1 #(.size(8)) mux_x(.inp1(x_past), .inp2(x_new), .sel(select), .out(x));
    mux2_to_1 #(.size(4)) mux_n(.inp1(n_past), .inp2(n_new), .sel(select), .out(n));
    mux2_to_1 #(.size(1)) mux_ovf(.inp1(ovf_past), .inp2(ovf_new), .sel(select), .out(ovf));
    mux2_to_1 #(.size(1)) mux_valid(.inp1(valid_past), .inp2(valid_new), .sel(select), .out(v));
endmodule