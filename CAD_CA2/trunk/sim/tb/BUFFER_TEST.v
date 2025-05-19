`timescale 1ns/1ns

module BUFFER_TEST #(parameter NUM_BIT = 4, NUM_REG = 4, ADDR_REG = 2, PAR_WRITE = 2, PAR_READ = 1)
();

    reg CLK = 1'b0;
    reg RST = 1'b0;
    reg WEN = 1'b0;
    reg [PAR_WRITE * NUM_BIT - 1 : 0]DIN;
    reg WRITE_EN = 1'b0;
    reg READ_EN = 1'b0;
    wire [PAR_READ * NUM_BIT - 1 : 0]DOUT;
    wire FULL , EMPTY , READY , VALID;

    top_module FIFO_BUF(.clk(CLK) , .rst(RST) , .write_en(WRITE_EN) , .read_en(READ_EN) , .din(DIN) , .dout(DOUT) , .full(FULL) , .empty(EMPTY) , .ready(READY) , .valid(VALID));
    initial repeat(100) #350 CLK = ~CLK;
    initial begin
        #1000 RST = 1'b1;
        #1000 RST = 1'b0;
        #1000 DIN = 8'b10110010;
        #500  WRITE_EN = 1'b1;
        #400  WRITE_EN = 1'b0;
        #10 DIN = 8'b00011100;
        #340  WRITE_EN = 1'b1;
        #350  WRITE_EN = 1'b0;
        #330 READ_EN = 1'b1;
        #350 READ_EN = 1'b0;
        #350 READ_EN = 1'b1;
        #350 READ_EN = 1'b0;
        #500 {READ_EN , WRITE_EN} = 2'b11;
        #300 {READ_EN , WRITE_EN} = 2'b00;
        // #1000 DIN = 8'b11111111;
        // #500  WRITE_EN = 1'b1;
        // #400  WRITE_EN = 1'b0;
        // #750  READ_EN = 1'b1;
        // #400  READ_EN = 1'b0;
        // #1000  READ_EN = 1'b1;
        // #400  READ_EN = 1'b0;
    end
endmodule

