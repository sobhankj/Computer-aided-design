`timescale 1ns/1ns
module memory_address(n, n_pipe, address);
    input [3:0] n, n_pipe;
    output [3:0] address;

    assign address = n - n_pipe;
endmodule