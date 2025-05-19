`timescale 1ns/1ns

module controller (clk, rst, write_en, read_en, ready, valid, init, inc_w, inc_r, wen);
input clk, rst, write_en, read_en, ready, valid;
output reg init, inc_w, inc_r, wen;
//here is for writing into buffer
// always @(*) begin
//     if(write_en && ready) begin
//         inc_w = 1'b1;
//         wen = 1'b1;
//     end
//     else begin
//         inc_w = 1'b0;
//         wen = 1'b0;
//     end
// end

assign inc_w = (write_en && ready) ? 1'b1 : 1'b0;
assign wen = (write_en && ready) ? 1'b1 : 1'b0;
assign inc_r = (read_en && valid) ? 1'b1 : 1'b0;

//here is for reading from buffer
// always @(*) begin
//     if (read_en && valid)
//         inc_r = 1'b1;
//     else
//         inc_r = 1'b0;
// end

endmodule
