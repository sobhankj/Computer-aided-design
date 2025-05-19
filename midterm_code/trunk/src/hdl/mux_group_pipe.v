`timescale 1ns/1ns
module mux_group_pipe(valid, overflow, y_past, y_next, t_past, t_next, x_past, x_next, ovf_past, ovf_next,
                        valid_past, valid_next, n_past, n_next, y, t, x, ovf, v, n);
    input overflow, valid, ovf_next, ovf_past, valid_next, valid_past;
    input [31:0] y_past, y_next, t_past, t_next;
    input [7:0] x_past, x_next;
    input [3:0] n_past, n_next;

    output [31:0] t, y;
    output [7:0] x;
    output [3:0] n;
    output v, ovf;

    wire select;

    assign select = ~(valid ^ overflow);

    mux2_to_1 #(.size(32)) mux_y(.inp1(y_past), .inp2(y_next), .sel(select), .out(y));
    mux2_to_1 #(.size(32)) mux_t(.inp1(t_past), .inp2(t_next), .sel(select), .out(t));
    mux2_to_1 #(.size(8)) mux_x(.inp1(x_past), .inp2(x_next), .sel(select), .out(x));
    mux2_to_1 #(.size(4)) mux_n(.inp1(n_past), .inp2(n_next), .sel(select), .out(n));
    mux2_to_1 #(.size(1)) mux_ovf(.inp1(ovf_past), .inp2(ovf_next), .sel(select), .out(ovf));
    mux2_to_1 #(.size(1)) mux_valid(.inp1(valid_past), .inp2(valid_next), .sel(select), .out(v));
endmodule

// `timescale 1ns/1ns
// module mux_group_pipe_special(nsel, y_past, y_next, t_past, t_next, x_past, x_next, ovf_past, ovf_next,
//                         valid_past, valid_next, n_past, n_next, y, t, x, ovf, v, n);
//     input ovf_next, ovf_past, valid_next, valid_past;
//     input [31:0] y_past, y_next, t_past, t_next;
//     input [7:0] x_past, x_next;
//     input [3:0] n_past, n_next , nsel;

//     output [31:0] t, y;
//     output [7:0] x;
//     output [3:0] n;
//     output v, ovf;

//     wire select;

//     // assign select = (nsel == 0 || nsel >= 4'b1100) ? 1'b1 : 1'b0;
//     assign select = 1'b1;

//     mux2_to_1 #(.size(32)) mux_y(.inp1(y_past), .inp2(y_next), .sel(select), .out(y));
//     mux2_to_1 #(.size(32)) mux_t(.inp1(t_past), .inp2(t_next), .sel(select), .out(t));
//     mux2_to_1 #(.size(8)) mux_x(.inp1(x_past), .inp2(x_next), .sel(select), .out(x));
//     mux2_to_1 #(.size(4)) mux_n(.inp1(n_past), .inp2(n_next), .sel(select), .out(n));
//     mux2_to_1 #(.size(1)) mux_ovf(.inp1(ovf_past), .inp2(ovf_next), .sel(select), .out(ovf));
//     mux2_to_1 #(.size(1)) mux_valid(.inp1(valid_past), .inp2(valid_next), .sel(select), .out(v));
// endmodule