`timescale 1ns/1ns

module tb();
    reg clk = 0;
    reg rst = 0;
    reg start = 0;

    reg [15:0] A = 16'b0001000000000000;
    reg [15:0] B = 16'b0010111000000000;
    wire [15:0] Y;
    wire done;

    top_module UUT(.clk(clk), .rst(rst), .A(A), .B(B), .start(start), .Y(Y), .done(done));

    initial repeat(300) #10 clk = ~clk; 
    initial begin 
    #20 rst = 1'b1;
    #20 rst = 1'b0;
    #20 start = 1'b1;
    #20 start = 1'b0;
    #800 start = 1'b1;
    A = 16'b111111111111111;
    B = 16'b000000000000000;
    #20 start = 1'b0;
    end 
endmodule