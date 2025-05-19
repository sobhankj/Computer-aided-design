module Buffer#(parameter WIDTH, parameter DEPTH=8, parameter PAR_READ=1, parameter PAR_WRITE=1)  
                        (clk, rst, write_en, read_en, din, dout, valid, ready);
    input clk, rst, write_en, read_en;
    input [0:(WIDTH * PAR_WRITE) - 1] din;
    output [0:(WIDTH * PAR_READ) - 1] dout;
    wire full, empty;
    output valid, ready;
    wire wcenten, rcnten, wen;

    BufferDatapath #(.WIDTH(WIDTH), .DEPTH(DEPTH), .PAR_READ(PAR_READ), .PAR_WRITE(PAR_WRITE)) 
                   datapath(.clk(clk), .rst(rst), .wen(wen), .din(din), .dout(dout), .ready(ready), .valid(valid), .wcnten(wcenten), .rcnten(rcnten), .empty(empty), .full(full), .read_en(read_en));
    BufferController controller(.clk(clk), .rst(rst), .valid(valid), .ready(ready), .wen(wen), .read_en(read_en), .wcnten(wcenten), .rcnten(rcnten), .write_en(write_en));
endmodule