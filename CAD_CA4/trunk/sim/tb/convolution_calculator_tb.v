`timescale 1ns/1ns
module convolution_calculator_tb();
    parameter IFMAP_NUM_OF_REG=5;
    parameter FILTER_NUM_OF_REG=6;
    parameter ADDR_WIDTH_IFMAP=3; 
    parameter ADDR_WIDTH_FILTER=4; 
    parameter ELEMENT_WIDTH=8;

    reg clk, rst=1'b0, start;

    reg [ELEMENT_WIDTH-1:0] FILTER;
    reg [IFMAP_NUM_OF_REG-1:0] stride;
    reg [ELEMENT_WIDTH+1:0] IFMAP;
    reg [ADDR_WIDTH_FILTER-1:0] filter_size = 4'b0011;
    reg read_en_IFMAP, write_en_IFMAP, read_en_filter, write_en_filter;
    wire [ELEMENT_WIDTH-1:0] output_psum;

    ConvolutionCalculator #(.IFMAP_NUM_OF_REG(IFMAP_NUM_OF_REG), .FILTER_NUM_OF_REG(FILTER_NUM_OF_REG+1), .ADDR_WIDTH_IFMAP(ADDR_WIDTH_IFMAP), 
                .ADDR_WIDTH_FILTER(ADDR_WIDTH_FILTER), .ELEMENT_WIDTH(ELEMENT_WIDTH)) top_module_tb
                (.clk(clk), .rst(rst), .start(start), .IFMAP(IFMAP), .FILTER(FILTER), .output_psum(output_psum), .stride(stride), 
                .write_en_IFMAP(write_en_IFMAP), .write_en_filter(write_en_filter), .filter_size(filter_size));

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        start = 1'b0;
        stride = 8'b00000001;
        write_en_IFMAP = 1'b0;

        #15;
        rst=1'b0;
        #10;
        start = 1'b1;

        #15;
        start = 1'b0;
        // IFMAP 1
        IFMAP = {10'b1011111111};
        #5;
        write_en_IFMAP = 1'b1;
        #10;

        #5;
        write_en_IFMAP = 1'b1;
        #10;

        IFMAP = {10'b0011111100};
        #5;
        write_en_IFMAP = 1'b1;
        #10;

        IFMAP = {10'b0011111100};
        #5;
        write_en_IFMAP = 1'b1;
        #10;

        IFMAP = {10'b0111111000};
        #5;
        #10;
        write_en_IFMAP = 1'b0;
        #10;

        #50;
        // // IFMAP 2
        IFMAP = {10'b1011111111};
        #5;
        write_en_IFMAP = 1'b1;
        #20;

        IFMAP = {10'b0011111100};
        #5;
        write_en_IFMAP = 1'b1;
        #10;

        IFMAP = {10'b0111111000};
        #5;
        write_en_IFMAP = 1'b1;
        #30;
        write_en_IFMAP = 1'b0;
        #40;

        // // sevomi
        // IFMAP = {10'b1011111111};
        // #5;
        // write_en_IFMAP = 1'b1;
        // #20;

        // IFMAP = {10'b0011111100};
        // #25;
        // write_en_IFMAP = 1'b1;
        // #10;

        // IFMAP = {10'b0111111000};
        // #5;
        // write_en_IFMAP = 1'b1;
        // #10;
        // write_en_IFMAP = 1'b0;

        // filters
        FILTER = {8'b10000000};
        #5;
        write_en_filter = 1'b1;
        #20;

        write_en_filter = 1'b0;
        #50;

        FILTER = {8'b10010100};
        #5;
        write_en_filter = 1'b1;
        #20;

        write_en_filter = 1'b0;
        #50;

        FILTER = {8'b11111111};
        #5;
        write_en_filter = 1'b1;
        #20;

        write_en_filter = 1'b0;
        #50;

        #200 FILTER = {8'b01010101};
        #5;
        write_en_filter = 1'b1;
        #20;

        write_en_filter = 1'b0;
        #50;

        FILTER = {8'b10010101};
        #5;
        write_en_filter = 1'b1;
        #20;

        write_en_filter = 1'b0;
        #50;

        FILTER = {8'b01101010};
        #5;
        write_en_filter = 1'b1;
        #20;

        write_en_filter = 1'b0;
        #50;
        
        // #900;
        // // // IFMAP 2
        // IFMAP = {10'b1011111111};
        // #5;
        // write_en_IFMAP = 1'b1;
        // #15;

        // IFMAP = {10'b0011111100};
        // #5;
        // write_en_IFMAP = 1'b1;
        // #10;

        // IFMAP = {10'b0111111000};
        // #5;
        // write_en_IFMAP = 1'b1;
        // #30;
        // write_en_IFMAP = 1'b0;
        
        #5000 $stop;
    end
endmodule