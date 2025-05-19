`timescale 1ns/1ns
module register_temp #(parameter size)(clk, rst, ld, init, inp, out);
    input clk, rst, ld, init;
    input [size-1:0] inp;
    output reg [size-1:0] out;

    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= {size{1'b0}};
        else if (init)
            out <= {1'b0, {size-1{1'b1}}};
        else if (ld)
            out <= inp;
    end
endmodule
