module BufferController(clk, rst, wen, read_en, wcnten, rcnten, write_en, valid, ready);
    input clk, rst, write_en, read_en, ready, valid;
    output reg wen, rcnten, wcnten;

    assign wcnten = (write_en && ready) ? 1'b1 : 1'b0;
    assign wen = (write_en && ready) ? 1'b1 : 1'b0;
    assign rcnten = (read_en && valid) ? 1'b1 : 1'b0;
endmodule