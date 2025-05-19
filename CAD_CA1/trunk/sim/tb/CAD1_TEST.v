`timescale 1ns/1ns

module CAD1_TEST();
    reg CLK = 1'b0;
    reg RST = 1'b0;
    reg START = 1'b0;

    wire DONE;

    top_module CAD1(.start(START) , .clk(CLK) , .rst(RST) , .done(DONE));
    initial repeat(400) #350 CLK = ~CLK;
    initial begin
    #1000 RST = 1'b1;
    #1000 RST = 1'b0;
    #1000 START = 1'b1;
    #1000 START = 1'b0;
    end
endmodule