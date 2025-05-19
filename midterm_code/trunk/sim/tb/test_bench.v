`timescale 1ns/1ns
module test_bench();
    reg clk=1'b0, rst=1'b0, Reset=1'b0, start=1'b0;
    reg [2:0] n;
    reg [7:0] x;
    wire [31:0] y;
    wire valid, ready, overflow;
    
    top_module tm(
        .clk(clk), .rst(rst), .n(n), .x(x), .Reset(Reset), .start(start), .y(y), .valid(valid), .ready(ready), .overflow(overflow)
    );

    initial begin
        forever #10 clk = ~clk;
    end

    initial begin
        #10;
        start = 0;
        Reset = 0;

        #15;
        start = 1;

        #20;
        start = 0;
        n = 3'b110;

        #20;
        x = 8'b10000001;

        #25;
        x = 8'h0f;

        #20;
        x = 8'h01;

        #20;
        x = 8'h00;

        #20;
        x = 8'h05;

        #500;
        Reset = 1'b1;
        
        #20;
        Reset = 1'b0;

        #15;
        start = 1;

        #20;
        start = 0;
        n = 3'b111;

        #25;
        x = 8'b01111111;

        #20;
        x = 8'b01100000;

        #20;
        x = 8'b01110000;

        #20;
        x = 8'b01111000;

        #20;
        x = 8'b01111100;

        #500;
        $stop;
    end


endmodule