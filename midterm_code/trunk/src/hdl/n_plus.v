`timescale 1ns/1ns
module n_plus(n, n_out);
    input [2:0] n;
    output [3:0] n_out;
    assign n_out = {1'b0, n} + {4'd1};
endmodule